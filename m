Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab1AJTlV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 14:41:21 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:50535 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398Ab1AJTlS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 14:41:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=o5EokM04Lcmw5CxPt8jkk9pFIgJerr1bkI7lrOZ5YLBGMndYnLHEs4rWlq5toIODTR
         6cbRMx3ORaHbX5RW4APCvAaztJCEkTzT3FI4NfzhKwlPZdr+qjTwyNLUcUfnCCzeRf7n
         G4x3gdmorZCwTqNAX4AnqMPmoeriKUIG6L+KQ=
Date: Mon, 10 Jan 2011 17:40:55 -0200
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <daahern@cisco.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        a.p.zijlstra@chello.nl, paulus@samba.org, tzanussi@gmail.com,
        imunsie@au1.ibm.com, linux-kernel@vger.kernel.org,
        linux-perf-users@vger.kernel.org
Subject: Re: perf: commit 55b4462 causes perf record to hang
Message-ID: <20110110194055.GA19447@ghostprotocols.net>
References: <4D2B544F.1050803@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D2B544F.1050803@cisco.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Jan 10, 2011 at 11:47:43AM -0700, David Ahern escreveu:
> With latest version of perf-core branch, a variant of perf record hangs:
> 
> # /tmp/build-perf/perf record -v -e cs -fo /tmp/perf.data  -- sleep 1
> couldn't open /proc/-1/status
> couldn't open /proc/-1/maps
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.003 MB /tmp/perf.data (~120 samples) ]
> 
> It sits there forever. Back trace is:

Yeah, this was reported by Ingo too, I was looking at it now, thanks for
bisecting it, now trying to figure out why that patch is problematic.
 
> (gdb) bt
> #0  0x0000000000447658 in __perf_session__process_events
> (session=0xab9500, data_offset=208,
>     data_size=2896, file_size=3104, ops=0x685580) at util/session.c:1006
> #1  0x00000000004107dd in process_buildids () at builtin-record.c:466
> #2  0x000000000041084d in atexit_header () at builtin-record.c:477
> #3  0x00007f45cc3e89e1 in exit () from /lib64/libc.so.6
> #4  0x0000000000404749 in handle_internal_command (argc=9,
> argv=0x7fffc59e2c70) at perf.c:359
> #5  0x000000000040488e in run_argv (argcp=0x7fffc59e2b5c,
> argv=0x7fffc59e2b50) at perf.c:403
> #6  0x0000000000404a98 in main (argc=9, argv=0x7fffc59e2c70) at perf.c:489
> 
> 
> git bisect traced the hang to
> 
> commit 55b44629f599a2305265ae9c77f9d9bcfd6ddc17
> Author: Thomas Gleixner <tglx@linutronix.de>
> Date:   Tue Nov 30 17:49:46 2010 +0000
> 
>     perf session: Use sensible mmap size
> 
>     On 64bit we can map the whole file in one go, on 32bit we can at
> least map
>     32MB and not map/unmap tiny chunks of the file.
> 
>     Base the progress bar on 1/16 of the data size.
> 
>     Preparatory patch to get rid of the malloc/memcpy/free of trace data.
> 
> 
> If I revert the changes (attached porting of it) perf-record does not hang.
> 
> David

> diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
> index 6fb4694..5d35e13 100644
> --- a/tools/perf/util/session.c
> +++ b/tools/perf/util/session.c
> @@ -143,15 +143,7 @@ struct perf_session *perf_session__new(const char *filename, int mode,
>  	INIT_LIST_HEAD(&self->dead_threads);
>  	self->hists_tree = RB_ROOT;
>  	self->last_match = NULL;
> -	/*
> -	 * On 64bit we can mmap the data file in one go. No need for tiny mmap
> -	 * slices. On 32bit we use 32MB.
> -	 */
> -#if BITS_PER_LONG == 64
> -	self->mmap_window = ULLONG_MAX;
> -#else
> -	self->mmap_window = 32 * 1024 * 1024ULL;
> -#endif
> +	self->mmap_window = 32;
>  	self->machines = RB_ROOT;
>  	self->repipe = repipe;
>  	INIT_LIST_HEAD(&self->ordered_samples.samples);
> @@ -949,14 +941,19 @@ int __perf_session__process_events(struct perf_session *session,
>  				   u64 data_offset, u64 data_size,
>  				   u64 file_size, struct perf_event_ops *ops)
>  {
> -	u64 head, page_offset, file_offset, file_pos, progress_next;
> +	u64 head, page_offset, file_offset, file_pos;
>  	int err, mmap_prot, mmap_flags, map_idx = 0;
>  	struct ui_progress *progress;
> -	size_t	page_size, mmap_size;
> +	size_t	page_size;
>  	char *buf, *mmaps[8];
>  	event_t *event;
>  	uint32_t size;
>  
> +	progress = ui_progress__new("Processing events...", session->size);
> +	if (progress == NULL)
> +		return -1;
> +
> +
>  	perf_event_ops__fill_defaults(ops);
>  
>  	page_size = sysconf(_SC_PAGESIZE);
> @@ -968,15 +965,6 @@ int __perf_session__process_events(struct perf_session *session,
>  	if (data_offset + data_size < file_size)
>  		file_size = data_offset + data_size;
>  
> -	progress_next = file_size / 16;
> -	progress = ui_progress__new("Processing events...", file_size);
> -	if (progress == NULL)
> -		return -1;
> -
> -	mmap_size = session->mmap_window;
> -	if (mmap_size > file_size)
> -		mmap_size = file_size;
> -
>  	memset(mmaps, 0, sizeof(mmaps));
>  
>  	mmap_prot  = PROT_READ;
> @@ -987,13 +975,14 @@ int __perf_session__process_events(struct perf_session *session,
>  		mmap_flags = MAP_PRIVATE;
>  	}
>  remap:
> -	buf = mmap(NULL, mmap_size, mmap_prot, mmap_flags, session->fd,
> -		   file_offset);
> +	buf = mmap(NULL, page_size * session->mmap_window, mmap_prot,
> +		   mmap_flags, session->fd, file_offset);
>  	if (buf == MAP_FAILED) {
>  		pr_err("failed to mmap file\n");
>  		err = -errno;
>  		goto out_err;
>  	}
> +	ui_progress__update(progress, file_offset);
>  	mmaps[map_idx] = buf;
>  	map_idx = (map_idx + 1) & (ARRAY_SIZE(mmaps) - 1);
>  	file_pos = file_offset + head;
> @@ -1007,9 +996,9 @@ more:
>  	if (size == 0)
>  		size = 8;
>  
> -	if (head + event->header.size >= mmap_size) {
> +	if (head + event->header.size >= page_size * session->mmap_window) {
>  		if (mmaps[map_idx]) {
> -			munmap(mmaps[map_idx], mmap_size);
> +			munmap(mmaps[map_idx], page_size * session->mmap_window);
>  			mmaps[map_idx] = NULL;
>  		}
>  
> @@ -1039,11 +1028,6 @@ more:
>  	head += size;
>  	file_pos += size;
>  
> -	if (file_pos >= progress_next) {
> -		progress_next += file_size / 16;
> -		ui_progress__update(progress, file_pos);
> -	}
> -
>  	if (file_pos < file_size)
>  		goto more;
>  

