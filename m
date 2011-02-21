Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755746Ab1BUCvp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 21:51:45 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:46081 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755712Ab1BUCvn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 21:51:43 -0500
Message-ID: <0ddbf6e443055625a7a3d14574a86718.squirrel@webmail.greenhost.nl>
In-Reply-To: <20110220105514.GB3514@viiv.ffwll.ch>
References: <3f9bbd0924f54f6241cc16293fbcbbb4.squirrel@webmail.greenhost.nl>
    <20110219182511.GA3977@viiv.ffwll.ch>
    <92f5b87a3559ed7f1b7c46b7497c1ad5.squirrel@webmail.greenhost.nl>
    <20110220105514.GB3514@viiv.ffwll.ch>
Date: Mon, 21 Feb 2011 03:51:38 +0100 (CET)
Subject: Re: [BUG] drm/i915 Screen corruption introduced by 
     a00b10c360b35d6431a94cb
From: "Indan Zupancic" <indan@nul.nu>
To: "Daniel Vetter" <daniel@ffwll.ch>
Cc: "Indan Zupancic" <indan@nul.nu>, "Chris Wilson" <chris@chris-wilson.co.uk>,
        "LKML" <linux-kernel@vger.kernel.org>, dri-devel@lists.freedesktop.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 27c1264e312f7e45ec0349526d776c80
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Feel free to ignore this post, it's a it of rambling.

On Sun, February 20, 2011 11:55, Daniel Vetter wrote:
> I've just noticed that one of the patches (the 2nd one) doesn't work
> as advertised. Please retest with the attached one.

I was wondering why that was, so I looked a bit closer:

Old patch:

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 17bd766..fbc21e3 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -763,7 +763,7 @@ static int i915_getparam(struct drm_device *dev, void *data,
 		value = HAS_BLT(dev);
 		break;
 	case I915_PARAM_HAS_RELAXED_FENCING:
-		value = 1;
+		value = 0;
 		break;
 	case I915_PARAM_HAS_COHERENT_RINGS:
 		value = 1;

New patch:

diff --git a/drivers/gpu/drm/i915/i915_dma.c b/drivers/gpu/drm/i915/i915_dma.c
index 17bd766..d275c96 100644
--- a/drivers/gpu/drm/i915/i915_dma.c
+++ b/drivers/gpu/drm/i915/i915_dma.c
@@ -762,9 +762,6 @@ static int i915_getparam(struct drm_device *dev, void *data,
 	case I915_PARAM_HAS_BLT:
 		value = HAS_BLT(dev);
 		break;
-	case I915_PARAM_HAS_RELAXED_FENCING:
-		value = 1;
-		break;
 	case I915_PARAM_HAS_COHERENT_RINGS:
 		value = 1;
 		break;

Looking at userspace intel-dri code it becomes clear why:

	gp.param = I915_PARAM_HAS_EXECBUF2;
	ret = drmIoctl(bufmgr_gem->fd, DRM_IOCTL_I915_GETPARAM, &gp);
	if (!ret)
		exec2 = 1;

	gp.param = I915_PARAM_HAS_BSD;
	ret = drmIoctl(bufmgr_gem->fd, DRM_IOCTL_I915_GETPARAM, &gp);
	bufmgr_gem->has_bsd = ret == 0;

	gp.param = I915_PARAM_HAS_BLT;
	ret = drmIoctl(bufmgr_gem->fd, DRM_IOCTL_I915_GETPARAM, &gp);
	bufmgr_gem->has_blt = ret == 0;

	gp.param = I915_PARAM_HAS_RELAXED_FENCING;
	ret = drmIoctl(bufmgr_gem->fd, DRM_IOCTL_I915_GETPARAM, &gp);
	bufmgr_gem->has_relaxed_fencing = ret == 0;

The stupid code assumes that if an option is supported, the value is true too,
while the kernel return code just tells whether it knows the option, and the
value is copied to gp.value, but that's ignored by intel-dri!

And a quick look at the other code gives a strong impression of lots of code
dubplication with the kernel driver.

More and more I'm getting the impression that you guys haven't gotten the
interfaces between all bits right yet. All in all you seem to be somewhat
in the same mess as filesystems are with overly complex interaction between
the MM system, VFS and individual filesystems, all doing more or less the
same in slightly different ways, instead of abstracting things properly.
(Which is also just an impression, I haven't looked that close yet.)

To give you an idea of a driver subsystem that does get it right:

All the common libata code is 23k lines. (wc liba*)
All the individual sata drivers code combined are 19k lines. (wc sata_*)

DRM does it differently (only counting .c files):

Common drm code is 21k
i915 is 37k
nouveau is 47k
radeon is 68k

And then there are the userspace drivers:
xf86-video-intel/src/*.c is 16k
drm/intel/ is 4k
mesa/drivers/dri/i915/ is 22k

Of course graphics drivers are a lot more complex than sata drivers,
but because of that extra complexity it's a lot easier to make things
even more compex by getting the interfaces wrong. So what I'm saying is,
there seems a lot of room for improvements. The intel driver code I've
seen is mostly busy with infrastructure stuff and talking to other bits
and pieces, but it doesn't seem to do much actual work.

To come back to the I915_PARAM_HAS_RELAXED_FENCING thing:

Why is this interface there at all? It seems like a driver internal detail
thing. Either it should be handled entirely in the kernel driver, and this
interface wouldn't be there, or, if the userspace driver has to know about
it, it should be entirely handled by the userspace driver and not done by
the kernel driver at all.

Another slightly annoying thing: The code is littered with gen checks,
while very often the only difference is a register or size value. Why
not put those in a gen specific hardware description structure which is
used unconditionally, instead of having a lot of almost the same code?

The current design seems overly complex and fragile, and I think you guys
make it more difficult for yourself than necessary.

Greetings,

Indan


