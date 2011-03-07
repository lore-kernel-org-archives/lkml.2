Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754077Ab1CGI5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 03:57:42 -0500
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:57726 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab1CGI5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 03:57:39 -0500
Date: Mon, 7 Mar 2011 09:57:41 +0100
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for 2.6.38-rc7
Message-ID: <20110307095741.25d0cac5@mschwide.boeblingen.de.ibm.com>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from 'for-linus' branch of

	git://git390.marist.edu/pub/scm/linux-2.6.git for-linus

to receive the following updates:

Dan Carpenter (1):
      [S390] keyboard: integer underflow bug

Martin Schwidefsky (2):
      [S390] xpram: remove __initdata attribute from module parameters
      [S390] tape: deadlock on system work queue

 drivers/s390/block/xpram.c    |    4 +-
 drivers/s390/char/keyboard.c  |    3 +-
 drivers/s390/char/tape.h      |    8 ++++
 drivers/s390/char/tape_34xx.c |   59 ++++++++++++++++++++---------
 drivers/s390/char/tape_3590.c |   83 +++++++++++++++++++++++++++++++++--------
 5 files changed, 120 insertions(+), 37 deletions(-)

diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index c881a14..1f6a4d8 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -62,8 +62,8 @@ static int xpram_devs;
 /*
  * Parameter parsing functions.
  */
-static int __initdata devs = XPRAM_DEVS;
-static char __initdata *sizes[XPRAM_MAX_DEVS];
+static int devs = XPRAM_DEVS;
+static char *sizes[XPRAM_MAX_DEVS];
 
 module_param(devs, int, 0);
 module_param_array(sizes, charp, NULL, 0);
diff --git a/drivers/s390/char/keyboard.c b/drivers/s390/char/keyboard.c
index 8cd58e4..5ad44da 100644
--- a/drivers/s390/char/keyboard.c
+++ b/drivers/s390/char/keyboard.c
@@ -460,7 +460,8 @@ kbd_ioctl(struct kbd_data *kbd, struct file *file,
 	  unsigned int cmd, unsigned long arg)
 {
 	void __user *argp;
-	int ct, perm;
+	unsigned int ct;
+	int perm;
 
 	argp = (void __user *)arg;
 
diff --git a/drivers/s390/char/tape.h b/drivers/s390/char/tape.h
index 7a242f0..267b54e 100644
--- a/drivers/s390/char/tape.h
+++ b/drivers/s390/char/tape.h
@@ -280,6 +280,14 @@ tape_do_io_free(struct tape_device *device, struct tape_request *request)
 	return rc;
 }
 
+static inline void
+tape_do_io_async_free(struct tape_device *device, struct tape_request *request)
+{
+	request->callback = (void *) tape_free_request;
+	request->callback_data = NULL;
+	tape_do_io_async(device, request);
+}
+
 extern int tape_oper_handler(int irq, int status);
 extern void tape_noper_handler(int irq, int status);
 extern int tape_open(struct tape_device *);
diff --git a/drivers/s390/char/tape_34xx.c b/drivers/s390/char/tape_34xx.c
index c17f35b..c265111 100644
--- a/drivers/s390/char/tape_34xx.c
+++ b/drivers/s390/char/tape_34xx.c
@@ -53,23 +53,11 @@ static void tape_34xx_delete_sbid_from(struct tape_device *, int);
  * Medium sense for 34xx tapes. There is no 'real' medium sense call.
  * So we just do a normal sense.
  */
-static int
-tape_34xx_medium_sense(struct tape_device *device)
+static void __tape_34xx_medium_sense(struct tape_request *request)
 {
-	struct tape_request *request;
-	unsigned char       *sense;
-	int                  rc;
-
-	request = tape_alloc_request(1, 32);
-	if (IS_ERR(request)) {
-		DBF_EXCEPTION(6, "MSEN fail\n");
-		return PTR_ERR(request);
-	}
-
-	request->op = TO_MSEN;
-	tape_ccw_end(request->cpaddr, SENSE, 32, request->cpdata);
+	struct tape_device *device = request->device;
+	unsigned char *sense;
 
-	rc = tape_do_io_interruptible(device, request);
 	if (request->rc == 0) {
 		sense = request->cpdata;
 
@@ -88,15 +76,47 @@ tape_34xx_medium_sense(struct tape_device *device)
 			device->tape_generic_status |= GMT_WR_PROT(~0);
 		else
 			device->tape_generic_status &= ~GMT_WR_PROT(~0);
-	} else {
+	} else
 		DBF_EVENT(4, "tape_34xx: medium sense failed with rc=%d\n",
 			request->rc);
-	}
 	tape_free_request(request);
+}
+
+static int tape_34xx_medium_sense(struct tape_device *device)
+{
+	struct tape_request *request;
+	int rc;
+
+	request = tape_alloc_request(1, 32);
+	if (IS_ERR(request)) {
+		DBF_EXCEPTION(6, "MSEN fail\n");
+		return PTR_ERR(request);
+	}
 
+	request->op = TO_MSEN;
+	tape_ccw_end(request->cpaddr, SENSE, 32, request->cpdata);
+	rc = tape_do_io_interruptible(device, request);
+	__tape_34xx_medium_sense(request);
 	return rc;
 }
 
+static void tape_34xx_medium_sense_async(struct tape_device *device)
+{
+	struct tape_request *request;
+
+	request = tape_alloc_request(1, 32);
+	if (IS_ERR(request)) {
+		DBF_EXCEPTION(6, "MSEN fail\n");
+		return;
+	}
+
+	request->op = TO_MSEN;
+	tape_ccw_end(request->cpaddr, SENSE, 32, request->cpdata);
+	request->callback = (void *) __tape_34xx_medium_sense;
+	request->callback_data = NULL;
+	tape_do_io_async(device, request);
+}
+
 struct tape_34xx_work {
 	struct tape_device	*device;
 	enum tape_op		 op;
@@ -109,6 +129,9 @@ struct tape_34xx_work {
  * is inserted but cannot call tape_do_io* from an interrupt context.
  * Maybe that's useful for other actions we want to start from the
  * interrupt handler.
+ * Note: the work handler is called by the system work queue. The tape
+ * commands started by the handler need to be asynchrounous, otherwise
+ * a deadlock can occur e.g. in case of a deferred cc=1 (see __tape_do_irq).
  */
 static void
 tape_34xx_work_handler(struct work_struct *work)
@@ -119,7 +142,7 @@ tape_34xx_work_handler(struct work_struct *work)
 
 	switch(p->op) {
 		case TO_MSEN:
-			tape_34xx_medium_sense(device);
+			tape_34xx_medium_sense_async(device);
 			break;
 		default:
 			DBF_EVENT(3, "T34XX: internal error: unknown work\n");
diff --git a/drivers/s390/char/tape_3590.c b/drivers/s390/char/tape_3590.c
index fbe361f..de2e99e 100644
--- a/drivers/s390/char/tape_3590.c
+++ b/drivers/s390/char/tape_3590.c
@@ -329,17 +329,17 @@ out:
 /*
  * Enable encryption
  */
-static int tape_3592_enable_crypt(struct tape_device *device)
+static struct tape_request *__tape_3592_enable_crypt(struct tape_device *device)
 {
 	struct tape_request *request;
 	char *data;
 
 	DBF_EVENT(6, "tape_3592_enable_crypt\n");
 	if (!crypt_supported(device))
-		return -ENOSYS;
+		return ERR_PTR(-ENOSYS);
 	request = tape_alloc_request(2, 72);
 	if (IS_ERR(request))
-		return PTR_ERR(request);
+		return request;
 	data = request->cpdata;
 	memset(data,0,72);
 
@@ -354,23 +354,42 @@ static int tape_3592_enable_crypt(struct tape_device *device)
 	request->op = TO_CRYPT_ON;
 	tape_ccw_cc(request->cpaddr, MODE_SET_CB, 36, data);
 	tape_ccw_end(request->cpaddr + 1, MODE_SET_CB, 36, data + 36);
+	return request;
+}
+
+static int tape_3592_enable_crypt(struct tape_device *device)
+{
+	struct tape_request *request;
+
+	request = __tape_3592_enable_crypt(device);
+	if (IS_ERR(request))
+		return PTR_ERR(request);
 	return tape_do_io_free(device, request);
 }
 
+static void tape_3592_enable_crypt_async(struct tape_device *device)
+{
+	struct tape_request *request;
+
+	request = __tape_3592_enable_crypt(device);
+	if (!IS_ERR(request))
+		tape_do_io_async_free(device, request);
+}
+
 /*
  * Disable encryption
  */
-static int tape_3592_disable_crypt(struct tape_device *device)
+static struct tape_request *__tape_3592_disable_crypt(struct tape_device *device)
 {
 	struct tape_request *request;
 	char *data;
 
 	DBF_EVENT(6, "tape_3592_disable_crypt\n");
 	if (!crypt_supported(device))
-		return -ENOSYS;
+		return ERR_PTR(-ENOSYS);
 	request = tape_alloc_request(2, 72);
 	if (IS_ERR(request))
-		return PTR_ERR(request);
+		return request;
 	data = request->cpdata;
 	memset(data,0,72);
 
@@ -383,9 +402,28 @@ static int tape_3592_disable_crypt(struct tape_device *device)
 	tape_ccw_cc(request->cpaddr, MODE_SET_CB, 36, data);
 	tape_ccw_end(request->cpaddr + 1, MODE_SET_CB, 36, data + 36);
 
+	return request;
+}
+
+static int tape_3592_disable_crypt(struct tape_device *device)
+{
+	struct tape_request *request;
+
+	request = __tape_3592_disable_crypt(device);
+	if (IS_ERR(request))
+		return PTR_ERR(request);
 	return tape_do_io_free(device, request);
 }
 
+static void tape_3592_disable_crypt_async(struct tape_device *device)
+{
+	struct tape_request *request;
+
+	request = __tape_3592_disable_crypt(device);
+	if (!IS_ERR(request))
+		tape_do_io_async_free(device, request);
+}
+
 /*
  * IOCTL: Set encryption status
  */
@@ -457,8 +495,7 @@ tape_3590_ioctl(struct tape_device *device, unsigned int cmd, unsigned long arg)
 /*
  * SENSE Medium: Get Sense data about medium state
  */
-static int
-tape_3590_sense_medium(struct tape_device *device)
+static int tape_3590_sense_medium(struct tape_device *device)
 {
 	struct tape_request *request;
 
@@ -470,6 +507,18 @@ tape_3590_sense_medium(struct tape_device *device)
 	return tape_do_io_free(device, request);
 }
 
+static void tape_3590_sense_medium_async(struct tape_device *device)
+{
+	struct tape_request *request;
+
+	request = tape_alloc_request(1, 128);
+	if (IS_ERR(request))
+		return;
+	request->op = TO_MSEN;
+	tape_ccw_end(request->cpaddr, MEDIUM_SENSE, 128, request->cpdata);
+	tape_do_io_async_free(device, request);
+}
+
 /*
  * MTTELL: Tell block. Return the number of block relative to current file.
  */
@@ -546,15 +595,14 @@ tape_3590_read_opposite(struct tape_device *device,
  * 2. The attention msg is written to the "read subsystem data" buffer.
  * In this case we probably should print it to the console.
  */
-static int
-tape_3590_read_attmsg(struct tape_device *device)
+static void tape_3590_read_attmsg_async(struct tape_device *device)
 {
 	struct tape_request *request;
 	char *buf;
 
 	request = tape_alloc_request(3, 4096);
 	if (IS_ERR(request))
-		return PTR_ERR(request);
+		return;
 	request->op = TO_READ_ATTMSG;
 	buf = request->cpdata;
 	buf[0] = PREP_RD_SS_DATA;
@@ -562,12 +610,15 @@ tape_3590_read_attmsg(struct tape_device *device)
 	tape_ccw_cc(request->cpaddr, PERFORM_SS_FUNC, 12, buf);
 	tape_ccw_cc(request->cpaddr + 1, READ_SS_DATA, 4096 - 12, buf + 12);
 	tape_ccw_end(request->cpaddr + 2, NOP, 0, NULL);
-	return tape_do_io_free(device, request);
+	tape_do_io_async_free(device, request);
 }
 
 /*
  * These functions are used to schedule follow-up actions from within an
  * interrupt context (like unsolicited interrupts).
+ * Note: the work handler is called by the system work queue. The tape
+ * commands started by the handler need to be asynchrounous, otherwise
+ * a deadlock can occur e.g. in case of a deferred cc=1 (see __tape_do_irq).
  */
 struct work_handler_data {
 	struct tape_device *device;
@@ -583,16 +634,16 @@ tape_3590_work_handler(struct work_struct *work)
 
 	switch (p->op) {
 	case TO_MSEN:
-		tape_3590_sense_medium(p->device);
+		tape_3590_sense_medium_async(p->device);
 		break;
 	case TO_READ_ATTMSG:
-		tape_3590_read_attmsg(p->device);
+		tape_3590_read_attmsg_async(p->device);
 		break;
 	case TO_CRYPT_ON:
-		tape_3592_enable_crypt(p->device);
+		tape_3592_enable_crypt_async(p->device);
 		break;
 	case TO_CRYPT_OFF:
-		tape_3592_disable_crypt(p->device);
+		tape_3592_disable_crypt_async(p->device);
 		break;
 	default:
 		DBF_EVENT(3, "T3590: work handler undefined for "
