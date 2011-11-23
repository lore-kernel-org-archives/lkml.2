Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab1KWQRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 11:17:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36883 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab1KWQRw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 11:17:52 -0500
MIME-Version: 1.0
In-Reply-To: <1321999366-23784-9-git-send-email-corentincj@iksaif.net>
References: <1321999366-23784-1-git-send-email-corentincj@iksaif.net>
	<1321999366-23784-9-git-send-email-corentincj@iksaif.net>
Date: Wed, 23 Nov 2011 17:17:50 +0100
Message-ID: <CANq1E4TPKrig6SUT6OWXFoi=K_Q+3KNd6eZD693zfoJSWGNmGg@mail.gmail.com>
Subject: Re: [PATCH 08/15] samsung-laptop: add battery life extender support
From: David Herrmann <dh.herrmann@googlemail.com>
To: Corentin Chary <corentincj@iksaif.net>
Cc: platform-driver-x86@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
        Randy Dunlap <rdunlap@xenotime.net>, Matthew Garrett <mjg@redhat.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corentin

On Tue, Nov 22, 2011 at 11:02 PM, Corentin Chary <corentincj@iksaif.net> wrote:
> Signed-off-by: Corentin Chary <corentincj@iksaif.net>
> ---
>  .../ABI/testing/sysfs-driver-samsung-laptop        |   10 +++
>  drivers/platform/x86/samsung-laptop.c              |   82 ++++++++++++++++++++
>  2 files changed, 92 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/ABI/testing/sysfs-driver-samsung-laptop b/Documentation/ABI/testing/sysfs-driver-samsung-laptop
> index 0a81023..a6a56e1 100644
> --- a/Documentation/ABI/testing/sysfs-driver-samsung-laptop
> +++ b/Documentation/ABI/testing/sysfs-driver-samsung-laptop
> @@ -17,3 +17,13 @@ Description: Some Samsung laptops have different "performance levels"
>                Specifically, not all support the "overclock" option,
>                and it's still unknown if this value even changes
>                anything, other than making the user feel a bit better.
> +
> +What:          /sys/devices/platform/samsung/battery_life_extender
> +Date:          December 1, 2011
> +KernelVersion: 3.3
> +Contact:       Corentin Chary <corentin.chary@gmail.com>
> +Description:   Max battery charge level can be modified, battery cycle
> +               life can be extended by reducing the max battery charge
> +               level.
> +               0 means normal battery mode (100% charge)
> +               1 means battery life extender mode (80% charge)
> diff --git a/drivers/platform/x86/samsung-laptop.c b/drivers/platform/x86/samsung-laptop.c
> index 6493542..16f45da 100644
> --- a/drivers/platform/x86/samsung-laptop.c
> +++ b/drivers/platform/x86/samsung-laptop.c
> @@ -104,6 +104,10 @@ struct sabi_commands {
>        u16 get_performance_level;
>        u16 set_performance_level;
>
> +       /* 0x80 is off, 0x81 is on */
> +       u16 get_battery_life_extender;
> +       u16 set_battery_life_extender;
> +
>        /*
>         * Tell the BIOS that Linux is running on this machine.
>         * 81 is on, 80 is off
> @@ -157,6 +161,9 @@ static const struct sabi_config sabi_configs[] = {
>                        .get_performance_level = 0x08,
>                        .set_performance_level = 0x09,
>
> +                       .get_battery_life_extender = 0xFFFF,
> +                       .set_battery_life_extender = 0xFFFF,
> +
>                        .set_linux = 0x0a,
>                },
>
> @@ -204,6 +211,9 @@ static const struct sabi_config sabi_configs[] = {
>                        .get_performance_level = 0x31,
>                        .set_performance_level = 0x32,
>
> +                       .get_battery_life_extender = 0x65,
> +                       .set_battery_life_extender = 0x66,
> +
>                        .set_linux = 0xff,
>                },
>
> @@ -531,8 +541,78 @@ static ssize_t set_performance_level(struct device *dev,
>  static DEVICE_ATTR(performance_level, S_IWUSR | S_IRUGO,
>                   get_performance_level, set_performance_level);
>
> +static int read_battery_life_extender(struct samsung_laptop *samsung)
> +{
> +       const struct sabi_commands *commands = &samsung->config->commands;
> +       struct sabi_data data;
> +       int retval;
> +
> +       if (commands->get_battery_life_extender == 0xFFFF)
> +               return -ENODEV;
> +
> +       memset(&data, 0, sizeof(data));
> +       data.data[0] = 0x80;
> +       retval = sabi_command(samsung, commands->get_battery_life_extender,
> +                             &data, &data);
> +
> +       if (retval)
> +               return retval;
> +
> +       if (data.data[0] != 0 && data.data[0] != 1)
> +               return -ENODEV;
> +
> +       return data.data[0];
> +}
> +
> +static int write_battery_life_extender(struct samsung_laptop *samsung,
> +                                      int enabled)
> +{
> +       const struct sabi_commands *commands = &samsung->config->commands;
> +       struct sabi_data data;
> +
> +       memset(&data, 0, sizeof(data));
> +       data.data[0] = 0x80 | enabled;
> +       return sabi_command(samsung, commands->set_battery_life_extender,
> +                           &data, NULL);
> +}
> +
> +static ssize_t get_battery_life_extender(struct device *dev,
> +                                        struct device_attribute *attr,
> +                                        char *buf)
> +{
> +       struct samsung_laptop *samsung = dev_get_drvdata(dev);
> +       int ret;
> +
> +       ret = read_battery_life_extender(samsung);
> +       if (ret < 0)
> +               return ret;
> +
> +       return sprintf(buf, "%d\n", ret);
> +}
> +
> +static ssize_t set_battery_life_extender(struct device *dev,
> +                                       struct device_attribute *attr,
> +                                       const char *buf, size_t count)
> +{
> +       struct samsung_laptop *samsung = dev_get_drvdata(dev);
> +       int ret, value;
> +
> +       if (!count || sscanf(buf, "%i", &value) != 1)
> +               return -EINVAL;
> +
> +       ret = write_battery_life_extender(samsung, !!value);
> +       if (ret < 0)
> +               return ret;
> +
> +       return count;
> +}
> +
> +static DEVICE_ATTR(battery_life_extender, S_IWUSR | S_IRUGO,
> +                  get_battery_life_extender, set_battery_life_extender);
> +
>  static struct attribute *platform_attributes[] = {
>        &dev_attr_performance_level.attr,
> +       &dev_attr_battery_life_extender.attr,
>        NULL
>  };
>
> @@ -631,6 +711,8 @@ static mode_t samsung_sysfs_is_visible(struct kobject *kobj,
>
>        if (attr == &dev_attr_performance_level.attr)
>                ok = !!samsung->config->performance_levels[0].name;
> +       if (attr == &dev_attr_battery_life_extender.attr)
> +               ok = !!(read_battery_life_extender(samsung) >= 0);
>
>        return ok ? attr->mode : 0;
>  }
> --
> 1.7.5.4

My BIOS provides this option, too. However, this driver does not
detect it on my machine. During initialization I get:
samsung_laptop: SABI command 0x0078 failed with completion flag 0xaa

Maybe you can help debugging this. If there is something I can test
via debugfs, just tell me.

Regards
David
