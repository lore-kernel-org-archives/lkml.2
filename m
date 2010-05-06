Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381Ab0EFVJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 17:09:31 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:54927 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab0EFVJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 17:09:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=CCu63uhksCV7VN1dhyM487FqXNSM69Lh7BGmGhimg+bJv6Uu4/5F/o6mwySUQkIAny
         8z9jZhTJIHVgROqKtqPCIGUQeN6btgj0KRQTBwel/KWLc8WkpsRjpl9LaUDNDSi/bVwi
         Oiw6xrwj7e+i7vg4sGcxzOHBxjlRlrDl9yehM=
Date: Fri, 7 May 2010 01:09:19 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Mike Frysinger <vapier.adi@gmail.com>,
       Michael Hennerich <michael.hennerich@analog.com>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Bryan Wu <cooloney@kernel.org>, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2] USB: isp1760: Soften DW3 X/transaction error bit
 handling
Message-ID: <20100506210919.GA28930@oksana.dev.rtsoft.ru>
References: <20100506191532.GA11365@oksana.dev.rtsoft.ru>
 <Pine.LNX.4.44L0.1005061543421.1708-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005061543421.1708-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There were some reports[1] of isp1760 USB driver malfunctioning
with high speed devices, noticed on Blackfin and PowerPC targets.
These reports indicated that the original Philips 'pehcd'[2]
driver worked fine.

We've noticed the same issue with an ARM RealView platform. This
happens under load (with only some mass storage devices, not all,
just as in another report[3]):

  error bit is set in DW3
  error bit is set in DW3
  error bit is set in DW3
  usb 1-1.2: device descriptor read/64, error -32

It appears that the 'pehcd' driver checks the X bit only if the
transaction is halted (H bit), otherwise the error is so far
insignificant.

The ISP176x chips were modeled after EHCI, and EHCI spec says
(thanks to Alan Stern for pointing out):

"Transaction errors cause the status field to be updated to reflect
 the type of error, but the transaction continues to be retried until
 the Active bit is set to 0.  When the error counter reaches 0, the
 Halt bit is set and the Active bit is cleared."

So, just as the original Philips driver, isp1760 must report the
error only if the transaction error and the halt bits are set.

[1] http://markmail.org/message/lx4qrlbrs2uhcnly
[2] svn co svn://sources.blackfin.uclinux.org/linux-kernel/trunk/drivers/usb/host -r 5494
    See pehci.c:pehci_hcd_update_error_status().
[3] http://blackfin.uclinux.org/gf/tracker/5148

Signed-off-by: Anton Vorontsov <avorontsov@mvista.com>
---

On Thu, May 06, 2010 at 03:53:54PM -0400, Alan Stern wrote:
[...]
> > I didn't find where exactly ISP1760 spec mandates 'H && X'
> > handling (maybe it's in the EHCI spec?),
> 
> Yes, it is described implicitly in the EHCI spec, section 4.10.3.

Thanks! I've added this to the commit message.

On Thu, May 06, 2010 at 03:23:28PM -0400, Mike Frysinger wrote:
> On Thu, May 6, 2010 at 15:15, Anton Vorontsov wrote:
> > [3] http://blackfin.uclinux.org/gf/project/uclinux-dist/tracker/?action=TrackerItemEdit&tracker_item_id=5148
>
> i doubt you feel like resending, but this is a better link:
>   http://blackfin.uclinux.org/gf/tracker/5148

Yeah. I've changed the link, thanks.

 drivers/usb/host/isp1760-hcd.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/host/isp1760-hcd.c b/drivers/usb/host/isp1760-hcd.c
index 9f01293..9989c0b 100644
--- a/drivers/usb/host/isp1760-hcd.c
+++ b/drivers/usb/host/isp1760-hcd.c
@@ -713,12 +713,11 @@ static int check_error(struct ptd *ptd)
 	u32 dw3;
 
 	dw3 = le32_to_cpu(ptd->dw3);
-	if (dw3 & DW3_HALT_BIT)
+	if (dw3 & DW3_HALT_BIT) {
 		error = -EPIPE;
 
-	if (dw3 & DW3_ERROR_BIT) {
-		printk(KERN_ERR "error bit is set in DW3\n");
-		error = -EPIPE;
+		if (dw3 & DW3_ERROR_BIT)
+			pr_err("error bit is set in DW3\n");
 	}
 
 	if (dw3 & DW3_QTD_ACTIVE) {
-- 
1.7.0.5

