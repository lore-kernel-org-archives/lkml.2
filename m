Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754095Ab1KGPNg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 10:13:36 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34448 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab1KGPNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 10:13:34 -0500
Message-ID: <4EB7F58D.6080102@redhat.com>
Date: Mon, 07 Nov 2011 17:13:17 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Gleb Natapov <gleb@redhat.com>, kvm@vger.kernel.org, mtosatti@redhat.com,
        linux-kernel@vger.kernel.org, mingo@elte.hu, acme@ghostprotocols.net
Subject: Re: [PATCHv2 2/9] KVM: Expose a version 2 architectural PMU to a
 guests
References: <1320323618-10375-1-git-send-email-gleb@redhat.com>   <1320323618-10375-3-git-send-email-gleb@redhat.com>  <1320676467.18053.43.camel@twins> <4EB7EF4F.3090907@redhat.com> <1320677949.18053.54.camel@twins>
In-Reply-To: <1320677949.18053.54.camel@twins>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2011 04:59 PM, Peter Zijlstra wrote:
> > > > +                */
> > > > +               if (!kvm_is_in_guest())
> > > > +                       irq_work_queue(&pmc->vcpu->arch.pmu.irq_work);
> > > > +               else
> > > > +                       kvm_make_request(KVM_REQ_PMI, pmc->vcpu);
> > > > +       }
> > > > +} 
> > >
> > > I'm not sure I get this, since the counters are vcpu task bound and only
> > > count while the guest is running as per (144d31e6f19) how can we get an
> > > NMI outside of guest context with the vcpu not halted?
> > 
> > PMI skew.  Do we know how bad it can get?
>
> You're talking about the PMI getting asserted before leaving guest mode
> but not getting ran until after we left guest mode?

Yes (here, "guest mode" is not the hardware guest mode, but what
kvm_is_in_guest() returns).

> But in that case we know the guest is stopped, right? So we can simply
> set that REQ_PMI bit and have guest entry sort things, no?

Unless there is no guest entry, due to the guest sleeping.

Consider the sequence:

guest:
   nop
hardware:
   counter overflow; PMI sent to APIC
guest:
   hlt
hardware:
   begin vmexit due to HLT
host:
   process vmexit
   mark as outside guest mode (i.e. kvm_is_in_guest() now returns false)
   schedule(), since the guest is sleeping (and assume no interrupts
pending)
hardware:
   APIC finally posts NMI
host:
   process NMI; set KVM_REQ_PMI
   iret
host:
   happily do other things, ignoring that we need to post a PMI to the guest

note, this needs a fairly huge PMI skew to happen.

(btw, like userspace, kvm PMIs may as well be ordinary interrupts. 
Should we consider some logic to only make them NMIs if some counter
requires it?  NMI costs are set to increase dramatically with the
check-all-possible-sources patchset).

-- 
error compiling committee.c: too many arguments to function

