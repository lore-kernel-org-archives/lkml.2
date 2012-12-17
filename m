Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab2LQQBD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 11:01:03 -0500
Received: from nat28.tlf.novell.com ([130.57.49.28]:36720 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752557Ab2LQQBB convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:13:1>);
	Mon, 17 Dec 2012 11:01:01 -0500
Message-Id: <50CF4FC502000078000B0CB6@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.1 
Date: Mon, 17 Dec 2012 16:00:53 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: "Linus Torvalds" <torvalds@linux-foundation.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>, "Ingo Molnar" <mingo@elte.hu>,
        "Michael Kerrisk" <mtk.manpages@gmail.com>,
        "Guennadi Liakhovetski" <g.liakhovetski@gmx.de>,
        "Matt Fleming" <matt.fleming@intel.com>,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Dave Jones" <davej@redhat.com>, "David Howells" <dhowells@redhat.com>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Markus Trippelsdorf" <markus@trippelsdorf.de>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] x86/uapi for 3.8
References: <201212122211.qBCMBRxl027895@terminus.zytor.com>
 <23916.1355356085@warthog.procyon.org.uk>
 <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk>
 <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
 <20121215163323.GA229@x4>
 <CA+55aFz3iLPT3wzbU_Nhh4ft1eNQcd4WdQXsgXnKBs6vG9a_Uw@mail.gmail.com>
 <50CEEE3302000078000B0AC0@nat28.tlf.novell.com>
 <CA+55aFzhgW=GBwGtxufqhX+ykNCRqek=iyVszvkpCTw=-MXSyA@mail.gmail.com>
In-Reply-To: <CA+55aFzhgW=GBwGtxufqhX+ykNCRqek=iyVszvkpCTw=-MXSyA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 17.12.12 at 16:44, Linus Torvalds <torvalds@linux-foundation.org> wrote:
> On Mon, Dec 17, 2012 at 1:04 AM, Jan Beulich <JBeulich@suse.com> wrote:
>>
>> How about this being caused by using the same lower level
>> page table entries that swapper_pg_dir uses, namely including
>> the _PAGE_GLOBAL bits? efi_call_virt_{pre,epi}log() only write
>> CR3 (see 185034e72d591f9465e5e18f937ed642e7ea0070), but
>> would need to also flip CR4.PGE afaict.
> 
> Now *this* is the kind of issue that I could easily see causing major
> corruption, but be subtle enough to not happen reliably. Coming back
> from the EFI calls (or going into them) with stale TLB contents due to
> global pages could explain things.
> 
> Good thinking. That efi call code should use flush_tlb_kernel() (or
> __flush_tlb_global() if it wants to avoid any paravirtualization
> stuff) if it has global pages in different places from the normal
> kernel map. Does it really have that?

I don't see it having such. But I also don't think flush_tlb_kernel()
is the right mechanism here. I'd rather suggest clearing CR4.PGE in
the "prelog", an restore it in the epilog. Para-virtual environments
shouldn't be directly interfacing with EFI runtime code anyway.

Jan

