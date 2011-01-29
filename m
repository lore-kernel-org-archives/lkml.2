Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab1A2C7i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 21:59:38 -0500
Received: from mx3.gwdg.de ([134.76.10.16]:50253 "EHLO mx3.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752063Ab1A2C7h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 21:59:37 -0500
X-IronPort-Reputation-Score: None
X-IronPort-AV: E=McAfee;i="5400,1158,6240"; a="22494372"
X-IronPort-AV: E=Sophos;i="4.60,395,1291590000"; 
   d="scan'208";a="22494372"
In-Reply-To: <alpine.LSU.2.00.1101281347200.1759@sister.anvils>
References: <20110123011221.GB1805@nowhere> <1295780472-8475-1-git-send-email-chris@chris-wilson.co.uk> <20110123175945.GA1760@nowhere> <alpine.LSU.2.00.1101232246380.3691@sister.anvils> <849307$b9dvii@azsmga001.ch.intel.com> <alpine.LSU.2.00.1101281347200.1759@sister.anvils>
Mime-Version: 1.0 (Apple Message framework v753.1)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <EB643972-4918-4B89-B325-59D03648F2F9@tuebingen.mpg.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Olsa <jolsa@redhat.com>, Chris Clayton <chris2553@googlemail.com>,
        Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Content-Transfer-Encoding: 7bit
From: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Subject: Re: [PATCH] drm/i915,agp/intel: Do not clear stolen entries
Date: Sat, 29 Jan 2011 03:59:38 +0100
To: Hugh Dickins <hughd@google.com>
X-Mailer: Apple Mail (2.753.1)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jan 28, 2011, at 11:00 PM, Hugh Dickins wrote:

> Sorry, this is now abount vblank or scanout rather than stolen  
> entries.
>
> On Mon, 24 Jan 2011, Chris Wilson wrote:
>> On Sun, 23 Jan 2011 23:40:41 -0800 (PST), Hugh Dickins  
>> <hughd@google.com> wrote:
>>
>>> On this laptop I'm typing from (GM965 with KMS), I've had no trouble
>>> getting X up; but when typing in one of the xterms, typed characters
>>> often stop echoing, until I shift to a different window, whereupon
>>> they appear.  This condition cleared (for a while) by switching to
>>> VESA fb console and back; no such problem observed on that console.
>>>
>>> Does that sound familiar?  I have no evidence whatever that i915 is
>>> to blame here.  Several times I tried bisecting last week, but each
>>> attempt ended up in a nonsensical place, because the effect does not
>>> occur to order.  So I'd sometimes mark a bisection point as good  
>>> when
>>> I guess it must actually have been bad.  Perhaps it's a matter of
>>> timing or an uninitialized variable.  But while I'm here, worth  
>>> asking
>>> if that behaviour sounds like anything you might be responsible for?
>>
>> Sounds suspiciously like the batch buffer is not being dispatched and
>> flushed to the scanout. A very similar bug was recently fixed for
>> xf86-video-intel 2.14.0 which was causing deferred output.
>
> I made a more patient bisection during the week, on x86_64 which
> seemed more consistent than i386, and this time it converged sensibly:
> to commit 0af7e4dff50454905092d468e91c1ef92e10e6b4
> drm/i915: Add support for precise vblank timestamping (v2)
>
> Which kindly notes in its commit message:
>     This code has been only tested on a HP-Mini Netbook with
>     Atom processor and Intel 945GME gpu. The codepath for
>     (IS_G4X(dev) || IS_GEN5(dev) || IS_GEN6(dev)) gpu's
>     has not been tested so far due to lack of hardware.
> so not surprising that it doesn't work on GM965.
>
> I'm now running with this silly revert:
>
> --- a/drivers/gpu/drm/i915/i915_drv.c	2011-01-18 22:04:29.000000000  
> -0800
> +++ b/drivers/gpu/drm/i915/i915_drv.c	2011-01-24 19:35:51.000000000  
> -0800
> @@ -674,8 +674,8 @@ static struct drm_driver driver = {
>  	.device_is_agp = i915_driver_device_is_agp,
>  	.enable_vblank = i915_enable_vblank,
>  	.disable_vblank = i915_disable_vblank,
> -	.get_vblank_timestamp = i915_get_vblank_timestamp,
> -	.get_scanout_position = i915_get_crtc_scanoutpos,
> +	.get_vblank_timestamp = NULL /* i915_get_vblank_timestamp */,
> +	.get_scanout_position = NULL /* i915_get_crtc_scanoutpos */,
>  	.irq_preinstall = i915_driver_irq_preinstall,
>  	.irq_postinstall = i915_driver_irq_postinstall,
>  	.irq_uninstall = i915_driver_irq_uninstall,
>
> which makes 2.6.38-rc usable; though I do believe that I've seen
> the same issue (unflushed text) occur a couple of times since, much
> too rare to bisect or get upset by, but indicative of some  
> remaining bug.
>

Hi,

just skimmed through the archives of this thread. Do i understand  
correctly that the problem that gets fixed by your revert is that

<snip>
>>> when typing in one of the xterms, typed characters
>>> often stop echoing, until I shift to a different window, whereupon
>>> they appear.  This condition cleared (for a while) by switching to
>>> VESA fb console and back; no such problem observed on that console.
>>
</snip>

Is this with desktop composition enabled? Do things like glxgears in  
a window work correctly? If desktop composition is off?

For a softer fix to the problem you can revert your revert and  
disable use of those functions by the drm core via:

echo 0 > /sys/modules/drm/parameters/timestamp_precision_usec

But can you run it with echo 7 >  /sys/modules/drm/parameters/debug

and show me bits of the syslog output when the problem happens?  
Especially output from the functions  
"drm_calc_vbltimestamp_from_scanoutpos" and "drm_handle_vblank" and  
maybe for "vblank_disable_fn", "drm_update_vblank_count", and  
"drm_vblank_get".

Those functions (are supposed to) compute exact timestamps of start  
of scanout after each vblank. If they get disabled via the "echo  
0 ..." then a do_gettimeofday() is called for a crude approximation  
of start of scanout. The computed timestamps are returned to clients  
which want them (oml_sync_control extension). I doubt that many apps  
use that extension or its timestamps already, especially not desktop  
compositors etc., so i wouldn't expect trouble from such wrong  
timestamps.

However, the timestamps are also used in drm_handle_vblank() in  
drivers/gpu/drm/drm_irq.c at each vblank irq to detect and filter out  
redundant vblank irq's to avoid miscounting of vblanks (observed on  
some Radeon's). If the kms driver would deliver a grossly wrong  
timestamp and something would be wrong in the implementation of that  
filtering, it could happen that the vblank counter doesn't get  
incremented -> delivery of a vblank event to the x-server gets  
delayed -> a swapbuffer operation on a composited desktop gets  
delayed -> content of a redirected window updates only with a delay.

The relevant check which could prevent vblank counter increments and  
delay vblank event delivery to the x-server in drm_handle_vblank()  
would be:

         if (abs(diff_ns) > DRM_REDUNDANT_VBLIRQ_THRESH_NS) {

The condition should be satisfied if everything works correctly, but  
also if timestamps would be grossly wrong, thereby leading to a  
larger than 1 msec positive or negative diff_ns. s64 diff_ns is a  
signed 64 bit integer. Could abs(diff_ns) somehow miscompute for  
large 64 bit numbers?

All guesswork, the syslog output should tell us more if the  
timestamping is really involved in the problem.

thanks,
-mario

*********************************************************************
Mario Kleiner
Max Planck Institute for Biological Cybernetics
Spemannstr. 38
72076 Tuebingen
Germany

e-mail: mario.kleiner@tuebingen.mpg.de
office: +49 (0)7071/601-1623
fax:    +49 (0)7071/601-616
www:    http://www.kyb.tuebingen.mpg.de/~kleinerm
*********************************************************************
"For a successful technology, reality must take precedence
over public relations, for Nature cannot be fooled."
(Richard Feynman)

