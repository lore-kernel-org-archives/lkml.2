Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755288Ab1D2OeL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 10:34:11 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:45430 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab1D2OeJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 10:34:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ROxw/MBdLmt6AyuV9KIuVVAPGy2pqKKi1+aic/QF1f0lNYLkaL/P052h+kSRSO1NbV
         0o5InpDGterabAZLdBjFQfiAQoimBtnNvxD67zHLUFymweWkXyCF60FU2PWIEuUa0LCV
         cpyFKEixSwFVPxXjeWIWqV7xdvxGtrG7yHZ1c=
Message-ID: <4DBACC5C.1020502@gmail.com>
Date: Fri, 29 Apr 2011 08:34:04 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: mingo@redhat.com, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, dsahern@gmail.com, tglx@linutronix.de,
        mingo@elte.hu
CC: linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/stat] perf stat: Fail softly on unsupported events
References: <tip-7y40wib8n006io7hjpn1dsrm@git.kernel.org>
In-Reply-To: <tip-7y40wib8n006io7hjpn1dsrm@git.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 04/29/11 08:27, tip-bot for Ingo Molnar wrote:
> Commit-ID:  370faf1dd0461ad811852c8abbbcd3d73b1e4fc4
> Gitweb:     http://git.kernel.org/tip/370faf1dd0461ad811852c8abbbcd3d73b1e4fc4
> Author:     Ingo Molnar <mingo@elte.hu>
> AuthorDate: Fri, 29 Apr 2011 16:11:03 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 29 Apr 2011 16:22:33 +0200
> 
> perf stat: Fail softly on unsupported events
> 
> David Ahern reported this perf stat failure:
> 
>> # /tmp/build-perf/perf stat -- sleep 1
>>   Error: stalled-cycles-frontend event is not supported.
>>   Fatal: Not all events could be opened.
>>
>> This is a Dell R410 with an E5620 processor.
> 
> Fail in a softer fashion on unknown/unsupported events.
> 
> Reported-by: David Ahern <dsahern@gmail.com>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Link: http://lkml.kernel.org/n/tip-7y40wib8n006io7hjpn1dsrm@git.kernel.org
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  tools/perf/builtin-stat.c |    4 +---
>  1 files changed, 1 insertions(+), 3 deletions(-)
> 
> diff --git a/tools/perf/builtin-stat.c b/tools/perf/builtin-stat.c
> index 9e596ab..c8b535b 100644
> --- a/tools/perf/builtin-stat.c
> +++ b/tools/perf/builtin-stat.c
> @@ -377,7 +377,7 @@ static int run_perf_stat(int argc __used, const char **argv)
>  
>  	list_for_each_entry(counter, &evsel_list->entries, node) {
>  		if (create_perf_stat_counter(counter) < 0) {
> -			if (errno == EINVAL || errno == ENOSYS)
> +			if (errno == EINVAL || errno == ENOSYS || errno == ENOENT)
>  				continue;
>  
>  			if (errno == EPERM || errno == EACCES) {
> @@ -385,8 +385,6 @@ static int run_perf_stat(int argc __used, const char **argv)
>  				      "\t Consider tweaking"
>  				      " /proc/sys/kernel/perf_event_paranoid or running as root.",
>  				      system_wide ? "system-wide " : "");
> -			} else if (errno == ENOENT) {
> -				error("%s event is not supported. ", event_name(counter));

This silently ignores events -- including ones that a user requested. I
think a better option is a continue here.

 /tmp/build-perf/perf stat -- sleep 1
  Error: stalled-cycles-frontend event is not supported.
  Error: stalled-cycles-backend event is not supported.


>  			} else {
>  				error("open_counter returned with %d (%s). "
>  				      "/bin/dmesg may provide additional information.\n",
