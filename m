Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932108Ab0GOBvs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 21:51:48 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42782 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758125Ab0GOBvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 21:51:47 -0400
MIME-Version: 1.0
In-Reply-To: <AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com>
References: <20100714154923.947138065@efficios.com>
	<20100714155804.049012415@efficios.com>
	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	<20100714170617.GB4955@Krystal>
	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	<20100714203940.GC22096@Krystal>
	<AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>
	<20100714222115.GA30122@Krystal>
	<AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com>
	<AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com>
Date: Wed, 14 Jul 2010 18:45:28 -0700
Message-ID: <AANLkTil4LYSjS88P2CopOVi3Ty9pxwFPsaw0328KlPSu@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 6:23 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> So this is what I think it might look like, with the %rip in place.
>  [ ...]
> Hmm?

I didn't fill in the iret fault details, because I thought that would
be trivial. We get an exception, it's a slow case, how hard can it be
to just call the NMI code?

But thinking some more about it, it doesn't feel as trivial any more.
We want to set up that same nesting code for the faked NMI call, but
now I made it be two separate variables, and they need to be set in an
NMI-safe way without us actually having access to the whole NMI
blocking that the CPU does for a real NMI.

So there's a few subtleties there too. Probably need to make the two
percpu values adjacent, and use cmpxchg16b in the "emulate NMI on
exception" code to set them both atomically. Or something. So I think
it's doable, but it's admittedly more complicated than I thought it
would be.

.. and obviously there's nothing that guarantees that the code I
already posted is correct either. The whole concept might be total
crap.

                  Linus
