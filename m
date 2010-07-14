Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752702Ab0GNQ3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 12:29:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42753 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751741Ab0GNQ3S convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 12:29:18 -0400
MIME-Version: 1.0
In-Reply-To: <20100714155804.049012415@efficios.com>
References: <20100714154923.947138065@efficios.com>
	<20100714155804.049012415@efficios.com>
Date: Wed, 14 Jul 2010 09:28:41 -0700
Message-ID: <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
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
        Andi Kleen <andi@firstfloor.org>,
        Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 8:49 AM, Mathieu Desnoyers
<mathieu.desnoyers@efficios.com> wrote:
>> I think you're vastly overestimating what is sane to do from an NMI
>> context.  It is utterly and totally insane to assume vmalloc is available
>> in NMI.

I agree that NMI handlers shouldn't touch vmalloc space. But now that
percpu data is mapped through the VM, I do agree that other CPU's may
potentially need to touch that data, and an interrupt (including an
NMI) might be the first to create the mapping.

And that's why the faulting code needs to be interrupt-safe for the
vmalloc area.

However, it does look like the current scheduler should make it safe
to access "current->mm->pgd" from regular interrupts, so the problem
is apparently only an NMI issue. So exactly what are the circumstances
that create and expose percpu data on a CPU _without_ mapping it on
that CPU?

IOW, I'm missing some background here. I agree that at least some
basic percpu data should generally be available for an NMI handler,
but at the same time I wonder how come that basic percpu data wasn't
already mapped?

The traditional irq vmalloc race was something like:
 - one CPU does a "fork()", which copies the basic kernel mappings
 - in another thread a driver does a vmalloc(), which creates a _new_
mapping that didn't get copied.
 - later on a switch_to() switches to the newly forked process that
missed the vmalloc initialization
 - we take an interrupt for the driver that needed the new vmalloc
space, but now it doesn't have it, and we fill it in at run-time for
the (rare) race.

and I'm simply not seeing how fork() could ever race with percpu data setup.

So please just document the sequence that actually needs the page
table setup for the NMI/percpu case.

This patch (1/2) doesn't look horrible per se. I have no problems with
it. I just want to understand why it is needed.

                        Linus
