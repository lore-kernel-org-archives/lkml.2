Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754055Ab0ITHXS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 03:23:18 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54345 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752239Ab0ITHXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 03:23:17 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Hans J. Koch" <hjk@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
References: <m1y6b48973.fsf@fess.ebiederm.org> <20100917205946.GF2522@local>
	<m139t451b4.fsf_-_@fess.ebiederm.org>
Date: Mon, 20 Sep 2010 00:23:12 -0700
In-Reply-To: <m139t451b4.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's
	message of "Mon, 20 Sep 2010 00:19:59 -0700")
Message-ID: <m1ocbs3mlb.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;"Hans J. Koch" <hjk@linutronix.de>
X-Spam-Relay-Country: 
Subject: [PATCH 3/5] uio: Remove unused uio_info mmap method.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


There are no drivers in the kernel that implement the uio_info mmap
method so there is no point in keeping it.

Further keeping the mmap method would necessitate wrapping all of the
methods in vm_operations_struct to successfully implement support for
hotunplugable hardware, and it I have yet to find a correct way to wrap
the the vm_operations_struct close method.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 drivers/uio/uio.c          |    6 ------
 include/linux/uio_driver.h |    1 -
 2 files changed, 0 insertions(+), 7 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 95f25ae..fc52fbc 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -659,7 +659,6 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 	struct uio_device *idev = listener->dev;
 	int mi;
 	unsigned long requested_pages, actual_pages;
-	int ret = 0;
 
 	if (vma->vm_end < vma->vm_start)
 		return -EINVAL;
@@ -676,11 +675,6 @@ static int uio_mmap(struct file *filep, struct vm_area_struct *vma)
 	if (requested_pages > actual_pages)
 		return -EINVAL;
 
-	if (idev->info->mmap) {
-		ret = idev->info->mmap(idev->info, vma);
-		return ret;
-	}
-
 	switch (idev->info->mem[mi].memtype) {
 		case UIO_MEM_PHYS:
 			return uio_mmap_physical(vma);
diff --git a/include/linux/uio_driver.h b/include/linux/uio_driver.h
index d6188e5..33789d4 100644
--- a/include/linux/uio_driver.h
+++ b/include/linux/uio_driver.h
@@ -88,7 +88,6 @@ struct uio_info {
 	unsigned long		irq_flags;
 	void			*priv;
 	irqreturn_t (*handler)(int irq, struct uio_info *dev_info);
-	int (*mmap)(struct uio_info *info, struct vm_area_struct *vma);
 	int (*open)(struct uio_info *info, struct inode *inode);
 	int (*release)(struct uio_info *info, struct inode *inode);
 	int (*irqcontrol)(struct uio_info *info, s32 irq_on);
-- 
1.7.2.2

