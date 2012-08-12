Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816Ab2HLXzC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Aug 2012 19:55:02 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40423 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495Ab2HLXyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Aug 2012 19:54:36 -0400
Message-ID: <50284234.40306@gmail.com>
Date: Mon, 13 Aug 2012 09:54:28 +1000
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
Subject: Re: [PATCH 05/11] fblog: register one fblog object per framebuffer
References: <1344783205-2384-1-git-send-email-dh.herrmann@googlemail.com> <1344783205-2384-6-git-send-email-dh.herrmann@googlemail.com>
In-Reply-To: <1344783205-2384-6-git-send-email-dh.herrmann@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/08/12 00:53, David Herrmann wrote:
> One fblog object is associated to each registered framebuffer. This way,
> we can draw the console to each framebuffer. When a framebuffer driver
> unregisters a framebuffer, we also unregister our fblog object. That is,
> our lifetime is coupled to the lifetime of the framebuffer. However, this
> does not mean that we are always active. On the contrary, we do not even
> own a reference to the framebuffer. We don't need it as we are notified
> _before_ the last reference is dropped.
> 
> However, if other users have a reference to our object, we simply mark it
> as dead when the associated framebuffer dies and leave it alone. When the
> last reference is dropped, it will be automatically freed.
> 
> Signed-off-by: David Herrmann <dh.herrmann@googlemail.com>

Hi David,

Quick review below.

Thanks,
~Ryan

> ---
>  drivers/video/console/fblog.c | 195 ++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 195 insertions(+)
> 
> diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
> index fb39737..279f4d8 100644
> --- a/drivers/video/console/fblog.c
> +++ b/drivers/video/console/fblog.c
> @@ -23,15 +23,210 @@
>   * all fblog instances before running other graphics applications.
>   */
>  
> +#define pr_fmt(_fmt) KBUILD_MODNAME ": " _fmt
> +
> +#include <linux/device.h>
> +#include <linux/fb.h>
>  #include <linux/module.h>
> +#include <linux/mutex.h>
> +
> +enum fblog_flags {
> +	FBLOG_KILLED,
> +};
> +
> +struct fblog_fb {
> +	unsigned long flags;

Are more flags added in later patches? If not, why not just have:

  bool is_killed;

?

> +	struct fb_info *info;
> +	struct device dev;
> +};
> +
> +static DEFINE_MUTEX(fblog_registration_lock);
> +static struct fblog_fb *fblog_fbs[FB_MAX];
> +
> +#define to_fblog_dev(_d) container_of(_d, struct fblog_fb, dev)
> +
> +/*
> + * fblog framebuffer list
> + * The fblog_fbs[] array contains all currently registered framebuffers. If a
> + * framebuffer is in that list, we always must make sure that we own a reference
> + * to it. If it is added through the notifier callbacks, then this is always
> + * guaranteed.
> + * We are only interested in registered framebuffers. That is, if a driver calls
> + * unregister_framebuffer() we directly unlink it from our list. This guarantees
> + * that the associated fb_info is always valid. However, we might still have
> + * pending users so we mark it as dead so no further framebuffer actions are
> + * done. If the last user then drops a reference, the memory gets freed
> + * automatically.
> + */
> +
> +static void fblog_release(struct device *dev)
> +{
> +	struct fblog_fb *fb = to_fblog_dev(dev);
> +
> +	kfree(fb);
> +	module_put(THIS_MODULE);
> +}
> +
> +static void fblog_do_unregister(struct fb_info *info)
> +{
> +	struct fblog_fb *fb;
> +
> +	fb = fblog_fbs[info->node];
> +	if (!fb || fb->info != info)
> +		return;
> +
> +	fblog_fbs[info->node] = NULL;
> +
> +	device_del(&fb->dev);
> +	put_device(&fb->dev);

device_unregister?

> +}
> +
> +static void fblog_do_register(struct fb_info *info, bool force)
> +{
> +	struct fblog_fb *fb;
> +	int ret;
> +
> +	fb = fblog_fbs[info->node];
> +	if (fb && fb->info != info) {
> +		if (!force)
> +			return;
> +
> +		fblog_do_unregister(fb->info);
> +	}
> +
> +	fb = kzalloc(sizeof(*fb), GFP_KERNEL);
> +	if (!fb)
> +		return;
> +
> +	fb->info = info;
> +	__module_get(THIS_MODULE);
> +	device_initialize(&fb->dev);
> +	fb->dev.class = fb_class;
> +	fb->dev.release = fblog_release;
> +	dev_set_name(&fb->dev, "fblog%d", info->node);
> +	fblog_fbs[info->node] = fb;
> +
> +	ret = device_add(&fb->dev);
> +	if (ret) {
> +		fblog_fbs[info->node] = NULL;
> +		set_bit(FBLOG_KILLED, &fb->flags);
> +		put_device(&fb->dev);

kfree(fb); ?

> +		return;
> +	}
> +}
> +
> +static void fblog_register(struct fb_info *info, bool force)
> +{
> +	mutex_lock(&fblog_registration_lock);
> +	fblog_do_register(info, force);
> +	mutex_unlock(&fblog_registration_lock);
> +}
> +
> +static void fblog_unregister(struct fb_info *info)
> +{
> +	mutex_lock(&fblog_registration_lock);
> +	fblog_do_unregister(info);
> +	mutex_unlock(&fblog_registration_lock);
> +}

This locking is needlessly heavy, and could easily pushed down into the
fb_do_(un)register functions. It would also help make it clear exactly
what the lock is protecting.

> +static int fblog_event(struct notifier_block *self, unsigned long action,
> +		       void *data)
> +{
> +	struct fb_event *event = data;
> +	struct fb_info *info = event->info;
> +
> +	switch(action) {
> +	case FB_EVENT_FB_REGISTERED:
> +		/* This is called when a low-level system driver registers a new
> +		 * framebuffer. The registration lock is held but the console
> +		 * lock might not be held when this is called. */

Nitpick:

  /*
   * The Linux kernel multi-line
   * comment style looks like
   * this.
   */

> +		fblog_register(info, true);
> +		break;
> +	case FB_EVENT_FB_UNREGISTERED:
> +		/* This is called when a low-level system driver unregisters a
> +		 * framebuffer. The registration lock is held but the console
> +		 * lock might not be held. */
> +		fblog_unregister(info);
> +		break;
> +	}
> +
> +	return 0;
> +}
> +
> +static void fblog_scan(void)
> +{
> +	unsigned int i;
> +	struct fb_info *info, *tmp;
> +
> +	for (i = 0; i < FB_MAX; ++i) {
> +		info = get_fb_info(i);
> +		if (!info || IS_ERR(info))

Nitpick:

  if (IS_ERR_OR_NULL(info))

> +			continue;
> +
> +		fblog_register(info, false);

This function should really return a value to indicate if it failed.
There is no point continuing if it didn't register anything.

> +		/* There is a very subtle race-condition. Even though we might
> +		 * own a reference to the fb, it may still get unregistered
> +		 * between our call from get_fb_info() and fblog_register().
> +		 * Therefore, we simply check whether the same fb still is
> +		 * registered by calling get_fb_info() again. Only if they
> +		 * differ we know that it got unregistered, therefore, we
> +		 * call fblog_unregister() with the old pointer. */
> +
> +		tmp = get_fb_info(i);
> +		if (tmp && !IS_ERR(tmp))
> +			put_fb_info(tmp);
> +		if (tmp != info)
> +			fblog_unregister(info);

It would be better to fix this issue properly. Calling fblog_unregister
here also looks unsafe if the call to fblog_register above failed.

> +		/* Here we either called fblog_unregister() and therefore do not
> +		 * need any reference to the fb, or we can be sure that the FB
> +		 * is registered and FB_EVENT_FB_UNREGISTERED will be called
> +		 * before the last reference is dropped. Hence, we can drop our
> +		 * reference here. */

This seems a slightly odd reasoning. Why would you not hold a reference
to something you are using?

> +		put_fb_info(info);
> +	}
> +}
> +
> +static struct notifier_block fblog_notifier = {
> +	.notifier_call = fblog_event,
> +};
>  
>  static int __init fblog_init(void)
>  {
> +	int ret;
> +
> +	ret = fb_register_client(&fblog_notifier);
> +	if (ret) {
> +		pr_err("cannot register framebuffer notifier\n");
> +		return ret;
> +	}
> +
> +	fblog_scan();
> +
>  	return 0;
>  }
>  
>  static void __exit fblog_exit(void)
>  {
> +	unsigned int i;
> +	struct fb_info *info;
> +
> +	fb_unregister_client(&fblog_notifier);
> +
> +	/* We scan through the whole registered_fb array here instead of
> +	 * fblog_fbs because we need to get the device lock _before_ the
> +	 * fblog-registration-lock. */
> +
> +	for (i = 0; i < FB_MAX; ++i) {
> +		info = get_fb_info(i);
> +		if (!info || IS_ERR(info))
> +			continue;
> +
> +		fblog_unregister(info);

Given the description of the get_fb_info/fblog_register race above, can
this unregister the wrong framebuffer?

> +		put_fb_info(info);
> +	}
>  }
>  
>  module_init(fblog_init);
> 

