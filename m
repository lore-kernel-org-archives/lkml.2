Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab0EZUkf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 16:40:35 -0400
Received: from smtp-out.google.com ([74.125.121.35]:27900 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757040Ab0EZUke convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 16:40:34 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=pxtUM1DWdyGnmNVDH1b2ZoTPkZP77rK4lK9eQnoO5vdkz553exAeJqi/aphpHYANL
	ooDR065jBRW5pIU3oq3pA==
MIME-Version: 1.0
In-Reply-To: <20100526203315.GD9874@ghostprotocols.net>
References: <1274664671-27385-1-git-send-email-acme@infradead.org>
	<AANLkTil5WtBnMQt1odjEgmWHOuuKxb4AIyuBLAqOiUSg@mail.gmail.com>
	<20100526005531.GA9874@ghostprotocols.net>
	<AANLkTim-xv9mNEwGCueV47AoKh6AXbrdbTdCEwZHaEHJ@mail.gmail.com>
	<20100526182351.GB9874@ghostprotocols.net>
	<AANLkTimOEUKYXzdMOiWE6gRxR7vJX36VscdLjRroqGLq@mail.gmail.com>
	<20100526193255.GC9874@ghostprotocols.net>
	<AANLkTinxVsp1qtfqjlwl-ngrcD9IBDg6GoBnAk07ABuo@mail.gmail.com>
	<20100526203315.GD9874@ghostprotocols.net>
Date: Wed, 26 May 2010 22:40:24 +0200
Message-ID: <AANLkTimBC83Z8lSD8Drfpefl1D8Fpx-hYuQaZx4RyvSG@mail.gmail.com>
Subject: Re: [GIT PULL 0/2] perf annotate fix and report improvoment
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       mingo@elte.hu, Peter Zijlstra <peterz@infradead.org>,
       Tom Zanussi <tzanussi@gmail.com>, Mike Galbraith <efault@gmx.de>,
       Paul Mackerras <paulus@samba.org>,
       "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 10:33 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Wed, May 26, 2010 at 10:11:14PM +0200, Stephane Eranian escreveu:
>> On Wed, May 26, 2010 at 9:32 PM, Arnaldo Carvalho de Melo
>> <acme@infradead.org> wrote:
>> > Em Wed, May 26, 2010 at 09:07:05PM +0200, Stephane Eranian escreveu:
>> >> But in this example, I only really care about the symbols in the
>> >> noploop program (/tmp/noploop).
>> >>
>> >> Missing symbol support for the kernel should not cause perf to avoid
>> >> trying to resolve the symbols in other modules such as my user program
>> >> here.
>> >
>> > Right, my bad, I thought that the problem was about the kernel symbols.
>> >
>> > Then can you try replacing:
>> >
>> > perf annotate -i ~/perf.data noploop
>> >
>> > with:
>> >
>> > perf annotate -i ~/perf.data -d noploop
>> >
>> > And see if that helps?
>> >
>> Ok that works. But if I turned on TUI, then I cannot obtain
>> the same result. I am guessing it does not use the -d option.
>
> Humm, it should be working, i.e. -d processing is about adding a filter,
> lemme see...
>
> Yeah, in builtin-annotate.c
>
>        OPT_STRING('d', "dsos", &symbol_conf.dso_list_str, "dso[,dso...]",
>                   "only consider symbols in these dsos"),
>
> It sets the dso_list_str and that is used when processing events in:
>
>        perf_session__process_events
>                process_sample_event (in builtin-annotate.c)
>                        event__preprocess_sample
>
> In event__preprocess_sample:
>
>     if (symbol_conf.dso_list &&
>         (!al->map || !al->map->dso ||
>          !(strlist__has_entry(symbol_conf.dso_list,
>                               al->map->dso->short_name) ||
>            (al->map->dso->short_name != al->map->dso->long_name &&
>             strlist__has_entry(symbol_conf.dso_list,
>                                al->map->dso->long_name)))))
>             goto out_filtered;
>
> Yeah, this is all done no matter what frontend is used :-\
>
> I just tried it here with:
>
> [root@emilia linux-2.6-tip]# perf report -d libc-2.12.so
> [root@emilia linux-2.6-tip]# perf annotate -d libc-2.12.so
>
> with
>
> [root@emilia linux-2.6-tip]# cat ~/.perfconfig
> [tui]
>
>        report = on
>        annotate = on
> [root@emilia linux-2.6-tip]#
>
> And it works as expected.
>
I did not explain my testcase enough ;-<

With TUI, I started from perf report -i perf.data, then chose to zoom into
the noploop symbol.
