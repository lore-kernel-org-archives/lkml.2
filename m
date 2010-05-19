Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755083Ab0ESBIO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 21:08:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31702 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752219Ab0ESBIN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 21:08:13 -0400
Message-ID: <4BF339DF.9070406@redhat.com>
Date: Tue, 18 May 2010 21:07:43 -0400
From: Masami Hiramatsu <mhiramat@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@infradead.org>
CC: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       =?UTF-8?B?RnLDqWTDqXJpYyBXZWlzYmVja2Vy?= <fweisbec@gmail.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Tom Zanussi <tzanussi@gmail.com>
Subject: Re: [PATCH 3/5] perf probe: Fix some error exit paths
References: <1274228881-8035-1-git-send-email-acme@infradead.org> <1274228881-8035-4-git-send-email-acme@infradead.org>
In-Reply-To: <1274228881-8035-4-git-send-email-acme@infradead.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Arnaldo Carvalho de Melo wrote:
> From: Arnaldo Carvalho de Melo <acme@redhat.com>
> 
> That could leave filedescriptors open and leak memory. Also stop using
> xmalloc, use malloc and handle results just like other error cases in
> the same routine that used it.

Oops, thanks for fixing.
BTW, I found some other bugs... See below.

> 
> Cc: Frédéric Weisbecker <fweisbec@gmail.com>
> Cc: Masami Hiramatsu <mhiramat@redhat.com>
> Cc: Mike Galbraith <efault@gmx.de>
> Cc: Paul Mackerras <paulus@samba.org>
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Tom Zanussi <tzanussi@gmail.com>
> LKML-Reference: <new-submission>
> Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
> ---
>  tools/perf/util/probe-finder.c |   27 +++++++++++++++++----------
>  1 files changed, 17 insertions(+), 10 deletions(-)
> 
> diff --git a/tools/perf/util/probe-finder.c b/tools/perf/util/probe-finder.c
> index 93583eb..0bfd46a 100644
> --- a/tools/perf/util/probe-finder.c
> +++ b/tools/perf/util/probe-finder.c
> @@ -743,32 +743,34 @@ static int find_lazy_match_lines(struct list_head *head,
>  				 const char *fname, const char *pat)
>  {
>  	char *fbuf, *p1, *p2;
> -	int fd, ret, line, nlines = 0;
> +	int fd, line, nlines = -1;
>  	struct stat st;
>  
>  	fd = open(fname, O_RDONLY);
>  	if (fd < 0) {

I think "fd = -errno;" should be here.

>  		pr_warning("Failed to open %s: %s\n", fname, strerror(-fd));
> -		return fd;
> +		return -1;

Here is also better to return fd (= -errno).

>  	}
>  
> -	ret = fstat(fd, &st);
> -	if (ret < 0) {
> +	nlines = fstat(fd, &st);
> +	if (nlines < 0) {
>  		pr_warning("Failed to get the size of %s: %s\n",
>  			   fname, strerror(errno));
> -		return ret;
> +		goto out_close;
>  	}
> -	fbuf = xmalloc(st.st_size + 2);
> -	ret = read(fd, fbuf, st.st_size);
> -	if (ret < 0) {
> +	fbuf = malloc(st.st_size + 2);
> +	if (fbuf == NULL)

Here, we should set nlines = -ENOMEM;

> +		goto out_close;
> +	nlines = read(fd, fbuf, st.st_size);
> +	if (nlines < 0) {
>  		pr_warning("Failed to read %s: %s\n", fname, strerror(errno));
> -		return ret;
> +		goto out_free_fbuf;
>  	}
> -	close(fd);
>  	fbuf[st.st_size] = '\n';	/* Dummy line */
>  	fbuf[st.st_size + 1] = '\0';
>  	p1 = fbuf;
>  	line = 1;
> +	nlines = 0;
>  	while ((p2 = strchr(p1, '\n')) != NULL) {
>  		*p2 = '\0';
>  		if (strlazymatch(p1, pat)) {
> @@ -778,7 +780,10 @@ static int find_lazy_match_lines(struct list_head *head,
>  		line++;
>  		p1 = p2 + 1;
>  	}
> +out_free_fbuf:
>  	free(fbuf);
> +out_close:
> +	close(fd);
>  	return nlines;
>  }
>  
> @@ -955,6 +960,8 @@ int find_kprobe_trace_events(int fd, struct perf_probe_event *pev,
>  	if (!dbg) {
>  		pr_warning("No dwarf info found in the vmlinux - "
>  			"please rebuild with CONFIG_DEBUG_INFO=y.\n");
> +		free(pf.tevs);
> +		*tevs = NULL;
>  		return -EBADF;
>  	}
>  

Thank you,

-- 
Masami Hiramatsu
e-mail: mhiramat@redhat.com
