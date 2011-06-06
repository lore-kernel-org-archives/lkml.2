Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758007Ab1FFUpW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 16:45:22 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:37919 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755948Ab1FFUpU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 16:45:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CUSs1MUFoG3MaLR7YranqjVEWdudpGL6bmXzGbj4IdTJQ7JWUfr92YqhWxQZaJym+o
         9E+9l24ReiUZyek67yQMfOcm04Cz3m5ivKQWJ4eylMBOKXf6t7c/0SWXPU+RaEHlGKV/
         UHAmvVA/PQeAX8cRifRVB6gPW0j8QKzQy2t8s=
MIME-Version: 1.0
In-Reply-To: <1307392610-27911-1-git-send-email-tytso@mit.edu>
References: <1307392610-27911-1-git-send-email-tytso@mit.edu>
Date: Mon, 6 Jun 2011 16:45:19 -0400
Message-ID: <BANLkTimX_R8-mT4PqAhqwvCPm_-bcDFqVQ@mail.gmail.com>
Subject: Re: [PATCH] vfs: make unlink() return ENOENT in preference to EROFS
From: Arnaud Lacombe <lacombar@gmail.com>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Jun 6, 2011 at 4:36 PM, Theodore Ts'o <tytso@mit.edu> wrote:
> If user space attempts to unlink a non-existent file, and the file
> system is mounted read-only, return ENOENT instead of EROFS.  Either
> error code is arguably valid/correct, but ENOENT is a more specific
> error message.
>
> Reported-by: Michael Tokarev <mjt@tls.msk.ru>
> Signed-off-by: "Theodore Ts'o" <tytso@mit.edu>
> ---
>  fs/namei.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/namei.c b/fs/namei.c
> index 1ab641f..a9edbe0 100644
> --- a/fs/namei.c
> +++ b/fs/namei.c
> @@ -2708,9 +2708,9 @@ static long do_unlinkat(int dfd, const char __user *pathname)
>        error = PTR_ERR(dentry);
>        if (!IS_ERR(dentry)) {
>                /* Why not before? Because we want correct error value */
> -               if (nd.last.name[nd.last.len])
> -                       goto slashes;
>                inode = dentry->d_inode;
> +               if (nd.last.name[nd.last.len] || !inode)
> +                       goto slashes;
>                if (inode)
>                        ihold(inode);
It seems to me that this conditional will now always be verified as
you jump to `slashes' whenever `inode' is NULL, no ?

 - Arnaud

>                error = mnt_want_write(nd.path.mnt);
> --
> 1.7.4.1.22.gec8e1.dirty
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
