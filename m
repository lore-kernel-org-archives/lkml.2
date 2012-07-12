Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030719Ab2GLQTr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 12:19:47 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934076Ab2GLQTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 12:19:45 -0400
Message-ID: <1342109982.10815.20.camel@ul30vt>
Subject: Re: [PATCH v3 0/2] kvm: level irqfd and new eoifd
From: Alex Williamson <alex.williamson@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Jan Kiszka <jan.kiszka@siemens.com>, "mst@redhat.com" <mst@redhat.com>,
        "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 12 Jul 2012 10:19:42 -0600
In-Reply-To: <4FFE9A6F.3080607@redhat.com>
References: <20120703191106.6735.78272.stgit@bling.home>
	  <4FFD4D0A.2000202@redhat.com> <4FFD52E7.3030806@siemens.com>
	  <4FFD5A2B.2040605@redhat.com> <4FFD6221.1060304@siemens.com>
	  <4FFD68C3.7000504@redhat.com> <1342036673.2229.17.camel@bling.home>
	 <4FFE9A6F.3080607@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 12:35 +0300, Avi Kivity wrote:
> On 07/11/2012 10:57 PM, Alex Williamson wrote:
> >> 
> >> > We still have classic KVM device assignment to provide fast-path INTx.
> >> > But if we want to replace it midterm, I think it's necessary for VFIO to
> >> > be able to provide such a path as well.
> >> 
> >> I would like VFIO to have no regressions vs. kvm device assignment,
> >> except perhaps in uncommon corner cases.  So I agree.
> > 
> > I ran a few TCP_RR netperf tests forcing a 1Gb tg3 nic to use INTx.
> > Without irqchip support vfio gets a bit more than 60% of KVM device
> > assignment.  That's a little bit of an unfair comparison since it's more
> > than just the I/O path.  With the proposed interfaces here, enabling
> > irqchip, vfio is within 10% of KVM device assignment for INTx.  For MSI,
> > I can actually make vfio come out more than 30% better than KVM device
> > assignment if I send the eventfd from the hard irq handler.  Using a
> > threaded handler as the code currently does, vfio is still behind KVM.
> > It's hard to beat a direct call chain.
> 
> We can have a direct call chain with vfio too, using a custom eventfd
> poll function, no?  Assuming we set up a fast path for unicast msi.

You'll have to help me out a little, eventfd_signal walks the wait_queue
and calls each function.  On the injection path that includes
irqfd_wakeup.  For an MSI that seems to already provide direct
injection.  For level we'll schedule_work, so that explains the overhead
in that path, but it's not too dissimilar to a a threaded irq.  vfio
does something very similar, so there's a schedule_work both on inject
and on eoi.  I'll have to check whether anything prevents the unmask
from the wait_queue function in vfio, that could be a significant chunk
of the gap.  Where's the custom poll function come into play?  Thanks,

Alex

