Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab1ELOiA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 10:38:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:65215 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757491Ab1ELOh7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 10:37:59 -0400
Message-ID: <4DCBF0B7.7080102@redhat.com>
Date: Thu, 12 May 2011 17:37:43 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Joerg Roedel <joro@8bytes.org>
CC: Jan Kiszka <jan.kiszka@siemens.com>, linux-kernel@vger.kernel.org,
        kvm@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [PATCH v1 0/5] KVM in-guest performance monitoring
References: <1305129333-7456-1-git-send-email-avi@redhat.com> <20110512093309.GD8707@8bytes.org> <4DCBACC7.8080000@siemens.com> <20110512131130.GG8707@8bytes.org> <4DCBE13A.2050204@redhat.com> <20110512142449.GI8707@8bytes.org>
In-Reply-To: <20110512142449.GI8707@8bytes.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/2011 05:24 PM, Joerg Roedel wrote:
> >  Paravirtualizing does have its advantages.  For the PMU, for example, we
> >  can have a single hypercall read and reprogram all counters, saving
> >  *many* exits.  But I think we need to start from the architectural PMU
> >  and see exactly what the problems are, before we optimize it to death.
>
> The problem certainly is that with arch-pmu we add a lot of msr-exits to
> the guest-context-switch path if it uses per-task profiling. Depending
> on the workload this can very much distort the results.

Right.  The combination of per-task profiling with high context switch 
rates is problematic.

One thing we could do is paravirtualize at a lower level, introduce a 
hypercall for batch MSR reads and writes.  So we can use the existing 
PMU semantics and code, just optimize the switch.  This is similar to 
what Xen did with lazy cpu updates, and what kvm did for paravirt 
pagetable writes.

I've considered something similar for mmio - use hypercalls for ordinary 
mmio to avoid calling into the emulator - but virtio uses pio which 
isn't emulated and we don't have massive consumers of mmio (except 
perhaps hpet).

(and we can have a cpuid bit that advertises whether we recommend to use 
this feature for PMU MSRs; if/when we get hardware support, we turn it off)

-- 
error compiling committee.c: too many arguments to function

