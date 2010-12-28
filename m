Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab0L1CgW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 21:36:22 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:60272 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752988Ab0L1CgV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 21:36:21 -0500
X-Sasl-enc: syAYKxhpsKADKB+Neb5AGkdOELVtbTAu5bUY8eDtRYtT 1293503779
Subject: Re: [PATCH] autofs4: Do not potentially dereference NULL pointer
 returned by fget() in autofs_dev_ioctl_setpipefd()
From: Ian Kent <raven@themaw.net>
To: Jesper Juhl <jj@chaosbits.net>
Cc: autofs@linux.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LNX.2.00.1012182238560.17400@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012182238560.17400@swampdragon.chaosbits.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Dec 2010 10:36:13 +0800
Message-ID: <1293503773.5923.3.camel@perseus>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-12-18 at 22:43 +0100, Jesper Juhl wrote:
> Hi,
> 
> In fs/autofs4/dev-ioctl.c::autofs_dev_ioctl_setpipefd() we call fget(), 
> which may return NULL, but we do not explicitly test for that NULL return 
> so we may end up dereferencing a NULL pointer - bad.
> 
> When I originally submitted this patch I had chosen EBUSY as the return 
> value to use if this happens. Ian Kent was kind enough to explain why that 
> would most likely be wrong and why EBADF should most likely be used 
> instead. This version of the patch uses EBADF.
> 
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
Acked-by: Ian Kent <raven@themaw.net>

> ---
>  dev-ioctl.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/autofs4/dev-ioctl.c b/fs/autofs4/dev-ioctl.c
> index eff9a41..a650d7e 100644
> --- a/fs/autofs4/dev-ioctl.c
> +++ b/fs/autofs4/dev-ioctl.c
> @@ -372,6 +372,10 @@ static int autofs_dev_ioctl_setpipefd(struct file *fp,
>  		return -EBUSY;
>  	} else {
>  		struct file *pipe = fget(pipefd);
> +		if (!pipe) {
> +			err = -EBADF;
> +			goto out;
> +		}
>  		if (!pipe->f_op || !pipe->f_op->write) {
>  			err = -EPIPE;
>  			fput(pipe);
> 
> 
> 


