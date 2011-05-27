Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab1E0Mdl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 08:33:41 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63551 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab1E0Mdj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 08:33:39 -0400
MIME-Version: 1.0
In-Reply-To: <1306476003-4624-1-git-send-email-namhyung@gmail.com>
References: <1306476003-4624-1-git-send-email-namhyung@gmail.com>
Date: Fri, 27 May 2011 08:33:37 -0400
Message-ID: <BANLkTinyavxu3HQq0e_pkuMkj_kiTOi=zg@mail.gmail.com>
Subject: Re: [PATCH 1/3] nbd: pass MSG_* flags to kernel_recvmsg()
From: Paul Clements <paul.clements@us.sios.com>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 2:00 AM, Namhyung Kim <namhyung@gmail.com> wrote:
> Unlike kernel_sendmsg(), kernel_recvmsg() requires passing flags explicitly
> via last parameter instead of struct msghdr.msg_flags. Therefore calls to
> sock_xmit(lo, 0, ..., MSG_WAITALL) have not been processed properly by tcp
> layer wrt. the flag. Fix it.

Thanks. Good catch. I wonder why recvmsg takes external flags and
sendmsg uses the ones attached to msg? Odd...

--
Paul

> Signed-off-by: Namhyung Kim <namhyung@gmail.com>
> Cc: Paul Clements <Paul.Clements@steeleye.com>
> ---
>  drivers/block/nbd.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index e6fc716aca45..1df3bfe5225b 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -192,7 +192,8 @@ static int sock_xmit(struct nbd_device *lo, int send, void *buf, int size,
>                        if (lo->xmit_timeout)
>                                del_timer_sync(&ti);
>                } else
> -                       result = kernel_recvmsg(sock, &msg, &iov, 1, size, 0);
> +                       result = kernel_recvmsg(sock, &msg, &iov, 1, size,
> +                                               msg.msg_flags);
>
>                if (signal_pending(current)) {
>                        siginfo_t info;
> --
> 1.7.5.2
>
>
