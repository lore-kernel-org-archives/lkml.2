Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756374Ab0FAUFc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:05:32 -0400
Received: from smtp-out.google.com ([74.125.121.35]:27492 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754093Ab0FAUF2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:05:28 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=bET6FzRpNSAnYJhf9W1bcfx7CF8CY/7EEwdIDoq4RMuf2ITwDcJ0K8oyoaofzFoKj
	V5M/mmf7tnxG5sNZNH7VA==
MIME-Version: 1.0
In-Reply-To: <20100601183837.GC4093@ghostprotocols.net>
References: <AANLkTimTMDjP3fgcOv2kIUPYYONAiMYPdhDb1VsLrTE_@mail.gmail.com>
	<20100601183837.GC4093@ghostprotocols.net>
Date: Tue, 1 Jun 2010 22:05:24 +0200
Message-ID: <AANLkTinpaxSIEmqetcXDZIRdLUT7IuVPGInwTqN9F5cQ@mail.gmail.com>
Subject: Re: [BUG] perf: buildid not managed properly when cmd path is 
	relative
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
       perfmon2-devel@lists.sf.net, eranian@gmail.com,
       "David S. Miller" <davem@davemloft.net>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <peterz@infradead.org>, Tom Zanussi <tzanussi@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

You patch does seem to fix the problem.

However, I think there may be another issue, maybe
caused by the patch.

If you monitor a program WITHOUT buildids, and you run

$ perf record tmp/foo
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.077 MB perf.data (~3370 samples) ]

$  ./perf buildid-list
86200ab2bca285344a55156a079debbbe172bcc5 [kernel.kallsyms]

foo does not appear, yet we know it got samples.

$ ./perf buildid-list --with-hits
86200ab2bca285344a55156a079debbbe172bcc5 [kernel.kallsyms]
0000000000000000000000000000000000000000 /home/eranian/tmp/foo

With the --with-hits option, I get more output than without.Supposedly
no option means 'prints all entries', including those with hits or
without buildids.


On Tue, Jun 1, 2010 at 8:38 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Thu, May 27, 2010 at 03:46:16PM +0200, Stephane Eranian escreveu:
>> I ran into another problem while running more tests with perf record,
>> perf buildid-list.
>
>> I do the following:
>
>> $ perf record foo/noploop 5 ; perf buildid-list
>> 54b1e7cc3cf52e0db255aab44ce7538eb62655b8 [kernel.kallsyms]
>> 875ae61623e89f408b425ca0486a9ec99e3ac73e
>> /home/eranian/perfmon/official/tip/build/tools/perf/foo/noploop
>>
>> I know I have samples in noploop:
>> $ perf report -D
>> 0x10a0 [0x20]: PERF_RECORD_SAMPLE(IP, 2): 14721/14721: 0x4006d6 period: 2351576
>>  ... thread: noploop:14721
>>  ...... dso: ./foo/noploop
>
>> But if I ask with buildid-list (like per-archive is doing) then I get:
>> $ perf buildid-list --with-hits
>> 54b1e7cc3cf52e0db255aab44ce7538eb62655b8 [kernel.kallsyms]
>> 0000000000000000000000000000000000000000 ./foo/noploop
>
>> The builid is bogus for noploop and it is relative path not full anymore.
>
> Hi Stephane,
>
>        Can you please try the following patch?
>
> Thanks in advance,
>
> - Arnaldo
>
> From 9d146ff3c994634c529396442a4a96b0e58809e2 Mon Sep 17 00:00:00 2001
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> Date: Tue, 1 Jun 2010 12:37:05 -0300
> Subject: [PATCH 1/1] perf buildid-list: Fix --with-hits event processing
> MIME-Version: 1.0
> Content-Type: text/plain; charset=UTF-8
> Content-Transfer-Encoding: 8bit
>
> When we use plain 'perf buildid-list' we use only what is in the buildid
> table in the perf.data header. And those have absolute pathnames because
> at 'perf record' time we used __perf_session__process_events and that
> doesn't sets up the path shortening code in map__new() that happens if
> symbol_conf.full_paths is false, the default.
>
> On the other hand, when we use 'perf buildid-list --with-hits' we
> process all the events using perf_session__process_events, adding
> entries to the global DSO list _after_ removing the current directory
> from the DSO name, for presentation purposes.
>
> Because of that we end up having two entries in the DSO list when
> recording events for binaries using relative pathnames.
>
> Fix it minimally by setting symbol_conf.full_paths to true when marking
> the DSOs with hits in 'perf buildid-list --with-hits', as used by 'perf
> archive'
>
> Right fix longer term is to shorten the path only at presentation time.
> Will be done for 2.6.36.
>
> Reported-by: Stephane Eranian <eranian@google.com>
> Cc: David S. Miller <davem@davemloft.net>
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Stephane Eranian <eranian@google.com>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/builtin-buildid-list.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/builtin-buildid-list.c b/tools/perf/builtin-buildid-list.c
> index 44a47e1..9989072 100644
> --- a/tools/perf/builtin-buildid-list.c
> +++ b/tools/perf/builtin-buildid-list.c
> @@ -43,8 +43,10 @@ static int __cmd_buildid_list(void)
>        if (session == NULL)
>                return -1;
>
> -       if (with_hits)
> +       if (with_hits) {
> +               symbol_conf.full_paths = true;
>                perf_session__process_events(session, &build_id__mark_dso_hit_ops);
> +       }
>
>        perf_session__fprintf_dsos_buildid(session, stdout, with_hits);
>
> --
> 1.6.5.2
>
>



-- 
Stephane Eranian  | EMEA Software Engineering
Google France | 38 avenue de l'Opéra | 75002 Paris
Tel : +33 (0) 1 42 68 53 00
This email may be confidential or privileged. If you received this
communication by mistake, please
don't forward it to anyone else, please erase all copies and
attachments, and please let me know that
it went to the wrong person. Thanks
