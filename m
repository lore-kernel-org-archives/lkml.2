Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752075Ab2LSXku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 18:40:50 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:48916 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab2LSXkl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 18:40:41 -0500
MIME-Version: 1.0
In-Reply-To: <50D24C25.5050604@zytor.com>
References: <50CCEE49.3080801@zytor.com>
	<CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com>
	<50CCF6F6.4020107@zytor.com>
	<CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com>
	<50CD04F1.8020902@zytor.com>
	<0dcbce7a-d2ae-44fa-9658-81590f71ec47@email.android.com>
	<20121219220504.GA32212@jshin-Toonie>
	<50D23EE8.7030904@zytor.com>
	<20121219225155.GK24895@liondog.tnic>
	<20121219225941.GB2968@jshin-Toonie>
	<20121219230329.GM24895@liondog.tnic>
	<50D24C25.5050604@zytor.com>
Date: Wed, 19 Dec 2012 15:40:38 -0800
X-Google-Sender-Auth: CmD8zkmhjKisttZ2V-4JttYhMqs
Message-ID: <CAE9FiQWuC+34=q1K5oj8j+U1XjbXPDz5k1VKvs4vnoZDAzFzRg@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Borislav Petkov <bp@alien8.de>, Jacob Shin <jacob.shin@amd.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 3:22 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> The other bit is that building the real kernel page tables iteratively
> (ignoring the early page tables here) is safer, since the real page
> table builder is fully aware of the memory map.  This means any
> "spillover" from the early page tables gets minimized to regions where
> there are data objects that have to be accessed early.  Since Yinghai
> already had iterative page table building working, I don't see any
> reason to not use that capability.

that is v6, right?

including that patch

---

Subject: [PATCH] x86, 64bit: Set extra ident mapping for whole kernel range

Current when kernel is loaded above 1G, only [_text, _text+2M] is set
up with extra ident page table.
That is not enough, some variables that could be used early are out of
that range, like BRK for early page table.
Need to set map for [_text, _end] include text/data/bss/brk...

Also current kernel is not allowed to be loaded above 512g, it thinks
that address is too big.
We need to add one extra spare page for level3 to point that 512g range.
Need to check _text range and set level4 pg with that spare level3 page,
and set level3 with level2 page to cover [_text, _end] with extra mapping.

At last, to handle crossing GB boundary, we need to add another
level2 spare page. To handle crossing 512GB boundary, we need to
add another level3 spare page to next 512G range.

Test on with kexec-tools with local test code to force loading kernel
cross 1G, 5G, 512g, 513g.

We need this to put relocatable 64bit bzImage high above 1g.

-v4: add crossing GB boundary handling.
-v5: use spare pages from BRK, so could save pages when kernel is not
        loaded above 1GB.
