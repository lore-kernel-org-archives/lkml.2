Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754067Ab0INShl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 14:37:41 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:47242 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0INShk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 14:37:40 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: "Hans J. Koch" <hjk@linutronix.de>, <linux-kernel@vger.kernel.org>
References: <m1y6b48973.fsf@fess.ebiederm.org>
Date: Tue, 14 Sep 2010 11:37:36 -0700
In-Reply-To: <m1y6b48973.fsf@fess.ebiederm.org> (Eric W. Biederman's message
	of "Tue, 14 Sep 2010 11:35:28 -0700")
Message-ID: <m1k4mo893j.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg Kroah-Hartman <gregkh@suse.de>
X-Spam-Relay-Country: 
Subject: [PATCH 3/5] uio: Cleanup irq handling.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Change the value of UIO_IRQ_NONE -2 to 0.  0 is well defined in the rest
of the kernel as the value to indicate an irq has not been assigned.

Update the calls to request_irq and free_irq to only ignore UIO_IRQ_NONE
and UIO_IRQ_CUSTOM allowing the rest of the kernel's possible irq
numbers to be used.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 drivers/uio/uio.c          |   14 +++++++-------
 include/linux/uio_driver.h |    2 +-
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 8132288..0fd2cda 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -512,7 +512,7 @@ static unsigned int uio_poll(struct file *filep, poll_table *wait)
 	struct uio_listener *listener = filep->private_data;
 	struct uio_device *idev = listener->dev;
 
-	if (idev->info->irq == UIO_IRQ_NONE)
+	if (!idev->info->irq)
 		return -EIO;
 
 	poll_wait(filep, &idev->wait, wait);
@@ -530,7 +530,7 @@ static ssize_t uio_read(struct file *filep, char __user *buf,
 	ssize_t retval;
 	s32 event_count;
 
-	if (idev->info->irq == UIO_IRQ_NONE)
+	if (!idev->info->irq)
 		return -EIO;
 
 	if (count != sizeof(s32))
@@ -578,7 +578,7 @@ static ssize_t uio_write(struct file *filep, const char __user *buf,
 	ssize_t retval;
 	s32 irq_on;
 
-	if (idev->info->irq == UIO_IRQ_NONE)
+	if (!idev->info->irq)
 		return -EIO;
 
 	if (count != sizeof(s32))
@@ -825,9 +825,9 @@ int __uio_register_device(struct module *owner,
 
 	info->uio_dev = idev;
 
-	if (idev->info->irq >= 0) {
-		ret = request_irq(idev->info->irq, uio_interrupt,
-				  idev->info->irq_flags, idev->info->name, idev);
+	if (info->irq && (info->irq != UIO_IRQ_CUSTOM)) {
+		ret = request_irq(info->irq, uio_interrupt,
+				  info->irq_flags, info->name, idev);
 		if (ret)
 			goto err_request_irq;
 	}
@@ -863,7 +863,7 @@ void uio_unregister_device(struct uio_info *info)
 
 	uio_free_minor(idev);
 
-	if (info->irq >= 0)
+	if (info->irq && (info->irq != UIO_IRQ_CUSTOM))
 		free_irq(info->irq, idev);
 
 	uio_dev_del_attributes(idev);
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index 5dcc9ff..d6188e5 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -108,7 +108,7 @@ extern void uio_event_notify(struct uio_info *info);
 
 /* defines for uio_info->irq */
 #define UIO_IRQ_CUSTOM	-1
-#define UIO_IRQ_NONE	-2
+#define UIO_IRQ_NONE	0
 
 /* defines for uio_mem->memtype */
 #define UIO_MEM_NONE	0
-- 
1.7.2.2

