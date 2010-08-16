Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750929Ab0HPECT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 00:02:19 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50988 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750735Ab0HPECS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 00:02:18 -0400
MIME-Version: 1.0
In-Reply-To: <1281929408.3530.1.camel@clockmaker-el6>
References: <AANLkTi=NFpeyo7Q31yMfqKSP2c-2OS2ccqa=Q9CQ8bpk@mail.gmail.com> <1281929408.3530.1.camel@clockmaker-el6>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 15 Aug 2010 21:01:57 -0700
Message-ID: <AANLkTim0RbgfJjb+Wn_LiK9suBTC-kmi9SiZskRpYy0T@mail.gmail.com>
Subject: Re: Intel graphics CPU usage - SDVO detect bogosity?
To: Dave Airlie <airlied@redhat.com>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Zhao Yakui <yakui.zhao@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 8:30 PM, Dave Airlie <airlied@redhat.com> wrote:
>
> At least we should replace mdelay with msleep in those functions.

How precise does the timing have to be? I think i2c is self-clocking,
so it's ok to see big skews? Becuase msleep() can be off by quite a
bit (mdelay can too, but it's _way_ more rare, and requires either a
preemptible kernel or serious interrupt activity).

> Can you get a boot with drm.debug=4?

Sure. That results in a truncated dmesg (with a 128k buffer). The
thing seems to spew out something every ten seconds:

  ...
  [  232.610044] [drm:intel_sdvo_debug_write], SDVOB: W: 0B
             (SDVO_CMD_GET_ATTACHED_DISPLAYS)
  [  232.624504] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00
             (Success)
  [  232.624517] [drm:intel_sdvo_detect], SDVO response 1 0
  [  232.624524] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 01
             (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
  [  242.672044] [drm:intel_sdvo_debug_write], SDVOB: W: 0B
             (SDVO_CMD_GET_ATTACHED_DISPLAYS)
  [  242.686503] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00
             (Success)
  [  242.686516] [drm:intel_sdvo_detect], SDVO response 1 0
  [  242.686523] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 01
             (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
  [  252.750044] [drm:intel_sdvo_debug_write], SDVOB: W: 0B
             (SDVO_CMD_GET_ATTACHED_DISPLAYS)
  [  252.764526] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00
             (Success)
  [  252.764539] [drm:intel_sdvo_detect], SDVO response 1 0
  ...

It looks like it takes about 15 ms each time.  But 15 ms each 10s
doesn't seem to be enough to account for the load average. Maybe it
gets synchronized with the timer tick or something, causing the load
average to look artificially inflated (it also doesn't match up with
kworker using 1%+ CPU time).

So maybe there is something else going on. Maybe the load average
thing comes from some interaction with the new workqueue thing.

I'll send the whole dmesg to you in a private message, I don't think
we want 128kB of crud on lkml.

> I wonder are we picking up a bad SDVO, the insane code retries 50 times
> with a hard loop delay.

Well, I'm not seeing any failures, but maybe those don't get printed out?

                        Linus
