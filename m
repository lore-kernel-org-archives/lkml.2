Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754857Ab1J0Sk3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 14:40:29 -0400
Received: from smtp-out.google.com ([74.125.121.67]:41588 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754362Ab1J0Sk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 14:40:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
	b=GhEb7VK4zgq3F1lChMggPGLqGiGRzd7oHKdmnmX3HtOZDFxvdNXDz2k5NNSCOW45J
	pEErLCtIiPsnXcwkopb1w==
From: Miche Baker-Harvey <miche@google.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, Amit Shah <amit.shah@redhat.com>,
        Anton Blanchard <anton@samba.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        virtualization@lists.linux-foundation.org,
        Miche Baker-Harvey <miche@google.com>
Subject: [PATCH] VirtioConsole support.
Date: Thu, 27 Oct 2011 11:39:53 -0700
Message-Id: <1319740793-2187-1-git-send-email-miche@google.com>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <20111027173527.GA23839@phenom.dumpdata.com>
References: <20111027173527.GA23839@phenom.dumpdata.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Multiple HVC console terminals enabled.

Serialize device and port open and initialization.  Added a mutex
which gates the handling of control messages in virtio_console.c.
This includes adding and removing ports, and making opened ports be
consoles.  Extended the use of the prvdata spinlock to cover some missed
modifications to prvdata.next_vtermno.

I also added a mutex in hvc_console::hvc_alloc() to coordinate waiting
for the driver to be ready, and for the one-time call to hvc_init().  It
had been the case that this was sometimes being called mulitple times, and
partially setup state was being used by the second caller of hvc_alloc().

Make separate struct console* for each new port.  There was a single static
struct console* hvc_console, to be used for early printk.  We aren't doing
early printk, but more importantly, there is no code to multiplex on that
one console.  Multiple virtio_console ports were "sharing" this, which was
disasterous since both the index and the flags for the console are stored
there. The console struct is remembered in the hvc_struct, and it is
deallocated when the hvc_struct is deallocated.

------------------

Konrad, thanks for trying this out on Xen.
This is working in my KVM environment, letting me start multiple
virtio_consoles with getty's on them, but I'm really not sure how
all the console pieces fit together yet.  Feedback is welcome.

Signed-off-by: Miche Baker-Harvey <miche@google.com>
---
 drivers/char/virtio_console.c |   22 +++++++++++++++++++---
 drivers/tty/hvc/hvc_console.c |   39 +++++++++++++++++++++++++++++++++------
 drivers/tty/hvc/hvc_console.h |    1 +
 3 files changed, 53 insertions(+), 9 deletions(-)

diff --git a/drivers/char/virtio_console.c b/drivers/char/virtio_console.c
index fb68b12..e819d46 100644
--- a/drivers/char/virtio_console.c
+++ b/drivers/char/virtio_console.c
@@ -24,6 +24,7 @@
 #include <linux/fs.h>
 #include <linux/init.h>
 #include <linux/list.h>
+#include <linux/mutex.h>
 #include <linux/poll.h>
 #include <linux/sched.h>
 #include <linux/slab.h>
@@ -95,6 +96,11 @@ struct console {
 	u32 vtermno;
 };
 
+/* serialize the handling of control messages, which includes
+ * the initialization of the virtio_consoles.
+ */
+static DEFINE_MUTEX(virtio_console_mutex);
+
 struct port_buffer {
 	char *buf;
 
@@ -979,8 +985,14 @@ int init_port_console(struct port *port)
 	 * pointers.  The final argument is the output buffer size: we
 	 * can do any size, so we put PAGE_SIZE here.
 	 */
-	port->cons.vtermno = pdrvdata.next_vtermno;
+	spin_lock_irq(&pdrvdata_lock);
+	port->cons.vtermno = pdrvdata.next_vtermno++;
+	spin_unlock_irq(&pdrvdata_lock);
 
+	/*
+	 * xxx Use index 0 for now assuming there is no early HVC, since
+	 * we don't support it.
+	 */
 	port->cons.hvc = hvc_alloc(port->cons.vtermno, 0, &hv_ops, PAGE_SIZE);
 	if (IS_ERR(port->cons.hvc)) {
 		ret = PTR_ERR(port->cons.hvc);
@@ -990,7 +1002,6 @@ int init_port_console(struct port *port)
 		return ret;
 	}
 	spin_lock_irq(&pdrvdata_lock);
-	pdrvdata.next_vtermno++;
 	list_add_tail(&port->cons.list, &pdrvdata.consoles);
 	spin_unlock_irq(&pdrvdata_lock);
 	port->guest_connected = true;
@@ -1317,7 +1328,6 @@ static void handle_control_message(struct ports_device *portdev,
 	int err;
 
 	cpkt = (struct virtio_console_control *)(buf->buf + buf->offset);
-
 	port = find_port_by_id(portdev, cpkt->id);
 	if (!port && cpkt->event != VIRTIO_CONSOLE_PORT_ADD) {
 		/* No valid header at start of buffer.  Drop it. */
@@ -1326,6 +1336,11 @@ static void handle_control_message(struct ports_device *portdev,
 		return;
 	}
 
+	/*
+	 * These are rare initialization-time events that should be
+	 * serialized.
+	 */
+	mutex_lock(&virtio_console_mutex);
 	switch (cpkt->event) {
 	case VIRTIO_CONSOLE_PORT_ADD:
 		if (port) {
@@ -1429,6 +1444,7 @@ static void handle_control_message(struct ports_device *portdev,
 		}
 		break;
 	}
+	mutex_unlock(&virtio_console_mutex);
 }
 
 static void control_work_handler(struct work_struct *work)
diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 7430bc3..03ff6ed 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -29,8 +29,9 @@
 #include <linux/kernel.h>
 #include <linux/kthread.h>
 #include <linux/list.h>
-#include <linux/module.h>
 #include <linux/major.h>
+#include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/sysrq.h>
 #include <linux/tty.h>
 #include <linux/tty_flip.h>
@@ -84,6 +85,10 @@ static LIST_HEAD(hvc_structs);
  * list traversal.
  */
 static DEFINE_SPINLOCK(hvc_structs_lock);
+/*
+ * only one task does allocation at a time.
+ */
+static DEFINE_MUTEX(hvc_ports_mutex);
 
 /*
  * This value is used to assign a tty->index value to a hvc_struct based
@@ -242,6 +247,7 @@ static void destroy_hvc_struct(struct kref *kref)
 
 	spin_unlock(&hvc_structs_lock);
 
+	kfree(hp->hvc_console);
 	kfree(hp);
 }
 
@@ -822,19 +828,25 @@ struct hvc_struct *hvc_alloc(uint32_t vtermno, int data,
 			     int outbuf_size)
 {
 	struct hvc_struct *hp;
+	struct console *cp;
 	int i;
 
 	/* We wait until a driver actually comes along */
+	mutex_lock(&hvc_ports_mutex);
 	if (!hvc_driver) {
 		int err = hvc_init();
-		if (err)
+		if (err) {
+			mutex_unlock(&hvc_ports_mutex);
 			return ERR_PTR(err);
+		}
 	}
 
 	hp = kzalloc(ALIGN(sizeof(*hp), sizeof(long)) + outbuf_size,
 			GFP_KERNEL);
-	if (!hp)
+	if (!hp) {
+		mutex_unlock(&hvc_ports_mutex);
 		return ERR_PTR(-ENOMEM);
+	}
 
 	hp->vtermno = vtermno;
 	hp->data = data;
@@ -845,6 +857,19 @@ struct hvc_struct *hvc_alloc(uint32_t vtermno, int data,
 	kref_init(&hp->kref);
 
 	INIT_WORK(&hp->tty_resize, hvc_set_winsz);
+	/*
+	 * make each console its own struct console.
+	 * No need to do allocation and copy under lock.
+	 */
+	cp = kzalloc(sizeof(*cp), GFP_KERNEL);
+	if (!cp) {
+		kfree(hp);
+		mutex_unlock(&hvc_ports_mutex);
+		return ERR_PTR(-ENOMEM);
+	}
+	memcpy(cp, &hvc_console, sizeof(*cp));
+	hp->hvc_console = cp;
+
 	spin_lock_init(&hp->lock);
 	spin_lock(&hvc_structs_lock);
 
@@ -862,13 +887,14 @@ struct hvc_struct *hvc_alloc(uint32_t vtermno, int data,
 		i = ++last_hvc;
 
 	hp->index = i;
-	hvc_console.index = i;
+	cp->index = i;
 	vtermnos[i] = vtermno;
 	cons_ops[i] = ops;
 
 	list_add_tail(&(hp->next), &hvc_structs);
 	spin_unlock(&hvc_structs_lock);
-	register_console(&hvc_console);
+	register_console(cp);
+	mutex_unlock(&hvc_ports_mutex);
 
 	return hp;
 }
@@ -879,7 +905,8 @@ int hvc_remove(struct hvc_struct *hp)
 	unsigned long flags;
 	struct tty_struct *tty;
 
-	unregister_console(&hvc_console);
+	BUG_ON(!hp->hvc_console);
+	unregister_console(hp->hvc_console);
 	spin_lock_irqsave(&hp->lock, flags);
 	tty = tty_kref_get(hp->tty);
 
diff --git a/drivers/tty/hvc/hvc_console.h b/drivers/tty/hvc/hvc_console.h
index c335a14..2d20ab7 100644
--- a/drivers/tty/hvc/hvc_console.h
+++ b/drivers/tty/hvc/hvc_console.h
@@ -58,6 +58,7 @@ struct hvc_struct {
 	const struct hv_ops *ops;
 	int irq_requested;
 	int data;
+	struct console *hvc_console;
 	struct winsize ws;
 	struct work_struct tty_resize;
 	struct list_head next;
-- 
1.7.3.1

