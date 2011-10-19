Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752086Ab1JSBHP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 21:07:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:44648 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751397Ab1JSBHN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 21:07:13 -0400
MIME-Version: 1.0
In-Reply-To: <20111018182958.GS20828@google.com>
References: <1318896400-32498-1-git-send-email-msb@chromium.org>
	<CABqxG0eKhaGUMvdNMOdahnqdYiT8i+3Hhf8vbQyq8TEJUOU0Lg@mail.gmail.com>
	<CABqxG0cP8Vc1FiAoOSB7cWdJyS=c0eFx1Hj6nY9GY=uTL_EgHg@mail.gmail.com>
	<20111018182958.GS20828@google.com>
Date: Wed, 19 Oct 2011 09:07:12 +0800
Message-ID: <CABqxG0ekuqGDiFRsE9p1J2FubWo3J+SufwuUC=56JCSF3dVoTA@mail.gmail.com>
Subject: Re: [PATCH] drm: avoid switching to text console if there is no panic timeout
From: Dave Young <hidave.darkstar@gmail.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        Hugh Dickins <hughd@chromium.org>, Hugh Dickins <hughd@google.com>,
        Dave Airlie <airlied@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, marcheu@chromium.org,
        rientjes@google.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 19, 2011 at 2:29 AM, Mandeep Singh Baines <msb@chromium.org> wrote:
> Dave Young (hidave.darkstar@gmail.com) wrote:
>> On Tue, Oct 18, 2011 at 10:19 AM, Dave Young <hidave.darkstar@gmail.com> wrote:
>> > On Tue, Oct 18, 2011 at 8:06 AM, Mandeep Singh Baines <msb@chromium.org> wrote:
>> >> From: Hugh Dickins <hughd@chromium.org>
>> >>
>> >> Add a check for panic_timeout in the drm_fb_helper_panic() notifier: if
>> >> we're going to reboot immediately, the user will not be able to see the
>> >> messages anyway, and messing with the video mode may display artifacts,
>> >> and certainly get into several layers of complexity (including mutexes and
>> >> memory allocations) which we shall be much safer to avoid.
>> >
>> > There's one exception is use printk_delay
>>
>> OTOH the complexity do exist also when timeout is set, IMHO it is worth
>>
>
> Hi Dave,
>
> I agree. The complexity is worth it if you want to see the panic trace
> on the VT. But if you have the panic_timeout negative (i.e. reboot
> immediately) than you're just add more risk/complexity to panic for no
> benefit.
>
>
> To avoid losing the panic traces, a reliable panic is critical.
>
> In our app, we use panic_timeout=-1 and we use ramoops for capturing panic
> traces. We want the panic path to be as simple as possible to avoid
> wedging machines and to avoid losing panic traces. In our test lab,
> if a machine gets wedged, a human needs to go and power cycle the machine
> to bring it back online.
>
> For user devices, we want to panic quickly and get the device back up
> ASAP. Our reboot time is under 8 seconds so its less than 10 seconds before
> you're back online and surfing the web. We also want to avoid displaying any
> artifacts or traces to the user when panicking.
>
> You bring up a good point about printk_delay. But I'm thinking if you're
> using prink_delay you'd also want to set panic_timeout >= 0. Otherwise,
> you'd reboot immediately after displaying the last line of output.

fair enough, thanks.

>
> Regards,
> Mandeep
>
>> >
>> >>
>> >> Signed-off-by: Hugh Dickins <hughd@google.com>
>> >> [ Edited commit message and modified to short-circuit panic_timeout < 0
>> >>  instead of testing panic_timeout >= 0.  -Mandeep ]
>> >> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
>> >> Cc: Dave Airlie <airlied@redhat.com>
>> >> Cc: Andrew Morton <akpm@linux-foundation.org>
>> >> Cc: dri-devel@lists.freedesktop.org
>> >> ---
>> >>  drivers/gpu/drm/drm_fb_helper.c |    7 +++++++
>> >>  1 files changed, 7 insertions(+), 0 deletions(-)
>> >>
>> >> diff --git a/drivers/gpu/drm/drm_fb_helper.c b/drivers/gpu/drm/drm_fb_helper.c
>> >> index f7c6854..0e62c93 100644
>> >> --- a/drivers/gpu/drm/drm_fb_helper.c
>> >> +++ b/drivers/gpu/drm/drm_fb_helper.c
>> >> @@ -254,6 +254,13 @@ bool drm_fb_helper_force_kernel_mode(void)
>> >>  int drm_fb_helper_panic(struct notifier_block *n, unsigned long ununsed,
>> >>                        void *panic_str)
>> >>  {
>> >> +       /*
>> >> +        * It's a waste of time and effort to switch back to text console
>> >> +        * if the kernel should reboot before panic messages can be seen.
>> >> +        */
>> >> +       if (panic_timeout < 0)
>> >> +               return 0;
>> >> +
>> >>        printk(KERN_ERR "panic occurred, switching back to text console\n");
>> >>        return drm_fb_helper_force_kernel_mode();
>> >>  }
>> >> --
>> >> 1.7.3.1
>> >>
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> >> the body of a message to majordomo@vger.kernel.org
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >> Please read the FAQ at  http://www.tux.org/lkml/
>> >>
>> >
>> >
>> >
>> > --
>> > Regards
>> > Dave
>> >
>>
>>
>>
>> --
>> Regards
>> Dave
>



-- 
Regards
Dave
