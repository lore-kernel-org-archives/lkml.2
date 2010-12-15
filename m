Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959Ab0LODDW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 22:03:22 -0500
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43151 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758698Ab0LODDV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 22:03:21 -0500
X-Sasl-enc: n7op4OKfHDgKc9wlfaIqWBhj3OPa5JTFxklB+TTniVgq 1292382199
Subject: Re: [autofs] [PATCH][RFC] autofs4: Do not potentially dereference
 null pointer returned by fget() in autofs_dev_ioctl_setpipefd()
From: Ian Kent <raven@themaw.net>
To: Jesper Juhl <jj@chaosbits.net>
Cc: autofs@linux.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1012122357570.9206@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012122357570.9206@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 15 Dec 2010 11:03:15 +0800
Message-ID: <1292382195.2979.17.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-13 at 00:02 +0100, Jesper Juhl wrote:
> Hi,
> 
> In fs/autofs4/dev-ioctl.c::autofs_dev_ioctl_setpipefd() we call fget(), 
> which may return NULL, but we do not explicitly test for that NULL return 
> so we may end up dereferencing a NULL pointer - bad.

Oops, thanks for this.

> 
> A comment in fget() says "File object ref couldn't be taken" when that 
> function returns NULL, so I guess EBUSY is the proper error to return from 
> autofs_dev_ioctl_setpipefd() when this happens, but I'm far from sure 
> about this, so I'd like some feedback before this patch is merged.

Not sure EBUSY is the one to use.

What is happening here is that user space has opened a file handle it
thinks is against an autofs mount point (which may actually be covered
by another mount, hence the need for an ioctl) and is asking the kernel
to set it in the super block info struct so it can be used for control
operations. By the look of fget() a NULL return would happen if the file
table was full (ENFILE) or the file handle had already been closed
(probably EBADF) so perhaps EBADF would be a better choice.

> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  dev-ioctl.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
>  compile tested only.
> 
> diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
> index eff9a41..ab551ee 100644
> --- a/fs/autofs4/dev-ioctl.c
> +++ b/fs/autofs4/dev-ioctl.c
> @@ -372,6 +372,10 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
>  		return -EBUSY;
>  	} else {
>  		struct file *pipe = fget(pipefd);
> +		if (!pipe) {
> +			err = -EBUSY;
> +			goto out;
> +		}
>  		if (!pipe->f_op || !pipe->f_op->write) {
>  			err = -EPIPE;
>  			fput(pipe);
> 
> 
> 


