Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759624Ab0GQBQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 21:16:33 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44790 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759576Ab0GQBQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 21:16:32 -0400
MIME-Version: 1.0
In-Reply-To: <20100716224140.GI7338@basil.fritz.box>
References: <4C409CBA.1050709@redhat.com>
	<4C409F62.6030303@zytor.com>
	<4C40A1BD.4040507@redhat.com>
	<4C40A227.6000207@zytor.com>
	<4C40A4E8.5090605@redhat.com>
	<AANLkTinc_of_KYCFt9-8GZYGFLyqQLlgNttPe-YvZn-1@mail.gmail.com>
	<4C40B277.9030408@redhat.com>
	<AANLkTimfZb22E7c_ftyc5WfKsGvJKKq-J3Vq8Y6FNvhT@mail.gmail.com>
	<20100716220730.GH7338@basil.fritz.box>
	<AANLkTikzZ436qG4vuNYNItDV69u9HqWna1ND51GzUtwH@mail.gmail.com>
	<20100716224140.GI7338@basil.fritz.box>
Date: Fri, 16 Jul 2010 18:15:35 -0700
Message-ID: <AANLkTim_jPFLkmGqNpOHGo2RIRVyi2W72S42yaQCVqRk@mail.gmail.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Avi Kivity <avi@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
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
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 3:41 PM, Andi Kleen <andi@firstfloor.org> wrote:
>
> Maybe I'm misunderstanding everything (and it has been a lot of emails
> in the thread), but the case I was thinking of would be if the second NMI
> faults too, and then another one comes in after the IRET etc.

No, the nested NMI cannot fault, because it never even enters C code.
It literally just returns immediately after having noticed it is
nested (and corrupted the stack of the original one, so that the
original NMI will re-do itself at return)..

So the nested NMI will use some few tens of bytes of stack. In fact,
it will use the stack "above" the stack that the original NMI handler
is using, because it will reset the stack pointer back to the top of
the NMI stack. So in a very real sense, it is not even extending the
stack, it is just re-using a small part of the same stack that the
original NMI used (and that we copied away so that it doesn't matter
that it gets re-used)

As to another small but important detail: the _nested_ NMI actually
returns using "popf+ret", leaving NMI's blocked again. Thus
guaranteeing forward progress and lack of NMI storms.

To summarize:

 - the "original" (first-level) NMI can take faults (like the page
fault to fill in vmalloc pages lazily, or debug faults). That will
actually cause two stack frames (or three, if you debug a page fault
that happened while NMI was active). So there is certainly exception
nesting going on, but we're talking _much_ less stack than normal
stack usage where the nesting can be deep and in complex routines.

 - any "nested" NMI's will not actually use any more stack at all than
a non-nested one, because we've pre-reserved space for them (and we
_had_ to reserve space for them due to IST)

 - even if we get NMI's during the execution of the original NMI,
there can be only one such "spurious" NMI per nested exception. So if
we take a single page fault, that exception will re-enable NMI
(because it returns with "iret"), and as a result we may take a
_single_ new nested NMI until we disable NMI's again.

In other words, the approach is not all that different from doing
"lazy irq disable" like powerpc does for regular interrupts. For
NMI's, we do it because it's impossible (on x86) to disable NMI's
without actually taking one.

                         Linus
