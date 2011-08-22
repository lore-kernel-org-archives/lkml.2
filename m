Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752980Ab1HVOie (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 10:38:34 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:58240 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752268Ab1HVOic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 10:38:32 -0400
Subject: Re: [PATCH] perf, tool, record: Fix the header generation for pipe
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: acme@redhat.com, a.p.zijlstra@chello.nl, mingo@elte.hu, paulus@samba.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1314022997-9217-1-git-send-email-jolsa@redhat.com>
References: <1314022997-9217-1-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 22 Aug 2011 16:38:33 +0200
Message-ID: <1314023913.2307.63.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 22 août 2011 à 16:23 +0200, Jiri Olsa a écrit :
> The generation of the perf data file fails when using pipe
> as the output file descriptor.
> 
> When record command generates the data header, several files are put
> inside and the file size is stored ahead of the file contents itself.
> 
> The problem is that debugfs files cannot be stat-ed for size so we
> need to read the whole file, count the size and update the file size
> via seek&write (pwrite call).
> This cannot be done for pipes, since it's not allowed to seek on it.
> 
> The attached patch changes current behaviour for pipes to get the
> file size first and write correct data within the first pass.
> For other than pipe files, the current behaviour stands.
> 
> This issue was caught when running the script command:
> 
> 	# perf script  syscall-counts ls
> 
> since it connects record and report via pipe.
> 
> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  tools/perf/util/trace-event-info.c |   81 +++++++++++++++++++++++++++++++-----
>  1 files changed, 70 insertions(+), 11 deletions(-)
> 
> diff --git a/tools/perf/util/trace-event-info.c b/tools/perf/util/trace-event-info.c
> index 3403f81..62ab9a2 100644
> --- a/tools/perf/util/trace-event-info.c
> +++ b/tools/perf/util/trace-event-info.c
> @@ -59,6 +59,7 @@ unsigned int page_size;
>  
>  static const char *output_file = "trace.info";
>  static int output_fd;
> +static int output_is_pipe;
>  
>  struct event_list {
>  	struct event_list *next;
> @@ -183,20 +184,59 @@ int bigendian(void)
>  	return *ptr == 0x01020304;
>  }
>  
> +static off_t get_file_size(int fd)
> +{
> +	off_t size = 0;
> +	char buf[BUFSIZ];
> +	int r;
> +
> +	do {
> +		r = read(fd, buf, BUFSIZ);
> +		if (r > 0)
> +			size += r;
> +	} while (r > 0);
> +
> +	if (lseek(fd, 0, SEEK_SET))
> +		die("seek failed");
> +
> +	return size;
> +}

This part makes no sense :

If fd is a pipe, you'll call die("seek failed")

If it's not a pipe, you can try lseek(fd, 0, SEEK_END)+lseek(fd, 0,
SEEK_SET) or fstat(fd, &st) instead of the read() loop.



