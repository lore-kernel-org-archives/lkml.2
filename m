Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757168Ab2EYPVz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 11:21:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:11393 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752430Ab2EYPVx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 11:21:53 -0400
Message-ID: <4FBFA37E.2060308@redhat.com>
Date: Fri, 25 May 2012 12:21:34 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Anssi Hannula <anssi.hannula@iki.fi>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [GIT PULL for v3.5-rc1] media updates for v3.5
References: <4FBE5518.5090705@redhat.com> <CA+55aFyt2OFOsr5uCpQ6nrur4zhHhmWUJrvMgLH_Wy1niTbC6w@mail.gmail.com> <4FBEB72D.4040905@redhat.com> <CA+55aFyYQkrtgvG99ZOOhAzoKi8w5rJfRgZQy3Dqs39p1n=FPA@mail.gmail.com> <4FBF773B.10408@redhat.com> <4FBF9BE8.3020300@iki.fi>
In-Reply-To: <4FBF9BE8.3020300@iki.fi>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-05-2012 11:49, Anssi Hannula escreveu:
> 25.05.2012 15:12, Mauro Carvalho Chehab kirjoitti:
>> Em 24-05-2012 19:40, Linus Torvalds escreveu:
>>> On Thu, May 24, 2012 at 3:33 PM, Mauro Carvalho Chehab
>>> <mchehab@redhat.com> wrote:
>>>>
>>>> The Kconfig default for DVB_FE_CUSTOMISE is 'n'. So, if no DVB bridge is selected,
>>>> nothing will be compiled.
>>>
>>> Sadly, it looks like the default for distro kernels is 'y'.
>>
>> I'll change the default on Fedora (f16/f17/rawhide).
>>
>>> Which means that if you start with a distro kernel config, and then
>>> try to cut it down to match your system, you end up screwed in the
>>> future - all the new hardware will default to on.
>>>
>>> At least that's how I noticed it. Very annoying.
>>
>> A simple way to solve it seems to make those options dependent on CONFIG_EXPERT.
>>
>> Not sure if all usual distributions disable it, but I guess most won't have
>> EXPERT enabled.
>>
>> The enclosed patch does that. If nobody complains, I'll submit it together
>> with the next git pull request.
>>
>> Regards,
>> Mauro
>>
>> -
>>
>> [RFC PATCH] Make tuner/frontend options dependent on EXPERT
>>
>> The media CUSTOMISE options are there to allow embedded systems and advanced
>> users to disable tuner/frontends that are supported by a bridge driver to
>> be disabled, in order to save some disk space and memory, when compiled builtin.
>>
>> However, distros are mistakenly enabling it, causing problems when a
>> make oldconfig is used.
>>
>> Make those options dependent on EXPERT, in order to avoid such annoyance behavior.
>>
>> Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
>>
>> diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
>> index bbf4945..702a3bf 100644
>> --- a/drivers/media/common/tuners/Kconfig
>> +++ b/drivers/media/common/tuners/Kconfig
>> @@ -35,6 +35,7 @@ config MEDIA_TUNER
>>  config MEDIA_TUNER_CUSTOMISE
>>  	bool "Customize analog and hybrid tuner modules to build"
>>  	depends on MEDIA_TUNER
>> +	depends on EXPERT
>>  	default y if EXPERT
>         ^^^^^^^^^^^^^^^^^^^
> 
> Hmm, why should CONFIG_EXPERT automatically mean that the tuner modules
> should be customized? I'd think this shouldn't default to y even with
> EXPERT.
> 
> Not a biggie, just thought I'd point it out :)
> 
> (as a sidenote, on Mageia kernels CONFIG_EXPERT is on... didn't check
> why, could be just historical reasons)
> 
>>  	help
>>  	  This allows the user to deselect tuner drivers unnecessary
>> diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
>> index b98ebb2..6d3c2f7 100644
>> --- a/drivers/media/dvb/frontends/Kconfig
>> +++ b/drivers/media/dvb/frontends/Kconfig
>> @@ -1,6 +1,7 @@
>>  config DVB_FE_CUSTOMISE
>>  	bool "Customise the frontend modules to build"
>>  	depends on DVB_CORE
>> +	depends on EXPERT
>>  	default y if EXPERT
> 
> Ditto.
> 
>>  	help
>>  	  This allows the user to select/deselect frontend drivers for their
>

This was added on the changeset b3fc1782c8 (see below). A latter changeset (6a108a14fa3)
renamed EMBEDDED to EXPERT.

For embedded systems, it makes more sense to customize the tuners/demods, in order to
remove drivers that would never be used there. That's the rationale behind this patch.

>From my side, I don't mind removing the "default y if EXPERT", but, as I don't usually
work with embedded devices, I don't care much about that. It would be great to hear
some comments from embedded people about that as well.

That's said, it is weird that Mageia is using CONFIG_EXPERT. Are they using those
two Kconfig options enabled as well?

Regards,
Mauro

-

commit b3fc1782c8b84574e44cf5869c9afa75523e2db8
Author: Guennadi Liakhovetski <lyakh@extensa5220.grange>
Date:   Thu Aug 5 18:09:28 2010 -0300

    V4L/DVB: V4L: do not autoselect components on embedded systems
    
    Tuner, DVB frontend and video helper chip drivers are by default
    autoselected by their respective host cards, this, however, doesn't make
    much sense on SoC-based systems. Disable autoselection on EMBEDDED
    systems.
    
    Signed-off-by: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
    Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/media/common/tuners/Kconfig b/drivers/media/common/tuners/Kconfig
index 409a426..b3ed5da 100644
--- a/drivers/media/common/tuners/Kconfig
+++ b/drivers/media/common/tuners/Kconfig
@@ -34,7 +34,7 @@ config MEDIA_TUNER
 menuconfig MEDIA_TUNER_CUSTOMISE
 	bool "Customize analog and hybrid tuner modules to build"
 	depends on MEDIA_TUNER
-	default n
+	default y if EMBEDDED
 	help
 	  This allows the user to deselect tuner drivers unnecessary
 	  for their hardware from the build. Use this option with care
diff --git a/drivers/media/dvb/frontends/Kconfig b/drivers/media/dvb/frontends/Kconfig
index 51d578a..b5f6a04 100644
--- a/drivers/media/dvb/frontends/Kconfig
+++ b/drivers/media/dvb/frontends/Kconfig
@@ -1,7 +1,7 @@
 config DVB_FE_CUSTOMISE
 	bool "Customise the frontend modules to build"
 	depends on DVB_CORE
-	default N
+	default y if EMBEDDED
 	help
 	  This allows the user to select/deselect frontend drivers for their
 	  hardware from the build.
diff --git a/drivers/media/video/Kconfig b/drivers/media/video/Kconfig
index c70b67d..9d55fef 100644
--- a/drivers/media/video/Kconfig
+++ b/drivers/media/video/Kconfig
@@ -83,7 +83,7 @@ config VIDEO_FIXED_MINOR_RANGES
 
 config VIDEO_HELPER_CHIPS_AUTO
 	bool "Autoselect pertinent encoders/decoders and other helper chips"
-	default y
+	default y if !EMBEDDED
 	---help---
 	  Most video cards may require additional modules to encode or
 	  decode audio/video standards. This option will autoselect






