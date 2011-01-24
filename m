Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751687Ab1AXTuv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 14:50:51 -0500
Received: from swampdragon.chaosbits.net ([90.184.90.115]:14551 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751554Ab1AXTut (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 14:50:49 -0500
Date: Mon, 24 Jan 2011 20:51:30 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Ian Kent <raven@themaw.net>
cc: linux-kernel@vger.kernel.org, autofs@linux.kernel.org
Subject: Re: [PATCH] autofs4: Do not potentially dereference NULL pointer
 returned by fget() in autofs_dev_ioctl_setpipefd()
In-Reply-To: <alpine.LNX.2.00.1012182238560.17400@swampdragon.chaosbits.net>
Message-ID: <alpine.LNX.2.00.1101242048590.10252@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1012182238560.17400@swampdragon.chaosbits.net>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ian,

On Sat, 18 Dec 2010, Jesper Juhl wrote:

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

It's been more than a month now since I submitted this updated patch 
adressing your feedback, but I've not seen any feedback on it.
Is it OK? Will you merge it? 

/Jesper


-- 
Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please.

