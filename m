Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751257Ab1CJIhV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 03:37:21 -0500
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:52253 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944Ab1CJIhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 03:37:20 -0500
X-IronPort-AV: E=Sophos;i="4.62,295,1297036800"; 
   d="scan'208";a="4713189"
Subject: Re: [Xen-devel] [PATCH 06/14] xen: events: refactor GSI pirq
 bindings functions
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
In-Reply-To: <20110310040042.GA7682@dumpdata.com>
References: <1299692459.17339.700.camel@zakaz.uk.xensource.com>
	 <1299692486-28634-6-git-send-email-ian.campbell@citrix.com>
	 <20110310040042.GA7682@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 10 Mar 2011 08:37:18 +0000
Message-ID: <1299746238.17339.716.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-10 at 04:00 +0000, Konrad Rzeszutek Wilk wrote:
> 	if (0 == nr_ioapics) {
> > -		for (irq = 0; irq < NR_IRQS_LEGACY; irq++)
> > -			xen_allocate_pirq(irq, 0, "xt-pic");
> > +		for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
> > +			pirq = xen_allocate_pirq_gsi(irq);
> > +			if (pirq < 0)
> > +				break;
> 
> Would it make sense to print a warning here?

I was almost tempted by a BUG_ON but:

8<-------------------------------------------------

>From b5f92c9d914988cd29c45a84cde462a8588467b6 Mon Sep 17 00:00:00 2001
From: Ian Campbell <ian.campbell@citrix.com>
Date: Thu, 10 Mar 2011 08:36:55 +0000
Subject: [PATCH] xen: irq: warn if we cannot allocate a PIRQ for the legacy IRQs in dom0

Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
---
 arch/x86/pci/xen.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/arch/x86/pci/xen.c b/arch/x86/pci/xen.c
index 3ee5f4a..ca58a73 100644
--- a/arch/x86/pci/xen.c
+++ b/arch/x86/pci/xen.c
@@ -452,7 +452,8 @@ void __init xen_setup_pirqs(void)
 	if (0 == nr_ioapics) {
 		for (irq = 0; irq < NR_IRQS_LEGACY; irq++) {
 			pirq = xen_allocate_pirq_gsi(irq);
-			if (pirq < 0)
+			if (WARN(pirq < 0,
+				 "Could not allocate PIRQ for legacy interrupt\n"))
 				break;
 			irq = xen_bind_pirq_gsi_to_irq(irq, pirq, 0, "xt-pic");
 		}
-- 
1.5.6.5



