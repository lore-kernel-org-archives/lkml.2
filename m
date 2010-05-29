Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab0E2W6U (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 18:58:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:44365 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756668Ab0E2W6S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 18:58:18 -0400
Date: Sat, 29 May 2010 19:57:54 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [BUG] perf: buildid not managed properly when cmd path is
 relative
Message-ID: <20100529225754.GC28009@ghostprotocols.net>
References: <AANLkTimTMDjP3fgcOv2kIUPYYONAiMYPdhDb1VsLrTE_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTimTMDjP3fgcOv2kIUPYYONAiMYPdhDb1VsLrTE_@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Thu, May 27, 2010 at 03:46:16PM +0200, Stephane Eranian escreveu:
> I ran into another problem while running more tests with
> perf record, perf buildid-list.
> 
> I do the following:
> 
> $ perf record foo/noploop 5
> $ perf buildid-list
> 54b1e7cc3cf52e0db255aab44ce7538eb62655b8 [kernel.kallsyms]
> 875ae61623e89f408b425ca0486a9ec99e3ac73e
> /home/eranian/perfmon/official/tip/build/tools/perf/foo/noploop
> 
> I know I have samples in noploop:
> $ perf report -D
> ...
> 0x10a0 [0x20]: PERF_RECORD_SAMPLE(IP, 2): 14721/14721: 0x4006d6 period: 2351576
>  ... thread: noploop:14721
>  ...... dso: ./foo/noploop
> 
> But if I ask with buildid-list (like per-archive is doing) then I get:
> 
> $ perf buildid-list --with-hits
> 54b1e7cc3cf52e0db255aab44ce7538eb62655b8 [kernel.kallsyms]
> 0000000000000000000000000000000000000000 ./foo/noploop
> 
> The builid is bogus for noploop and it is relative path not full anymore.
> 
> I instrumented __dsos__fprintf_buildid() and I get:
> hit=0 name=/home/eranian/perfmon/official/tip/build/tools/perf/foo/noploop
> hit=1 name=./foo/noploop
> 0000000000000000000000000000000000000000 ./foo/noploop
> 
> So it looks like when cmd is relative there are two entries but the one
> that counts the hits is the one with relative path. But is does not have
> the buildid, the full path entry does.
> 
> This is an issue because perf-archive only packages the
> content of .debug with hits.
> 
> The problem does not exists when cmd are found from PATH.

I reproduced the problem, and yeah, annoying, will work on it, thanks
for the report.

- Arnaldo
