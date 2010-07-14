Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756786Ab0GNRGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 13:06:23 -0400
Received: from mail.openrapids.net ([64.15.138.104]:39176 "EHLO
	blackscsi.openrapids.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756082Ab0GNRGU convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 13:06:20 -0400
Date: Wed, 14 Jul 2010 13:06:17 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
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
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100714170617.GB4955@Krystal>
References: <20100714154923.947138065@efficios.com> <20100714155804.049012415@efficios.com> <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com>
X-Editor: vi
X-Info: http://www.efficios.com
X-Operating-System: Linux/2.6.26-2-686 (i686)
X-Uptime: 12:40:41 up 172 days, 19:17,  7 users,  load average: 0.00, 0.02,
	0.00
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Linus Torvalds (torvalds@linux-foundation.org) wrote:
> On Wed, Jul 14, 2010 at 8:49 AM, Mathieu Desnoyers
> <mathieu.desnoyers@efficios.com> wrote:

(I was quoting Peter Anvin below) ;)

> >> I think you're vastly overestimating what is sane to do from an NMI
> >> context.  It is utterly and totally insane to assume vmalloc is available
> >> in NMI.
> 
> I agree that NMI handlers shouldn't touch vmalloc space. But now that
> percpu data is mapped through the VM, I do agree that other CPU's may
> potentially need to touch that data, and an interrupt (including an
> NMI) might be the first to create the mapping.
> 
[...]
> So please just document the sequence that actually needs the page
> table setup for the NMI/percpu case.
> 
> This patch (1/2) doesn't look horrible per se. I have no problems with
> it. I just want to understand why it is needed.

The problem originally addressed by this patch is the case where a NMI handler
try to access vmalloc'd per-cpu data, which goes as follow:

- One CPU does a fork(), which copies the basic kernel mappings.
- Perf allocates percpu memory for buffer control data structures.
  This mapping does not get copied.
- Tracing is activated.
- switch_to() to the newly forked process which missed the new percpu
  allocation.
- We take a NMI, which touches the vmalloc'd percpu memory in the Perf tracing
  handler, therefore leading to a page fault in NMI context. Here, we might be
  in the middle of switch_to(), where ->current might not be in sync with the
  current cr3 register.

The three choices we have to handle this that I am aware of are:
1) supporting page faults in NMI context, which imply removing ->current
   dependency and supporting iret-less return path.
2) duplicating the percpu alloc API with a variant that maps to kmalloc.
3) using vmalloc_sync_all() after creating the mapping. (only works for x86_64,
   not x86_32).

Choice 3 seems like a no-go on x86_32, choice 2 seems like a last-resort
(involves API duplication and reservation of a fixed-amount of per-cpu memory at
boot). Hence the proposal of choice 1.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
