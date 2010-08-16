Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab0HPE3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 00:29:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33849 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751627Ab0HPE3j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 00:29:39 -0400
Subject: Re: Intel graphics CPU usage - SDVO detect bogosity?
From: Dave Airlie <airlied@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@linux.ie>, Chris Wilson <chris@chris-wilson.co.uk>,
        Zhao Yakui <yakui.zhao@intel.com>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Adam Jackson <ajax@redhat.com>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
In-Reply-To: <AANLkTim0RbgfJjb+Wn_LiK9suBTC-kmi9SiZskRpYy0T@mail.gmail.com>
References: <AANLkTi=NFpeyo7Q31yMfqKSP2c-2OS2ccqa=Q9CQ8bpk@mail.gmail.com>
	 <1281929408.3530.1.camel@clockmaker-el6>
	 <AANLkTim0RbgfJjb+Wn_LiK9suBTC-kmi9SiZskRpYy0T@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 16 Aug 2010 14:29:16 +1000
Message-ID: <1281932956.3530.3.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-15 at 21:01 -0700, Linus Torvalds wrote:
> On Sun, Aug 15, 2010 at 8:30 PM, Dave Airlie <airlied@redhat.com> wrote:
> >
> > At least we should replace mdelay with msleep in those functions.
> 
> How precise does the timing have to be? I think i2c is self-clocking,
> so it's ok to see big skews? Becuase msleep() can be off by quite a
> bit (mdelay can too, but it's _way_ more rare, and requires either a
> preemptible kernel or serious interrupt activity).

In this case it definitely doesn't matter, I expect msleep to be a much
nicer to the system in general idea esp in routines we can all at
runtime from userspace.

> 
> > Can you get a boot with drm.debug=4?
> 
> Sure. That results in a truncated dmesg (with a 128k buffer). The
> thing seems to spew out something every ten seconds:
> 
>   ...
>   [  232.610044] [drm:intel_sdvo_debug_write], SDVOB: W: 0B
>              (SDVO_CMD_GET_ATTACHED_DISPLAYS)
>   [  232.624504] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00
>              (Success)
>   [  232.624517] [drm:intel_sdvo_detect], SDVO response 1 0
>   [  232.624524] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 01
>              (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
>   [  242.672044] [drm:intel_sdvo_debug_write], SDVOB: W: 0B
>              (SDVO_CMD_GET_ATTACHED_DISPLAYS)
>   [  242.686503] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00
>              (Success)
>   [  242.686516] [drm:intel_sdvo_detect], SDVO response 1 0
>   [  242.686523] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 01
>              (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
>   [  252.750044] [drm:intel_sdvo_debug_write], SDVOB: W: 0B
>              (SDVO_CMD_GET_ATTACHED_DISPLAYS)
>   [  252.764526] [drm:intel_sdvo_debug_response], SDVOB: R: 01 00
>              (Success)
>   [  252.764539] [drm:intel_sdvo_detect], SDVO response 1 0
>   ...
> 
> It looks like it takes about 15 ms each time.  But 15 ms each 10s
> doesn't seem to be enough to account for the load average. Maybe it
> gets synchronized with the timer tick or something, causing the load
> average to look artificially inflated (it also doesn't match up with
> kworker using 1%+ CPU time).
> 
> So maybe there is something else going on. Maybe the load average
> thing comes from some interaction with the new workqueue thing.
> 
> I'll send the whole dmesg to you in a private message, I don't think
> we want 128kB of crud on lkml.
> 
> > I wonder are we picking up a bad SDVO, the insane code retries 50 times
> > with a hard loop delay.
> 
> Well, I'm not seeing any failures, but maybe those don't get printed out?

Oh wierd, so not where I thought it was, I expect then the SDVO HDMI
detection is completely insane,

intel_sdvo_hdmi_sink_detect looks to contain some really uninspiring
code. Might be worth adding some debug in there to see if it sinks a lot
of time.

Dave.

