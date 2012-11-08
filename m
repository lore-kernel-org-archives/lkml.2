Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752339Ab2KHOzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Nov 2012 09:55:33 -0500
Received: from mail-ye0-f174.google.com ([209.85.213.174]:58932 "EHLO
	mail-ye0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab2KHOzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Nov 2012 09:55:32 -0500
Date: Thu, 8 Nov 2012 11:55:22 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>, Andi Kleen <ak@linux.intel.com>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH 1/6] perf tools: Synthesize data mmap events for threads
Message-ID: <20121108145522.GL3430@ghostprotocols.net>
References: <1352273234-28912-1-git-send-email-namhyung@kernel.org>
 <1352273234-28912-2-git-send-email-namhyung@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1352273234-28912-2-git-send-email-namhyung@kernel.org>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Nov 07, 2012 at 04:27:09PM +0900, Namhyung Kim escreveu:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Current perf_event__synthesize_mmap_events() only deals with
> executable mappings.  With upcoming memory access sampling,

Not "upcoming", "recently added", since your patch needs the patch, in
Stephane series, that introduces PERF_RECORD_MISC_MMAP_DATA.

> non-executable data mappings are needed also.
> 
> While at it, convert parsing code to use sscanf which makes
> the code cleaner IMHO.

Please split the patch in two, one that does the
PERF_RECORD_MISC_MMAP_DATA and other that converts from hex2u64 to
sscanf.

- Arnaldo
 
> Cc: Stephane Eranian <eranian@google.com>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/perf/util/event.c | 78 ++++++++++++++++++++++---------------------------
>  1 file changed, 35 insertions(+), 43 deletions(-)
> 
> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
> index ca9ca285406a..068acf606b40 100644
> --- a/tools/perf/util/event.c
> +++ b/tools/perf/util/event.c
> @@ -193,55 +193,47 @@ static int perf_event__synthesize_mmap_events(struct perf_tool *tool,
>  	event->header.misc = PERF_RECORD_MISC_USER;
>  
>  	while (1) {
> -		char bf[BUFSIZ], *pbf = bf;
> -		int n;
> +		char bf[BUFSIZ];
> +		char prot[5], *pprot = prot;
>  		size_t size;
> +		char exec_name[PATH_MAX], *pexec = exec_name;
> +		char anonstr[] = "//anon";
> +
>  		if (fgets(bf, sizeof(bf), fp) == NULL)
>  			break;
>  
> +		/* ensure null termination since stack will be reused */
> +		strcpy(exec_name, "");
> +
>  		/* 00400000-0040c000 r-xp 00000000 fd:01 41038  /bin/cat */
> -		n = hex2u64(pbf, &event->mmap.start);
> -		if (n < 0)
> -			continue;
> -		pbf += n + 1;
> -		n = hex2u64(pbf, &event->mmap.len);
> -		if (n < 0)
> +		sscanf(bf, "%"PRIx64"-%"PRIx64" %s %"PRIx64" %*x:%*x %*u %s\n",
> +		       &event->mmap.start, &event->mmap.len, pprot,
> +		       &event->mmap.pgoff, pexec);
> +
> +		if (prot[2] == 'x' && !strcmp(exec_name, ""))
> +			strcpy(exec_name, anonstr);
> +
> +		/* ignore non-executable anon mappings */
> +		if (!strcmp(exec_name, ""))
>  			continue;
> -		pbf += n + 3;
> -		if (*pbf == 'x') { /* vm_exec */
> -			char anonstr[] = "//anon\n";
> -			char *execname = strchr(bf, '/');
> -
> -			/* Catch VDSO */
> -			if (execname == NULL)
> -				execname = strstr(bf, "[vdso]");
> -
> -			/* Catch anonymous mmaps */
> -			if ((execname == NULL) && !strstr(bf, "["))
> -				execname = anonstr;
> -
> -			if (execname == NULL)
> -				continue;
> -
> -			pbf += 3;
> -			n = hex2u64(pbf, &event->mmap.pgoff);
> -
> -			size = strlen(execname);
> -			execname[size - 1] = '\0'; /* Remove \n */
> -			memcpy(event->mmap.filename, execname, size);
> -			size = PERF_ALIGN(size, sizeof(u64));
> -			event->mmap.len -= event->mmap.start;
> -			event->mmap.header.size = (sizeof(event->mmap) -
> -					        (sizeof(event->mmap.filename) - size));
> -			memset(event->mmap.filename + size, 0, machine->id_hdr_size);
> -			event->mmap.header.size += machine->id_hdr_size;
> -			event->mmap.pid = tgid;
> -			event->mmap.tid = pid;
> -
> -			if (process(tool, event, &synth_sample, machine) != 0) {
> -				rc = -1;
> -				break;
> -			}
> +
> +		if (prot[2] != 'x')
> +			event->header.misc |= PERF_RECORD_MISC_MMAP_DATA;
> +
> +		size = strlen(exec_name) + 1;
> +		memcpy(event->mmap.filename, exec_name, size);
> +		size = PERF_ALIGN(size, sizeof(u64));
> +		event->mmap.len -= event->mmap.start;
> +		event->mmap.header.size = (sizeof(event->mmap) -
> +					   (sizeof(event->mmap.filename) - size));
> +		memset(event->mmap.filename + size, 0, machine->id_hdr_size);
> +		event->mmap.header.size += machine->id_hdr_size;
> +		event->mmap.pid = tgid;
> +		event->mmap.tid = pid;
> +
> +		if (process(tool, event, &synth_sample, machine) != 0) {
> +			rc = -1;
> +			break;
>  		}
>  	}
>  
> -- 
> 1.7.11.7
