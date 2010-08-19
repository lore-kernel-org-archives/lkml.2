Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753882Ab0HSPEh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 11:04:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:38596 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753657Ab0HSPEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 11:04:31 -0400
Date: Thu, 19 Aug 2010 12:04:22 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: callchain sampling bug in perf?
Message-ID: <20100819150422.GA325@ghostprotocols.net>
References: <20100815225359.GA32152@infradead.org> <20100819005720.GB5324@nowhere> <20100819085700.GB8782@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819085700.GB8782@infradead.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, Aug 19, 2010 at 04:57:01AM -0400, Christoph Hellwig escreveu:
> On Thu, Aug 19, 2010 at 02:57:22AM +0200, Frederic Weisbecker wrote:
> > Hmm, against which tree are you running? I've just tested callchains
> > record on random kprobe based tracepoint and it seemed to work well
> > on report.
> 
> It's 2.6.36-rc1 + a few filesystem related changes.
> 
> > Could you send me your perf.data and also the resulting archive
> > after the following command: "perf archive" ?
> 
> Both attached.

[acme@doppio tmp]$ tar xvf perf.data.tar.bz2 -C ~/.debug
.build-id/36/4300f12afee3dd5b1a87269d60de586f6b61ce
[kernel.kallsyms]/364300f12afee3dd5b1a87269d60de586f6b61ce
[acme@doppio tmp]$
[acme@doppio tmp]$ cat /home/acme/.perfconfig 
[tui]

	report=off
[acme@doppio tmp]$ perf report
# Events: 11K cycles
#
# Overhead       Command      Shared Object     Symbol
# ........  ............  .................  .........
#
    61.70%        python  [kernel.kallsyms]  [k] xlog_sync
    24.05%     flush-9:1  [kernel.kallsyms]  [k] xlog_sync
     7.99%          sync  [kernel.kallsyms]  [k] xlog_sync
     2.94%  xfssyncd/md1  [kernel.kallsyms]  [k] xlog_sync
     1.54%  compilebench  [kernel.kallsyms]  [k] xlog_sync
     1.31%            sh  [kernel.kallsyms]  [k] xlog_sync
     0.23%         :3500  [kernel.kallsyms]  [k] xlog_sync
     0.17%         :3496  [kernel.kallsyms]  [k] xlog_sync
     0.06%         :3570  [kernel.kallsyms]  [k] xlog_sync
     0.01%         :3590  [kernel.kallsyms]  [k] xlog_sync


#
# (For a higher level overview, try: perf report --sort comm,dso)
#
[acme@doppio tmp]$

# yeah, I need to do what we discussed and make tui activation on the command
# line, this use case proves it, if it needed proving usefulness at all :-)

[acme@doppio tmp]$ cat /home/acme/.perfconfig 
[tui]

	report=on

[acme@doppio tmp]$ perf report

http://vger.kernel.org/~acme/perf/perf-report-tui-callchain-xlog_sync.png

So it seems to work (you tell me if the callchains make sense), and the problem
is just on the stdio based callchain rendering.

Frederic, so it doesn't look like anything in the kernel, just a tools/perf/
problem.

I found some issues on the TUI as well, please press the left key some times
after expanding some callchains, so that the window can be resized, your workload
has just a few top level entries, so the window initially is small, I need to
take into account the (to be expanded) callchains and size it properly.

- Arnaldo
