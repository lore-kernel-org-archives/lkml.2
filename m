Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932270Ab2LRPrz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 10:47:55 -0500
Received: from mail-we0-f180.google.com ([74.125.82.180]:50767 "EHLO
	mail-we0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088Ab2LRPrx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 10:47:53 -0500
X-Greylist: delayed 1496 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 10:47:53 EST
MIME-Version: 1.0
In-Reply-To: <50D0473D.9060106@vodafone.de>
References: <1355779884.1414.14.camel@x61.thuisdomein>
	<50D0473D.9060106@vodafone.de>
Date: Tue, 18 Dec 2012 10:22:55 -0500
Message-ID: <CADnq5_ORb_kdaehxR6y+P1S0eStiLEo7jFOYXhn4sMDw5b=bcw@mail.gmail.com>
Subject: Re: [PATCH] [RFC] drm/radeon: return 0 on successful gpu reset
From: Alex Deucher <alexdeucher@gmail.com>
To: =?ISO-8859-1?Q?Christian_K=F6nig?= <deathsimple@vodafone.de>
Cc: Paul Bolle <pebolle@tiscali.nl>, Jerome Glisse <jglisse@redhat.com>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 5:36 AM, Christian König
<deathsimple@vodafone.de> wrote:
> On 17.12.2012 22:31, Paul Bolle wrote:
>>
>> On an (outdated) laptop the radeon driver (almost always) prints, during
>> the first resume of each session:
>>      [drm] crtc 1 is connected to a TV
>>
>> This message is a bit puzzling as, as far as I know, no TV has ever
>> been connected to this laptop. Anyhow, before v3.5, if that happened the
>> radeon driver then printed an error during all following resumes:
>>      [drm:radeon_cs_ioctl] *ERROR* Failed to parse relocation -35!
>>
>> (-35 is -EDEADLK.) But the resume would succeed and the driver seemed to
>> run without too much trouble. From v3.5 onwards things changed. If the
>> (puzzling) message about crtc 1 was printed on first resume the laptop
>> would simply hang on second resume. Only a manual power off would then
>> be possible. In that case nothing of interest would be found in the
>> (truncated) logs.  And, most annoyingly, the hang would never happen if
>> the laptop was booted with, say, "console=ttyS0,115200n8" added to the
>> kernel command line.
>>
>> I bisected the hang to commit 6c6f478370eccfbfafbdc6fc55c0def03e58f124
>> ("drm/radeon: rework recursive gpu reset handling"), which was added in
>> the v3.5 release cycle. After discovering that and poking at the driver
>> it turned out that this hang is triggered by radeon_cs_handle_lockup()
>> returning -EAGAIN after successfully resetting the gpu. Simply returning
>> 0 makes the hang disappear (and makes the drm error reappear).
>>
>> Nothing in the code or the commit explanation clarifies why -EAGAIN
>> should be returned on successful gpu reset. So I suggest
>> radeon_cs_handle_lockup() simply returns what radeon_gpu_reset()
>> returns, eg 0 (on success) or a negative error code (on failure).
>>
>> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
>> ---
>> 0) This exact patch is untested (but I run something comparable).
>>
>> 1) Sent as an RFC because I do not understand why this laptop (almost
>> always) prints the "crtc 1" message on first resume. Note that another
>> workaround for this hang is simply booting with "radeon.tv=0".
>
> Alex should probably take a look into this, since he probably is the one
> with the deepest knowledge of the display engine. My best guess is that it
> is just some error while probing for an attached TV and actually isn't so
> bad after all.

TV detection is always a bit flakey.  I suspect some register or gpio
related to TV out doesn't get restored properly on resume which
results in a false positive.  What asic is this?

>
>
>> 2) Also sent as an RFC because I have no idea whatsoever why returning
>> -EAGAIN will hang the machine. I guess it's returned to userland by
>> radeon_cs_ioctl(). What code uses that ioctl? And what does that code do
>> on -EAGAIN that hangs this laptop?
>
>
> EAGAIN just tells userspace to reissue the requested system call. When a
> system call is interrupted (either by a signal or in our case a GPU lockup)
> it aborts and EGAIN is returned to userspace, telling userspace that it
> should try again. So by just returning 0 userspace things that our system
> call was executed and doesn't try it again.
>
> So you just prevented the normal reissuing of the system call and so also
> prevented whatever this command submission should be doing in the first
> place.
>
>
>> 3) A third reason to send this as an RFC is that I also have no idea why
>> this hang doesn't happen when booting with "console=ttyS0,115200n8" or
>> even "console=tty0"! But I guess I'm now allowed to call this hang a
>> Heisenbug.
>
> "Heisenbug" ? LOL, I need to remember that.
>
> But anyway it is not so unusual seeing a bug like this, cause it is possible
> (but highly unlikely) that actually trying to print an error message can
> cause a lockup.
>
> You should definitely try Alex latest drm-fixes-3.8 branch
> (git://people.freedesktop.org/~agd5f/linux) since the possibility is quite
> high that we already have fixed that bug. If that doesn't helps then please
> open a bug report and leave me a note so that I can investigate further.

I don't have a 3.8 fixes branch up just yet, but will soon.

Alex

>
> Christian.
>
>
>
>>
>>   drivers/gpu/drm/radeon/radeon_cs.c |    5 +----
>>   1 files changed, 1 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/gpu/drm/radeon/radeon_cs.c
>> b/drivers/gpu/drm/radeon/radeon_cs.c
>> index 41672cc..a302c00 100644
>> --- a/drivers/gpu/drm/radeon/radeon_cs.c
>> +++ b/drivers/gpu/drm/radeon/radeon_cs.c
>> @@ -486,11 +486,8 @@ out:
>>     static int radeon_cs_handle_lockup(struct radeon_device *rdev, int r)
>>   {
>> -       if (r == -EDEADLK) {
>> +       if (r == -EDEADLK)
>>                 r = radeon_gpu_reset(rdev);
>> -               if (!r)
>> -                       r = -EAGAIN;
>> -       }
>>         return r;
>>   }
>>
>
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
