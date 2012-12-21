Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752012Ab2LUV0k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 16:26:40 -0500
Received: from mail-bk0-f47.google.com ([209.85.214.47]:55004 "EHLO
	mail-bk0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417Ab2LUV0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 16:26:38 -0500
MIME-Version: 1.0
In-Reply-To: <50D49E0A.1080609@zytor.com>
References: <20121221030018.GA15032@www.outflux.net>
	<50D3E91C.9060907@zytor.com>
	<CAE9FiQVNeQqXktmaG0XOJwSxFEVrGKA9j6UDN2N_aDDp-8y_fA@mail.gmail.com>
	<50D495FD.8060103@zytor.com>
	<CAE9FiQXcXn0xr_ACt4fS_=xWtXR8zGoYfpSzFKG4nEvKF=sGdQ@mail.gmail.com>
	<50D49E0A.1080609@zytor.com>
Date: Fri, 21 Dec 2012 13:26:36 -0800
X-Google-Sender-Auth: iEDazgkzgmy3oX7qTRPSNXhFtPE
Message-ID: <CAE9FiQUu6mvTZ7ONsEeCx8OOocKkCEkC2-OmwdWyjHAJ4=gVHQ@mail.gmail.com>
Subject: Re: [RFC] stack and heap are executable on x86_64
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 9:36 AM, H. Peter Anvin <hpa@zytor.com> wrote:
> We should NEVER have RW + x at the same time (at least when the kernel
> is compiled properly.)  Looks like your patch does get rid of a bunch of
> stuff in the low mapping -- although the low mapping really should never
> be +x at all -- but there are still problems with the high mapping

after enabling CONFIG_DEBUG_RODATA

get
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
0xffffffff81000000-0xffffffff82200000          18M     ro         PSE GLB x  pmd
0xffffffff82200000-0xffffffff82c00000          10M     ro         PSE GLB NX pmd
0xffffffff82c00000-0xffffffff82dc9000        1828K     RW             GLB x  pte
0xffffffff82dc9000-0xffffffff82e00000         220K     RW             GLB NX pte
0xffffffff82e00000-0xffffffff83000000           2M     RW         PSE GLB NX pmd
0xffffffff83000000-0xffffffff8313a000        1256K     RW             GLB NX pte
0xffffffff8313a000-0xffffffff83200000         792K     RW             GLB x  pte
0xffffffff83200000-0xffffffff83e00000          12M     RW         PSE GLB x  pmd
0xffffffff83e00000-0xffffffffa0000000         450M                           pmd

for
[    0.000000] Kernel Layout:
[    0.000000]   .text: [0x01000000-0x021434f8]
[    0.000000] .rodata: [0x02200000-0x02a13fff]
[    0.000000]   .data: [0x02c00000-0x02dc763f]
[    0.000000]   .init: [0x02dc9000-0x0312cfff]
[    0.000000]    .bss: [0x0313b000-0x03dd6fff]
[    0.000000]    .brk: [0x03dd7000-0x03dfffff]

looks like .data, .bss, .brk should not have x set.
