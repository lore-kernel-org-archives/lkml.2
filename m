Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab0GNXJV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:09:21 -0400
Received: from one.firstfloor.org ([213.235.205.2]:60885 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436Ab0GNXJT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:09:19 -0400
Date: Thu, 15 Jul 2010 01:09:13 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>, Ingo Molnar <mingo@elte.hu>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100714230913.GG22373@basil.fritz.box>
References: <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
 <20100714170617.GB4955@Krystal>
 <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
 <20100714184642.GA9728@elte.hu>
 <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
 <AANLkTinfmoKvi1SauDA5_RiTmu6bztTDk8b_ycS-lr8S@mail.gmail.com>
 <20100714195617.GC22373@basil.fritz.box>
 <20100714200552.GA22096@Krystal>
 <20100714223116.GB14533@nowhere>
 <AANLkTik-sJL_pAJg38Hzpl_jpn2v90t7tppYqOGmu6p-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTik-sJL_pAJg38Hzpl_jpn2v90t7tppYqOGmu6p-@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  - at vmalloc time, when adding a new page directory entry, walk all
> the tens of thousands of existing page tables under a lock that
> guarantees that we don't add any new ones (ie it will lock out fork())
> and add the required pgd entry to them.
> 
>  - or just take the fault and do the "fill the page tables" on demand.
> 
> Quite frankly, most of the time it's probably better to make that last
> choice (unless your hardware makes it easy to make the first choice,

Adding new PGDs should happen only very rarely (in fact 
at most once per boot on i386-PAE36 with only 4 entries, most used by user 
space), most of the time when you do a vmalloc it changes only lower level 
tables. 

The PGD for the kernel mappings is already set up. On x86-64 it can happen 
more often in theory, but in practice it should be also extremly rare because
a PGD is so large.

That's why I'm not sure this problem even happened. It should 
be extremly rare that you exactly add that PGD during the per cpu
allocation. 

It can happen in theory, but for such a rare case take a lock
and walking everything should be fine.

-Andi

