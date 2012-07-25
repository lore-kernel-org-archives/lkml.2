Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756422Ab2GYGMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 02:12:14 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61675 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab2GYGMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 02:12:12 -0400
MIME-Version: 1.0
In-Reply-To: <1343176370-5856-1-git-send-email-ccross@android.com>
References: <1343176370-5856-1-git-send-email-ccross@android.com>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Wed, 25 Jul 2012 14:11:30 +0800
X-Google-Sender-Auth: B5OzJc_hFuPF4I71v4iD2E5TUSw
Message-ID: <CAK5ve-LY1iw7CanrMSZ0PtK=Fk9Au9tXnmaOuZ5P7vnP+5VAgA@mail.gmail.com>
Subject: Re: [PATCH] leds: triggers: send uevent when changing triggers
To: Colin Cross <ccross@android.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Richard Purdie <rpurdie@rpsys.net>, linux-leds@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 8:32 AM, Colin Cross <ccross@android.com> wrote:
> Some triggers create sysfs files when they are enabled.  Send a uevent
> "change" notification whenever the trigger is changed to allow userspace
> processes such as udev to modify permissions on the new files.
>

This looks like an workaround only for led trigger, can we fix this in
sysfs level?

Thanks,
-Bryan

> Signed-off-by: Colin Cross <ccross@android.com>
> ---
>  drivers/leds/led-triggers.c |   13 +++++++++++++
>  1 files changed, 13 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/leds/led-triggers.c b/drivers/leds/led-triggers.c
> index 46b4c76..a85ce09 100644
> --- a/drivers/leds/led-triggers.c
> +++ b/drivers/leds/led-triggers.c
> @@ -102,6 +102,12 @@ ssize_t led_trigger_show(struct device *dev, struct device_attribute *attr,
>  void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
>  {
>         unsigned long flags;
> +       char *event = NULL;
> +       char *envp[2];
> +       const char *name;
> +
> +       name = trigger ? trigger->name : "none";
> +       event = kasprintf(GFP_KERNEL, "TRIGGER=%s", name);
>
>         /* Remove any existing trigger */
>         if (led_cdev->trigger) {
> @@ -122,6 +128,13 @@ void led_trigger_set(struct led_classdev *led_cdev, struct led_trigger *trigger)
>                 if (trigger->activate)
>                         trigger->activate(led_cdev);
>         }
> +
> +       if (event) {
> +               envp[0] = event;
> +               envp[1] = NULL;
> +               kobject_uevent_env(&led_cdev->dev->kobj, KOBJ_CHANGE, envp);
> +               kfree(event);
> +       }
>  }
>  EXPORT_SYMBOL_GPL(led_trigger_set);
>
> --
> 1.7.7.3
>



-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
