Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab1BJTQd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 14:16:33 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:40170 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab1BJTQc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 14:16:32 -0500
Subject: Re: [RFC] perf tool: load data variable symbols
From: Peter Zijlstra <peterz@infradead.org>
To: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Lin Ming <ming.m.lin@intel.com>, mingo@elte.hu,
        Stephane Eranian <eranian@google.com>, fweisbec@gmail.com,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <20110210162555.GB20676@ghostprotocols.net>
References: <1297347333.2272.37.camel@localhost>
	 <20110210162555.GB20676@ghostprotocols.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 Feb 2011 20:17:35 +0100
Message-ID: <1297365455.5226.22.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-10 at 14:25 -0200, Arnaldo Carvalho de Melo wrote:
> Em Thu, Feb 10, 2011 at 10:15:33PM +0800, Lin Ming escreveu:
> > Hi, all
> > 
> > Currently, perf tool only load function symbols when parsing perf.data.
> > 
> > But it is also helpful if variable symbols can be loaded.
> > 
> > For example, Intel load latency monitoring facility records data linear
> > address of the load operation. It's useful if the data linear address is
> > resolved into symbol, just like functions.
> > 
> > enum map_type {
> >         MAP__FUNCTION = 0,
> >         MAP__VARIABLE,
> > };
> > 
> > We already have MAP__VARIABLE defined, although it's not used now.
> > 
> > For both kernel and userspace applications, we can load the variable
> > symbols from .data and .bss section.
> > 
> > What do you think?
> 
> It suposedly already works, as you noticed there are no users in the
> tree, IIRC I wrote that because somebody at IBM asked for it for some
> tool and since then I haven't heard about such tool.
> 
> It will load global variable locations from the symtab, like:
> 
> [acme@felicio linux]$ readelf -s ~/bin/perf  | grep OBJECT | grep nr_
>   216: 000000000076b9b0  8 OBJECT  LOCAL  DEFAULT   29 nr_tasks
>   222: 00000000007eba48  8 OBJECT  LOCAL  DEFAULT   29 nr_run_events
>   223: 00000000007eba50  8 OBJECT  LOCAL  DEFAULT   29 nr_sleep_events
>   224: 00000000007eba58  8 OBJECT  LOCAL  DEFAULT   29 nr_wakeup_events
>   225: 00000000007eba60  8 OBJECT  LOCAL  DEFAULT   29 nr_sleep_corrections
>   226: 00000000007eba68  8 OBJECT  LOCAL  DEFAULT   29 nr_run_events_optimized
>   233: 00000000007ebaa0  8 OBJECT  LOCAL  DEFAULT   29 nr_runs
>   238: 00000000007ebac0  8 OBJECT  LOCAL  DEFAULT   29 nr_timestamps
>   239: 00000000007ebac8  8 OBJECT  LOCAL  DEFAULT   29 nr_unordered_timestamps
>   240: 00000000007ebad0  8 OBJECT  LOCAL  DEFAULT   29 nr_state_machine_bugs
>   241: 00000000007ebad8  8 OBJECT  LOCAL  DEFAULT   29 nr_context_switch_bugs
>   242: 00000000007ebae0  8 OBJECT  LOCAL  DEFAULT   29 nr_events
>   243: 00000000007ebae8  8 OBJECT  LOCAL  DEFAULT   29 nr_lost_chunks
>   244: 00000000007ebaf0  8 OBJECT  LOCAL  DEFAULT   29 nr_lost_events
>   624: 0000000000817d28  8 OBJECT  LOCAL  DEFAULT   29 nr_unordered
>   700: 000000000081a200  8 OBJECT  LOCAL  DEFAULT   29 nr_allocs
>   701: 000000000081a208  8 OBJECT  LOCAL  DEFAULT   29 nr_cross_allocs
>  1145: 0000000000831180  4 OBJECT  LOCAL  DEFAULT   29 vmlinux_path__nr_entries
> [acme@felicio linux]$ 
> 
> But for things to start to get interesting we need to extend what we have in
> 'perf probe', i.e. the DWARF location expressions, to do reverse lookup based
> on data address from sample, register file snapshots, and those DWARF location
> expressions.

Another way is to reverse map the reported IP (PEBS + fixup) to a data
access using the dwarf info. That would also work for dynamically
allocated data structures.

(clearly you'd loose variable things like which entry in an array, but
you should still be able to identify the structure members)


