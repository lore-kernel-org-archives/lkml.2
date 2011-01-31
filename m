Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754190Ab1AaSEi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 13:04:38 -0500
Received: from claw.goop.org ([74.207.240.146]:36704 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751434Ab1AaSEh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 13:04:37 -0500
Message-ID: <4D46F9AE.80606@goop.org>
Date: Mon, 31 Jan 2011 10:04:30 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Kaushik Barde <kbarde@huawei.com>
CC: "'Avi Kivity'" <avi@redhat.com>, "'Jan Beulich'" <JBeulich@novell.com>,
        "'Xiaowei Yang'" <xiaowei.yang@huawei.com>,
        "'Nick Piggin'" <npiggin@kernel.dk>,
        "'Peter Zijlstra'" <a.p.zijlstra@chello.nl>, fanhenglong@huawei.com,
        "'Kenneth Lee'" <liguozhu@huawei.com>,
        "'linqaingmin'" <linqiangmin@huawei.com>, wangzhenguo@huawei.com,
        "'Wu Fengguang'" <fengguang.wu@intel.com>,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        "'Marcelo Tosatti'" <mtosatti@redhat.com>
Subject: Re: One (possible) x86 get_user_pages bug
References: <4D416D9A.9010603@huawei.com> <4D419416020000780002ECB7@vpn.id2.novell.com> <4D41B90D.5000305@goop.org> <4D456139.4090508@redhat.com> <001801cbc0cc$00d98d70$028ca850$@com>
In-Reply-To: <001801cbc0cc$00d98d70$028ca850$@com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2011 02:21 PM, Kaushik Barde wrote:
> I agree i.e. deviation from underlying arch consideration is not a good
> idea.
>
> Also, agreed, hypervisor knows which page entries are ready for TLB flush
> across vCPUs. 
>
> But, using above knowledge, along with TLB flush based on IPI is a better
> solution.  Its ability to synchronize it with pCPU based IPI and TLB flush
> across vCPU. is key. 

I'm not sure I follow you here.  The issue with TLB flush IPIs is that
the hypervisor doesn't know the purpose of the IPI and ends up
(potentially) waking up a sleeping VCPU just to flush its tlb - but
since it was sleeping there were no stale TLB entries to flush.

Xen's TLB flush hypercalls can optimise that case by only sending a real
IPI to PCPUs which are actually running target VCPUs.  In other cases,
where a PCPU is known to have stale entries but it isn't running a
relevant VCPU, it can just mark a deferred TLB flush which gets executed
before the VCPU runs again.

In other words, Xen can take significant advantage of getting a
higher-level call ("flush these TLBs") compared just a simple IPI.

Are you suggesting that the hypervisor should export some kind of "known
dirty TLB" table to the guest, and have the guest work out which VCPUs
need IPIs sent to them?  How would that work?

> IPIs themselves should be in few hundred uSecs in terms latency. Also, why
> should pCPU be in sleep state for active vCPU scheduled page workload?

A "few hundred uSecs" is really very slow - that's nearly a
millisecond.  It's worth spending some effort to avoid those kinds of
delays.

    J

> -Kaushik
>
> -----Original Message-----
> From: Avi Kivity [mailto:avi@redhat.com] 
> Sent: Sunday, January 30, 2011 5:02 AM
> To: Jeremy Fitzhardinge
> Cc: Jan Beulich; Xiaowei Yang; Nick Piggin; Peter Zijlstra;
> fanhenglong@huawei.com; Kaushik Barde; Kenneth Lee; linqaingmin;
> wangzhenguo@huawei.com; Wu Fengguang; xen-devel@lists.xensource.com;
> linux-kernel@vger.kernel.org; Marcelo Tosatti
> Subject: Re: One (possible) x86 get_user_pages bug
>
> On 01/27/2011 08:27 PM, Jeremy Fitzhardinge wrote:
>> And even just considering virtualization, having non-IPI-based tlb
>> shootdown is a measurable performance win, since a hypervisor can
>> optimise away a cross-VCPU shootdown if it knows no physical TLB
>> contains the target VCPU's entries.  I can imagine the KVM folks could
>> get some benefit from that as well.
> It's nice to avoid the IPI (and waking up a cpu if it happens to be 
> asleep) but I think the risk of deviating too much from the baremetal 
> arch is too large, as demonstrated by this bug.
>
> (well, async page faults is a counterexample, I wonder if/when it will 
> bite us)
>

