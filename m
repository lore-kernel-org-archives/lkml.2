Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757799Ab0GNU4I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 16:56:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43459 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756860Ab0GNU4G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 16:56:06 -0400
MIME-Version: 1.0
In-Reply-To: <20100714201753.GB22096@Krystal>
References: <20100714154923.947138065@efficios.com>
	<20100714155804.049012415@efficios.com>
	<AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
	<20100714170617.GB4955@Krystal>
	<AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	<20100714184642.GA9728@elte.hu>
	<AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com>
	<20100714193652.GA13630@nowhere>
	<AANLkTilD4aYej_36lOCEvMNCdYc4jBIupi5-77oD9vD2@mail.gmail.com>
	<20100714201753.GB22096@Krystal>
Date: Wed, 14 Jul 2010 13:55:25 -0700
Message-ID: <AANLkTinDD83ngFttUSA590nDyWTrVu1FmP62QieEjR-6@mail.gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
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
        Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 1:17 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
> It only handles the case of a single NMI coming in. What happens in this
> scenario?

[ two nested NMI's ]

The _right_ thing happens.

What do you think the hardware would have done itself? The NMI was
blocked. It wouldn't get replayed twice. If you have two NMI's
happening while another NMI is active, you will get a single NMI after
the first NMI has completed.

So stop these _idiotic_ complaints. And face the music:

 - NMI's aren't that important. They are a _hell_ of a lot less
important than the standard page fault path, for example.

 - We do _not_ want to add more NMI magic outside of the NMI
codepaths. It's much better to handle NMI special cases in the NMI
code, rather than sprinkle them in random other codepaths (like percpu
allocators) that have NOTHING WHAT-SO-EVER to do with NMI's!

                        Linus

>
> - NMI (1) comes in.
> - takes a fault
>    - iret
> - NMI (2) comes in.
>  - nesting detected, popf/ret
> - takes another fault
> - NMI (3) comes in.
>  - nesting detected, popf/ret
> - iret faults
>  - executes only one extra NMI handler
>
> We miss NMI (3) here. I think this is an important change from a semantic where,
> AFAIK, the hardware should be allowed to assume that the CPU will execute as
> many nmi handlers are there are NMIs acknowledged.
>
> Thanks,
>
> Mathieu
>
> --
> Mathieu Desnoyers
> Operating System Efficiency R&D Consultant
> EfficiOS Inc.
> http://www.efficios.com
>
