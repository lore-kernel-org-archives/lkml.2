Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754253Ab0GNP7d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 11:59:33 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:38818 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751672Ab0GNP7b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 11:59:31 -0400
Message-Id: <20100714154923.947138065@efficios.com>
User-Agent: quilt/0.48-1
Date: Wed, 14 Jul 2010 11:49:23 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [patch 0/2] x86: NMI-safe trap handlers
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Wed, 14 Jul 2010 15:58:04 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

There seem to have been some churn regarding Perf problems with per-cpu memory
allocation which uses vmalloc. Long story short: faulting NMIs reactivate NMIs
faster than supposed, because x86 re-enables NMIs at the first iret encountered,
which leads to nested NMIs.

x86_32 cannot use vmalloc_sync_all() to sychronize the TLBs from every
processes because the vmalloc area is mapped in a different address space for
each process on this architecture. A second alternative is to duplicate the
per-cpu allocation API to have a variant using kmalloc only. This would lead to
code and API duplication and should probably be kept as last resort. A third
solution to this problem is to make the page fault handler aware of NMIs and
ensure it can be called from this context. This third solution is proposed by
this patchset.

So I'm respinning this patchset which has been sitting for a while, used for
about 1-2 years in the LTTng tree without problems, already tested in a -tip
sub-branch in the past. It uses a ret/popf instruction pair instead of iret when
it detects that a trap handler is nested over an NMI. A second patch takes care
of making the page fault handler nmi-safe by using the cr3 register rather than
accessing ->current, which could be in the middle of being changed by a context
switch.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
