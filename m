Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934868Ab0GOWQW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Jul 2010 18:16:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44596 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S934833Ab0GOWQV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Jul 2010 18:16:21 -0400
MIME-Version: 1.0
In-Reply-To: <20100715220117.GA1499@Krystal>
References: <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com>
	<20100714203940.GC22096@Krystal>
	<AANLkTinM0eFnreNB5l_6f20oSGBchqAtYPb57tM01kUB@mail.gmail.com>
	<20100714222115.GA30122@Krystal>
	<AANLkTikLG4xVYfvuMtbuzsqcnzo1ut4dFAm6piqy2Lh7@mail.gmail.com>
	<AANLkTin21xBD-BFY4ZX2BPRFnT5-LkgGugvWsvTEP4Mr@mail.gmail.com>
	<AANLkTil4LYSjS88P2CopOVi3Ty9pxwFPsaw0328KlPSu@mail.gmail.com>
	<20100715183153.GA9276@Krystal>
	<AANLkTilfXUtQznSzOmO9ecoaviIt62Hv6jdUOMSRLdrF@mail.gmail.com>
	<AANLkTimAn0uMpeYKctO0qxM6nwbfev3RHARLZIbf991k@mail.gmail.com>
	<20100715220117.GA1499@Krystal>
Date: Thu, 15 Jul 2010 15:16:12 -0700
Message-ID: <AANLkTinL3S3iMSoP0fb6bxn9IY62OmytBtbqCKy9CZk2@mail.gmail.com>
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

On Thu, Jul 15, 2010 at 3:01 PM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>
>                 . NMI exit code
> and fake NMI entry are made reentrant with respect to NMI handler interruption
> by testing, at the very beginning of the NMI handler, if a NMI is nested over
> the whole nmi_atomic .. nmi_atomic_end code region.

That is totally bogus. The NMI can be nested by exceptions and
function calls - the whole _point_ of this thing. So testing "rip" for
anything else than the specific final "iret" is meaningless. You will
be in an NMI region regardless of what rip is.

> This code assumes NMIs have a separate stack.

It also needs to be made per-cpu (and the flags be per-cpu).

Then you could in fact possibly test the stack pointer for whether it
is in the NMI stack area, and use the value of %rsp itself as the
flag. So you could avoid the flag entirely. Because testing %rsp is
valid - testing %rip is not.

That would also avoid the race, because %rsp (as a flag) now gets
cleared atomically by the "iret". So that might actually solve things.

                          Linus
