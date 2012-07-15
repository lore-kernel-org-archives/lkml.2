Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751827Ab2GOKKF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 06:10:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751178Ab2GOKKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 06:10:01 -0400
Message-ID: <500296F3.1060603@redhat.com>
Date: Sun, 15 Jul 2012 13:09:55 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Alex Williamson <alex.williamson@redhat.com>
CC: Jan Kiszka <jan.kiszka@siemens.com>, "mst@redhat.com" <mst@redhat.com>,
        "gleb@redhat.com" <gleb@redhat.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3 0/2] kvm: level irqfd and new eoifd
References: <20120703191106.6735.78272.stgit@bling.home>  <4FFD4D0A.2000202@redhat.com> <4FFD52E7.3030806@siemens.com>  <4FFD5A2B.2040605@redhat.com> <4FFD6221.1060304@siemens.com>  <4FFD68C3.7000504@redhat.com> <1342036673.2229.17.camel@bling.home>  <4FFE9A6F.3080607@redhat.com> <1342109982.10815.20.camel@ul30vt> <1342114713.10815.25.camel@ul30vt>
In-Reply-To: <1342114713.10815.25.camel@ul30vt>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 08:38 PM, Alex Williamson wrote:
> On Thu, 2012-07-12 at 10:19 -0600, Alex Williamson wrote:
>> On Thu, 2012-07-12 at 12:35 +0300, Avi Kivity wrote:
>> > On 07/11/2012 10:57 PM, Alex Williamson wrote:
>> > >> 
>> > >> > We still have classic KVM device assignment to provide fast-path INTx.
>> > >> > But if we want to replace it midterm, I think it's necessary for VFIO to
>> > >> > be able to provide such a path as well.
>> > >> 
>> > >> I would like VFIO to have no regressions vs. kvm device assignment,
>> > >> except perhaps in uncommon corner cases.  So I agree.
>> > > 
>> > > I ran a few TCP_RR netperf tests forcing a 1Gb tg3 nic to use INTx.
>> > > Without irqchip support vfio gets a bit more than 60% of KVM device
>> > > assignment.  That's a little bit of an unfair comparison since it's more
>> > > than just the I/O path.  With the proposed interfaces here, enabling
>> > > irqchip, vfio is within 10% of KVM device assignment for INTx.  For MSI,
>> > > I can actually make vfio come out more than 30% better than KVM device
>> > > assignment if I send the eventfd from the hard irq handler.  Using a
>> > > threaded handler as the code currently does, vfio is still behind KVM.
>> > > It's hard to beat a direct call chain.
>> > 
>> > We can have a direct call chain with vfio too, using a custom eventfd
>> > poll function, no?  Assuming we set up a fast path for unicast msi.
>> 
>> You'll have to help me out a little, eventfd_signal walks the wait_queue
>> and calls each function.  On the injection path that includes
>> irqfd_wakeup.  For an MSI that seems to already provide direct
>> injection.  For level we'll schedule_work, so that explains the overhead
>> in that path, but it's not too dissimilar to a a threaded irq.  vfio
>> does something very similar, so there's a schedule_work both on inject
>> and on eoi.  I'll have to check whether anything prevents the unmask
>> from the wait_queue function in vfio, that could be a significant chunk
>> of the gap.
> 
> Yep, the schedule_work in the eoi is the culprit.  A direct unmask from
> the wait queue function gives me better results than kvm for INTx.
> We'll have to see how the leapfrogging goes once KVM switches to
> injection from the hard handler.  I'm still curious what this custom
> poll function would give us though.  Thanks,
> 

btw, why is the overhead so large?  A context switch should be on the
order of 1 microsecond or less.  Given that, every 5000 context switches
per second cost a 1% cpu load on one core.  You would need a very heavy
interrupt load to see  a large degradation.  Or is the extra latency the
problem?

-- 
error compiling committee.c: too many arguments to function


