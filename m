Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757427Ab0GNW5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:57:23 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753187Ab0GNW5W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:57:22 -0400
MIME-Version: 1.0
In-Reply-To: <20100714223116.GB14533@nowhere>
References: <20100714154923.947138065@efficios.com>
	<20100714155804.049012415@efficios.com>
	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	<20100714170617.GB4955@Krystal>
	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	<20100714184642.GA9728@elte.hu>
	<AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
	<AANLkTinfmoKvi1SauDA5_RiTmu6bztTDk8b_ycS-lr8S@mail.gmail.com>
	<20100714195617.GC22373@basil.fritz.box>
	<20100714200552.GA22096@Krystal>
	<20100714223116.GB14533@nowhere>
Date: Wed, 14 Jul 2010 15:56:43 -0700
Message-ID: <AANLkTik-sJL_pAJg38Hzpl_jpn2v90t7tppYqOGmu6p-@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
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
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 3:31 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
> Until now I didn't because I clearly misunderstand the vmalloc internals. I'm
> not even quite sure why a memory allocated with vmalloc sometimes can be not
> mapped (and then fault once for this to sync). Some people have tried to explain
> me but the picture is still vague to me.

So the issue is that the system can have thousands and thousands of
page tables (one for each process), and what do you do when you add a
new kernel virtual mapping?

You can:

 - make sure that you only ever use _one_ single top-level entry for
all vmalloc issues, and can make sure that all processes are created
with that static entry filled in. This is optimal, but it just doesn't
work on all architectures (eg on 32-bit x86, it would limit the
vmalloc space to 4MB in non-PAE, whatever)

 - at vmalloc time, when adding a new page directory entry, walk all
the tens of thousands of existing page tables under a lock that
guarantees that we don't add any new ones (ie it will lock out fork())
and add the required pgd entry to them.

 - or just take the fault and do the "fill the page tables" on demand.

Quite frankly, most of the time it's probably better to make that last
choice (unless your hardware makes it easy to make the first choice,
which is obviously simplest for everybody). It makes it _much_ cheaper
to do vmalloc. It also avoids that nasty latency issue. And it's just
simpler too, and has no interesting locking issues with how/when you
expose the page tables in fork() etc.

So the only downside is that you do end up taking a fault in the
(rare) case where you have a newly created task that didn't get an
even newer vmalloc entry. And that fault can sometimes be in an
interrupt or an NMI. Normally it's trivial to handle that fairly
simple nested fault. But NMI has that inconvenient "iret unblocks
NMI's, because there is no dedicated 'nmiret' instruction" problem on
x86.

                            Linus
