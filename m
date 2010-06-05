Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932620Ab0FEUjn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 16:39:43 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:36956 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932163Ab0FEUjm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 16:39:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=V7x0mUOpJ3uNaatDDNltDJ7mtCN2f2PjPZXmHF9BQRmMSYZMIIPDbWg11jYWFcVGHJ
         WC2GMa9LhuhvcJDfON5fur9jHnst+BhoOjZe/2WAnwgh/CJk4bRtsxAaMicBA0/AzV+c
         Phje9GKYT7Lxhj8NJ48K/Vw/zRW7HtYBc95Tg=
MIME-Version: 1.0
In-Reply-To: <201005241600.o4OG0QuA012887@hera.kernel.org>
References: <201005241600.o4OG0QuA012887@hera.kernel.org>
Date: Sat, 5 Jun 2010 22:39:40 +0200
X-Google-Sender-Auth: K9Icgkzu5EGapas79CwS8W0ae9k
Message-ID: <AANLkTil7N3ZJclwotDQVt-8IYKudZ5mqPbyH906Cd4IJ@mail.gmail.com>
Subject: Re: drivers: Push down BKL into various drivers
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Arnd Bergmann <arnd@arndb.de>, Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 24, 2010 at 18:00, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
> index ad730e1..e00a1cc 100644
> --- a/drivers/input/misc/hp_sdc_rtc.c
> +++ b/drivers/input/misc/hp_sdc_rtc.c
> @@ -43,6 +43,7 @@
>  #include <linux/proc_fs.h>
>  #include <linux/poll.h>
>  #include <linux/rtc.h>
> +#include <linux/smp_lock.h>
>  #include <linux/semaphore.h>
>
>  MODULE_AUTHOR("Brian S. Julin <bri@calyx.com>");
> @@ -64,8 +65,8 @@ static DECLARE_WAIT_QUEUE_HEAD(hp_sdc_rtc_wait);
>  static ssize_t hp_sdc_rtc_read(struct file *file, char __user *buf,
>                               size_t count, loff_t *ppos);
>
> -static int hp_sdc_rtc_ioctl(struct inode *inode, struct file *file,
> -                           unsigned int cmd, unsigned long arg);
> +static long hp_sdc_rtc_unlocked_ioctl(struct file *file,
> +                                     unsigned int cmd, unsigned long arg);
>
>  static unsigned int hp_sdc_rtc_poll(struct file *file, poll_table *wait);
>
> @@ -512,7 +513,7 @@ static int hp_sdc_rtc_read_proc(char *page, char **start, off_t off,
>         return len;
>  }
>
> -static int hp_sdc_rtc_ioctl(struct inode *inode, struct file *file,
> +static int hp_sdc_rtc_ioctl(struct file *file,
>                            unsigned int cmd, unsigned long arg)
>  {
>  #if 1
> @@ -659,14 +660,27 @@ static int hp_sdc_rtc_ioctl(struct inode *inode, struct file *file,
>  #endif
>  }
>
> +static long hp_sdc_rtc_unlocked_ioctl(struct file *file,
> +                                     unsigned int cmd, unsigned long arg)
> +{
> +       int ret;
> +
> +       lock_kernel();
> +       ret = hp_sdc_rtc_ioctl(file, cmd, arg);
> +       unlock_kernel();
> +
> +       return ret;
> +}
> +
> +
>  static const struct file_operations hp_sdc_rtc_fops = {
> -        .owner =       THIS_MODULE,
> -        .llseek =      no_llseek,
> -        .read =                hp_sdc_rtc_read,
> -        .poll =                hp_sdc_rtc_poll,
> -        .ioctl =       hp_sdc_rtc_ioctl,
> -        .open =                hp_sdc_rtc_open,
> -        .fasync =      hp_sdc_rtc_fasync,
> +        .owner =               THIS_MODULE,
> +        .llseek =              no_llseek,
> +        .read =                        hp_sdc_rtc_read,
> +        .poll =                        hp_sdc_rtc_poll,
> +        .unlocked_ioctl =      hp_sdc_rtc_ioctl,
> +        .open =                        hp_sdc_rtc_open,
> +        .fasync =              hp_sdc_rtc_fasync,
>  };
>
>  static struct miscdevice hp_sdc_rtc_dev = {

Something went wrong with this one:

| drivers/input/misc/hp_sdc_rtc.c:681: warning: initialization from
incompatible pointer type
| drivers/input/misc/hp_sdc_rtc.c:665: warning:
‘hp_sdc_rtc_unlocked_ioctl’ defined but not used

(detected while debugging my script to find compiler warning regressions)

Gr{oetje,eeting}s,

						Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
							    -- Linus Torvalds
