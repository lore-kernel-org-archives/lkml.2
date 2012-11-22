Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756347Ab2KVVLQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 16:11:16 -0500
Received: from [93.179.225.50] ([93.179.225.50]:51284 "EHLO shrek.podlesie.net"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab2KVVLO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 16:11:14 -0500
Date: Thu, 22 Nov 2012 22:11:09 +0100
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: Re: i915: black screen after blank when LID is closed on Linux >= 3.1
Message-ID: <20121122211109.GA14204@shrek.podlesie.net>
References: <20121122185416.GA13169@shrek.podlesie.net>
 <CAKMK7uGBSwBeW=hCJi1sZgahQQSKdSy8K=i+M53hF3vDuNzDDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKMK7uGBSwBeW=hCJi1sZgahQQSKdSy8K=i+M53hF3vDuNzDDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 09:17:54PM +0100, Daniel Vetter wrote:
> Hi,
> 
> Thanks for the report. Now this smells like something which could take
> a bit longer to track down, so can you please file this on
> bugs.freedesktop.org against DRM -> DRI/Intel to ensure that we dont'
> loose track of it?

Yes, I will add a bug report there.

> 
> A few questions and things to test below.
> 
> On Thu, Nov 22, 2012 at 7:54 PM, Krzysztof Mazur <krzysiek@podlesie.net> wrote:
> > since Linux 3.1 I'm having some problems with i915 driver on HP nc6120
> > with 915GM chipset. The display goes black after the kernel tries to
> > blank screen while LID is closed (see steps to reproduce to more detailed
> > description).
> >
> > Currently I'm using Linux 3.7-rc6 with KMS enabled and disabled ACPI
> > video by something equivalent to (without it the LID, and the whole
> > ACPI, does not work):
> 
> Can you be more specific about what does not work? Do the lid events
> no longer function, or is something else broken?

It's a separate issue, probably not related to i915 driver. However
it might be important that I have disabled ACPI video, and it might
cause later problems so I added that information. However in < 3.1
kernel I also had disabled ACPI video and everything worked without
problems.

This ACPI problem started around 2.6.33 (the first workaround I used
is on top of 2.6.33.7:

commit 1dcdd646523a63a9e6476fd5ef46d82c67bb9a99
Author: Krzysztof Mazur <krzysiek@podlesie.net>
Date:   Wed Aug 11 09:35:35 2010 +0200

    disable ACPI video
    
    ACPI video causes problem on HP Compaq nc6120. After starting of X
    lid stops working.

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index b765790..1427cbb 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -2478,7 +2478,8 @@ static int __init acpi_video_init(void)
 {
 	dmi_check_system(video_dmi_table);
 
-	if (intel_opregion_present())
+	/* KM: test for nc6120 */
+	if (intel_opregion_present() || 1)
 		return 0;
 
 	return acpi_video_register();
)

I found similar bug reported on
https://bugzilla.redhat.com/show_bug.cgi?id=512958 and I never reported
that. I also tried:

     static int acpi_video_bus_start_devices(struct acpi_video_bus *video)
     {
    +   return acpi_video_bus_DOS(video, 3, 0);
     	return acpi_video_bus_DOS(video, 0, 0);
     }

but without success.

Without ACPI video driver loaded everything works, LID button sends ACPI
events, the display is tuned off when LID is pressed. After loading ACPI
video driver the LID stops sending ACPI events, and some other really
strange issues starts - for instance reading 
/sys/class/thermal/thermal_zone%d/tempcauses causes displaying "^@" in
console.

> >
> > In Linux 3.1 to 3.6 I've been using following workaround:
> > diff --git a/drivers/gpu/drm/i915/intel_display.c b/drivers/gpu/drm/i915/intel_display.c
> > index 2163818..51ebb77 100644
> > --- a/drivers/gpu/drm/i915/intel_display.c
> > +++ b/drivers/gpu/drm/i915/intel_display.c
> > @@ -6000,10 +6000,12 @@ static int intel_crtc_mode_set(struct drm_crtc *crtc,
> >                                               x, y, old_fb);
> >         drm_vblank_post_modeset(dev, pipe);
> >
> > +#if 0
> >         if (ret)
> >                 intel_crtc->dpms_mode = DRM_MODE_DPMS_OFF;
> >         else
> >                 intel_crtc->dpms_mode = DRM_MODE_DPMS_ON;
> > +#endif
> >
> >         return ret;
> >  }
> 
> Since a dpms ioctl call tends to follow a modeset, this likely only
> results in that dpms call enabling the hw again. Can you please add
> drm.debug=0xe to your kernel cmdline and boot into a 3.6 with this
> hack applied, reproduce the issue and the attach the complete dmesg?
> 
> The below WARNs from 3.7 support that, we've simply improved the
> code's ability to detect such problems. Can you please boot into a
> kernel with the latest drm-intel-next-queued branch merged in, but no
> other patches applied. Again please append drm.debug=0xe and then
> attach the complete dmesg after you've reproduced the issue.

Thanks, I will check that, but probably I will need to disable ACPI
video, because without it the LID does not work so the problem cannot
be probably triggered.

> 
> Please also compile your kernels with CONFIG_PRINTK_TIME=y, the
> timestamps in dmesg help a lot in figuring things out.
> 
> Yours, Daniel
> 

Thanks,

Krzysiek
