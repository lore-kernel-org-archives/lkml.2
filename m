Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751460Ab1ADOMc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 09:12:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:51883 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1ADOMb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 09:12:31 -0500
Date: Tue, 4 Jan 2011 12:12:14 -0200
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Han Pingtian <phan@redhat.com>, Mike Galbraith <efault@gmx.de>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>, Thomas Gleixner <tglx@linutronix.de>,
        mingo@elte.hu
Subject: Re: [GIT PULL||RFC 00/11] perf library and regression testing
 improvements
Message-ID: <20110104141214.GB19989@ghostprotocols.net>
References: <1294112905-25325-1-git-send-email-acme@infradead.org>
 <20110104071629.GB13299@elte.hu>
 <AANLkTinjkC=4yQbiLxF7=G1izFa2pOuR=WvRXbha3wsj@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinjkC=4yQbiLxF7=G1izFa2pOuR=WvRXbha3wsj@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, Jan 04, 2011 at 02:59:00PM +0100, Stephane Eranian escreveu:
> Arnaldo,
> 
> The version of perf at tip-x86 commit 9274b36, segfaults for me:
> 
> $ gdb perf
> (gdb) r stat date
> 
> Program received signal SIGSEGV, Segmentation fault.
> [Switching to Thread 0x7fdc602eb6e0 (LWP 4590)]
> cmd_stat (argc=1, argv=0x7fff6fa2a9f0, prefix=<value optimized out>)
> at builtin-stat.c:206
> 206			update_stats(&ps->res_stats[i], count[i]);
> (gdb) bt
> #0  cmd_stat (argc=1, argv=0x7fff6fa2a9f0, prefix=<value optimized
> out>) at builtin-stat.c:206
> #1  0x0000000000405c8b in handle_internal_command (argc=2,
> argv=0x7fff6fa2a9f0) at perf.c:286
> #2  0x00000000004060b0 in main (argc=2, argv=0x7fff6fa2a680) at perf.c:403
> 
> Most like ps is NULL.

Well, it shoudldn't, as we do, before calling that function:

        list_for_each_entry(pos, &evsel_list, node) {
                if (perf_evsel__alloc_stat_priv(pos) < 0 ||
                    perf_evsel__alloc_counts(pos, cpus->nr) < 0 ||
                    perf_evsel__alloc_fd(pos, cpus->nr, threads->nr) < 0)
                        goto out_free_fd;
        }

And then at line 206 it does:

	update_stats(&ps->res_stats[i], count[i]);

ps was set to be:

	struct perf_stat *ps = counter->priv;

that was set by perf_evsel__alloc_stat_priv

and count is

u64 *count = counter->counts->aggr.values;

That was allocated by perf_evsel__alloc_counts

/me scratches head :-\

- Arnaldo
