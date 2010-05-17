Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab0EQPjX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 11:39:23 -0400
Received: from smtp-out.google.com ([216.239.44.51]:27478 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab0EQPjW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 11:39:22 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:content-transfer-encoding:x-system-of-record;
	b=uD0KhUKayBbabE11ivYSBM8rfQYWqpVVnVsyce1GJyPwvHhAbnOYTvhpK3JzxZaD0
	7W0oP9HBjIuZ1jDjLGV2g==
MIME-Version: 1.0
In-Reply-To: <20100517141910.GA14367@ghostprotocols.net>
References: <4bf11ae9.e88cd80a.06b0.ffffa8e3@mx.google.com>
	 <20100517141910.GA14367@ghostprotocols.net>
Date: Mon, 17 May 2010 17:39:19 +0200
Message-ID: <AANLkTimk2CO5OlG_inE1pAnmv2-eB7jNxXb18uT4ipxt@mail.gmail.com>
Subject: Re: [PATCH] perf: fix bug mismatch with -c option definition
From: Stephane Eranian <eranian@google.com>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: linux-kernel@vger.kernel.org, peterz@infradead.org, mingo@elte.hu,
       paulus@samba.org, davem@davemloft.net, fweisbec@gmail.com,
       perfmon2-devel@lists.sf.net, eranian@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 4:19 PM, Arnaldo Carvalho de Melo
<acme@infradead.org> wrote:
> Em Mon, May 17, 2010 at 12:04:01PM +0200, Stephane Eranian escreveu:
>>   The -c option defines the user requested sampling period. It was implemented
>>   using an unsigned int variable but the type of the option was OPT_LONG. Thus,
>>   the option parser was overwriting memory belonging to other variables, namely
>>   the mmap_pages leading to a zero page sampling buffer. The bug was exposed
>>   only when compiling at -O0, probably because the compiler was padding
>>   variables at higher optimization levels.
>
> Well spotted!

As you can imagine, it was not so trivial to find ;->

>
>>   This patch fixes this problem by declaring user_interval as u64. This also
>>   avoids wrap-around issues for large period on 32-bit systems.
>>
>>   Signed-off-by: Stephane Eranian <eranian@google.com>
>> --
>>  tools/perf/builtin-record.c |    8 ++++----
>>  1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
>> index 0f467cf..78f64cc 100644
>> --- a/tools/perf/builtin-record.c
>> +++ b/tools/perf/builtin-record.c
>> @@ -33,8 +33,8 @@ enum write_mode_t {
>>
>>  static int                   *fd[MAX_NR_CPUS][MAX_COUNTERS];
>>
>> -static unsigned int          user_interval                   = UINT_MAX;
>> -static long                  default_interval                =      0;
>> +static u64                   user_interval                   = ULLONG_MAX;
>> +static u64                   default_interval                =      0;
>
> The parsing code uses this for OPT_LONG:
>
>        case OPTION_LONG:
>                if (unset) {
>                        *(long *)opt->value = 0;
>                        return 0;
>                }
>                if (opt->flags & PARSE_OPT_OPTARG && !p->opt) {
>                        *(long *)opt->value = opt->defval;
>                        return 0;
>                }
>                if (get_arg(p, opt, flags, &arg))
>                        return -1;
>                *(long *)opt->value = strtol(arg, (char **)&s, 10);
>
> So I think we should augment the parsing code to have OPTION_ULONG, and,
> for handling u64, OPTION_ULLONG.
>
> I'll add that and then modify your patch to use it.
>
That's fine too.
Thanks.
