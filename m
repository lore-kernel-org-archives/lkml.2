Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab2LSXup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:50:45 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48069 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751062Ab2LSXuk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:50:40 -0500
Message-ID: <50D252B6.6050802@zytor.com>
Date: Wed, 19 Dec 2012 15:50:14 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jacob Shin <jacob.shin@amd.com>
CC: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
References: <50CCF6F6.4020107@zytor.com> <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com> <50CD04F1.8020902@zytor.com> <0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com> <20121219220504.GA32212@jshin-Toonie> <50D23EE8.7030904@zytor.com> <20121219225155.GK24895@liondog.tnic> <20121219225941.GB2968@jshin-Toonie> <20121219230329.GM24895@liondog.tnic> <50D24C25.5050604@zytor.com> <20121219234054.GA6130@jshin-Toonie>
In-Reply-To: <20121219234054.GA6130@jshin-Toonie>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2012 03:40 PM, Jacob Shin wrote:
>>
>> Just make the hole a bit bigger, so it starts at 0xfc00000000, then you
>> only need one MTRR.  This is the correct BIOS-level fix, and it really
>> needs to happen.
>>
>> Do these systems actually exist in the field or are they engineering
>> prototypes?  In the latter case, we might be done at that point.
>
> Yes, HP is shipping (or will ship soon) such systems.
>

Can you get them to fix the BIOS first, or at least ship a BIOS update? 
  Otherwise there will be a probabilistic failure, and it sounds like it 
is your (AMD's) fault.

>> The other bit is that building the real kernel page tables iteratively
>> (ignoring the early page tables here) is safer, since the real page
>> table builder is fully aware of the memory map.  This means any
>> "spillover" from the early page tables gets minimized to regions where
>> there are data objects that have to be accessed early.  Since Yinghai
>> already had iterative page table building working, I don't see any
>> reason to not use that capability.
>
> Yes, I'll test again with latest, but Yinghai's patchset mapping only
> RAM from top down solved our problem.

Please don't make me go Steve Ballmer on you.

We're talking about two different things... the early page tables versus 
the permanent page tables.  The permanent page tables we can handle 
because the page table creation at that point is aware of the memory map.

The early page tables are what is used before we get to that point. 
Creating them on demand means that if there are no early-needed data 
structures near the hole, there will be no access and everything will be 
okay, but as the early page table creation *is not and cannot be* aware 
of the memory map.  Right now that simply cannot happen, because all 
such data structures are confined to 32-bit addresses, however *THAT 
WILL CHANGE AND WILL CHANGE SOON*, exactly because these kinds of 
large-memory system needs that to happen.  You may start seeing failures 
at that time, and there isn't a huge lot we can do about it.

We are trying to discuss mitigation strategies with you, but you haven't 
really given us any useful information, e.g. what happens near the 
various boundaries of the hole, what could trigger prefeching into the 
range, and what it would take to fix the BIOSes.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

