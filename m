Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647Ab2HNLBv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 07:01:51 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33676 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab2HNLBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 07:01:49 -0400
MIME-Version: 1.0
In-Reply-To: <50284234.40306@gmail.com>
References: <1344783205-2384-1-git-send-email-dh.herrmann@googlemail.com>
	<1344783205-2384-6-git-send-email-dh.herrmann@googlemail.com>
	<50284234.40306@gmail.com>
Date: Tue, 14 Aug 2012 13:01:47 +0200
Message-ID: <CANq1E4QP8PwQRFBr++b3cu1dM9NWf6+Y45rq4UAirjaAHyeM4Q@mail.gmail.com>
Subject: Re: [PATCH 05/11] fblog: register one fblog object per framebuffer
From: David Herrmann <dh.herrmann@googlemail.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: linux-fbdev@vger.kernel.org,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org,
        Geert Uytterhoeven <geert@linux-m68k.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ryan

On Mon, Aug 13, 2012 at 1:54 AM, Ryan Mallon <rmallon@gmail.com> wrote:
> On 13/08/12 00:53, David Herrmann wrote:
>>  drivers/video/console/fblog.c | 195 ++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 195 insertions(+)
>>
>> diff --git a/drivers/video/console/fblog.c b/drivers/video/console/fblog.c
>> index fb39737..279f4d8 100644
>> --- a/drivers/video/console/fblog.c
>> +++ b/drivers/video/console/fblog.c
>> @@ -23,15 +23,210 @@
>>   * all fblog instances before running other graphics applications.
>>   */
>>
>> +#define pr_fmt(_fmt) KBUILD_MODNAME ": " _fmt
>> +
>> +#include <linux/device.h>
>> +#include <linux/fb.h>
>>  #include <linux/module.h>
>> +#include <linux/mutex.h>
>> +
>> +enum fblog_flags {
>> +     FBLOG_KILLED,
>> +};
>> +
>> +struct fblog_fb {
>> +     unsigned long flags;
>
> Are more flags added in later patches? If not, why not just have:
>
>   bool is_killed;
>
> ?

Yes, more are added in patch-6 and patch-8 which includes FBLOG_OPEN,
FBLOG_SUSPENDED, FBLOG_BLANKED.

>> +static void fblog_release(struct device *dev)
>> +{
>> +     struct fblog_fb *fb = to_fblog_dev(dev);
>> +
>> +     kfree(fb);
>> +     module_put(THIS_MODULE);
>> +}
>> +
>> +static void fblog_do_unregister(struct fb_info *info)
>> +{
>> +     struct fblog_fb *fb;
>> +
>> +     fb = fblog_fbs[info->node];
>> +     if (!fb || fb->info != info)
>> +             return;
>> +
>> +     fblog_fbs[info->node] = NULL;
>> +
>> +     device_del(&fb->dev);
>> +     put_device(&fb->dev);
>
> device_unregister?

Right, I will replace it.

>> +}
>> +
>> +static void fblog_do_register(struct fb_info *info, bool force)
>> +{
>> +     struct fblog_fb *fb;
>> +     int ret;
>> +
>> +     fb = fblog_fbs[info->node];
>> +     if (fb && fb->info != info) {
>> +             if (!force)
>> +                     return;
>> +
>> +             fblog_do_unregister(fb->info);
>> +     }
>> +
>> +     fb = kzalloc(sizeof(*fb), GFP_KERNEL);
>> +     if (!fb)
>> +             return;
>> +
>> +     fb->info = info;
>> +     __module_get(THIS_MODULE);
>> +     device_initialize(&fb->dev);
>> +     fb->dev.class = fb_class;
>> +     fb->dev.release = fblog_release;
>> +     dev_set_name(&fb->dev, "fblog%d", info->node);
>> +     fblog_fbs[info->node] = fb;
>> +
>> +     ret = device_add(&fb->dev);
>> +     if (ret) {
>> +             fblog_fbs[info->node] = NULL;
>> +             set_bit(FBLOG_KILLED, &fb->flags);
>> +             put_device(&fb->dev);
>
> kfree(fb); ?

No. See device_initialize() in ./drivers/base/core.c. After a call to
device_initialize() the object is ref-counted so put_device() will
invoke the fblog_release() callback which will call kfree(fb) itself.

>> +             return;
>> +     }
>> +}
>> +
>> +static void fblog_register(struct fb_info *info, bool force)
>> +{
>> +     mutex_lock(&fblog_registration_lock);
>> +     fblog_do_register(info, force);
>> +     mutex_unlock(&fblog_registration_lock);
>> +}
>> +
>> +static void fblog_unregister(struct fb_info *info)
>> +{
>> +     mutex_lock(&fblog_registration_lock);
>> +     fblog_do_unregister(info);
>> +     mutex_unlock(&fblog_registration_lock);
>> +}
>
> This locking is needlessly heavy, and could easily pushed down into the
> fb_do_(un)register functions. It would also help make it clear exactly
> what the lock is protecting.

I need to call fblog_do_unregister() from within fblog_do_register().
I cannot release the locks while calling fblog_do_unregister() so I
need the unlocked fblog_do_unregister() function. So the locking must
be in a wrapper function.

See below for an explanation of the locks.

>> +static int fblog_event(struct notifier_block *self, unsigned long action,
>> +                    void *data)
>> +{
>> +     struct fb_event *event = data;
>> +     struct fb_info *info = event->info;
>> +
>> +     switch(action) {
>> +     case FB_EVENT_FB_REGISTERED:
>> +             /* This is called when a low-level system driver registers a new
>> +              * framebuffer. The registration lock is held but the console
>> +              * lock might not be held when this is called. */
>
> Nitpick:
>
>   /*
>    * The Linux kernel multi-line
>    * comment style looks like
>    * this.
>    */

I was confused by a recent discussion on the LKML:
http://comments.gmane.org/gmane.linux.kernel/1282421
However, turns out they didn't add this to CodingStyle so I will adopt
the old style again. Will be fixed in the next revision, thanks.

>> +             fblog_register(info, true);
>> +             break;
>> +     case FB_EVENT_FB_UNREGISTERED:
>> +             /* This is called when a low-level system driver unregisters a
>> +              * framebuffer. The registration lock is held but the console
>> +              * lock might not be held. */
>> +             fblog_unregister(info);
>> +             break;
>> +     }
>> +
>> +     return 0;
>> +}
>> +
>> +static void fblog_scan(void)
>> +{
>> +     unsigned int i;
>> +     struct fb_info *info, *tmp;
>> +
>> +     for (i = 0; i < FB_MAX; ++i) {
>> +             info = get_fb_info(i);
>> +             if (!info || IS_ERR(info))
>
> Nitpick:
>
>   if (IS_ERR_OR_NULL(info))

Didn't know of this macro, thanks.

>> +                     continue;
>> +
>> +             fblog_register(info, false);
>
> This function should really return a value to indicate if it failed.
> There is no point continuing if it didn't register anything.

Indeed.

>> +             /* There is a very subtle race-condition. Even though we might
>> +              * own a reference to the fb, it may still get unregistered
>> +              * between our call from get_fb_info() and fblog_register().
>> +              * Therefore, we simply check whether the same fb still is
>> +              * registered by calling get_fb_info() again. Only if they
>> +              * differ we know that it got unregistered, therefore, we
>> +              * call fblog_unregister() with the old pointer. */
>> +
>> +             tmp = get_fb_info(i);
>> +             if (tmp && !IS_ERR(tmp))
>> +                     put_fb_info(tmp);
>> +             if (tmp != info)
>> +                     fblog_unregister(info);
>
> It would be better to fix this issue properly. Calling fblog_unregister
> here also looks unsafe if the call to fblog_register above failed.

fblog_unregister() does nothing if the passed "info" does not match
the found "info" so this is safe. And as we are holding a reference to
"info" here, the pointer is always valid and cannot be used by other
FBs.

Fixing this properly means changing the locking of fbdev. This can
either be done by exporting the fbdev-registration-lock (which I want
to avoid as locking should never be exported in an API) or by changing
fbdev to provide an scan/enumeration function itself. However, in my
opinion both would be uglier than using this race-condition-check
here.

The best way would be redesigning the fbdev in-kernel API. But that
means checking that fbcon will not break and this is something I
really don't want to touch.

>> +             /* Here we either called fblog_unregister() and therefore do not
>> +              * need any reference to the fb, or we can be sure that the FB
>> +              * is registered and FB_EVENT_FB_UNREGISTERED will be called
>> +              * before the last reference is dropped. Hence, we can drop our
>> +              * reference here. */
>
> This seems a slightly odd reasoning. Why would you not hold a reference
> to something you are using?

It's because get_fb_info() takes the fbdev-registration-lock so we
cannot call it from fblog_event(). And fblog_event() calls
fblog_register() for hotplugged framebuffers so we cannot get a refcnt
for hotplugged framebuffers.
Now I can either increase the fbdev-refcount manually without calling
get_fb_info() in fblog_register() or I can simply drop the framebuffer
when the fbdev-core notifies me that it is gone. I chose the latter
one.

>> +             put_fb_info(info);
>> +     }
>> +}
>> +
>> +static struct notifier_block fblog_notifier = {
>> +     .notifier_call = fblog_event,
>> +};
>>
>>  static int __init fblog_init(void)
>>  {
>> +     int ret;
>> +
>> +     ret = fb_register_client(&fblog_notifier);
>> +     if (ret) {
>> +             pr_err("cannot register framebuffer notifier\n");
>> +             return ret;
>> +     }
>> +
>> +     fblog_scan();
>> +
>>       return 0;
>>  }
>>
>>  static void __exit fblog_exit(void)
>>  {
>> +     unsigned int i;
>> +     struct fb_info *info;
>> +
>> +     fb_unregister_client(&fblog_notifier);
>> +
>> +     /* We scan through the whole registered_fb array here instead of
>> +      * fblog_fbs because we need to get the device lock _before_ the
>> +      * fblog-registration-lock. */
>> +
>> +     for (i = 0; i < FB_MAX; ++i) {
>> +             info = get_fb_info(i);
>> +             if (!info || IS_ERR(info))
>> +                     continue;
>> +
>> +             fblog_unregister(info);
>
> Given the description of the get_fb_info/fblog_register race above, can
> this unregister the wrong framebuffer?

No. fblog_unregister() will do nothing if the "info" pointers do not
match. Moreover, this unregisters _all_ framebuffers, so I don't
understand how this can unregister the "wrong" framebuffer?

But I just noticed a race here. If the fbdev core unregisters a
framebuffer during my loop, I will not call fblog_unregister() on it,
as it does not exist anymore. Therefore, I will not free it in my
fblog_fbs array as the fblog_notifier has already been unregistered.
So I need to set a global "exiting" flag and fblog_event() shall only
handle the UNBIND/UNREGISTER events during exit. Then I simply move
the fb_unregister_client() call below this loop.

>> +             put_fb_info(info);
>> +     }
>>  }
>>
>>  module_init(fblog_init);
>>
>

A short explanation for all locks:
First of all, I spent hours getting this right. The easy way would be
removing all locks and relying on the fbdev locking (fbcon does this).
But obviously, that doesn't work as fbdev has no safe way of
scanning/enumerating all existing devices. And this is needed as fblog
can be compiled as a module.
fbdev has a core registration-lock and each framebuffer has its own
fb-lock. fblog_event() is sometimes called with these locks held,
sometimes without any locks held (see the comments in this function)
and I need to work around this.
So fblog_event() as entry point for hotplugging is called with the
fbdev-registration-lock held. And it calls fblog_(un)register() which
uses its own locks. So when calling this from fblog_scan(), I need to
make sure to guarantee that the locks are acquired in the same order
as in fblog_event(), otherwise I might have deadlocks. But I have no
outside access to the fbdev-registration-lock, therefore, the
fblog-registration-lock is needed and fblog_scan() needs to check for
those ugly races.

As you mentioned that this locking is needlessly complex, I have to
disagree. I use one lock to protect the registration
(fblog_registration_lock) and one lock to protect each registered
framebuffer from concurrent access (struct fblog_fb->lock). This is
the most common way to protect hotplugged devices and I don't see how
this can be done with less locks? (these are the only locks that are
added by fblog).
Normally, this would be all locks I have to access. However, the
fbdev-core wasn't designed as in-kernel API and thus has very
inconsistent locking. And all entry points to fblog that are not
through fbdev-notifier-callbacks (eg, fblog_scan) need to make sure to
acquire the same locks as the fbdev-core to avoid races with the
fbdev-core. As this is not possible, because the fbdev-locks are not
exported, I need to carefully use fbdev-functions that guarantee that
I have no races. And I think I found the only way to guarantee this.
If anyone has other ideas, I would be glad to hear them.

Thanks for reviewing the code!
Regards
David
