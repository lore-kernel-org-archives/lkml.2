Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754045Ab1CUTf3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 15:35:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:56386 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab1CUTf1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 15:35:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=VdCGRMBDjQJHD78+CuEAKTj5k+SbJbxoxn6fVssUFZxWtKc8z60sVv61XqpCB0lZNd
         8fCbGGR9bdXMZBnLmP3iuVlBrRNbK//piK/4gs8v6h/XjoyJ1zapm32pCmCB7xSN+8ts
         hHcgsxzyerQBlXufb5AtMlVAn6ti4n1aUwsgM=
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1103212013060.15815@swampdragon.chaosbits.net>
References: <alpine.LNX.2.00.1103212013060.15815@swampdragon.chaosbits.net>
Date: Mon, 21 Mar 2011 15:35:27 -0400
Message-ID: <AANLkTinD4ze=pZpGGmJ5vor9sbbBfuktAdRqpqiEHZW7@mail.gmail.com>
Subject: Re: [PATCH][resend] Do not potentially overflow string in sumversion
From: Arnaud Lacombe <lacombar@gmail.com>
To: Jesper Juhl <jj@chaosbits.net>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        WANG Cong <xiyou.wangcong@gmail.com>,
        James Morris <jmorris@intercode.com.au>,
        James Morris <jmorris@namei.org>, "David S. Miller" <davem@redhat.com>,
        David Miller <davem@davemloft.net>, Steve French <sfrench@us.ibm.com>,
        Steve French <smfrench@gmail.com>, Andrew Tridgell <tridge@samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Mar 21, 2011 at 3:17 PM, Jesper Juhl <jj@chaosbits.net> wrote:
> In scripts/mod/sumversion.c (in get_src_version()) we call
> getenv("MODVERDIR"). This returns a pointer to a string of unknown length.
> This string of unknown length we then pass on as an argument to sprintf()
> and tell it to write the result to 'filelist' which has a, very much
> fixed, size of 'PATH_MAX + 1'. If the string returned by getenv() is too
> long we'll overrun the statically allocated buffer.
> This patch prevents the buffer overrun by using snprintf() and telling it
> to copy a maximum of 'PATH_MAX + 1' bytes (including the terminating \0).
>
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>
> Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
> ---
>  sumversion.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
>  compile tested only. Patch against Linus' tree as of right now.
>
> diff --git
> a/scripts/mod/sumversion.c
> b/scripts/mod/sumversion.c
> index 9dfcd6d..522c675 100644
> --- a/scripts/mod/sumversion.c
> +++ b/scripts/mod/sumversion.c
> @@ -416,7 +416,7 @@ void get_src_version(const char *modname, char sum[], unsigned sumlen)
>                basename = strrchr(modname, '/') + 1;
>        else
>                basename = modname;
> -       sprintf(filelist, "%s/%.*s.mod", modverdir,
> +       snprintf(filelist, PATH_MAX + 1, "%s/%.*s.mod", modverdir,
>                (int) strlen(basename) - 2, basename);
>
Please, do not use hardcoded size. The `sizeof' operator would be much
more appropriate. Moreover, if you want thing to be done pedantically,
you should also check that you do not get a truncated output. If
snprintf() truncates the output, this should be reported and the error
path should be followed, not to fail silently.

 - Arnaud

>        file = grab_file(filelist, &len);
>
>
> --
> Jesper Juhl <jj@chaosbits.net>       http://www.chaosbits.net/
> Don't top-post http://www.catb.org/jargon/html/T/top-post.html
> Plain text mails only, please.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kbuild" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
