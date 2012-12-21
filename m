Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752116Ab2LUEo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 23:44:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60144 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582Ab2LUEok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 23:44:40 -0500
Message-ID: <50D3E91C.9060907@zytor.com>
Date: Thu, 20 Dec 2012 20:44:12 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC] stack and heap are executable on x86_64
References: <20121221030018.GA15032@www.outflux.net>
In-Reply-To: <20121221030018.GA15032@www.outflux.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/2012 07:00 PM, Kees Cook wrote:
>
> This change for pre-v3.5 creates a new exception table instead of
> trying to rewrite the old one. Since the tables are now relative,
> we can't actually set up an exception for things in stack and heap on
> x86_64 since the distance between the address and the table's .insn is
> more than INT_MAX. And if the table were moved into the stack or heap,
> then the fixup couldn't point back to the module's text segment. For
> v3.5 and later, I'm not sure what to do...
>
> So, mainly two things:
> - we need to fix the stack/heap markings.
> - it'd be nice to get test_nx back on its feet again.
>

I just looked at a /sys/kernel/debug/kernel_page_tables dump.... and 
there are a bunch of pages which are RWX:

0xffff880000000000-0xffff880000097000  604K RW             GLB x  pte
0xffff88000009d000-0xffff880000200000 1420K RW             GLB x  pte
0xffff880000200000-0xffff880001000000   14M RW         PSE GLB x  pmd
0xffff880001c00000-0xffff880035e00000  834M RW         PSE GLB x  pmd
0xffff880035e00000-0xffff880035ffe000 2040K RW             GLB x  pte
0xffff880036ff7000-0xffff880037000000   36K RW             GLB x  pte
0xffff880037000000-0xffff880040000000  144M RW         PSE GLB x  pmd
0xffffffff81c00000-0xffffffff81cea000  936K RW             GLB x  pte
0xffffffff81dfd000-0xffffffff81e00000   12K RW             GLB x  pte
0xffffffff81e00000-0xffffffff82000000    2M RW         PSE GLB x  pmd

One particular piece of idiocy is that we tied marking the pages 
executable into the PAT system, which means that if it is executable 
anywhere in the kernel it is executable everywhere.  That being said, I 
don't think that is the only thing at play here.

On the other hand... do we *ever* have a legitimate reason to run code 
below the -2G point?  If so we could/should probably mark those NX 
already at the higher paging levels...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

