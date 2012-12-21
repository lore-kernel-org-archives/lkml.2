Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751099Ab2LUG1T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 01:27:19 -0500
Received: from mail-bk0-f44.google.com ([209.85.214.44]:37227 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712Ab2LUG1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 01:27:12 -0500
MIME-Version: 1.0
In-Reply-To: <50D3E91C.9060907@zytor.com>
References: <20121221030018.GA15032@www.outflux.net>
	<50D3E91C.9060907@zytor.com>
Date: Thu, 20 Dec 2012 22:27:10 -0800
X-Google-Sender-Auth: ZIPAJDjCzGulQ9UCAhsZQI6jrog
Message-ID: <CAE9FiQVNeQqXktmaG0XOJwSxFEVrGKA9j6UDN2N_aDDp-8y_fA@mail.gmail.com>
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

On Thu, Dec 20, 2012 at 8:44 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> I just looked at a /sys/kernel/debug/kernel_page_tables dump.... and there
> are a bunch of pages which are RWX:
>
> 0xffff880000000000-0xffff880000097000  604K RW             GLB x  pte
> 0xffff88000009d000-0xffff880000200000 1420K RW             GLB x  pte
> 0xffff880000200000-0xffff880001000000   14M RW         PSE GLB x  pmd
> 0xffff880001c00000-0xffff880035e00000  834M RW         PSE GLB x  pmd
> 0xffff880035e00000-0xffff880035ffe000 2040K RW             GLB x  pte
> 0xffff880036ff7000-0xffff880037000000   36K RW             GLB x  pte
> 0xffff880037000000-0xffff880040000000  144M RW         PSE GLB x  pmd
> 0xffffffff81c00000-0xffffffff81cea000  936K RW             GLB x  pte
> 0xffffffff81dfd000-0xffffffff81e00000   12K RW             GLB x  pte
> 0xffffffff81e00000-0xffffffff82000000    2M RW         PSE GLB x  pmd

after for-x86-boot we will have
---[ Low Kernel Mapping ]---
0xffff880000000000-0xffff880000099000         612K     RW             GLB NX pte
0xffff880000099000-0xffff88000009a000           4K     ro             GLB NX pte
0xffff88000009a000-0xffff88000009b000           4K     ro             GLB x  pte
0xffff88000009b000-0xffff880000200000        1428K     RW             GLB NX pte
0xffff880000200000-0xffff8800dfe00000        3580M     RW         PSE GLB NX pmd
0xffff8800dfe00000-0xffff8800dfffe000        2040K     RW             GLB NX pte
0xffff8800dfffe000-0xffff8800e0000000           8K                           pte
0xffff8800e0000000-0xffff880100000000         512M                           pmd
0xffff880100000000-0xffff8801a0000000        2560M     RW         PSE GLB NX pmd
---[ High Kernel Mapping ]---
0xffffffff80000000-0xffffffff81000000          16M                           pmd
0xffffffff81000000-0xffffffff82a00000          26M     RW         PSE GLB x  pmd
0xffffffff82a00000-0xffffffff82b21000        1156K     RW             GLB x  pte
0xffffffff82b21000-0xffffffff82c00000         892K     RW             GLB NX pte
0xffffffff82c00000-0xffffffff82e00000           2M     RW         PSE GLB NX pmd
0xffffffff82e00000-0xffffffff82e92000         584K     RW             GLB NX pte
0xffffffff82e92000-0xffffffff83000000        1464K     RW             GLB x  pte
0xffffffff83000000-0xffffffff83c00000          12M     RW         PSE GLB x  pmd
0xffffffff83c00000-0xffffffffa0000000         452M                           pmd

so low mapping will only have trampoline get x set.
is that expected ?

Do we need to set low mapping corresponding to kernel range to x?

Yinghai
