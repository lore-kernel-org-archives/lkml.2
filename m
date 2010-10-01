Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756156Ab0JAUsb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 16:48:31 -0400
Received: from mxout1.idt.com ([157.165.5.25]:45729 "EHLO mxout1.idt.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab0JAUsa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 16:48:30 -0400
X-MimeOLE: Produced By Microsoft Exchange V6.5
Content-class: urn:content-classes:message
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Subject: RE: [PATCH v2 03/10] RapidIO: Use stored ingress port number instead of register read
Date: Fri, 1 Oct 2010 13:46:06 -0700
Message-ID: <0CE8B6BE3C4AD74AB97D9D29BD24E5520137C432@CORPEXCH1.na.ads.idt.com>
In-Reply-To: <4C97C6D8.4010407@neli.hopto.org>
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
thread-topic: [PATCH v2 03/10] RapidIO: Use stored ingress port number instead of register read
thread-index: ActZA7LM6/OAgaIuSP+K985Hm9p+XgIn5i/Q
References: <1284476363-1677-1-git-send-email-alexandre.bounine@idt.com><1284476363-1677-4-git-send-email-alexandre.bounine@idt.com> <20100914151219.5d92c6f9.akpm@linux-foundation.org> <0CE8B6BE3C4AD74AB97D9D29BD24E55201303D0E@CORPEXCH1.na.ads.idt.com> <4C97C6D8.4010407@neli.hopto.org>
From: "Bounine, Alexandre" <Alexandre.Bounine@idt.com>
To: "Micha Nelissen" <micha@neli.hopto.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        "Thomas Moll" <thomas.moll@sysgo.com>,
        "Matt Porter" <mporter@kernel.crashing.org>,
        "Li Yang" <leoli@freescale.com>,
        "Kumar Gala" <galak@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Micha,

Sorry for delayed reply.

Micha Nelissen <micha@neli.hopto.org> wrote:
> 
> Bounine, Alexandre wrote:
> > struct rio_dev {
> >     struct list_head global_list;
> >     struct list_head net_list;
> >     .....
> >     ..... rest of rio_dev
> >     .....
> >     struct rio_switch switch[0];
> > }
> 
> It makes sense to let rio_dev structures point to the switch they are
> attached to. That can be useful in various situations, but is not
> possible with this setup.
> 
> If a rio_dev is a switch then rdev->rswitch->rdev == rdev holds.
>

But the switch is a RIO device itself and all other parts of rio_dev
structure
are applicable to it as well. If there is situation when a device 
needs to hold a pointer to the attached switch that should be a pointer
to the switch rio_dev and not to its switch-specific extension. 
 
> > This will remove extra memory allocation, remove overlapping
structure
> > members and clean code sections like one shown below:
> >
> > 	u8 hopcount = 0xff;
> > 	u16 destid = rdev->destid;
> >
> > 	if (rdev->rswitch) {
> > 		destid = rdev->rswitch->destid;
> > 		hopcount = rdev->rswitch->hopcount;
> > 	}
> 
> Note that it is possible for rdev->destid to differ from
> rdev->rswitch->destid even if rswitch->rdev == rdev (for non-hosts
i.e.
> agents). rswitch->destid is the destid by which we discovered the
switch
> (and can reach it) but rdev->destid is the actual id given to the
switch.
> 

My goal is to have one destid storage for device - endpoint or switch.
And destid should be used only for one purpose: to reach corresponding
device.
In your statement above you suggest using rdev->destid instead of
rswitch->switchid.
RIO switches do not have any specific RIO ID that can be assigned to the
switch.
In this case the rswitch->switchid should work well for logical
identification
of the switch.

I think if (for switch) we load rdev->destid with some function
different
from its routing role this may bring unnecessary confusion.

I also will move rswitch->hopcount to rdev->hopcount. For endpoint it
will be set
to 0xff during rio_dev initialization.

Alex.
       
