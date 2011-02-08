Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752488Ab1BHJQE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 04:16:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51004 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253Ab1BHJQB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 04:16:01 -0500
Message-ID: <4D5109CC.2030901@redhat.com>
Date: Tue, 08 Feb 2011 11:15:56 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Jan Kiszka <jan.kiszka@siemens.com>
CC: Zachary Amsden <zamsden@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        kvm <kvm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: x86: Convert tsc_write_lock to raw_spinlock
References: <4D4BCB97.6000900@siemens.com> <4D4C698A.4010201@redhat.com> <4D4FD8EE.6040009@siemens.com> <4D4FFD97.6010805@redhat.com> <4D5008F0.5060200@siemens.com> <4D500C9F.2080501@redhat.com> <4D50120F.4030809@siemens.com> <4D501547.6040907@redhat.com> <4D501698.1000507@siemens.com> <4D501D43.5060608@redhat.com> <4D5024F3.9090105@siemens.com> <4D5027A1.8000505@redhat.com> <4D502AA5.7040407@siemens.com>
In-Reply-To: <4D502AA5.7040407@siemens.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/07/2011 07:23 PM, Jan Kiszka wrote:
> On 2011-02-07 18:10, Avi Kivity wrote:
> >  On 02/07/2011 06:59 PM, Jan Kiszka wrote:
> >>>
> >>>   (well, actually, cpufreq_notifier and kvm_arch_hardware_enable are
> >>>   already non preemptible, and the stats code should just go away?)
> >>
> >>  The stats code is trivial to convert, so it doesn't matter.
> >
> >  Removal is easier.
>
> Is that stat interface no longer used?

It's there for compatibility.  I'm itching to remove it.  See 
qemu-kvm.git/kvm/kvm_stat for the only known user, and for the 
replacement via tracepoints.

Tracepoints have marginally lower overhead when disabled, and somewhat 
higher overhead when enabled.  A disadvantage of tracepoints is that it 
is harder to associate an event with a vm when that event is triggered 
by a workqueue, but I don't think it matters in practice (kvm_stat 
doesn't even provide a per-vm breakdown).

> >
> >>  But what about mmu_shrink and its list_move_tail? How is this
> >>  synchronized against kvm_destroy_vm - already today?
> >
> >  kvm_destroy_vm() takes kvm_lock.  If a vm is destroyed before
> >  mmu_shrink(), mmu_shrink() will never see it.  If we reach mmu_shrink()
> >  before kvm_destroy_vm(), the latter will wait until mmu_shrink() is done.
> >
>
> Ah, I was confused. Would require some more logic if we wanted to make
> the loop lock-less, though.

Yes, the usual rcu_read_lock() / grab reference / rcu_read_unlock().

-- 
error compiling committee.c: too many arguments to function

