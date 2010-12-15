Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752796Ab0LOWtm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 17:49:42 -0500
Received: from mail-gx0-f180.google.com ([209.85.161.180]:47185 "EHLO
	mail-gx0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751691Ab0LOWtl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 17:49:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=uEedgoPGsAa3PnM7r2SQl5GgDI8gCWpR0mtSFujQd78Y5B+o50PIXUVk20TzfFcvmH
         FOPgeGDw5iNveP+cC+J0hxtwuE2lFljzOxTUikdgYNmXBbvlK2osc2Q/mIzbGHKKn7hc
         ejOOag4tPKz8A6diIW5mRfwilbTNaoA8K9xcM=
MIME-Version: 1.0
In-Reply-To: <1292450256-4544-1-git-send-email-mk@lab.zgora.pl>
References: <1292450256-4544-1-git-send-email-mk@lab.zgora.pl>
Date: Wed, 15 Dec 2010 23:49:39 +0100
Message-ID: <AANLkTi=Zz8eQTS+ja59eB9-F1aE2QP5DEVCwqBP50j8K@mail.gmail.com>
Subject: Re: [PATCH] btrfs: fix memory leak on error path in btrfs_get_acl()
From: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
To: Mariusz Kozlowski <mk@lab.zgora.pl>
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 15, 2010 at 10:57 PM, Mariusz Kozlowski <mk@lab.zgora.pl> wrote:
> If posix_acl_from_xattr() fails we leak memory stored in 'value'.
>
> Signed-off-by: Mariusz Kozlowski <mk@lab.zgora.pl>
> ---
>  fs/btrfs/acl.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/fs/btrfs/acl.c b/fs/btrfs/acl.c
> index 2222d16..11c9561 100644
> --- a/fs/btrfs/acl.c
> +++ b/fs/btrfs/acl.c
> @@ -61,6 +61,7 @@ static struct posix_acl *btrfs_get_acl(struct inode *inode, int type)
>                if (size > 0) {
>                        acl = posix_acl_from_xattr(value, size);
>                        if (IS_ERR(acl))
> +                               kfree(value);

Be careful with the evil { }

>                                return acl;
>                        set_cached_acl(inode, type, acl);
>                }
> --
> 1.7.0.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
