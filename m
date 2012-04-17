Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755938Ab2DQI4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 04:56:54 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62887 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755714Ab2DQI4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 04:56:52 -0400
MIME-Version: 1.0
In-Reply-To: <20120403202432.GA18564@core.coreip.homeip.net>
References: <20120403202432.GA18564@core.coreip.homeip.net>
From: Che-liang Chiou <clchiou@chromium.org>
Date: Tue, 17 Apr 2012 16:56:11 +0800
X-Google-Sender-Auth: Pz8wEaXT8Ji80xUTrIf2DynR2Fc
Message-ID: <CANJuy2KgOX=2Oc9Uaf1TGRAeyXt0UjdjU-o-yo+NVUYxKmk_4g@mail.gmail.com>
Subject: Re: [PATCH] Input: serio_raw - ensure we don't block in non-blocking read
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        David Herrmann <dh.herrmann@googlemail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3H8v5bo008852

I didn't test the patch, but the logic looks fine to me.

On Wed, Apr 4, 2012 at 4:24 AM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> Avoid calling wait_event_interruptible() if client requested non-blocking
> read, since it is not guaranteed that another thread will not consume
> event after we checked if serio_raw->head != serio_raw->tail.
>
> Also ensure we do not return 0 but keep waiting instead in blocking case,
> when another thread steals "our" byte.
>
> Signed-off-by: Dmitry Torokhov <dtor@mail.ru>
> ---
>  drivers/input/serio/serio_raw.c |   43 ++++++++++++++++++++++----------------
>  1 files changed, 25 insertions(+), 18 deletions(-)
>
> diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
> index 4494233..094d6fb 100644
> --- a/drivers/input/serio/serio_raw.c
> +++ b/drivers/input/serio/serio_raw.c
> @@ -165,31 +165,38 @@ static ssize_t serio_raw_read(struct file *file, char __user *buffer,
>        struct serio_raw *serio_raw = client->serio_raw;
>        char uninitialized_var(c);
>        ssize_t read = 0;
> -       int retval;
> +       int error = 0;
>
> -       if (serio_raw->dead)
> -               return -ENODEV;
> +       do {
> +               if (serio_raw->dead)
> +                       return -ENODEV;
>
> -       if (serio_raw->head == serio_raw->tail && (file->f_flags & O_NONBLOCK))
> -               return -EAGAIN;
> +               if (serio_raw->head == serio_raw->tail &&
> +                   (file->f_flags & O_NONBLOCK))
> +                       return -EAGAIN;
>
> -       retval = wait_event_interruptible(serio_raw->wait,
> -                       serio_raw->head != serio_raw->tail || serio_raw->dead);
> -       if (retval)
> -               return retval;
> +               if (count == 0)
> +                       break;
>
> -       if (serio_raw->dead)
> -               return -ENODEV;
> +               while (read < count && serio_raw_fetch_byte(serio_raw, &c)) {
> +                       if (put_user(c, buffer++)) {
> +                               error = -EFAULT;
> +                               goto out;
> +                       }
> +                       read++;
> +               }
>
> -       while (read < count && serio_raw_fetch_byte(serio_raw, &c)) {
> -               if (put_user(c, buffer++)) {
> -                       retval = -EFAULT;
> +               if (read)
>                        break;
> -               }
> -               read++;
> -       }
>
> -       return read ?: retval;
> +               if (!(file->f_flags & O_NONBLOCK))
> +                       error = wait_event_interruptible(serio_raw->wait,
> +                                       serio_raw->head != serio_raw->tail ||
> +                                       serio_raw->dead);
> +       } while (!error);
> +
> +out:
> +       return read ?: error;
>  }
>
>  static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
> --
> 1.7.7.6
>
>
> --
> Dmitry
���{.n�+�������+%�����ݶ��w��{.n�+����{��G�����{ay�ʇڙ�,j��f���h��������z_�(�階�ݢj"���m������G������?����&���~��iO��z��v�^�m����������?�I�
