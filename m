Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756774Ab0HPWqC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 18:46:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44068 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756457Ab0HPWqA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 18:46:00 -0400
Subject: Re: headers_check warnings in drm headers
From: Dave Airlie <airlied@redhat.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>, David Airlie <airlied@linux.ie>,
        dri-devel <dri-devel@lists.freedesktop.org>
In-Reply-To: <20100815192335.GA3438@merkur.ravnborg.org>
References: <20100815192335.GA3438@merkur.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 17 Aug 2010 08:45:50 +1000
Message-ID: <1281998750.3530.6.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-15 at 21:23 +0200, Sam Ravnborg wrote:
> When I ran "make headers_check" on upstream I got following
> set of warnings for the drm headers:
> 
> usr/include/drm/drm_mode.h:85: found __[us]{8,16,32,64} type without #include <linux/types.h>
> usr/include/drm/i915_drm.h:120: found __[us]{8,16,32,64} type without #include <linux/types.h>
> usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
> usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
> usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>
> 
> When I looked through the files I noticed a few things:
> 
> 1) Several files uses a mixture of native types and linux types.
>    For example "unsigned int" and "__u32" in the same file.
> 2) drm.h contains:
> #if defined(__linux__)
> 
> #include <linux/types.h>
> #include <asm/ioctl.h>
> typedef unsigned int drm_handle_t;
> 
> #else /* One of the BSDs */
> 
> #include <sys/ioccom.h>
> #include <sys/types.h>
> typedef int8_t   __s8;
> typedef uint8_t  __u8;
> typedef int16_t  __s16;
> typedef uint16_t __u16;
> typedef int32_t  __s32;
> typedef uint32_t __u32;
> typedef int64_t  __s64;
> typedef uint64_t __u64;
> typedef unsigned long drm_handle_t;
> 
> #endif
> 
> Why this when no-one else require this treatment?
> 
> 3) Lots of typedefs...
> 
> All in all - too much to dig into without knowing
> the background for the current state.
> 
> At a minimum please get the warnings fixed.

At a minimum please fix the checker to work.

It doesn't recurse, all of the .h files include drm.h, which includes
linux/types.h, this is how its meant to work. If the checker does
recurse then doesn't define __linux__ then fix that. This isn't a bug in
the drm header files.

We copy these files as is into a userspace that is shared with FreeBSD,
the ifdef is the minimum down from about 10 ifdefs 2-3 years ago
concession we've made.

Dave.

