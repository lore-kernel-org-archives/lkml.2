Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753110Ab1FMCy6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 22:54:58 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55319 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752705Ab1FMCy4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 22:54:56 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF57BF1.90509@jp.fujitsu.com>
Date: Mon, 13 Jun 2011 11:54:41 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: drepper@akkadia.org
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        rientjes@google.com, torvalds@linux-foundation.org,
        viro@zeniv.linux.org.uk, wilsons@start.ca,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] Add cloexec information to fdinfo
References: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com>
In-Reply-To: <201106100355.p5A3t8Aa024924@drepperk.user.openhosting.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/10 12:55), drepper@akkadia.org wrote:
> There is one piece of information about a file descriptor which is
> currently not visible from the outside: the close-on-exec flag.  The
> /proc/PID/fdinfo/* files have the mode information but this is
> missing.  Is the following patch acceptable?
> 
> What I don't know is whether the RCU locking is needed given that
> real locks are taken.  Someone with more knowledge could just
> remove those two lines.
> 
> 
> Signed-off-by: Ulrich Drepper <drepper@gmail.com>
> 
>  base.c |   17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/proc/base.c b/fs/proc/base.c
> index 14def99..bda3651 100644
> --- a/fs/proc/base.c
> +++ b/fs/proc/base.c
> @@ -1924,12 +1924,23 @@ static int proc_fd_info(struct inode *inode, struct path *path, char *info)
>  				*path = file->f_path;
>  				path_get(&file->f_path);
>  			}
> -			if (info)
> +			if (info) {
> +				int cloexec;
> +				struct fdtable *fdt;
> +
> +				rcu_read_lock();
> +				fdt = files_fdtable(files);
> +				cloexec = FD_ISSET(fd, fdt->close_on_exec);
> +				rcu_read_unlock();
> +
>  				snprintf(info, PROC_FDINFO_MAX,
>  					 "pos:\t%lli\n"
> -					 "flags:\t0%o\n",
> +					 "flags:\t0%o\n"
> +					 "cloexec: %d\n",
>  					 (long long) file->f_pos,
> -					 file->f_flags);
> +					 file->f_flags,
> +					 cloexec);
> +			}
>  			spin_unlock(&files->file_lock);
>  			put_files_struct(files);
>  			return 0;

I think this is correct and useful. However I don't know fdtable life cycle detail.
cc to linux-fsdevel.

