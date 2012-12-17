Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab2LQQkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:40:18 -0500
Received: from mga01.intel.com ([192.55.52.88]:18294 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752179Ab2LQQkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 11:40:16 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,303,1355126400"; 
   d="scan'208";a="263205466"
Message-ID: <50CF4ACD.80701@linux.intel.com>
Date: Mon, 17 Dec 2012 08:39:41 -0800
From: "H. Peter Anvin" <hpa@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Matt Fleming <matt.fleming@intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86/uapi for 3.8
References: <201212122211.qBCMBRxl027895@terminus.zytor.com> <23916.1355356085@warthog.procyon.org.uk> <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com> <21507.1355528749@warthog.procyon.org.uk> <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com> <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com> <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com> <20121215163323.GA229@x4> <CA+55aFz3iLPT3wzbU_Nhh4ft1eNQcd4WdQXsgXnKBs6vG9a_Uw@mail.gmail.com> <50CEEE3302000078000B0AC0@nat28.tlf.novell.com> <CA+55aFzhgW=GBwGtxufqhX+ykNCRqek=iyVszvkpCTw=-MXSyA@mail.gmail.com> <50CF4FC502000078000B0CB6@nat28.tlf.novell.com>
In-Reply-To: <50CF4FC502000078000B0CB6@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 08:00 AM, Jan Beulich wrote:
>>>> On 17.12.12 at 16:44, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> On Mon, Dec 17, 2012 at 1:04 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>>
>>> How about this being caused by using the same lower level
>>> page table entries that swapper_pg_dir uses, namely including
>>> the _PAGE_GLOBAL bits? efi_call_virt_{pre,epi}log() only write
>>> CR3 (see 185034e72d591f9465e5e18f937ed642e7ea0070), but
>>> would need to also flip CR4.PGE afaict.
>>
>> Now *this* is the kind of issue that I could easily see causing major
>> corruption, but be subtle enough to not happen reliably. Coming back
>> from the EFI calls (or going into them) with stale TLB contents due to
>> global pages could explain things.
>>
>> Good thinking. That efi call code should use flush_tlb_kernel() (or
>> __flush_tlb_global() if it wants to avoid any paravirtualization
>> stuff) if it has global pages in different places from the normal
>> kernel map. Does it really have that?
> 
> I don't see it having such. But I also don't think flush_tlb_kernel()
> is the right mechanism here. I'd rather suggest clearing CR4.PGE in
> the "prelog", an restore it in the epilog. Para-virtual environments
> shouldn't be directly interfacing with EFI runtime code anyway.
> 

Right, I think you nailed this one.  This patch copies PTEs from the
kernel PTEs and thus they will have the global bit set.  It obviously
makes no sense to *copy* PTEs from the kernel and yet leaving the global
bit set, which means there are two ways of fixing it: either sharing
page tables and use the cr4.pge off/on trick that Jan mentioned -- this
would also be my preference -- and the other is to copy the PTEs but
strip the global bit, which has the advantage that the actual kernel
mappings will survive.

One idea in this is to change ioremap() on x86-64 to instead of
allocating address space dynamically to always use the PAGE_OFFSET
mapping address, even for I/O devices.  Then the trampoline page table
can simply include two sets of pointers into the kernel page tables --
with, again, the caveat that a global page flush is absolutely mandatory.

Linus, Ingo, do you have any preferences here?

	-hpa


