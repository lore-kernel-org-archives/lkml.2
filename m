Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934403Ab1FWUNa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 16:13:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:40001 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932792Ab1FWUN2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 16:13:28 -0400
Date: Thu, 23 Jun 2011 17:13:19 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 21/22] KVM: MMU: mmio page fault support
Message-ID: <20110623201319.GA19483@amt.cnet>
References: <4E01FBC9.3020009@cn.fujitsu.com>
 <4E01FDE0.5080800@cn.fujitsu.com>
 <20110622215940.GA30064@amt.cnet>
 <4E02B0BE.7070003@cn.fujitsu.com>
 <20110623142134.GA12181@amt.cnet>
 <4E037E21.6010203@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E037E21.6010203@cn.fujitsu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 24, 2011 at 01:55:45AM +0800, Xiao Guangrong wrote:
> On 06/23/2011 10:21 PM, Marcelo Tosatti wrote:
> 
> >>> An spte does not have to contain the present bit to generate a valid EPT
> >>> misconfiguration (and an spte dump is still required in that case).
> >>> Use !is_mmio_spte() instead.
> >>>
> >>
> >> We can not use !is_mmio_spte() here, since the shadow page can be zapped anytime,
> >> for example:
> >>
> >> sp.spt[i] = mmio-spte
> >>
> >>           VCPU 0                                    VCPU 1    
> >> Access sp.spte[i], ept misconfig is occurred
> >>                                                    delete sp
> >>                                    (if the number of shadow page is out of the limit
> >>                                     or page shrink is required, and other events...)
> >>
> >> Walk shadow page out of the lock and get the
> >> non-present spte
> >> (*the point we are discussing*)
> > 
> > Then is_mmio_spte(non-present spte) == false, right? Point is that it
> > only sptes with precise mmio spte pattern should be considered mmio
> > sptes, otherwise consider a genuine EPT misconfiguration error (which
> > must be reported).
> > 
> 
> No, not all no mmio spte is considered a genuine EPT misconfig, as the above
> case, we can get !is_mmio_spte(), but it is not the genuine EPT misconfig
> since it is caused by shadow page zapped

I mean it must be

if (is_mmio_spte(spte))
    handle_mmio
if (spte == spte_not_present) /* race, let CPU refault */
    return
handle EPT misconf

> > What about using fault code instead of spte as Avi suggested instead?
> > 
> 
> Do you mean waking guest page table to get mmio gva/mmio gpa for softmmu instead
> of walking shadow page table?
> 
> I think it is unsafe, since guest can change the mapping anytime, we can get the
> wrong mmio gva/mmio gpa to mmio emulate, consider follow case:
> 
> gva is mapped to the mmio region, we set the reserved bits in the spte:
> 
> VCPU 0                                               VCPU 1
> Access gva, reserved page fault is occurred
>                                              map gva to the RAM region
> Walking guest page table and get the RAM gpa           TLB flush
> (*the point we are discussing*)
> 
> Then we can get the wrong gpa to mmio emulate, so
> - VMM can detected the invalid mmio access
> - the event is missed, it neither accesses the mmio region nor the RAM region,
>   it is not as the real cpu does
> 
> Anyway, mmio spte is needed to detect bugs for hard mmu

Actually i was thinking about EPT misconf, but there are no other fields
than GPA. 

