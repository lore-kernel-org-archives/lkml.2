Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756735Ab2LNTr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 14:47:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49340 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754461Ab2LNTrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 14:47:55 -0500
Message-ID: <50CB8213.9000908@zytor.com>
Date: Fri, 14 Dec 2012 11:46:27 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Borislav Petkov <bp@alien8.de>, "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <20121211170605.GD28827@liondog.tnic> <CAE9FiQXOrH4POQESnGycSrf-7e5MhO9y1wfa7ZSEVr9TO_45ZA@mail.gmail.com> <50C76F9E.4080001@zytor.com> <CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com> <50C7C859.60405@zytor.com> <CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com> <50C82ABF.3020907@zytor.com> <20121212133853.GC8760@liondog.tnic> <50C963B1.3040609@zytor.com> <50C96717.3020407@zytor.com> <20121213191317.GE31485@liondog.tnic> <50CA4A7A.10104@zytor.com> <CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com>
In-Reply-To: <CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2012 01:11 AM, Yinghai Lu wrote:
> On Thu, Dec 13, 2012 at 1:36 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> : tazenda 111 ; qemu-kvm -smp 2 -m 2048 -hda ~/qemu/fc10/qemu-fc10-64.img
>> -serial stdio -kernel o.x86_64/arch/x86/boot/bzImage -append 'ro
>> root=/dev/sda1 console=ttyS0 earlyprintk=serial,ttyS0 debug'
>> early console in setup code
>> early console in decompress_kernel
>>
>> [    0.000000] init_memory_mapping: [mem 0x00000000-0x7fffdfff]
>> [    0.000000]  [mem 0x00000000-0x7fdfffff] page 2M
>> [    0.000000]  [mem 0x7fe00000-0x7fffdfff] page 4k
>> [    0.000000] Kernel panic - not syncing: Cannot find space for the kernel
>> page tables
>> [    0.000000] Pid: 0, comm: swapper Not tainted 3.7.0+ #16
>> [    0.000000] Call Trace:
>> [    0.000000]  [<ffffffff817f0d2e>] panic+0xb6/0x1b5
>> [    0.000000]  [<ffffffff817e3801>] init_memory_mapping+0x471/0x5a0
>> [    0.000000]  [<ffffffff81ecd37f>] setup_arch+0x65c/0xb71
>> [    0.000000]  [<ffffffff81ec998e>] start_kernel+0x8a/0x348
>> [    0.000000]  [<ffffffff81ec9452>] x86_64_start_reservations+0x132/0x136
>> [    0.000000]  [<ffffffff81ec94fe>] x86_64_start_kernel+0xa8/0xad
> 
> attached works on kvm local, but SMP does not work yet.
> 
> ON TOP of linus tree + tip:x86/mm2
> 
> I added mapping to kernel to init_level2_mapping with BRK before #PF
> handler still works. (before early_trap_init)
> copy entries into init_level2_page from early_level4_pgt....
> split setup_real_mode to reserve and copy... copy need to after
> init_mem_mapping for system with more than 512G ram.
> 
> my plan is using this one replace
> 
>       [PATCH v6 06/27] x86, 64bit: Set extra ident mapping for whole
> kernel range
> 

That patch doesn't apply on top of the merge of x86/mm2 and
linus/master.  A trivial fixup is totally nonfunctional -- no
earlyprintk, just a null pointer death in setup_real_mode().

I suspect we don't need init_level4_pgt at all and should just plan to
get rid of it.  Is there any reason we can't just build the proper
kernel page table set in pagetable_init() and switch to it there?

	-hpa

