Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754600Ab0JRJIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 05:08:13 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51337 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752925Ab0JRJIM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 05:08:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Uh8PKywGe07wO3n9fI2G6ieulvTrRWYclsKgNaHMpoqu6eJaES4g3PI8E4H0DpvMkl
         RYgPx0u9SqSpW3btEkPsraVr0NcllXPUsGLQGh3t1sVzrNUYhtaOIk5eUH4nqrBQDLBg
         iu/7Sd5PO0sUzkGoQDWwWB89ikePf3TNv1qOs=
MIME-Version: 1.0
In-Reply-To: <201010181043.14253.toralf.foerster@gmx.de>
References: <201010131328.06465.toralf.foerster@gmx.de>
	<201010171555.40453.toralf.foerster@gmx.de>
	<20101017201837.GA16458@lst.de>
	<201010181043.14253.toralf.foerster@gmx.de>
Date: Mon, 18 Oct 2010 11:08:11 +0200
X-Google-Sender-Auth: CQdeExjx3q5h3nXDirpb2aMq3x8
Message-ID: <AANLkTin8v5bKFSDkYqwBk6+id3tyucotBz+amvEdtf+8@mail.gmail.com>
Subject: Re: Fwd: Re: UML kernel crash of v2.6.36-rcX kernel
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Christoph Hellwig <hch@lst.de>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/10/18 Toralf Förster <toralf.foerster@gmx.de>:
>
> Christoph Hellwig wrote at 22:18:37
>> I really can't see any relation to the patch.  Can you try the some
>> things in the following order, please:
> ...
>>  (4) re-apply the include/linux/statfs.h changes and see if it still
>>       boots
>
> The first half of step 4 was it (I did not apply the "Definitions for the flag
> in f_flag.") :
>
> diff --git a/include/linux/statfs.h b/include/linux/statfs.h
> index b34cc82..0166d32 100644
> --- a/include/linux/statfs.h
> +++ b/include/linux/statfs.h
> @@ -2,7 +2,6 @@
>  #define _LINUX_STATFS_H
>
>  #include <linux/types.h>
> -
>  #include <asm/statfs.h>
>
>  struct kstatfs {
> @@ -16,7 +15,29 @@ struct kstatfs {
>        __kernel_fsid_t f_fsid;
>        long f_namelen;
>        long f_frsize;
> -   long f_spare[5];
> + long f_flags;
> + long f_spare[4];
>  };

That should only matter for code that accesses the former fifth
element of f_spare[].
fs/compat.c:put_compat_statfs(struct compat_statfs __user *ubuf,
struct kstatfs *kbuf) does that:

            __put_user(0, &ubuf->f_spare[0]) ||
            __put_user(0, &ubuf->f_spare[1]) ||
            __put_user(0, &ubuf->f_spare[2]) ||
            __put_user(0, &ubuf->f_spare[3]) ||
            __put_user(0, &ubuf->f_spare[4]))

Seems struct compat_statfs* may have 4, 5, or 6 elements in the f_spare[] array,
depending on the architecture.

> FWIW the uml kernel boots fine even with that commit however it crashed after
> a special http request : $> wget http://n22_uml/phpsysinfo/

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
