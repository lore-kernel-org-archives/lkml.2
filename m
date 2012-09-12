Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754068Ab2ILAbd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 20:31:33 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:63911 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab2ILAbb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 20:31:31 -0400
X-AuditID: 9c93016f-b7bffae000003557-61-504fd7e1e678
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 01/18] perf test: Remove die() calls
References: <1347407590-30960-1-git-send-email-acme@infradead.org>
	<1347407590-30960-2-git-send-email-acme@infradead.org>
Date: Wed, 12 Sep 2012 09:24:33 +0900
In-Reply-To: <1347407590-30960-2-git-send-email-acme@infradead.org> (Arnaldo
	Carvalho de Melo's message of "Tue, 11 Sep 2012 20:52:53 -0300")
Message-ID: <87627kay0u.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Arnaldo

On Tue, 11 Sep 2012 20:52:53 -0300, Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
>
> Just use pr_err() + return -1 and let the other tests run as well and
> then the perf's main() exit doing whatever it needs.
[snip]
> diff --git a/tools/perf/builtin-test.c b/tools/perf/builtin-test.c
> index cf33e50..6ae102e 100644
> --- a/tools/perf/builtin-test.c
> +++ b/tools/perf/builtin-test.c
> @@ -1023,14 +1023,16 @@ static int __test__rdpmc(void)
>  
>  	fd = sys_perf_event_open(&attr, 0, -1, -1, 0);
>  	if (fd < 0) {
> -		die("Error: sys_perf_event_open() syscall returned "
> -		    "with %d (%s)\n", fd, strerror(errno));
> +		pr_debug("Error: sys_perf_event_open() syscall returned "
> +			 "with %d (%s)\n", fd, strerror(errno));

s/pr_debug/pr_err/ ?

Otherwise the message will not be shown unless -v option is given
- and it's not sync with the changelog ;-)


> +		return -1;
>  	}
>  
>  	addr = mmap(NULL, page_size, PROT_READ, MAP_SHARED, fd, 0);
>  	if (addr == (void *)(-1)) {
> -		die("Error: mmap() syscall returned "
> -		    "with (%s)\n", strerror(errno));
> +		pr_debug("Error: mmap() syscall returned with (%s)\n",
> +			 strerror(errno));

Ditto.

Thanks,
Namhyung


> +		goto out_close;
>  	}
>  
>  	for (n = 0; n < 6; n++) {
> @@ -1051,9 +1053,9 @@ static int __test__rdpmc(void)
>  	}
>  
>  	munmap(addr, page_size);
> -	close(fd);
> -
>  	pr_debug("   ");
> +out_close:
> +	close(fd);
>  
>  	if (!delta_sum)
>  		return -1;
