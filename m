Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933236Ab1KHT3i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:29:38 -0500
Received: from smtp-out.google.com ([74.125.121.67]:47709 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932178Ab1KHT3f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:29:35 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=subject:to:from:date:message-id:in-reply-to:references:
	user-agent:mime-version:content-type:
	content-transfer-encoding:x-system-of-record;
	b=gFnFr6m/nnjxTdNzadlUOHGgT8456/BzjuDyxPpnzxVF/YTnx34CnBYkTGDRPqGCC
	bf2Mhbt15XIwiIeHfk+HA==
Subject: [PATCH v2 3/3] Use separate struct console structure for each
	hvc_console.
To: linux-kernel@vger.kernel.org
From: Miche Baker-Harvey <miche@google.com>
Date: Tue, 08 Nov 2011 11:29:32 -0800
Message-ID: <20111108192932.30437.39805.stgit@miche.sea.corp.google.com>
In-Reply-To: <20111108192916.30437.47434.stgit@miche.sea.corp.google.com>
References: <20111108192916.30437.47434.stgit@miche.sea.corp.google.com>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It is possible to make any virtio_console port be a console
by sending VIRITO_CONSOLE_CONSOLE_PORT.  But hvc_alloc was
using a single struct console hvc_console, which contains
both an index and flags which are per-port.

This adds a separate struct console for each virtio_console
that is CONSOLE_PORT.

Signed-off-by: Miche Baker-Harvey <miche@google.com>
---
 drivers/tty/hvc/hvc_console.c |   20 ++++++++++++++++++++
 drivers/tty/hvc/hvc_console.h |    1 +
 2 files changed, 21 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
index 09a6159..24a84d6 100644
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -247,6 +247,7 @@ static void destroy_hvc_struct(struct kref *kref)
 
 	spin_unlock(&hvc_structs_lock);
 
+	kfree(hp->hvc_console);
 	kfree(hp);
 }
 
@@ -827,6 +828,7 @@ struct hvc_struct *hvc_alloc(uint32_t vtermno, int data,
 			     int outbuf_size)
 {
 	struct hvc_struct *hp;
+	struct console *cp;
 	int i;
 
 	/* We wait until a driver actually comes along */
@@ -854,6 +856,17 @@ struct hvc_struct *hvc_alloc(uint32_t vtermno, int data,
 	kref_init(&hp->kref);
 
 	INIT_WORK(&hp->tty_resize, hvc_set_winsz);
+	/*
+	 * Make each console its own struct console.
+	 */
+	cp = kmemdup(&hvc_console, sizeof(*cp), GFP_KERNEL);
+	if (!cp) {
+		kfree(hp);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	hp->hvc_console = cp;
+
 	spin_lock_init(&hp->lock);
 	spin_lock(&hvc_structs_lock);
 
@@ -872,8 +885,13 @@ struct hvc_struct *hvc_alloc(uint32_t vtermno, int data,
 
 	hp->index = i;
 
+	cp->index = i;
+	vtermnos[i] = vtermno;
+	cons_ops[i] = ops;
+
 	list_add_tail(&(hp->next), &hvc_structs);
 	spin_unlock(&hvc_structs_lock);
+	register_console(cp);
 
 	return hp;
 }
@@ -884,6 +902,8 @@ int hvc_remove(struct hvc_struct *hp)
 	unsigned long flags;
 	struct tty_struct *tty;
 
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

