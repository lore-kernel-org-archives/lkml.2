Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab2LOVEP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 16:04:15 -0500
Received: from ud10.udmedia.de ([194.117.254.50]:33891 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab2LOVEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 16:04:14 -0500
Date: Sat, 15 Dec 2012 22:04:11 +0100
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Jan Beulich <jbeulich@suse.com>,
        Matt Fleming <matt.fleming@intel.com>,
        David Howells <dhowells@redhat.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Arnd Bergmann <arnd@arndb.de>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@elte.hu>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] x86/uapi for 3.8
Message-ID: <20121215210411.GA228@x4>
References: <23916.1355356085@warthog.procyon.org.uk>
 <CA+55aFwBh3SY-K_dqdjpqyiBE+_PzbjMc=Qnt-QU9LNaK325TA@mail.gmail.com>
 <21507.1355528749@warthog.procyon.org.uk>
 <CA+55aFw34Nwi_aNjN-jm4SHkvT5659_aNVVmvARTCg5=9K0cZg@mail.gmail.com>
 <CA+55aFytC4xktWHAfQ96cdbt5nu+qbYytUGky8wWAkxZE=J0kw@mail.gmail.com>
 <CA+55aFyd5O_GyB_+BgHVYNLW-DV8xMQ9LOgPU34AtCqVvzfDaQ@mail.gmail.com>
 <20121215163323.GA229@x4>
 <CA+55aFz3iLPT3wzbU_Nhh4ft1eNQcd4WdQXsgXnKBs6vG9a_Uw@mail.gmail.com>
 <50CCD24F.9090603@zytor.com>
 <CA+55aFxi5SnacGoHzHuth4PvTRQQWA5kWM+D2Mn+FgV4VGYADQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxi5SnacGoHzHuth4PvTRQQWA5kWM+D2Mn+FgV4VGYADQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.12.15 at 11:58 -0800, Linus Torvalds wrote:
> On Sat, Dec 15, 2012 at 11:41 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> >
> > Matt is on vacation, and I'm partly offline for the weekend, but that
> > definitely seems suspicious.  Do we have a memory map of the affected
> > machine(s)?
> 
> 
> but as mentioned, there's bound to be some particular kernel layout
> that triggers this, because I definitely ran a few kernels with that
> commit in it without problems (and clearly other people are too).
> Looking at my boot log, I had successful boots with both 6a57d104c8cb
> and c2714334b944, which contains that commit.
> 
> It might also be that it causes some massive corruption at boot time,
> but it then requires that that particular memory is actually used. So
> maybe it's not so much about the memory map except indirectly.
> 
> But that commit *does* look a lot more likely than the things I looked at.

The commit message says that only some broken implementations of EFI
firmware require the mapping for the physical I/O device addresses.

So I wonder if the following simple patch might be enough?
It fixes the issue for me at least.

diff --git a/arch/x86/mm/ioremap.c b/arch/x86/mm/ioremap.c
index e190f7b..402e4ca 100644
--- a/arch/x86/mm/ioremap.c
+++ b/arch/x86/mm/ioremap.c
@@ -50,7 +50,7 @@ int ioremap_change_attr(unsigned long vaddr, unsigned long size,
 	return err;
 }
 
-#ifdef CONFIG_X86_64
+#ifdef CONFIG_EFI
 static void ident_pte_range(unsigned long paddr, unsigned long vaddr,
 			    pmd_t *ppmd, pmd_t *vpmd, unsigned long end)
 {

-- 
Markus
