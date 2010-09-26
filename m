Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932484Ab0IZWr6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Sep 2010 18:47:58 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:39107 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932202Ab0IZWr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Sep 2010 18:47:56 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Greg KH <greg@kroah.com>
Cc: Greg KH <gregkh@suse.de>, "Hans J. Koch" <hjk@linutronix.de>,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
References: <m1y6b48973.fsf@fess.ebiederm.org> <20100917205946.GF2522@local>
	<m139t451b4.fsf_-_@fess.ebiederm.org>
	<20100924104555.GC1819@silverbox.local>
	<m1hbhfcbdo.fsf@fess.ebiederm.org>
	<20100924173106.GA4966@silverbox.local>
	<m14ode662q.fsf@fess.ebiederm.org> <20100925003308.GA29910@suse.de>
	<m1wrqa4mg5.fsf@fess.ebiederm.org> <20100926192142.GA7252@kroah.com>
Date: Sun, 26 Sep 2010 15:47:52 -0700
In-Reply-To: <20100926192142.GA7252@kroah.com> (Greg KH's message of "Sun, 26
	Sep 2010 12:21:42 -0700")
Message-ID: <m1zkv486lj.fsf_-_@fess.ebiederm.org>
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
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Greg KH <greg@kroah.com>
X-Spam-Relay-Country: 
Subject: [PATCH 2/5] uio: Kill unused vma_count.
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Remove the tracking of how many vmas are using in the uio memory
mapping mode.  The uio code doesn't use that information anywhere.

Signed-off-by: Eric W. Biederman <ebiederm@aristanetworks.com>
---
 drivers/uio/uio.c |   16 ----------------
 1 files changed, 0 insertions(+), 16 deletions(-)

diff --git a/drivers/uio/uio.c b/drivers/uio/uio.c
index 565559c..95f25ae 100644
--- a/drivers/uio/uio.c
+++ b/drivers/uio/uio.c
@@ -35,7 +35,6 @@ struct uio_device {
 	atomic_t		event;
 	struct fasync_struct	*async_queue;
 	wait_queue_head_t	wait;
-	int			vma_count;
 	struct uio_info		*info;
 	struct kobject		*map_dir;
 	struct kobject		*portio_dir;
@@ -599,18 +598,6 @@ static int uio_find_mem_index(struct vm_area_struct *vma)
 	return -1;
 }
 
-static void uio_vma_open(struct vm_area_struct *vma)
-{
-	struct uio_device *idev = vma->vm_private_data;
-	idev->vma_count++;
-}
-
-static void uio_vma_close(struct vm_area_struct *vma)
-{
-	struct uio_device *idev = vma->vm_private_data;
-	idev->vma_count--;
-}
-
 static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 {
 	struct uio_device *idev = vma->vm_private_data;
@@ -638,8 +625,6 @@ static int uio_vma_fault(struct vm_area_struct *vma, struct vm_fault *vmf)
 }
 
 static const struct vm_operations_struct uio_vm_ops = {
-	.open = uio_vma_open,
-	.close = uio_vma_close,
 	.fault = uio_vma_fault,
 };
 
@@ -665,7 +650,6 @@ static int uio_mmap_logical(struct vm_area_struct *vma)
 {
 	vma->vm_flags |= VM_RESERVED;
 	vma->vm_ops = &uio_vm_ops;
-	uio_vma_open(vma);
 	return 0;
 }
 
-- 
1.7.2.2

