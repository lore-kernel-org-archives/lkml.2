Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933989Ab0EZUdh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:33:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:40301 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093Ab0EZUdg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:33:36 -0400
Date: Wed, 26 May 2010 17:33:16 -0300
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
       mingo@elte.hu, Peter Zijlstra <peterz@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Subject: Re: [GIT PULL 0/2] perf annotate fix and report improvoment
Message-ID: <20100526203315.GD9874@ghostprotocols.net>
References: <1274664671-27385-1-git-send-email-acme@infradead.org>
 <AANLkTil5WtBnMQt1odjEgmWHOuuKxb4AIyuBLAqOiUSg@mail.gmail.com>
 <20100526005531.GA9874@ghostprotocols.net>
 <AANLkTim-xv9mNEwGCueV47AoKh6AXbrdbTdCEwZHaEHJ@mail.gmail.com>
 <20100526182351.GB9874@ghostprotocols.net>
 <AANLkTimOEUKYXzdMOiWE6gRxR7vJX36VscdLjRroqGLq@mail.gmail.com>
 <20100526193255.GC9874@ghostprotocols.net>
 <AANLkTinxVsp1qtfqjlwl-ngrcD9IBDg6GoBnAk07ABuo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinxVsp1qtfqjlwl-ngrcD9IBDg6GoBnAk07ABuo@mail.gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, May 26, 2010 at 10:11:14PM +0200, Stephane Eranian escreveu:
> On Wed, May 26, 2010 at 9:32 PM, Arnaldo Carvalho de Melo
> <acme@infradead.org> wrote:
> > Em Wed, May 26, 2010 at 09:07:05PM +0200, Stephane Eranian escreveu:
> >> But in this example, I only really care about the symbols in the
> >> noploop program (/tmp/noploop).
> >>
> >> Missing symbol support for the kernel should not cause perf to avoid
> >> trying to resolve the symbols in other modules such as my user program
> >> here.
> >
> > Right, my bad, I thought that the problem was about the kernel symbols.
> >
> > Then can you try replacing:
> >
> > perf annotate -i ~/perf.data noploop
> >
> > with:
> >
> > perf annotate -i ~/perf.data -d noploop
> >
> > And see if that helps?
> >
> Ok that works. But if I turned on TUI, then I cannot obtain
> the same result. I am guessing it does not use the -d option.

Humm, it should be working, i.e. -d processing is about adding a filter,
lemme see...

Yeah, in builtin-annotate.c

        OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
                   "only consider symbols in these dsos"),

It sets the dso_list_str and that is used when processing events in:

	perf_session__process_events
		process_sample_event (in builtin-annotate.c)
			event__preprocess_sample

In event__preprocess_sample:

     if (symbol_conf.dso_list &&
         (!al->map || !al->map->dso ||
          !(strlist__has_entry(symbol_conf.dso_list,
                               al->map->dso->short_name) ||
            (al->map->dso->short_name != al->map->dso->long_name &&
             strlist__has_entry(symbol_conf.dso_list,
                                al->map->dso->long_name)))))
             goto out_filtered;

Yeah, this is all done no matter what frontend is used :-\

I just tried it here with:

[root@emilia linux-2.6-tip]# perf report -d libc-2.12.so
[root@emilia linux-2.6-tip]# perf annotate -d libc-2.12.so

with

[root@emilia linux-2.6-tip]# cat ~/.perfconfig 
[tui]

	report = on
	annotate = on
[root@emilia linux-2.6-tip]#

And it works as expected.

- Arnaldo
