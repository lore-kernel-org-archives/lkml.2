Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755091Ab0CXJ2W (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 05:28:22 -0400
Received: from poutre.nerim.net ([62.4.16.124]:50557 "EHLO poutre.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754874Ab0CXJ2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 05:28:21 -0400
Date: Wed, 24 Mar 2010 10:28:16 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Giel van Schijndel <me@mortis.eu>
Cc: Hans de Goede <hdegoede@redhat.com>, Jonathan Cameron <jic23@cam.ac.uk>,
       Laurens Leemans <laurens@signips.com>, lm-sensors@lm-sensors.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: f71882fg: properly acquire I/O regions while 
 probing
Message-ID: <20100324102816.36d70c18@hyperion.delvare>
In-Reply-To: <20100324084643.GB6368@salidar.me.mortis.eu>
References: <1269353535-23134-1-git-send-email-me@mortis.eu>
	<4BA9C9D6.4020903@redhat.com>
	<20100324084643.GB6368@salidar.me.mortis.eu>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Giel,

On Wed, 24 Mar 2010 09:46:43 +0100, Giel van Schijndel wrote:
> On Wed, Mar 24, 2010 at 09:14:14AM +0100, Hans de Goede wrote:
> > I don't have any objections against the proposed changes, but there
> > are 3 unrelated changes in this patch, please break them up in
> > separate patches:
> > 
> > 1) code cleanup: properly using, previously defined, functions rather
> >    than duplicating their code.
> > 2) properly acquire I/O regions while probing
> > 3) Make the addresses to probe an array
> > 
> > And IMHO you might just as well drop number 3, it does not really make
> > the code any better readable, and the old way is how all superio hwmon
> > drivers do things.
> 
> Okay, broken up patches will follow as replies to this message.
> 
> Regarding number (3), my goal wasn't to put the probe addresses in an
> array. My goal (as I think should have been made clear by the commit
> message I had added) was to make sure that upon failure f71882fg_find's
> return value gets passed back from the module's init function. This to
> make sure the *proper* error code gets passed back to the user of
> insmod/modprobe (as opposed to it being replaced by -ENODEV).

This doesn't make much sense. We call f71882fg_find up to twice, so we
can get up to 2 error codes, but the module init function can only
return one. There is no rationale for favoring the value returned by
the second call over the value returned by the first call. So it seems
reasonable to return an arbitrary error code. Of course we could spend
code comparing the error values and returning the right one if the two
functions returned the same error value, and only use the arbitrary
default if they returned different values. But honestly I don't see any
point in doing this in practice. Let's just log errors other than
-ENODEV so that the user can see the exact cause of failure in the
kernel log.

> Further I think non -ENODEV errors should probably immediately result in
> module initialisation failing (rather than retrying a probe), that's a
> design choice though (which my patch doesn't bother addressing right
> now).

I disagree. If the probe of 0x2e/0x2f fails because that region was busy,
this should not prevent us from giving a try to region 0x4e/0x4f. I
can't think of any error that would warrant avoiding the probe at
0x4e/0x4f. Worse thing that can happen is that the second probe fails
too. No big deal.

> However, regarding the for-loop/array thing, the same behaviour can be
> aqcuired with a patch like the one following this line. (Please tell me
> if you like this approach or something similar better. Though,
> personally, I think it's "hackisher"/dirtier).
> 
> diff --git a/drivers/hwmon/f71882fg.c b/drivers/hwmon/f71882fg.c
> index 4230729..42d6304 100644
> --- a/drivers/hwmon/f71882fg.c
> +++ b/drivers/hwmon/f71882fg.c
> @@ -2295,9 +2295,11 @@ static int __init f71882fg_init(void)
>  
>         memset(&sio_data, 0, sizeof(sio_data));
>  
> -       if (f71882fg_find(0x2e, &address, &sio_data) &&
> -           f71882fg_find(0x4e, &address, &sio_data))
> -               goto exit;
> +       if (f71882fg_find(0x2e, &address, &sio_data)) {
> +               err = f71882fg_find(0x4e, &address, &sio_data);
> +               if (err)
> +                       goto exit;
> +       }
>  
>         err = platform_driver_register(&f71882fg_driver);
>         if (err)
> 

I don't like either implementation, I would leave the code as it is
today.

-- 
Jean Delvare
