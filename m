Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751572Ab1GYVxq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:53:46 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:46726 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214Ab1GYVxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:53:43 -0400
Date: Mon, 25 Jul 2011 23:53:28 +0200
From: Borislav Petkov <bp@amd64.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        "Przywara, Andre" <Andre.Przywara@amd.com>,
        "Pohlack, Martin" <Martin.Pohlack@amd.com>
Subject: Re: [PATCH] x86, AMD: Correct F15h IC aliasing issue
Message-ID: <20110725215328.GA25960@aftab>
References: <1311340547-7861-1-git-send-email-bp@amd64.org>
 <CA+55aFwL9Fwd9ouX3UMOayoBsZyZzTdDSySa6nZJxbpyLifbaQ@mail.gmail.com>
 <20110724172222.GB12621@aftab>
 <CA+55aFze=w7tjmyGa2w=D8b6roDuL5O0gmDKkSzLKBLLYZ_a+A@mail.gmail.com>
 <20110724182323.GA13247@aftab>
 <20110724183045.GB29660@elte.hu>
 <20110724190752.GA13647@aftab>
 <20110724204450.GB18546@elte.hu>
 <20110725200014.GA23986@aftab>
 <20110725200645.GC8302@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110725200645.GC8302@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 25, 2011 at 04:06:45PM -0400, Ingo Molnar wrote:
> 
> * Borislav Petkov <bp@amd64.org> wrote:
> 
> > So yeah, the simpler fix works for processes mapping libraries in 
> > the same order but not for processes mapping a subset of libraries 
> > in a different order.
> 
> but what is the proportion of 'good' versus bad alignment of 
> libraries, could you collect some stats on a representative enough, 
> fully booted up Linux system?
> 
> Are only 1% of mappings 'bad'? 5%? 10%? 50%? We have no idea and the 
> actual number matters a lot.

Actually, it's hard to say what is a 'good' and 'bad' allocation. If
they don't alias, they're always good :).

Anyway, I did some beginners awk-ery on a gentoo system with ca. 150
processes. Below is some data for the "r-xp" mappings.

ld-2.12.2.so, for example, is always loaded at an address with [14:12]
= 000b while libc's addresses differ in those bits because a different
number of allocations is being done between ld and libc, thus libc lands
at different offsets.

I'll do a more comprehensive collection tomorrow and distribute the
mappings by [14:12] value, that should give us a better idea.

/lib64/ld-2.12.2.so|r-xp|7f07f61d8000 1
/lib64/ld-2.12.2.so|r-xp|7f1d8be10000 1
/lib64/ld-2.12.2.so|r-xp|7f1ea7678000 1
/lib64/ld-2.12.2.so|r-xp|7f272e248000 1
/lib64/ld-2.12.2.so|r-xp|7f37acf88000 1
/lib64/ld-2.12.2.so|r-xp|7f49853f0000 1
/lib64/ld-2.12.2.so|r-xp|7f50c1460000 1
/lib64/ld-2.12.2.so|r-xp|7f59f58e0000 1
/lib64/ld-2.12.2.so|r-xp|7f63dc818000 1
/lib64/ld-2.12.2.so|r-xp|7f7267d70000 1
/lib64/ld-2.12.2.so|r-xp|7fa026ba0000 2
/lib64/ld-2.12.2.so|r-xp|7fa24de88000 1
/lib64/ld-2.12.2.so|r-xp|7fa604cf8000 1
/lib64/ld-2.12.2.so|r-xp|7fb07d418000 1
/lib64/ld-2.12.2.so|r-xp|7fc33cb78000 1
/lib64/ld-2.12.2.so|r-xp|7fd0c2770000 1
/lib64/ld-2.12.2.so|r-xp|7fd1e2a08000 1
/lib64/ld-2.12.2.so|r-xp|7fd214b18000 1
/lib64/ld-2.12.2.so|r-xp|7fda88a58000 1
/lib64/ld-2.12.2.so|r-xp|7fdb87d98000 1
/lib64/ld-2.12.2.so|r-xp|7fe42a588000 1
/lib64/ld-2.12.2.so|r-xp|7ffd79c08000 1
/lib64/libc-2.12.2.so|r-xp|7f07f4e3e000 1
/lib64/libc-2.12.2.so|r-xp|7f1d8b66d000 1
/lib64/libc-2.12.2.so|r-xp|7f1ea7315000 1
/lib64/libc-2.12.2.so|r-xp|7f272ceae000 1
/lib64/libc-2.12.2.so|r-xp|7f37acc25000 1
/lib64/libc-2.12.2.so|r-xp|7f498508d000 1
/lib64/libc-2.12.2.so|r-xp|7f50c0ca9000 1
/lib64/libc-2.12.2.so|r-xp|7f59f557d000 1
/lib64/libc-2.12.2.so|r-xp|7f63dc061000 1
/lib64/libc-2.12.2.so|r-xp|7f7267a0d000 1
/lib64/libc-2.12.2.so|r-xp|7fa02591d000 2
/lib64/libc-2.12.2.so|r-xp|7fa24d8a5000 1
/lib64/libc-2.12.2.so|r-xp|7fa604995000 1
/lib64/libc-2.12.2.so|r-xp|7fb07cc31000 1
/lib64/libc-2.12.2.so|r-xp|7fc33b7de000 1
/lib64/libc-2.12.2.so|r-xp|7fd0c1f89000 1
/lib64/libc-2.12.2.so|r-xp|7fd1e26a5000 1
/lib64/libc-2.12.2.so|r-xp|7fd2147b5000 1
/lib64/libc-2.12.2.so|r-xp|7fda884e8000 1
/lib64/libc-2.12.2.so|r-xp|7fdb87a35000 1
/lib64/libc-2.12.2.so|r-xp|7fe42a01c000 1
/lib64/libc-2.12.2.so|r-xp|7ffd79451000 1

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
