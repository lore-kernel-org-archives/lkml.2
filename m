Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab1EICLc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 22:11:32 -0400
Received: from mga14.intel.com ([143.182.124.37]:12602 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932321Ab1EICLb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 22:11:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,338,1301900400"; 
   d="scan'208";a="432696897"
From: "Tian, Kevin" <kevin.tian@intel.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: Thomas Gleixner <tglx@linutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        "JBeulich@novell.com" <JBeulich@novell.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
Date: Mon, 9 May 2011 10:11:13 +0800
Subject: RE: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
Thread-Topic: [PATCH v2 2/2] x86: don't unmask disabled irqs when migrating
 them
Thread-Index: AcwL+bTQLIdKuFPJQSKYXmpwNiVr0QB8sQcw
Message-ID: <625BA99ED14B2D499DC4E29D8138F1505C8ED7FB9F@shsmsx502.ccr.corp.intel.com>
References: <625BA99ED14B2D499DC4E29D8138F1505C8ED7F7E3@shsmsx502.ccr.corp.intel.com>
 <alpine.LFD.2.02.1105061149330.3005@ionos>
 <625BA99ED14B2D499DC4E29D8138F1505C8ED7F962@shsmsx502.ccr.corp.intel.com>
 <alpine.DEB.2.00.1105061526120.10886@kaball-desktop>
In-Reply-To: <alpine.DEB.2.00.1105061526120.10886@kaball-desktop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Stefano Stabellini [mailto:stefano.stabellini@eu.citrix.com]
> Sent: Friday, May 06, 2011 10:29 PM
> 
> On Fri, 6 May 2011, Tian, Kevin wrote:
> > > From: Thomas Gleixner
> > > Sent: Friday, May 06, 2011 6:00 PM
> > >
> > > On Fri, 6 May 2011, Tian, Kevin wrote:
> > > > x86: don't unmask disabled irqs when migrating them
> > > >
> > > > it doesn't make sense to mask/unmask a disabled irq when migrating
> > > > it from offlined cpu to another, because it's not expected to
> > > > handle any instance of it. Current mask/set_affinity/unmask steps
> > > > may trigger unexpected instance on disabled irq which then simply
> > > > bug on when there is no handler for it. One failing example is observed in
> Xen.
> > > > Xen pvops
> > >
> > > So there is no handler, why the heck is there an irq action?
> > >
> > > 	  if (!irq_has_action(irq) ....
> > > 	     	continue;
> > >
> > > Should have caught an uninitialized interrupt. If Xen abuses
> > > interrupts that way, then it rightfully explodes. And we do not fix it by magic
> somewhere else.
> >
> > sorry that my bad description here. there does be a dummy handler
> > registered on such irqs which simply throws out a BUG_ON when hit. I
> > should just say such injection is not expected instead of no handler.
> > :-)
> 
> I don't think this patch is necessary anymore after the event channel handling
> cleanup patches I have just sent to the list.
> Could you please try the following two patches:
> 
> http://marc.info/?l=linux-kernel&m=130468120032172&w=2
> http://marc.info/?l=linux-kernel&m=130468178200468&w=2
> 
> and let me know if you still need this patch?

yes, with your patch this issue disappears, since you explicitly make mask/unmask as
a nop for xen_percpu_chip, which effectively avoids them from undesired unmask
when doing the migration. Though it works, it's not intuitive as to me it's an
workaround to make Xen chip implementation adapting to specific fixup_irqs logic.
If the logic within fixup_irqs is changed in the future, it's still possible to expose this
issue again. If we explicitly avoid the percpu irqs in the 1st place in fixup_irqs like
what my 1st patch does, it'd be clearer.

But based on your referred patchesand Jeremy's info about possible unbinding xenn 
event from irq namespace, my patches are not that necessary now as before. So I'll leave 
to Thomas to decide whether he wants to take my 1st patch. the 2nd one talked in this
thread could be dropped. 

Thanks
Kevin
