Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab1HILZ6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 07:25:58 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:14830 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944Ab1HILZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 07:25:57 -0400
X-IronPort-AV: E=Sophos;i="4.67,342,1309737600"; 
   d="scan'208";a="7175233"
Subject: Re: [Xen-devel] [PATCH 2/3] xen/pv-on-hvm kexec: rebind virqs to
 existing eventchannel ports
From: Ian Campbell <Ian.Campbell@eu.citrix.com>
To: Olaf Hering <olaf@aepfle.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Jeremy Fitzhardinge" <jeremy@goop.org>,
        Konrad <konrad.wilk@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
In-Reply-To: <20110809092938.GB7283@aepfle.de>
References: <20110804162053.723541930@aepfle.de>
	 <20110804162054.510901329@aepfle.de>
	 <1312881460.26263.46.camel@zakaz.uk.xensource.com>
	 <20110809092938.GB7283@aepfle.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Tue, 9 Aug 2011 12:25:55 +0100
Message-ID: <1312889155.26263.106.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-08-09 at 10:29 +0100, Olaf Hering wrote:
> On Tue, Aug 09, Ian Campbell wrote:
> 
> > On Thu, 2011-08-04 at 17:20 +0100, Olaf Hering wrote:
> > > During a kexec boot some virqs such as timer and debugirq were already
> > > registered by the old kernel.  The hypervisor will return -EEXISTS from
> > > the new EVTCHNOP_bind_virq request and the BUG in bind_virq_to_irq()
> > > triggers.  Catch the -EEXISTS error and loop through all possible ports to find
> > > what port belongs to the virq/cpu combo.
> > 
> > Would it be better to proactively just query the status of all event
> > channels early on, like you do in find_virq, and setup the irq info
> > structures as appropriate? Rather than waiting for an -EEXISTS I mean.
> 
> Doing one hypercall in the common case is cheaper than doing a dozen in
> the kexec case.

It's actually up to NR_EVENT_CHANNELS*NR_VIRQS (since you will do this
each time you find a VIRQ which is already bound) which is 24,576 on 32
bit and 98,304 hypercalls on 64 bit. If you just do it in the common
case (i.e. query each VIRQ once) then it is "only" 1024 in the 32 bit
case and 4096 in the 64 bit case.

I guess there's probably no way to detect if/when we need to do this? I
suppose we could scan all VIRQs on on the first -EEXISTS?

> If you prefer I will rearrange this part and query first.
> 
> Olaf


