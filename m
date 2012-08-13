Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752859Ab2HMAEZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 20:04:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59823 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752592Ab2HMAEX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 20:04:23 -0400
Message-ID: <5028447E.7000208@gmail.com>
Date: Mon, 13 Aug 2012 10:04:14 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: David Herrmann <dh.herrmann@googlemail.com>
CC: linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 07/11] fblog: allow selecting fbs via sysfs and module-parameters
References: <1344783205-2384-1-git-send-email-dh.herrmann@googlemail.com> <1344783205-2384-8-git-send-email-dh.herrmann@googlemail.com>
In-Reply-To: <1344783205-2384-8-git-send-email-dh.herrmann@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/12 00:53, David Herrmann wrote:
> fblog is mainly useful during boot, reboot, panics and maintenance. In all
> cases you often want to control which monitors are used for console
> output. Moreover, in multi-seat environments it is desireable to reduce
> system-overhead by not drawing the console to all framebuffers. Four
> mechanisms to select framebuffers for fblog are added:
> 
> 1) "active" module parameter: This parameter selects whether fblog has
> access to available framebuffer devices. If it is true, then fblog will
> open devices following the rules described below and rendering will take
> place. If it is false, new hotplugged devices will not be activated and no
> more rendering to currently active devices takes place. However, active
> devices will continue rendering after this is set to true again.
> 
> 2) "active" sysfs attribute for each fblog object. Reading this value
> returns whether a framebuffer is currently active. Writing it opens/closes
> the framebuffer. This allows runtime control which fbs are used. For
> instance, init can set these to 0 after bootup.
> Note that a framebuffer is only active if this is 1 _and_ the "active"
> module parameter is set to "true".
> 
> 3) "activate_on_hotplug" module parameter: This selects whether a device
> is activated by default when hotplugged. This is true by default so new
> devices will be automatically activated.
> 
> 4) "main_only" module parameter: This selects what devices are activated
> on hotplug. This has no effect if "activate_on_hotplug" is false.
> Otherwise, if this is true then only fb0 will be activated on hotplug.
> This is false by default.
> 
> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>
> ---
>  drivers/video/console/fblog.c | 66 ++++++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 65 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
> index 1c526c5..aed77dc 100644
> --- a/drivers/video/console/fblog.c
> +++ b/drivers/video/console/fblog.c
> @@ -44,6 +44,9 @@ struct fblog_fb {
>  
>  static DEFINE_MUTEX(fblog_registration_lock);
>  static struct fblog_fb *fblog_fbs[FB_MAX];
> +static bool active = true;
> +static bool activate_on_hotplug = true;
> +static bool main_only = false;
>  
>  #define to_fblog_dev(_d) container_of(_d, struct fblog_fb, dev)
>  
> @@ -63,6 +66,9 @@ static int fblog_open(struct fblog_fb *fb)
>  {
>  	int ret;
>  
> +	if (!active)
> +		return -EPERM;
> +
>  	mutex_lock(&fb->lock);
>  
>  	if (test_bit(FBLOG_KILLED, &fb->flags)) {
> @@ -115,6 +121,40 @@ static void fblog_close(struct fblog_fb *fb, bool kill_dev)
>  	mutex_unlock(&fb->lock);
>  }
>  
> +static ssize_t fblog_dev_active_show(struct device *dev,
> +				     struct device_attribute *attr,
> +				     char *buf)
> +{
> +	struct fblog_fb *fb = to_fblog_dev(dev);
> +
> +	return snprintf(buf, PAGE_SIZE, "%d\n",
> +			!!test_bit(FBLOG_OPEN, &fb->flags));

Nitpick. sprintf is okay here, %d is rarely longer than PAGE_SIZE :-).

> +}
> +
> +static ssize_t fblog_dev_active_store(struct device *dev,
> +				      struct device_attribute *attr,
> +				      const char *buf,
> +				      size_t count)
> +{
> +	struct fblog_fb *fb = to_fblog_dev(dev);
> +	unsigned long num;
> +	int ret = 0;
> +
> +	num = simple_strtoul(buf, NULL, 10);

kstrtoul is preferred these days I think, it also catches errors.

> +
> +	mutex_lock(&fb->info->lock);
> +	if (num)
> +		ret = fblog_open(fb);
> +	else
> +		fblog_close(fb, false);
> +	mutex_unlock(&fb->info->lock);
> +
> +	return ret ? ret : count;

Nitpick, you can use gcc's shortcut form of the ? operator here:

	return ret ?: count;

> +}
> +
> +static DEVICE_ATTR(active, S_IRUGO | S_IWUSR | S_IWGRP, fblog_dev_active_show,
> +		   fblog_dev_active_store);
> +
>  /*
>   * fblog framebuffer list
>   * The fblog_fbs[] array contains all currently registered framebuffers. If a
> @@ -148,6 +188,7 @@ static void fblog_do_unregister(struct fb_info *info)
>  	fblog_fbs[info->node] = NULL;
>  
>  	fblog_close(fb, true);
> +	device_remove_file(&fb->dev, &dev_attr_active);
>  	device_del(&fb->dev);
>  	put_device(&fb->dev);
>  }
> @@ -156,6 +197,7 @@ static void fblog_do_register(struct fb_info *info, bool force)
>  {
>  	struct fblog_fb *fb;
>  	int ret;
> +	bool do_open = true;
>  
>  	fb = fblog_fbs[info->node];
>  	if (fb && fb->info != info) {
> @@ -186,7 +228,20 @@ static void fblog_do_register(struct fb_info *info, bool force)
>  		return;
>  	}
>  
> -	fblog_open(fb);
> +	ret = device_create_file(&fb->dev, &dev_attr_active);
> +	if (ret) {
> +		pr_err("fblog: cannot create sysfs entry");

Shouldn't need the "fblog: " prefix, since you have pr_fmt defined.

> +		/* do not open fb if we cannot create control file */
> +		do_open = false;
> +	}
> +
> +	if (!activate_on_hotplug)
> +		do_open = false;
> +	if (main_only && info->node != 0)
> +		do_open = false;
> +
> +	if (do_open)
> +		fblog_open(fb);
>  }
>  
>  static void fblog_register(struct fb_info *info, bool force)
> @@ -321,6 +376,15 @@ static void __exit fblog_exit(void)
>  	}
>  }
>  
> +module_param(active, bool, S_IRUGO | S_IWUSR | S_IWGRP);
> +MODULE_PARM_DESC(active, "Activate fblog rendering");
> +
> +module_param(activate_on_hotplug, bool, S_IRUGO | S_IWUSR | S_IWGRP);
> +MODULE_PARM_DESC(activate_on_hotplug, "Activate fblog on hotplugged devices");
> +
> +module_param(main_only, bool, S_IRUGO);
> +MODULE_PARM_DESC(main_only, "Activate fblog by default only on main devices");
> +
>  module_init(fblog_init);
>  module_exit(fblog_exit);
>  MODULE_LICENSE("GPL");
> 

