Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab2EHW52 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 18:57:28 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:36351 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab2EHW51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 18:57:27 -0400
Date: Tue, 8 May 2012 15:57:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: arnd@arndb.de, gregkh@linuxfoundation.org, tglx@linutronix.de,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kmsg: limit message size
Message-Id: <20120508155726.d02d6600.akpm@linux-foundation.org>
In-Reply-To: <1336229772-3488-1-git-send-email-levinsasha928@gmail.com>
References: <1336229772-3488-1-git-send-email-levinsasha928@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat,  5 May 2012 16:56:12 +0200
Sasha Levin <levinsasha928@gmail.com> wrote:

> There are no size checks in kmsg_write(), and we try allocating enough
> memory to store everything userspace gave us, which may be too much for
> kmalloc to allocate.
> 
> Furthermore, we can have an integer overflow if len==INT_MAX, in that case
> we'll corrupt kernel memory.
> 
> This was tested with several userspace programs that write to kmsg, and haven't
> found a case where the program attempts to write more than PAGE_SIZE.
> 
> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
> ---
>  drivers/char/mem.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/char/mem.c b/drivers/char/mem.c
> index d6e9d08..c90964b 100644
> --- a/drivers/char/mem.c
> +++ b/drivers/char/mem.c
> @@ -815,6 +815,9 @@ static ssize_t kmsg_writev(struct kiocb *iocb, const struct iovec *iv,
>  	ssize_t ret = -EFAULT;
>  	size_t len = iov_length(iv, count);
>  
> +	if (len > PAGE_SIZE)
> +		return -E2BIG;
> +
>  	line = kmalloc(len + 1, GFP_KERNEL);
>  	if (line == NULL)
>  		return -ENOMEM;

Well, this is a write(), and write() is permitted to return
less-than-asked-for.  So what we could do here is to write the first N
bytes and then return N to userspace.  Well-behaved userspace will
notice this and then do some more writing from offset N.

Could I ask that you try this and test it a bit, see whether there is
any well-behaved userspace out there?  Things like cat and echo
_should_ dtrt.

