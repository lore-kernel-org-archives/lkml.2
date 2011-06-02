Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933341Ab1FBJsf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 05:48:35 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:51639 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933050Ab1FBJsd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 05:48:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FRf+oy9hJWA9J5WjRk/Mgi2/VMVEV4pMUGZK2/JRiQDMUODeLASw9GBc6JYCNxCWPP
         kuk22e52+6tpVJj8gB84xVNxAHtDVth9+9NtWR6mjZ61U/e4VxgFKEmoQlQPzatXM763
         nKTquXvBLVQ4u2NsWFwn5LEZQQh0jPqfDQpJc=
MIME-Version: 1.0
In-Reply-To: <1307006645-12702-1-git-send-email-ike.pan@canonical.com>
References: <1307006553-12667-1-git-send-email-ike.pan@canonical.com>
	<1307006645-12702-1-git-send-email-ike.pan@canonical.com>
Date: Thu, 2 Jun 2011 11:48:30 +0200
Message-ID: <BANLkTik+-wMXcCgSb8cCWx6wxrT0JgAbpnbGqizCpk+3F6Wx_g@mail.gmail.com>
Subject: Re: [PATCH 2/3] ideapad: Add nodes in sysfs
From: Corentin Chary <corentin.chary@gmail.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 11:24 AM, Ike Panhc <ike.pan@canonical.com> wrote:
> Create the following nodes in sysfs
>        /sys/devices/platform/ideapad/brightness
>        /sys/devices/platform/ideapad/touchpad
>        /sys/devices/platform/ideapad/cfg
>        /sys/devices/platform/ideapad/backlight
>
> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
> ---
>  .../ABI/testing/sysfs-platform-ideapad-laptop      |   30 +++++
>  drivers/platform/x86/ideapad-laptop.c              |  128 +++++++++++++++++---
>  2 files changed, 140 insertions(+), 18 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-platform-ideapad-laptop b/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
> index 807fca2..869f0c4 100644
> --- a/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
> +++ b/Documentation/ABI/testing/sysfs-platform-ideapad-laptop
> @@ -4,3 +4,33 @@ KernelVersion: 2.6.37
>  Contact:       "Ike Panhc <ike.pan@canonical.com>"
>  Description:
>                Control the power of camera module. 1 means on, 0 means off.
> +
> +What:          /sys/devices/platform/ideapad/brightness
> +Date:          Jun 2011
> +KernelVersion: 3.0.1
> +Contact:       "Ike Panhc <ike.pan@canonical.com>"
> +Description:
> +               Brightness control. When reading, it shows <current>/<max>.
> +               When writing, it accepts new brightness value.
> +
> +What:          /sys/devices/platform/ideapad/touchpad
> +Date:          Jun 2011
> +KernelVersion: 3.0.1
> +Contact:       "Ike Panhc <ike.pan@canonical.com>"
> +Description:
> +               Control the power of touchpad. 1 means on, 0 means off.
> +
> +What:          /sys/devices/platform/ideapad/cfg
> +Date:          Jun 2011
> +KernelVersion: 3.0.1
> +Contact:       "Ike Panhc <ike.pan@canonical.com>"
> +Description:
> +               Ideapad capability bits.
> +
> +What:          /sys/devices/platform/ideapad/backlight
> +Date:          Jun 2011
> +KernelVersion: 3.0.1
> +Contact:       "Ike Panhc <ike.pan@canonical.com>"
> +Description:
> +               Control the power of backlight. 1 means on, 0 means off.
> +
> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
> index a5c0efa..9c09891 100644
> --- a/drivers/platform/x86/ideapad-laptop.c
> +++ b/drivers/platform/x86/ideapad-laptop.c
> @@ -160,22 +160,25 @@ static int write_ec_cmd(acpi_handle handle, int cmd, unsigned long data)
>  }
>
>  /*
> - * camera power
> + * sysfs helper
>  */
> -static ssize_t show_ideapad_cam(struct device *dev,
> -                               struct device_attribute *attr,
> -                               char *buf)
> +static ssize_t show_ideapad_helper(struct device *dev,
> +                                  struct device_attribute *attr,
> +                                  char *buf,
> +                                  int cmd)
>  {
>        unsigned long result;
>
> -       if (read_ec_data(ideapad_handle, 0x1D, &result))
> +       if (read_ec_data(ideapad_handle, cmd, &result))
>                return sprintf(buf, "-1\n");
>        return sprintf(buf, "%lu\n", result);
>  }
>
> -static ssize_t store_ideapad_cam(struct device *dev,
> -                                struct device_attribute *attr,
> -                                const char *buf, size_t count)
> +static ssize_t store_ideapad_helper(struct device *dev,
> +                                   struct device_attribute *attr,
> +                                   const char *buf,
> +                                   size_t count,
> +                                   int cmd)
>  {
>        int ret, state;
>
> @@ -183,14 +186,112 @@ static ssize_t store_ideapad_cam(struct device *dev,
>                return 0;
>        if (sscanf(buf, "%i", &state) != 1)
>                return -EINVAL;
> -       ret = write_ec_cmd(ideapad_handle, 0x1E, state);
> +       ret = write_ec_cmd(ideapad_handle, cmd, state);
>        if (ret < 0)
>                return ret;
>        return count;
>  }
>
> +/*
> + * sysfs node
> + */
> +static ssize_t show_ideapad_cam(struct device *dev,
> +                               struct device_attribute *attr,
> +                               char *buf)
> +{
> +       return show_ideapad_helper(dev, attr, buf, 0x1D);
> +}
> +
> +static ssize_t store_ideapad_cam(struct device *dev,
> +                                struct device_attribute *attr,
> +                                const char *buf, size_t count)
> +{
> +       return store_ideapad_helper(dev, attr, buf, count, 0x1E);
> +}
> +
>  static DEVICE_ATTR(camera_power, 0644, show_ideapad_cam, store_ideapad_cam);
>
> +static ssize_t show_ideapad_touchpad(struct device *dev,
> +                                    struct device_attribute *attr,
> +                                    char *buf)
> +{
> +       return show_ideapad_helper(dev, attr, buf, 0x1B);
> +}
> +
> +static ssize_t store_ideapad_touchpad(struct device *dev,
> +                                     struct device_attribute *attr,
> +                                     const char *buf, size_t count)
> +{
> +       return store_ideapad_helper(dev, attr, buf, count, 0x1C);
> +}
> +
> +static DEVICE_ATTR(touchpad, 0644, show_ideapad_touchpad,
> +                  store_ideapad_touchpad);
> +
> +static ssize_t show_ideapad_brightness(struct device *dev,
> +                                      struct device_attribute *attr,
> +                                      char *buf)
> +{
> +       unsigned long now, max;
> +
> +       if (read_ec_data(ideapad_handle, 0x11, &max))
> +               max = -1;
> +       if (read_ec_data(ideapad_handle, 0x12, &now))
> +               now = -1;
> +       return sprintf(buf, "%lu/%lu\n", now, max);
> +}
> +
> +static ssize_t store_ideapad_brightness(struct device *dev,
> +                                       struct device_attribute *attr,
> +                                       const char *buf, size_t count)
> +{
> +       return store_ideapad_helper(dev, attr, buf, count, 0x13);
> +}
> +
> +static DEVICE_ATTR(brightness, 0644, show_ideapad_brightness,
> +                  store_ideapad_brightness);
> +
> +static ssize_t show_ideapad_cfg(struct device *dev,
> +                               struct device_attribute *attr,
> +                               char *buf)
> +{
> +       struct ideapad_private *priv = dev_get_drvdata(dev);
> +
> +       return sprintf(buf, "0x%.8X\n", (unsigned int)(priv->cfg));
> +}
> +
> +static DEVICE_ATTR(cfg, 0444, show_ideapad_cfg, NULL);
> +
> +static ssize_t show_ideapad_backlight(struct device *dev,
> +                                     struct device_attribute *attr,
> +                                     char *buf)
> +{
> +       return show_ideapad_helper(dev, attr, buf, 0x18);
> +}
> +
> +static ssize_t store_ideapad_backlight(struct device *dev,
> +                                      struct device_attribute *attr,
> +                                      const char *buf, size_t count)
> +{
> +       return store_ideapad_helper(dev, attr, buf, count, 0x33);
> +}
> +
> +static DEVICE_ATTR(backlight, 0644, show_ideapad_backlight,
> +                  store_ideapad_backlight);
> +
> +static struct attribute *ideapad_attributes[] = {
> +       &dev_attr_camera_power.attr,
> +       &dev_attr_brightness.attr,
> +       &dev_attr_touchpad.attr,
> +       &dev_attr_cfg.attr,
> +       &dev_attr_backlight.attr,
> +       NULL
> +};
> +
> +static struct attribute_group ideapad_attribute_group = {
> +       .attrs = ideapad_attributes
> +};
> +
>  /*
>  * Rfkill
>  */
> @@ -285,15 +386,6 @@ static void __devexit ideapad_unregister_rfkill(struct acpi_device *adevice,
>  /*
>  * Platform device
>  */
> -static struct attribute *ideapad_attributes[] = {
> -       &dev_attr_camera_power.attr,
> -       NULL
> -};
> -
> -static struct attribute_group ideapad_attribute_group = {
> -       .attrs = ideapad_attributes
> -};
> -
>  static int __devinit ideapad_platform_init(struct ideapad_private *priv)
>  {
>        int result;
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

Hi Ike,
Why do you want to add /sys/devices/platform/ideapad/brightness and
    /sys/devices/platform/ideapad/backlight ?
Both of these files should be handled by the generic backlight class
(using brightness and bl_power).

Also, could you describe what are these "capabilities" in the sysfs doc file ?

Thanks


-- 
Corentin Chary
http://xf.iksaif.net
