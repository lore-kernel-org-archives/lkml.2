Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751941Ab2LURCP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 12:02:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36984 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751091Ab2LURCK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 12:02:10 -0500
Message-ID: <50D495FD.8060103@zytor.com>
Date: Fri, 21 Dec 2012 09:01:49 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC] stack and heap are executable on x86_64
References: <20121221030018.GA15032@www.outflux.net> <50D3E91C.9060907@zytor.com> <CAE9FiQVNeQqXktmaG0XOJwSxFEVrGKA9j6UDN2N_aDDp-8y_fA@mail.gmail.com>
In-Reply-To: <CAE9FiQVNeQqXktmaG0XOJwSxFEVrGKA9j6UDN2N_aDDp-8y_fA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 10:27 PM, Yinghai Lu wrote:
>
> after for-x86-boot we will have
> ---[ Low Kernel Mapping ]---
> 0xffff880000000000-0xffff880000099000         612K     RW             GLB NX pte
> 0xffff880000099000-0xffff88000009a000           4K     ro             GLB NX pte
> 0xffff88000009a000-0xffff88000009b000           4K     ro             GLB x  pte
> 0xffff88000009b000-0xffff880000200000        1428K     RW             GLB NX pte
> 0xffff880000200000-0xffff8800dfe00000        3580M     RW         PSE GLB NX pmd
> 0xffff8800dfe00000-0xffff8800dfffe000        2040K     RW             GLB NX pte
> 0xffff8800dfffe000-0xffff8800e0000000           8K                           pte
> 0xffff8800e0000000-0xffff880100000000         512M                           pmd
> 0xffff880100000000-0xffff8801a0000000        2560M     RW         PSE GLB NX pmd
> ---[ High Kernel Mapping ]---
> 0xffffffff80000000-0xffffffff81000000          16M                           pmd
> 0xffffffff81000000-0xffffffff82a00000          26M     RW         PSE GLB x  pmd
> 0xffffffff82a00000-0xffffffff82b21000        1156K     RW             GLB x  pte
> 0xffffffff82b21000-0xffffffff82c00000         892K     RW             GLB NX pte
> 0xffffffff82c00000-0xffffffff82e00000           2M     RW         PSE GLB NX pmd
> 0xffffffff82e00000-0xffffffff82e92000         584K     RW             GLB NX pte
> 0xffffffff82e92000-0xffffffff83000000        1464K     RW             GLB x  pte
> 0xffffffff83000000-0xffffffff83c00000          12M     RW         PSE GLB x  pmd
> 0xffffffff83c00000-0xffffffffa0000000         452M                           pmd
>
> so low mapping will only have trampoline get x set.
> is that expected ?
>

Yes.

> Do we need to set low mapping corresponding to kernel range to x?

No; we probably should never have the low mappings set to X, which comes 
down to what I said earlier... we should mark the low mapping NX at the 
PGD/PML4 level.

However, this isn't good enough.  You still have a large number of pages 
which are RWX, and we should *never* have RWX pages, period, full stop, 
and your map above sill have megabytes of them.

Furthermore, just saying "we applied this patchset and it seems to go 
away" isn't good enough... we need an understanding of *why* it makes 
things go away and how that makes it safe.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

