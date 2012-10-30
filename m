Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab2J3XBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 19:01:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6697 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758621Ab2J3XBt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 19:01:49 -0400
Date: Wed, 31 Oct 2012 00:01:20 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 03/25] perf tests: Add framework for automated
 perf_event_attr tests
Message-ID: <20121030230120.GA1067@krava.redhat.com>
References: <1351634526-1516-1-git-send-email-jolsa@redhat.com>
 <1351634526-1516-4-git-send-email-jolsa@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351634526-1516-4-git-send-email-jolsa@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 30, 2012 at 11:01:44PM +0100, Jiri Olsa wrote:
> Adding automated test to check event's perf_event_attr values.
> 
> The idea is run perf session with kidnapping sys_perf_event_open
> function. For each sys_perf_event_open call we store the
> perf_event_attr data to the file to be checked later against what
> we expect.
> 
> You can run this by:
>   $ python ./tests/attr.py -d ./tests/attr/ -p ./perf -v
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> ---
>  tools/perf/Makefile      |   1 +
>  tools/perf/perf.c        |   2 +
>  tools/perf/perf.h        |  16 ++-
>  tools/perf/tests/attr.c  | 136 ++++++++++++++++++++
>  tools/perf/tests/attr.py | 313 +++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 466 insertions(+), 2 deletions(-)
>  create mode 100644 tools/perf/tests/attr.c
>  create mode 100644 tools/perf/tests/attr.py
> 
> diff --git a/tools/perf/Makefile b/tools/perf/Makefile
> index 2d3427f..1da87a3 100644
> --- a/tools/perf/Makefile
> +++ b/tools/perf/Makefile
> @@ -430,6 +430,7 @@ LIB_OBJS += $(OUTPUT)arch/common.o
>  
>  LIB_OBJS += $(OUTPUT)tests/parse-events.o
>  LIB_OBJS += $(OUTPUT)tests/dso-data.o
> +LIB_OBJS += $(OUTPUT)tests/attr.o
>  
>  BUILTIN_OBJS += $(OUTPUT)builtin-annotate.o
>  BUILTIN_OBJS += $(OUTPUT)builtin-bench.o
> diff --git a/tools/perf/perf.c b/tools/perf/perf.c
> index e968373..a0ae290 100644
> --- a/tools/perf/perf.c
> +++ b/tools/perf/perf.c
> @@ -484,6 +484,8 @@ int main(int argc, const char **argv)
>  	}
>  	cmd = argv[0];
>  
> +	test_attr__init();
> +
>  	/*
>  	 * We use PATH to find perf commands, but we prepend some higher
>  	 * precedence paths: the "--exec-path" option, the PERF_EXEC_PATH
> diff --git a/tools/perf/perf.h b/tools/perf/perf.h
> index 469fbf2..0047264 100644
> --- a/tools/perf/perf.h
> +++ b/tools/perf/perf.h
> @@ -174,13 +174,25 @@ static inline unsigned long long rdclock(void)
>  	(void) (&_min1 == &_min2);		\
>  	_min1 < _min2 ? _min1 : _min2; })
>  
> +extern bool test_attr__enabled;
> +void test_attr__init(void);
> +void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
> +		     int fd, int group_fd, unsigned long flags);
> +
>  static inline int
>  sys_perf_event_open(struct perf_event_attr *attr,
>  		      pid_t pid, int cpu, int group_fd,
>  		      unsigned long flags)
>  {
> -	return syscall(__NR_perf_event_open, attr, pid, cpu,
> -		       group_fd, flags);
> +	int fd;
> +
> +	fd = syscall(__NR_perf_event_open, attr, pid, cpu,
> +		     group_fd, flags);
> +
> +	if (unlikely(test_attr__enabled))
> +		test_attr__open(attr, pid, cpu, fd, group_fd, flags);
> +
> +	return fd;
>  }
>  

SNIP

> +
> +void test_attr__open(struct perf_event_attr *attr, pid_t pid, int cpu,
> +		     int fd, int group_fd, unsigned long flags)
> +{
> +	if (store_event(attr, pid, cpu, fd, group_fd, flags))
> +		die("test attr FAILED");
> +}

ahh crap, I forgot the errno value preservation fix.. 

I'd send it later with another fix I have for perf stat or v2 if needed ;-)

jirka
