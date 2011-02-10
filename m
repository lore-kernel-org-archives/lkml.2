Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756548Ab1BJQ0W (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 11:26:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:6447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756247Ab1BJQ0V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 11:26:21 -0500
Date: Thu, 10 Feb 2011 14:25:55 -0200
From: Arnaldo Carvalho de Melo <acme@redhat.com>
To: Lin Ming <ming.m.lin@intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        Stephane Eranian <eranian@google.com>, fweisbec@gmail.com,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] perf tool: load data variable symbols
Message-ID: <20110210162555.GB20676@ghostprotocols.net>
References: <1297347333.2272.37.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1297347333.2272.37.camel@localhost>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Feb 10, 2011 at 10:15:33PM +0800, Lin Ming escreveu:
> Hi, all
> 
> Currently, perf tool only load function symbols when parsing perf.data.
> 
> But it is also helpful if variable symbols can be loaded.
> 
> For example, Intel load latency monitoring facility records data linear
> address of the load operation. It's useful if the data linear address is
> resolved into symbol, just like functions.
> 
> enum map_type {
>         MAP__FUNCTION = 0,
>         MAP__VARIABLE,
> };
> 
> We already have MAP__VARIABLE defined, although it's not used now.
> 
> For both kernel and userspace applications, we can load the variable
> symbols from .data and .bss section.
> 
> What do you think?

It suposedly already works, as you noticed there are no users in the
tree, IIRC I wrote that because somebody at IBM asked for it for some
tool and since then I haven't heard about such tool.

It will load global variable locations from the symtab, like:

[acme@felicio linux]$ readelf -s ~/bin/perf  | grep OBJECT | grep nr_
  216: 000000000076b9b0  8 OBJECT  LOCAL  DEFAULT   29 nr_tasks
  222: 00000000007eba48  8 OBJECT  LOCAL  DEFAULT   29 nr_run_events
  223: 00000000007eba50  8 OBJECT  LOCAL  DEFAULT   29 nr_sleep_events
  224: 00000000007eba58  8 OBJECT  LOCAL  DEFAULT   29 nr_wakeup_events
  225: 00000000007eba60  8 OBJECT  LOCAL  DEFAULT   29 nr_sleep_corrections
  226: 00000000007eba68  8 OBJECT  LOCAL  DEFAULT   29 nr_run_events_optimized
  233: 00000000007ebaa0  8 OBJECT  LOCAL  DEFAULT   29 nr_runs
  238: 00000000007ebac0  8 OBJECT  LOCAL  DEFAULT   29 nr_timestamps
  239: 00000000007ebac8  8 OBJECT  LOCAL  DEFAULT   29 nr_unordered_timestamps
  240: 00000000007ebad0  8 OBJECT  LOCAL  DEFAULT   29 nr_state_machine_bugs
  241: 00000000007ebad8  8 OBJECT  LOCAL  DEFAULT   29 nr_context_switch_bugs
  242: 00000000007ebae0  8 OBJECT  LOCAL  DEFAULT   29 nr_events
  243: 00000000007ebae8  8 OBJECT  LOCAL  DEFAULT   29 nr_lost_chunks
  244: 00000000007ebaf0  8 OBJECT  LOCAL  DEFAULT   29 nr_lost_events
  624: 0000000000817d28  8 OBJECT  LOCAL  DEFAULT   29 nr_unordered
  700: 000000000081a200  8 OBJECT  LOCAL  DEFAULT   29 nr_allocs
  701: 000000000081a208  8 OBJECT  LOCAL  DEFAULT   29 nr_cross_allocs
 1145: 0000000000831180  4 OBJECT  LOCAL  DEFAULT   29 vmlinux_path__nr_entries
[acme@felicio linux]$ 

But for things to start to get interesting we need to extend what we have in
'perf probe', i.e. the DWARF location expressions, to do reverse lookup based
on data address from sample, register file snapshots, and those DWARF location
expressions.

- Arnaldo
