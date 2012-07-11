Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933209Ab2GKT57 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 15:57:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45993 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933145Ab2GKT54 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 15:57:56 -0400
Message-ID: <1342036673.2229.17.camel@bling.home>
Subject: Re: [PATCH v3 0/2] kvm: level irqfd and new eoifd
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, "mst@redhat.com" <mst@redhat.com>,
        "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 11 Jul 2012 13:57:53 -0600
In-Reply-To: <4FFD68C3.7000504@redhat.com>
References: <20120703191106.6735.78272.stgit@bling.home>
	 <4FFD4D0A.2000202@redhat.com> <4FFD52E7.3030806@siemens.com>
	 <4FFD5A2B.2040605@redhat.com> <4FFD6221.1060304@siemens.com>
	 <4FFD68C3.7000504@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 14:51 +0300, Avi Kivity wrote:
> On 07/11/2012 02:23 PM, Jan Kiszka wrote:
> >> 
> >> I'd appreciate a couple of examples for formality's sake.
> > 
> > From the top of my head: NVIDIA FX3700 (granted, legacy by now), Atheros
> > AR9287. For others, I need to check.
> 
> Thanks.
> 
> >> 
> >>> And then there is not easily replaceable legacy hardware like old
> >>> telephony adapters or industrial I/O cards etc. that want this.
> >> 
> >> I imagine legacy hardware will live with the speed of routing through
> >> qemu, when running on modern platforms.
> > 
> > Just because it's "legacy" doesn't mean it's "low performance" and "low
> > interrupt rate".
> 
> I meant that it was used with lower throughput hardware, so the overhead
> of routing through qemu will be masked by the improved host hardware.
> But most of the improvement in hardware in recent years is the increase
> in core/thread count.
> 
> > We still have classic KVM device assignment to provide fast-path INTx.
> > But if we want to replace it midterm, I think it's necessary for VFIO to
> > be able to provide such a path as well.
> 
> I would like VFIO to have no regressions vs. kvm device assignment,
> except perhaps in uncommon corner cases.  So I agree.

I ran a few TCP_RR netperf tests forcing a 1Gb tg3 nic to use INTx.
Without irqchip support vfio gets a bit more than 60% of KVM device
assignment.  That's a little bit of an unfair comparison since it's more
than just the I/O path.  With the proposed interfaces here, enabling
irqchip, vfio is within 10% of KVM device assignment for INTx.  For MSI,
I can actually make vfio come out more than 30% better than KVM device
assignment if I send the eventfd from the hard irq handler.  Using a
threaded handler as the code currently does, vfio is still behind KVM.
It's hard to beat a direct call chain.

For more devices, one that seems common among the non-enterprise users
are TV capture cards, like the old PVR-250/350 devices.  These don't
support MSI.  Thanks,

Alex

