Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756577Ab0FCHmC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 03:42:02 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46922 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab0FCHmA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 03:42:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Sfzr+2vTT1cfnzrRU7/uLapFKWKhiNHLzjTkbIe1+28e9e3F6N3Zx143DZcOCvJ5SB
         ubhsBQYDT1pMALbpsGRlj977mrwRcHLkvoQAOqY1diG/9K/KGXKAaxhsxnkwTYYcajD2
         NrcTTbMit68pa7kl9LPPeHfTub0+c8TjYgHrs=
MIME-Version: 1.0
In-Reply-To: <1275523999-27462-5-git-send-email-arnd@arndb.de>
References: <1275523999-27462-1-git-send-email-arnd@arndb.de>
	<1275523999-27462-5-git-send-email-arnd@arndb.de>
Date: Thu, 3 Jun 2010 09:41:58 +0200
X-Google-Sender-Auth: pv2Os_25ctBDAHvCZ45vkKz1Ghc
Message-ID: <AANLkTil4-BDiE-zwlNaGHm_rEWQroR0F-3fpc7BW366k@mail.gmail.com>
Subject: Re: [RFC 4/5] BKL: use no BKL in llseek
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       John Kacur <jkacur@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Jan Blunck <jblunck@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 3, 2010 at 02:13, Arnd Bergmann <arnd@arndb.de> wrote:
> We have shown that the BKL in default_llseek and other
> llseek operations never protects against concurrent access
> from another function:

> --- a/drivers/zorro/proc.c
> +++ b/drivers/zorro/proc.c
> @@ -23,7 +23,7 @@ proc_bus_zorro_lseek(struct file *file, loff_t off, int whence)
>  {
>        loff_t new = -1;
>
> -       lock_kernel();
> +       mutex_lock(&file->f_dentry->d_inode->i_mutex);
>        switch (whence) {
>        case 0:
>                new = off;
> @@ -36,10 +36,10 @@ proc_bus_zorro_lseek(struct file *file, loff_t off, int whence)
>                break;
>        }
>        if (new < 0 || new > sizeof(struct ConfigDev)) {
> -               unlock_kernel();
> +               mutex_unlock(&file->f_dentry->d_inode->i_mutex);
>                return -EINVAL;
>        }
> -       unlock_kernel();
> +       mutex_unlock(&file->f_dentry->d_inode->i_mutex);
>        return (file->f_pos = new);
>  }

I was about to fix this like drivers/pci/proc.c handles it
(origiginally I cloned it from that fil
anyway).
Compared to your version, that also moves the setting of file->f_pos
inside the mutex,
which is probably also needed in other places...

> --- a/drivers/pnp/isapnp/proc.c
> +++ b/drivers/pnp/isapnp/proc.c
> @@ -32,7 +32,7 @@ static loff_t isapnp_proc_bus_lseek(struct file *file, loff_t off, int whence)
>  {
>        loff_t new = -1;
>
> -       lock_kernel();
> +       mutex_lock(&file->f_dentry->d_inode->i_mutex);
>        switch (whence) {
>        case 0:
>                new = off;
> @@ -45,10 +45,10 @@ static loff_t isapnp_proc_bus_lseek(struct file *file, loff_t off, int whence)
>                break;
>        }
>        if (new < 0 || new > 256) {
> -               unlock_kernel();
> +               mutex_unlock(&file->f_dentry->d_inode->i_mutex);
>                return -EINVAL;
>        }
> -       unlock_kernel();
> +       mutex_unlock(&file->f_dentry->d_inode->i_mutex);
>        return (file->f_pos = new);

... like here?

>  }

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
