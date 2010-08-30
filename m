Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755000Ab0H3Nmj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 09:42:39 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:49336 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752917Ab0H3Nmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 09:42:37 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1+/7EkyMa2/GC2i+S6pQNr47dLnMKI2q0Zx3PE78C
	rVpjE+6Hh6RvvS
From: Sven Joachim <svenjoac@gmx.de>
To: Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Ivan Bulatovic <combuster@gmx.com>,
        Chris Wilson <chris@chris-wilson.co.uk>, Eric Anholt <eric@anholt.net>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: i915: wrong framebuffer size in 2.6.36-rc3
References: <87wrr8cui7.fsf@turtle.gmx.de>
	<AANLkTi=SHwkFFNEUsbJR-eJnyWcDFXcWD-CRPN8uiSHK@mail.gmail.com>
Date: Mon, 30 Aug 2010 15:42:32 +0200
In-Reply-To: <AANLkTi=SHwkFFNEUsbJR-eJnyWcDFXcWD-CRPN8uiSHK@mail.gmail.com>
	(Pekka Enberg's message of "Mon, 30 Aug 2010 12:57:20 +0300")
Message-ID: <87hbiccj3r.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-08-30 11:57 +0200, Pekka Enberg wrote:

> On Mon, Aug 30, 2010 at 12:36 PM, Sven Joachim <svenjoac@gmx.de> wrote:
>> On my laptop which has a 1280x800 display, only the upper left 848x480
>> pixels are used on the console in 2.6.36-rc3.  The resolution is
>> correct, but /sys/class/graphics/fb0/modes looks like this:
>>
>> U:848x480p-0
>>
>> This is a regression from 2.6.35.  The graphics card according to lspci:
>>
>> 00:02.0 VGA compatible controller: Intel Corporation Mobile 945GM/GMS,
>> 943/940GML Express Integrated Graphics Controller (rev 03)
>
> Yeah, you're not alone on this:
>
> http://lkml.org/lkml/2010/8/23/452

Incidentally, I did not notice the problem initially described in this
thread, and 2.6.36-rc2 actually seems OK for me.  But after this commit:

commit 9559fcdbff4f93d29af04478bbc48294519424f5
Author: Jesse Barnes <jbarnes@virtuousgeek.org>
Date:   Tue Aug 24 11:31:16 2010 -0700

    drm/i915: fix vblank wait test condition
    
    When converting this to the new wait_for macro I inverted the wait
    condition, which causes all sorts of problems.  So correct it to fix
    several failures caused by the bad wait (flickering, bad output
    detection, tearing, etc.).
    
    Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
    Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>
    Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

@ -992,7 +992,7 @@ void intel_wait_for_vblank(struct drm_device *dev, int pipe)
 
 	/* Wait for vblank interrupt bit to set */
 	if (wait_for((I915_READ(pipestat_reg) &
-		      PIPE_VBLANK_INTERRUPT_STATUS) == 0,
+		      PIPE_VBLANK_INTERRUPT_STATUS),
 		     50, 0))
 		DRM_DEBUG_KMS("vblank wait timed out\n");
 }


only the upper left 848x480 pixels of the display are used for the
framebuffer.  Booting with the video=1280x800 commandline option works
around this problem.

Sven
