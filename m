Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751517Ab2EGRnQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 13:43:16 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48899 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777Ab2EGRnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 13:43:14 -0400
Message-ID: <4FA809AD.7060209@gmail.com>
Date: Mon, 07 May 2012 11:43:09 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/7] perf tools: Introduce perf_target__strerror()
References: <1336367344-28071-1-git-send-email-namhyung.kim@lge.com> <1336367344-28071-6-git-send-email-namhyung.kim@lge.com> <20120507172946.GC2485@infradead.org>
In-Reply-To: <20120507172946.GC2485@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/7/12 11:29 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, May 07, 2012 at 02:09:02PM +0900, Namhyung Kim escreveu:
>> The perf_target__strerror() sets @buf to a string that
>> describes the (perf_target-specific) error condition
>> that is passed via @errnum.
>>
>> This is similar to strerror_r() and does same thing if
>> @errnum has a standard errno value.
>
> This has a problem: why should I be warned when I do, as root:
>
> # perf top -u acme
>
> It warns me that "UID switch overriding SYSTEM", yeah, right that is
> what I asked, no need to tell me that :-)
>
> So what is missing in this case is that top starts with system_wide set,
> not from the command line.
>
> I.e. if I had asked for:
>
> # perf top --system_wide --user acme
>
> Ok, the warning would make sense.
>
> So just special case this in the top case, I think, like the patch
> below, ack?
>
> I'll fold this into this patch and add a [ committer note: ... ]
>
> Ack?
>
> - Arnaldo
>
> diff --git a/tools/perf/builtin-top.c b/tools/perf/builtin-top.c
> index a2518fc..780791f 100644
> --- a/tools/perf/builtin-top.c
> +++ b/tools/perf/builtin-top.c
> @@ -1257,7 +1257,16 @@ int cmd_top(int argc, const char **argv, const char *prefix __used)
>   	setup_browser(false);
>
>   	status = perf_target__validate(&top.target);
> -	if (status != PERF_ERRNO_TARGET__SUCCESS) {
> +	if (status != PERF_ERRNO_TARGET__SUCCESS&&
> +	    status != PERF_ERRNO_TARGET__PID_OVERRIDE_SYSTEM&&
> +	    status != PERF_ERRNO_TARGET__UID_OVERRIDE_SYSTEM) {
> +		/*
> + 		 * Top doesn't provide an explicit way to ask for system wide
> + 		 * profiling, it is the default.
> + 		 *
> + 		 * So we shouldn't warn the user when he/she asks for --pid or
> + 		 * --uid.
> + 		 */
>   		perf_target__strerror(&top.target, status, errbuf, BUFSIZ);
>   		ui__warning("%s", errbuf);
>   	}

Seems like we should avoid the propagation of the errnos beyond the 
depths of the library part. For perf-top why not default to nothing set 
and if the user does not request one, set system wide. i.e, following 
Patch 6 in this set do:

if (perf_target__none(&top.target)
     top.target.system_wide = true;

David
