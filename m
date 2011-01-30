Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751728Ab1A3A2Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Jan 2011 19:28:25 -0500
Received: from smtp-out.google.com ([216.239.44.51]:15307 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751236Ab1A3A2Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Jan 2011 19:28:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CIdvB5TkhE44sx5Cir9EUsnzOww9vxyQ7VWZ3k5EbNVTC1dUDceJ8uxowqvU4SAdwF
         a5peBXAaeZhEBKUXm2Ew==
MIME-Version: 1.0
In-Reply-To: <EB643972-4918-4B89-B325-59D03648F2F9@tuebingen.mpg.de>
References: <20110123011221.GB1805@nowhere>
	<1295780472-8475-1-git-send-email-chris@chris-wilson.co.uk>
	<20110123175945.GA1760@nowhere>
	<alpine.LSU.2.00.1101232246380.3691@sister.anvils>
	<849307$b9dvii@azsmga001.ch.intel.com>
	<alpine.LSU.2.00.1101281347200.1759@sister.anvils>
	<EB643972-4918-4B89-B325-59D03648F2F9@tuebingen.mpg.de>
Date: Sat, 29 Jan 2011 16:28:18 -0800
Message-ID: <AANLkTikLTuxYsHUHO3hdSrc_9rSBgmiyePHs6D=7VzjK@mail.gmail.com>
Subject: Re: [PATCH] drm/i915,agp/intel: Do not clear stolen entries
From: Hugh Dickins <hughd@google.com>
To: Mario Kleiner <mario.kleiner@tuebingen.mpg.de>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, Arnd Bergmann <arnd@arndb.de>,
        Jiri Olsa <jolsa@redhat.com>, Chris Clayton <chris2553@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 6:59 PM, Mario Kleiner
<mario.kleiner@tuebingen.mpg.de> wrote:
> On Jan 28, 2011, at 11:00 PM, Hugh Dickins wrote:
>
>> Sorry, this is now abount vblank or scanout rather than stolen entries.
>>
>> On Mon, 24 Jan 2011, Chris Wilson wrote:
>>>
>>> On Sun, 23 Jan 2011 23:40:41 -0800 (PST), Hugh Dickins <hughd@google.com>
>>> wrote:
>>>
>>>> On this laptop I'm typing from (GM965 with KMS), I've had no trouble
>>>> getting X up; but when typing in one of the xterms, typed characters
>>>> often stop echoing, until I shift to a different window, whereupon
>>>> they appear.  This condition cleared (for a while) by switching to
>>>> VESA fb console and back; no such problem observed on that console.
>>>>
>>>> Does that sound familiar?  I have no evidence whatever that i915 is
>>>> to blame here.  Several times I tried bisecting last week, but each
>>>> attempt ended up in a nonsensical place, because the effect does not
>>>> occur to order.  So I'd sometimes mark a bisection point as good when
>>>> I guess it must actually have been bad.  Perhaps it's a matter of
>>>> timing or an uninitialized variable.  But while I'm here, worth asking
>>>> if that behaviour sounds like anything you might be responsible for?
>>>
>>> Sounds suspiciously like the batch buffer is not being dispatched and
>>> flushed to the scanout. A very similar bug was recently fixed for
>>> xf86-video-intel 2.14.0 which was causing deferred output.
>>
>> I made a more patient bisection during the week, on x86_64 which
>> seemed more consistent than i386, and this time it converged sensibly:
>> to commit 0af7e4dff50454905092d468e91c1ef92e10e6b4
>> drm/i915: Add support for precise vblank timestamping (v2)
>>
>> Which kindly notes in its commit message:
>>    This code has been only tested on a HP-Mini Netbook with
>>    Atom processor and Intel 945GME gpu. The codepath for
>>    (IS_G4X(dev) || IS_GEN5(dev) || IS_GEN6(dev)) gpu's
>>    has not been tested so far due to lack of hardware.
>> so not surprising that it doesn't work on GM965.
>>
>> I'm now running with this silly revert:
>>
>> --- a/drivers/gpu/drm/i915/i915_drv.c   2011-01-18 22:04:29.000000000
>> -0800
>> +++ b/drivers/gpu/drm/i915/i915_drv.c   2011-01-24 19:35:51.000000000
>> -0800
>> @@ -674,8 +674,8 @@ static struct drm_driver driver = {
>>        .device_is_agp = i915_driver_device_is_agp,
>>        .enable_vblank = i915_enable_vblank,
>>        .disable_vblank = i915_disable_vblank,
>> -       .get_vblank_timestamp = i915_get_vblank_timestamp,
>> -       .get_scanout_position = i915_get_crtc_scanoutpos,
>> +       .get_vblank_timestamp = NULL /* i915_get_vblank_timestamp */,
>> +       .get_scanout_position = NULL /* i915_get_crtc_scanoutpos */,
>>        .irq_preinstall = i915_driver_irq_preinstall,
>>        .irq_postinstall = i915_driver_irq_postinstall,
>>        .irq_uninstall = i915_driver_irq_uninstall,
>>
>> which makes 2.6.38-rc usable; though I do believe that I've seen
>> the same issue (unflushed text) occur a couple of times since, much
>> too rare to bisect or get upset by, but indicative of some remaining bug.
>>
>
> Hi,
>
> just skimmed through the archives of this thread. Do i understand correctly
> that the problem that gets fixed by your revert is that
>
> <snip>
>>>>
>>>> when typing in one of the xterms, typed characters
>>>> often stop echoing, until I shift to a different window, whereupon
>>>> they appear.  This condition cleared (for a while) by switching to
>>>> VESA fb console and back; no such problem observed on that console.
>>>
> </snip>

Yes, that's the problem that's fixed by the little revert patch I
posted last time.
Sorry, this thread started out with other problems, then I asked Chris
if this might also be an i915 issue.

>
> Is this with desktop composition enabled?

Not that I'm aware of.  The see-through business.  I'm just using four
xterms in fvwm2 on openSUSE11.2 with own kernel.  If desktop
composition might be enabled by the X startup script, expecting me to
use gnome rather than fvwm2, then I suppose it might be enabled; but
it's not something I've chosen to turn on.  What should I check to
answer you for sure, if it matters?

> Do things like glxgears in a
> window work correctly? If desktop composition is off?

Yes, glxgears appears to work correctly: I type "glxgears" at the
xterm shell prompt, those letters and carriage return are not echoed
back to me, but the glxgears window appears with the gears turning
correctly, then I close that window, type more and again my typing is
not echoed.

>
> For a softer fix to the problem you can revert your revert and disable use
> of those functions by the drm core via:
>
> echo 0 > /sys/modules/drm/parameters/timestamp_precision_usec

Thanks for the info.  ("module" rather than "modules".)

>
> But can you run it with echo 7 >  /sys/modules/drm/parameters/debug
>
> and show me bits of the syslog output when the problem happens? Especially
> output from the functions "drm_calc_vbltimestamp_from_scanoutpos" and
> "drm_handle_vblank" and maybe for "vblank_disable_fn",
> "drm_update_vblank_count", and "drm_vblank_get".

Wow, millions of lines of output (partly because I couldn't see the
typo that had prevented me from turning it off after a few seconds).
I rebuilt the kernel with the DRM_DEBUG at the head of drm_ioctl()
edited out: that generates so many messages (cmd=0x400c645f
mostly, but some cmd=0x6458)  that the logging cannot keep up, and
hardly gets a chance to print anything else.

But even with that edited out, nothing from any of the functions that
you suggest: only, and perhaps this is the problem?,
[drm:i915_driver_irq_handler}, pipe a underrun
about 64 times per second.

I just tried setting the debug to 7 for a few seconds on 2.6.37, where
I see no problem: I appear to get the "pipe a underrun" messages with
that too; and the drm_ioctl messages, but much much fewer of them.
Though I've been veering between i386 and x86_64 in these tests, so
keep that in mind if what I'm saying makes no sense: the huge number
of drm_ioctls was with 2.6.36-rc2 (plus some of Chris's fixes) on
i386; the 64 underruns per second was with 2.6.36-rc2 (plus some of
Chris's fixes, minus the drm_ioctl DRM_DEBUG) on x86_64; the underruns
and reasonable number of drm_ioctls was with 2.6.37 on x86_64.

On this laptop I'm working with
# CONFIG_NO_HZ is not set
# CONFIG_HIGH_RES_TIMERS is not set
CONFIG_HZ_250=y
CONFIG_HZ=250
if those have any relevance.

Thanks,
Hugh

>
> Those functions (are supposed to) compute exact timestamps of start of
> scanout after each vblank. If they get disabled via the "echo 0 ..." then a
> do_gettimeofday() is called for a crude approximation of start of scanout.
> The computed timestamps are returned to clients which want them
> (oml_sync_control extension). I doubt that many apps use that extension or
> its timestamps already, especially not desktop compositors etc., so i
> wouldn't expect trouble from such wrong timestamps.
>
> However, the timestamps are also used in drm_handle_vblank() in
> drivers/gpu/drm/drm_irq.c at each vblank irq to detect and filter out
> redundant vblank irq's to avoid miscounting of vblanks (observed on some
> Radeon's). If the kms driver would deliver a grossly wrong timestamp and
> something would be wrong in the implementation of that filtering, it could
> happen that the vblank counter doesn't get incremented -> delivery of a
> vblank event to the x-server gets delayed -> a swapbuffer operation on a
> composited desktop gets delayed -> content of a redirected window updates
> only with a delay.
>
> The relevant check which could prevent vblank counter increments and delay
> vblank event delivery to the x-server in drm_handle_vblank() would be:
>
>        if (abs(diff_ns) > DRM_REDUNDANT_VBLIRQ_THRESH_NS) {
>
> The condition should be satisfied if everything works correctly, but also if
> timestamps would be grossly wrong, thereby leading to a larger than 1 msec
> positive or negative diff_ns. s64 diff_ns is a signed 64 bit integer. Could
> abs(diff_ns) somehow miscompute for large 64 bit numbers?
>
> All guesswork, the syslog output should tell us more if the timestamping is
> really involved in the problem.
>
> thanks,
> -mario
>
> *********************************************************************
> Mario Kleiner
> Max Planck Institute for Biological Cybernetics
> Spemannstr. 38
> 72076 Tuebingen
> Germany
>
> e-mail: mario.kleiner@tuebingen.mpg.de
> office: +49 (0)7071/601-1623
> fax:    +49 (0)7071/601-616
> www:    http://www.kyb.tuebingen.mpg.de/~kleinerm
> *********************************************************************
> "For a successful technology, reality must take precedence
> over public relations, for Nature cannot be fooled."
> (Richard Feynman)
>
>
