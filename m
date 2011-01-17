Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753407Ab1AQREc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 12:04:32 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38429 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab1AQREb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 12:04:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=iWNOvI7+G25ltgm6g+ZDuMYmO7t3P7O2cVcs68vvkmbo6C/3Yh46zfm77c+oRseA92
         jwEvtaXvrQSuxS0O23wf0/kmKkoUpBlD+S8Wsk5i37Q8FyW/jN6vF5WURVZiRYyUwEbj
         u4DhqDoeV7G8Zep/wmIyLqphPW4Qxozs1JyCA=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1101162145290.13377@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1101162145290.13377@swampdragon.chaosbits.net>
Date: Mon, 17 Jan 2011 12:04:29 -0500
X-Google-Sender-Auth: 96hmGEvLq5NCzMa90GXdSTBge_A
Message-ID: <AANLkTik+Z5C89Hb9Xu3az=deMsXj4rqvYpU=i7vXgdFx@mail.gmail.com>
Subject: Re: [PATCH] NFS4: Avoid potential NULL pointer dereference in decode_and_add_ds().
From: Fred Isaman <iisaman@netapp.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-nfs@vger.kernel.org, Trond Myklebust <Trond.Myklebust@netapp.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 16, 2011 at 3:50 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> strrchr() can return NULL if nothing is found. If this happens we'll
> dereference a NULL pointer in
> fs/nfs/nfs4filelayoutdev.c::decode_and_add_ds().
>
> I tried to find some other code that guarantees that this can never
> happen but I was unsuccessful. So, unless someone else can point to some
> code that ensures this can never be a problem, I believe this patch is
> needed.
>

The only guarantee is the assumption that the server isn't sending
garbage.  As such, this patch looks good to me.

Fred

> While I was changing this code I also noticed that all the dprintk()
> statements, except one, start with "%s:". The one missing the ":" I added
> it to.
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> ---
>  nfs4filelayoutdev.c |    7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
>  only compile tested.
>
> diff --git a/fs/nfs/nfs4filelayoutdev.c b/fs/nfs/nfs4filelayoutdev.c
> index 51fe64a..5a85b8f 100644
> --- a/fs/nfs/nfs4filelayoutdev.c
> +++ b/fs/nfs/nfs4filelayoutdev.c
> @@ -214,7 +214,7 @@ decode_and_add_ds(__be32 **pp, struct inode *inode)
>
>        /* ipv6 length plus port is legal */
>        if (rlen > INET6_ADDRSTRLEN + 8) {
> -               dprintk("%s Invalid address, length %d\n", __func__,
> +               dprintk("%s: Invalid address, length %d\n", __func__,
>                        rlen);
>                goto out_err;
>        }
> @@ -225,6 +225,11 @@ decode_and_add_ds(__be32 **pp, struct inode *inode)
>        /* replace the port dots with dashes for the in4_pton() delimiter*/
>        for (i = 0; i < 2; i++) {
>                char *res = strrchr(buf, '.');
> +               if (!res) {
> +                       dprintk("%s: Failed finding expected dots in port\n",
> +                               __func__);
> +                       goto out_free;
> +               }
>                *res = '-';
>        }
>
>
> --
> Jesper Juhl <jj@chaosbits.net>            http://www.chaosbits.net/
> Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
