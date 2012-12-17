Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753025Ab2LQPox (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 10:44:53 -0500
Received: from mail-wg0-f46.google.com ([74.125.82.46]:46497 "EHLO
	mail-wg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab2LQPow (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 10:44:52 -0500
MIME-Version: 1.0
In-Reply-To: <50CEEE3302000078000B0AC0@nat28.tlf.novell.com>
References: <201212122211.qBCMBRxl027895@terminus.zytor.com>
 <23916.1355356085@warthog.procyon.org.uk> <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk> <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
 <20121215163323.GA229@x4> <CA+55aFz3iLPT3wzbU_Nhh4ft1eNQcd4WdQXsgXnKBs6vG9a_Uw@mail.gmail.com>
 <50CEEE3302000078000B0AC0@nat28.tlf.novell.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 17 Dec 2012 07:44:30 -0800
X-Google-Sender-Auth: i2207P8fRc9aIjyQROfiPFEwn2k
Message-ID: <CA+55aFzhgW=GBwGtxufqhX+ykNCRqek=iyVszvkpCTw=-MXSyA@mail.gmail.com>
Subject: Re: [GIT PULL] x86/uapi for 3.8
To: Jan Beulich <JBeulich@suse.com>
Cc: Matt Fleming <matt.fleming@intel.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Arnd Bergmann <arnd@arndb.de>, Ingo Molnar <mingo@elte.hu>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Dave Jones <davej@redhat.com>, David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 17, 2012 at 1:04 AM, Jan Beulich <JBeulich@suse.com> wrote:
>
> How about this being caused by using the same lower level
> page table entries that swapper_pg_dir uses, namely including
> the _PAGE_GLOBAL bits? efi_call_virt_{pre,epi}log() only write
> CR3 (see 185034e72d591f9465e5e18f937ed642e7ea0070), but
> would need to also flip CR4.PGE afaict.

Now *this* is the kind of issue that I could easily see causing major
corruption, but be subtle enough to not happen reliably. Coming back
from the EFI calls (or going into them) with stale TLB contents due to
global pages could explain things.

Good thinking. That efi call code should use flush_tlb_kernel() (or
__flush_tlb_global() if it wants to avoid any paravirtualization
stuff) if it has global pages in different places from the normal
kernel map. Does it really have that?

            Linus
