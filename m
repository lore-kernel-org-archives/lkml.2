Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755826Ab2ACWiP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 17:38:15 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39785 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755720Ab2ACWiK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 17:38:10 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Jan  3 14:30:34 2012
Message-Id: <20120103223034.858164210@clark.kroah.org>
User-Agent: quilt/0.50-25.1
Date: Tue, 03 Jan 2012 14:30:00 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, "David S. Miller" <davem@davemloft.net>
Subject: [42/67] sparc64: Fix MSIQ HV call ordering in pci_sun4v_msiq_build_irq().
In-Reply-To: <20120103223043.GA26738@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 7cc8583372a21d98a23b703ad96cab03180b5030 ]

This silently was working for many years and stopped working on
Niagara-T3 machines.

We need to set the MSIQ to VALID before we can set it's state to IDLE.

On Niagara-T3, setting the state to IDLE first was causing HV_EINVAL
errors.  The hypervisor documentation says, rather ambiguously, that
the MSIQ must be "initialized" before one can set the state.

I previously understood this to mean merely that a successful setconf()
operation has been performed on the MSIQ, which we have done at this
point.  But it seems to also mean that it has been set VALID too.

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/sparc/kernel/pci_sun4v.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/arch/sparc/kernel/pci_sun4v.c
+++ b/arch/sparc/kernel/pci_sun4v.c
@@ -848,10 +848,10 @@ static int pci_sun4v_msiq_build_irq(stru
 	if (!irq)
 		return -ENOMEM;
 
-	if (pci_sun4v_msiq_setstate(pbm->devhandle, msiqid, HV_MSIQSTATE_IDLE))
-		return -EINVAL;
 	if (pci_sun4v_msiq_setvalid(pbm->devhandle, msiqid, HV_MSIQ_VALID))
 		return -EINVAL;
+	if (pci_sun4v_msiq_setstate(pbm->devhandle, msiqid, HV_MSIQSTATE_IDLE))
+		return -EINVAL;
 
 	return irq;
 }


