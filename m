Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757583Ab0GNX2f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 19:28:35 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58433 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754522Ab0GNX2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 19:28:34 -0400
MIME-Version: 1.0
In-Reply-To: <20100714230913.GG22373@basil.fritz.box>
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
	<20100714230913.GG22373@basil.fritz.box>
Date: Wed, 14 Jul 2010 16:22:52 -0700
Message-ID: <AANLkTinLbRqiLa6fcjsuC1b4yfAhAoLLk_0tzcV4K9jg@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
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

On Wed, Jul 14, 2010 at 4:09 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> It can happen in theory, but for such a rare case take a lock
> and walking everything should be fine.

Actually, that's _exactly_ the wrong kind of thinking.

Bad latency is bad latency, even when it happens rarely. So latency
problems kill - even when they are rare. So you want to avoid them.
And walking every possible page table is a _huge_ latency problem when
it happens.

In contrast, what's the advantage of doing thigns synchronously while
holding a lock? It's that you can avoid a few page faults, and get
better CPU use. But that's _stupid_ if it's something that is very
rare to begin with.

So the very rarity argues for the lazy approach. If it wasn't rare,
there would be a much stronger argument for trying to do things
up-front.

                   Linus
