Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754953Ab2JDLHP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 07:07:15 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:47834 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754708Ab2JDLHN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 07:07:13 -0400
Message-ID: <506D6DDD.6050405@nod.at>
Date: Thu, 04 Oct 2012 13:07:09 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [RFC] coredump: Ensure that the coredump helper has stdout
 and stderr
References: <1348849971-23412-1-git-send-email-richard@nod.at>
In-Reply-To: <1348849971-23412-1-git-send-email-richard@nod.at>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28.09.2012 18:32, Richard Weinberger wrote:
> Currently only stdin is available in the coredump helper process.
> If the process opens a file and then issues a printf(),
> printf() will write to that opened file instead to a console.
>
> Therefore open /dev/console and create fd 1 and 0 as init/main.c does.
> sys_close(0) is only needed if sys_open() succeeds.
> Before this patch it was in vain and returned always -EBADF because nobody
> opened fd 0.
>
> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>   fs/exec.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/fs/exec.c b/fs/exec.c
> index 574cf4d..2912fec 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -2079,7 +2079,13 @@ static int umh_pipe_setup(struct subprocess_info *info, struct cred *new)
>
>   	cp->file = files[1];
>
> -	sys_close(0);
> +	/* Ensure that the process has stdout and stderr */
> +	if (sys_open((const char __user *) "/dev/console", O_RDWR, 0) == 0) {
> +		sys_dup(0);
> +		sys_dup(0);
> +		sys_close(0);
> +	}
> +
>   	fd_install(0, files[0]);
>   	spin_lock(&cf->file_lock);
>   	fdt = files_fdtable(cf);
>

Ping?
