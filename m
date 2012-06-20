Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab2FTW0v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 18:26:51 -0400
Received: from casper.infradead.org ([85.118.1.10]:39872 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932507Ab2FTW0t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 18:26:49 -0400
Message-ID: <1340231192.21745.154.camel@twins>
Subject: Re: [PATCH 0/4] cputime: Virtual cputime accounting small cleanups
 and consolidation
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>
Date: Thu, 21 Jun 2012 00:26:32 +0200
In-Reply-To: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
References: <1340113391-1896-1-git-send-email-fweisbec@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 15:43 +0200, Frederic Weisbecker wrote:
> 
> I wish we could do more vtime cputime accounting consolidation
> but archs do the things pretty differently although I bet the
> behaviour could be more unified.
> 
Yes.. so s390,ia64 use thread_info, ppc uses their paca (arch private
precursor to per-cpu data).

So I understand why s390,ia64 want the sched hook, but I don't see why
ppc would need it, their account_process_tick() can fold whatever they
need on the tick.

So I think reworking s390,ia64 to use per-cpu storage should get rid of
this switch hook altogether.


Now everybody using VIRT_CPU_ACCOUNTING has the
syscall/__irq_{enter,exit} hooks and uses 64bit cputime_t.

IRQ_TIME_ACCOUNTING only has the __irq_{enter,exit} hook and uses
unsigned long cputime_t, it adds cputime_one_jiffy every tick when the
per-cpu counter is ahead of the cputime.


We could merge both and do away with the 64bit cputime thing by keeping
a (2nd) per-cpu kernel_cpustat which we fill with optional syscall/irq
hooks and have account_process_tick() first check if any of the
fine-grained fields overflow and if not, fall back to the regular tick
accounting (much like an extended irqtime_account_process_tick).


This would merge the fine-grain and tick based code-paths and do away
with the whole cputime_t mess, it would also merge the VIRT and IRQ
paths and make Frederic's optional syscall accounting trivial.

Or am I missing something obvious here? -- its late after all.

I'll try and write some code tomorrow.
