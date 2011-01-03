Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932186Ab1ACPJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 10:09:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45699 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932098Ab1ACPJC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 10:09:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cWTpUna2GUY0HEq2sXE0gKgJ0bPjeIsxMb61N9p1vllNuPHxHzUmMBudz7S85rHgwo
         DZ89cJNP5h3peYRWcqmaiFTJghp9MoSx1hucmpy9YtbVZE54+wW0oWHg+LSAN2742MkE
         oxekmJZgoIBlRc3/SkCNDpCfHr6MxC65/KYhE=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1101022150120.11481@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101022150120.11481@swampdragon.chaosbits.net>
Date: Mon, 3 Jan 2011 23:09:00 +0800
Message-ID: <AANLkTikc8pjsWcHRsAQwx8wMy0DQk+be0WnNUirPBS1C@mail.gmail.com>
Subject: Re: [PATCH] media, tlg2300: Fix memory leak in alloc_bulk_urbs_generic()
From: Huang Shijie <shijie8@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-media@vger.kernel.org, Kang Yong <kangyong@telegent.com>,
        Zhang Xiaobing <xbzhang@telegent.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jesper:
Thanks for your patch.


2011/1/3 Jesper Juhl <jj@chaosbits.net>:
> Hi,
>
> While reading
> drivers/media/video/tlg2300/pd-video.c::alloc_bulk_urbs_generic() I
> noticed that
>
>  - We don't free the memory allocated to 'urb' if the call to
>   usb_alloc_coherent() fails.
Yes.
thanks.

>  - If the 'num' argument to the function is ever <= 0 we'll return an
>   uninitialized variable 'i' to the caller.

Do not worry about this. All the 'num' are macros which is greater
then zero now.

>
> The following patch addresses both of the above by a) calling
> usb_free_urb() when usb_alloc_coherent() fails and by explicitly
> initializing 'i' to zero.
> I also moved the variables 'mem' and 'urb' inside the for loop. This does
> not actually make any difference, it just seemed more correct to me to let
> variables exist only in the innermost scope they are used.
>

Acked-by: Huang Shijie <shijie8@gmail.com>

>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  pd-video.c |   13 +++++++------
>  1 file changed, 7 insertions(+), 6 deletions(-)
>
>  compile tested only.
>
> diff --git a/drivers/media/video/tlg2300/pd-video.c b/drivers/media/video/tlg2300/pd-video.c
> index a1ffe18..df33a1d 100644
> --- a/drivers/media/video/tlg2300/pd-video.c
> +++ b/drivers/media/video/tlg2300/pd-video.c
> @@ -512,19 +512,20 @@ int alloc_bulk_urbs_generic(struct urb **urb_array, int num,
>                        int buf_size, gfp_t gfp_flags,
>                        usb_complete_t complete_fn, void *context)
>  {
> -       struct urb *urb;
> -       void *mem;
> -       int i;
> +       int i = 0;
>
> -       for (i = 0; i < num; i++) {
> -               urb = usb_alloc_urb(0, gfp_flags);
> +       for (; i < num; i++) {
> +               void *mem;
> +               struct urb *urb = usb_alloc_urb(0, gfp_flags);
>                if (urb == NULL)
>                        return i;
>
>                mem = usb_alloc_coherent(udev, buf_size, gfp_flags,
>                                         &urb->transfer_dma);
> -               if (mem == NULL)
> +               if (mem == NULL) {
> +                       usb_free_urb(urb);
>                        return i;
> +               }
>
>                usb_fill_bulk_urb(urb, udev, usb_rcvbulkpipe(udev, ep_addr),
>                                mem, buf_size, complete_fn, context);
>
>
>
> --
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
>
>
