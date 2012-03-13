Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab2CMUKt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 16:10:49 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43029 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752571Ab2CMUKr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 16:10:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Saravana Kannan <skannan@codeaurora.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper is not yet available
Date: Tue, 13 Mar 2012 21:14:57 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Kay Sievers <kay.sievers@vrfy.org>, Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>
References: <201203032122.36745.chunkeey@googlemail.com> <CAPXgP10oHRnPo7Es1RX8GM68dH13E0rzcFhXzOYFPcmKs=yh1A@mail.gmail.com> <4F5F16D9.3080607@codeaurora.org>
In-Reply-To: <4F5F16D9.3080607@codeaurora.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203132114.57828.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, March 13, 2012, Saravana Kannan wrote:
> On 01/-10/37 11:59, Kay Sievers wrote:
> > On Sat, Mar 10, 2012 at 00:36, Greg KH<gregkh@linuxfoundation.org>  wrote:
> >> On Fri, Mar 09, 2012 at 11:30:24PM +0100, Christian Lamparter wrote:
> >>> This patch fixes a regression which was introduced by:
> >>> "PM: Print a warning if firmware is requested when tasks are frozen"
> >>>
> >>> request_firmware_nowait does not stall in any system resume paths.
> >>> Therefore, I think it is perfectly save to use request_firmware_nowait
> >>> from at least the ->complete() callback.
> >>
> >> Is there code somewhere in the kernel that wants to do this?  Has commit
> >> a144c6a broken it somehow that this fix would resolve it?
> >>
> >>>
> >>> Signed-off-by: Christian Lamparter<chunkeey@googlemail.com>
> >>> ---
> >>>   drivers/base/firmware_class.c |    2 +-
> >>>   1 files changed, 1 insertions(+), 1 deletions(-)
> >>>
> >>> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> >>> index 6c9387d..017e020 100644
> >>> --- a/drivers/base/firmware_class.c
> >>> +++ b/drivers/base/firmware_class.c
> >>> @@ -535,7 +535,7 @@ static int _request_firmware(const struct firmware **firmware_p,
> >>>
> >>>        read_lock_usermodehelper();
> >>>
> >>> -     if (WARN_ON(usermodehelper_is_disabled())) {
> >>> +     if (WARN_ON(usermodehelper_is_disabled()&&  !(nowait&&  uevent))) {
> >>
> >> What does uevent have to do with things here?
> >
> > I don't think that the firmware loader should care about the
> > usermodehelper at all, and that stuff fiddling should just be removed
> > from the firmware class.
> >
> > Forking /sbin/hotplug is disabled by default, it is a broken concept,
> > and it cannot work reliably on today's systems.
> >
> > Firmware is not loaded by /sbin/hotplug since many years, but by udev
> > or whatever service handles uevents, like ueventd on android.
> >
> 
> Resending again after fixing my stupid email formatting.
> 
> We (mach-msm) just happened to be looking at similar issues with 
> request_firmware. The recent changes to request_firmware to check for 
> usermodehelper_is_disabled() was preventing us from using 
> request_firmware() in what I think is a valid use case. I will get to 
> that later.
> 
> To first suggest a solution specific the problem this patch is trying to 
> address, I think it would be better to do something like below. It's 
> just a quick RFC to show what I mean -- haven't even compiled it. If 
> there is an agreement on this suggestion, I can send out a cleaner patch.
> 
> firmware class: Check for usermode helper availability only
>   when enabled.
> 
> Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
> ---
>   drivers/base/firmware_class.c |   15 ++++++++-------
>   kernel/kmod.c                 |    2 +-
>   2 files changed, 9 insertions(+), 8 deletions(-)
> 
> diff --git a/drivers/base/firmware_class.c b/drivers/base/firmware_class.c
> index 06ed6b4..2a45bf7 100644
> --- a/drivers/base/firmware_class.c
> +++ b/drivers/base/firmware_class.c
> @@ -534,12 +534,6 @@ static int _request_firmware(const struct firmware 
> **firmware_p,
>                  return 0;
>          }
> 
> -       if (WARN_ON(usermodehelper_is_disabled())) {
> -               dev_err(device, "firmware: %s will not be loaded\n", name);
> -               retval = -EBUSY;
> -               goto out;
> -       }
> -
>          if (uevent)
>                  dev_dbg(device, "firmware: requesting %s\n", name);
> 
> @@ -555,12 +549,19 @@ static int _request_firmware(const struct firmware 
> **firmware_p,
>                                    round_jiffies_up(jiffies +
>                                                     loading_timeout * HZ));
> 
> -               kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
> +               retval = kobject_uevent(&fw_priv->dev.kobj, KOBJ_ADD);
> +               if (retval) {
> +                       dev_err(device, "firmware: %s will not be 
> loaded\n", name);
> +                       set_bit(FW_STATUS_ABORT, &fw_priv->status);
> +                       goto abort;
> +               }
>          }
> 
>          wait_for_completion(&fw_priv->completion);
> 
>          set_bit(FW_STATUS_DONE, &fw_priv->status);
> +
> +abort:
>          del_timer_sync(&fw_priv->timeout);
> 
>          mutex_lock(&fw_lock);
> 
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 47613df..e733afe3 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -422,7 +422,7 @@ int call_usermodehelper_exec(struct subprocess_info 
> *sub_info,
>          if (sub_info->path[0] == '\0')
>                  goto out;
> 
> -       if (!khelper_wq || usermodehelper_disabled) {
> +       if (!khelper_wq || (uevent_helper[0] && usermodehelper_disabled)) {
>                  retval = -EBUSY;
>                  goto out;
>          }
> 
> Now, getting to the issue we are facing -- the recent checks for 
> usermode helper in request_firmare() is failing request_firmware() in a 
> kthread that also activates a wake up source (or if you are familiar 
> with Android terms -- grabs a wake lock). By activating a wakeup source, 
> the kthread is properly indicating that a suspend shouldn't happen. So, 
> I think it's a valid use case for request_firmware().

It isn't really, although it may seems so.  In the mainline there is no
guarantee that system suspend will be aborted when you activate a wakeup
source (the suspend process may choose to ignore wakeup sources).

> With the current checks, that doesn't seem to be sufficient since a 
> kthread can coincidentally be running in parallel to the suspend 
> sequence. The suspend sequence sets "usermodehelper_disabled" for the 
> purpose of causing request_firmware() to fail immediately when called 
> from the suspend ops.

No, it doesn't do that for this purpose.  It does that to prevent a race
between usermode helpers and the freezer from happening.  The failing of
request_firmware() when called during system suspend/resume is a consequence
of that, not the reason why it is done.

> But that doesn't take into account that the kthread could also be running at
> the same time.

Yes, it does.  User space is frozen and your kthread can't possibly use a
usermode helper at that time.

> If this check wasn't there, the suspend would be aborted (since the kthread
> has activated the wakeup source) and the request_firmware() would have
> succeeded.

It would have succeeded _eventually_, after user space had been thawed.

> I think the usermodehelper check in the request_firmware() flow is 
> denying a wider swath of scenarios than it needs to. I think the real 
> check should be to only disallow request_firmware() in all of the 
> callbacks that are called from suspend_enter().
> 
> I was joking to my colleague (Stephen Boyd) about just walking up the 
> stack to see if suspend_enter() is in the stack, but he seems to have 
> ideas that would have a similar effect on the functionality without 
> being insane code. I will leave it to him to present his ideas.
> 
> But while we are trying to figure out ways to immediately error out 
> request_firmware() from suspend callbacks, I think we should remove the 
> usermodehelper check in request_firmware() since it's actually 
> preventing legitimate use cases.

All of those use cases are in fact of the "wait for user space to be thawed
and then load the firmware" type, which I believe may be handled without
changing that code.

Why don't you make your kthread freezable, for one example?

Why don't you use a freezable workqueue instead?

Rafael
