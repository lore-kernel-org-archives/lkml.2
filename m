Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756644Ab0KSTlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 14:41:52 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:63781 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756355Ab0KSTlu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 14:41:50 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=xX5lcUqcAp0oY9SXLTHbCMZuFuNzdGgcuoKudCqCgVe165vk5LmSg7j3ZoUYGFkA1o
         hnmGm5usunrT8QG24XwNMabHoodsmJRdLZJtYOEAdxOaDM71nX4Zh60jGC3+M4Kjrtvt
         4WfGTzVn0UrJgIhUYEwGAuffkeTSTImUyd2K0=
MIME-Version: 1.0
In-Reply-To: <20101116142029.623791796@kernel.dk>
References: <20101116140900.039761100@kernel.dk>
	<20101116142029.623791796@kernel.dk>
Date: Fri, 19 Nov 2010 11:41:50 -0800
X-Google-Sender-Auth: U6leNZiivknK8-YKthqyoU7H1k8
Message-ID: <AANLkTimpZ4910=Cz-A0CO0GUqF8c16Z+XKbTg0jzLpm=@mail.gmail.com>
Subject: Re: [patch 15/28] fs: scale inode alias list
From: Tim Pepper <lnxninja@linux.vnet.ibm.com>
To: Nick Piggin <npiggin@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 6:09 AM, Nick Piggin <npiggin@kernel.dk> wrote:

> @@ -290,13 +300,18 @@ void dput(struct dentry *dentry)
>                         * want to reduce dcache_lock anyway so this will
>                         * get improved.
>                         */
> +drop1:
>                        spin_unlock(&dentry->d_lock);
>                        goto repeat;
>                }
> -               if (parent && !spin_trylock(&parent->d_lock)) {
> -                       spin_unlock(&dentry->d_lock);
> +               if (!spin_trylock(&dcache_inode_lock)) {
> +drop2:
>                        spin_unlock(&dcache_lock);
> -                       goto repeat;
> +                       goto drop1;
> +               }
> +               if (parent && !spin_trylock(&parent->d_lock)) {
> +                       spin_unlock(&dcache_inode_lock);
> +                       goto drop2;
>                }
>        }
>        dentry->d_count--;

Another ugh moment.  But it gets better in patches 18 and 20.
