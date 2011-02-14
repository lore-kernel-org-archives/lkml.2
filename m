Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1BNAft (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 19:35:49 -0500
Received: from sous-sol.org ([216.99.217.87]:44408 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755225Ab1BNAfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 19:35:45 -0500
Date: Sun, 13 Feb 2011 16:35:31 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@gmail.com>, Dave Young <hidave.darkstar@gmail.com>,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        dri-devel@lists.freedesktop.org, Chris Wright <chrisw@sous-sol.org>,
        James Morris <jmorris@namei.org>
Subject: Re: Regression - Xorg start failed
Message-ID: <20110214003531.GH9869@sequoia.sous-sol.org>
References: <20110213062213.GA2525@darkstar.dhcp.inet.fi>
 <AANLkTimDuYgL2cSR8gE7Wrm9_w7cvG_wuUUsa=8TKs87@mail.gmail.com>
 <AANLkTimxCMgdfht7rrg8QiCppb=D7fvR92eeiewdqCpH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimxCMgdfht7rrg8QiCppb=D7fvR92eeiewdqCpH@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Sat, Feb 12, 2011 at 11:53 PM, Dave Airlie <airlied@gmail.com> wrote:
> > Probably should revert first, then work out what is crapping out libpciaccess.
> 
> Yeah, I'll revert. The patch is one of those "obviously a good idea,
> but in practice it's not something we can change now".

Turns out I'm just a bona fide idiot.

I was not testing the right kernel _and_ didn't get the logic right.

sorry for the screw up,
-chris
---

Subject: [PATCH] pci: use security_capable correctly during config space read

Commit 47970b1 ("pci: use security_capable() when checking capablities
during config space read") is just plain broken.  The normal capable()
interface returns true on success, but the LSM interface returns 0 on
success.

Signed-off-by: Chris Wright <chrisw@sous-sol.org>
---

I've tested this quickly (lspci behaviour is as expected).

diff --git a/drivers/pci/pci-sysfs.c b/drivers/pci/pci-sysfs.c
index f7771f3..ea25e5b 100644
--- a/drivers/pci/pci-sysfs.c
+++ b/drivers/pci/pci-sysfs.c
@@ -369,7 +369,7 @@ pci_read_config(struct file *filp, struct kobject *kobj,
 	u8 *data = (u8*) buf;
 
 	/* Several chips lock up trying to read undefined config space */
-	if (security_capable(filp->f_cred, CAP_SYS_ADMIN)) {
+	if (security_capable(filp->f_cred, CAP_SYS_ADMIN) == 0) {
 		size = dev->cfg_size;
 	} else if (dev->hdr_type == PCI_HEADER_TYPE_CARDBUS) {
 		size = 128;


