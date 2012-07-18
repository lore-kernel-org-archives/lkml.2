Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab2GRQwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:52:43 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:11794 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459Ab2GRQwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:52:41 -0400
X-IronPort-AV: E=Sophos;i="4.77,610,1336348800"; 
   d="scan'208";a="13593768"
Date: Wed, 18 Jul 2012 17:51:55 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>, "Tim (Xen.org)" <tim@xen.org>
Subject: Re: [PATCH WIP 6/6] xen/arm: enable evtchn irqs
In-Reply-To: <20120716145709.GB552@phenom.dumpdata.com>
Message-ID: <alpine.DEB.2.02.1207181750500.23783@kaball.uk.xensource.com>
References: <alpine.DEB.2.02.1206221644370.27860@kaball.uk.xensource.com> <1340381685-22529-1-git-send-email-stefano.stabellini@eu.citrix.com> <1340381685-22529-6-git-send-email-stefano.stabellini@eu.citrix.com> <20120709144005.GA12102@phenom.dumpdata.com>
 <alpine.DEB.2.02.1207131749470.23783@kaball.uk.xensource.com> <20120716145709.GB552@phenom.dumpdata.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 16 Jul 2012, Konrad Rzeszutek Wilk wrote:
> On Fri, Jul 13, 2012 at 06:14:33PM +0100, Stefano Stabellini wrote:
> > On Mon, 9 Jul 2012, Konrad Rzeszutek Wilk wrote:
> > > On Fri, Jun 22, 2012 at 05:14:45PM +0100, Stefano Stabellini wrote:
> > > > On ARM irqs are not enabled by default:
> > > 
> > > Which IRQs? Xen IRQs? Linux IRQs?
> > 
> > Linux IRQs
> > 
> > 
> > > > - call enable_percpu_irq for IRQ_EVTCHN_CALLBACK;
> > > 
> > > Why do we want to do that?
> >  
> > drivers are supposed to call enable_irq after request_irq, however on
> > x86 we could get away without it because Linux irqs are enabled by
> > default (see below)
> > 
> > 
> > > > - set the IRQF_VALID flag for the other irqs bound to evtchns. It causes
> > > > IRQ_NOAUTOEN to be set and as a consequence irq_unmask is going to be
> > > > called when a xenbus driver calls request_irq.
> > > 
> > > Can you explain in more details why we need that?
> > 
> > If _IRQ_NOAUTOEN is set, irq_settings_can_autoenable returns false and
> > __setup_irq doesn't call irq_startup.
> > 
> > IRQ_NOAUTOEN is set by default by set_irq_flags on ARM, but not on x86.
> 
> OK, please include those questions/answers in the git commit and
> repost.

---

xen/arm: enable evtchn irqs

On ARM Linux irqs are not enabled by default:

- call enable_percpu_irq for IRQ_EVTCHN_CALLBACK (drivers are supposed
to call enable_irq after request_irq);

- set the IRQF_VALID flag for the other irqs bound to evtchns. It causes
IRQ_NOAUTOEN to be set and as a consequence irq_unmask is going to be
called when a xenbus driver calls request_irq.
This is needed because IRQ_NOAUTOEN is set by set_irq_flags on ARM.
If IRQ_NOAUTOEN is set __setup_irq doesn't call irq_startup that is
responsible for calling irq_unmask at startup time.

Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index eae0d0b..ca92755 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -53,6 +53,7 @@
 #include <xen/interface/hvm/params.h>
 #include <xen/interface/physdev.h>
 #include <xen/interface/sched.h>
+#include <asm/hw_irq.h>
 
 /*
  * This lock protects updates to the following mapping and reference-count
@@ -824,6 +828,7 @@ int bind_evtchn_to_irq(unsigned int evtchn)
 
 		xen_irq_info_evtchn_init(irq, evtchn);
 	}
+	set_irq_flags(irq, IRQF_VALID);
 
 out:
 	mutex_unlock(&irq_mapping_update_lock);
@@ -1748,6 +1753,7 @@ int __init xen_init_IRQ_arm(void)
 	if (rc) {
 		printk(KERN_ERR "Error requesting IRQ %d\n", IRQ_EVTCHN_CALLBACK);
 	}
+	enable_percpu_irq(IRQ_EVTCHN_CALLBACK, 0);
 	return rc;
 }
 core_initcall(xen_init_IRQ_arm);
