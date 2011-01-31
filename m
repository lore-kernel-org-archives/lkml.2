Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab1AaWKU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 17:10:20 -0500
Received: from claw.goop.org ([74.207.240.146]:38003 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab1AaWKT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 17:10:19 -0500
Message-ID: <4D473343.7080708@goop.org>
Date: Mon, 31 Jan 2011 14:10:11 -0800
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
References: <4D416D9A.9010603@huawei.com> <4D419416020000780002ECB7@vpn.id2.novell.com> <4D41B90D.5000305@goop.org> <4D456139.4090508@redhat.com> <001801cbc0cc$00d98d70$028ca850$@com> <4D46F9AE.80606@goop.org> <003301cbc182$da3affc0$8eb0ff40$@com>
In-Reply-To: <003301cbc182$da3affc0$8eb0ff40$@com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2011 12:10 PM, Kaushik Barde wrote:
> << I'm not sure I follow you here.  The issue with TLB flush IPIs is that
> the hypervisor doesn't know the purpose of the IPI and ends up
> (potentially) waking up a sleeping VCPU just to flush its tlb - but
> since it was sleeping there were no stale TLB entries to flush.>>
>
> That's what I was trying understand, what is "Sleep" here? Is it ACPI sleep
> or some internal scheduling state? If vCPUs  are asynchronous to pCPU in
> terms of ACPI sleep state, then they need to synced-up. That's where entire
> ACPI modeling needs to be considered. That's where KVM may not see this
> issue. Maybe I am missing something here.

No, nothing to do with ACPI.  Multiple virtual CPUs (VCPUs) can be
multiplexed onto a single physical CPU (PCPU), in much the same way as
tasks are scheduled onto CPUs (identically, in KVM's case).  If a VCPU
is not currently running - either because it is simply descheduled, or
because it is blocked (what I slightly misleadingly called "sleeping"
above) in a hypercall, then it is not currently using any physical CPU
resources, including the TLBs.  In that case, there's no need to flush
that's VCPU's TLB entries, because there are none.

> << A "few hundred uSecs" is really very slow - that's nearly a
> millisecond.  It's worth spending some effort to avoid those kinds of
> delays.>>
>
> Actually, just checked IPIs are usually 1000-1500 cycles long (comparable to
> VMEXIT). My point is ideal solution should be where virtual platform
> behavior is closer to bare metal interrupts, memory, cpu state etc.. How to
> do it ? well that's what needs to be figured out :-)

The interesting number is not the raw cost of an IPI, but the overall
cost of the remote TLB flush.

    J
