Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758112Ab1I3SQl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 14:16:41 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:41532 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754714Ab1I3SQk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 14:16:40 -0400
Date: Fri, 30 Sep 2011 20:16:44 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 14/21] drm/i915: Correct eDP panel power sequencing delay
 computations
Message-ID: <20110930181644.GR2859@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
 <1317344993-24945-15-git-send-email-keithp@keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1317344993-24945-15-git-send-email-keithp@keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 29, 2011 at 06:09:46PM -0700, Keith Packard wrote:
> Store the panel power sequencing delays in the dp private structure,
> rather than the global device structure. Who knows, maybe we'll get
> more than one eDP device in the future.
> 
> Look at both the current hardware register settings and the VBT
> specified panel power sequencing timings. Use the maximum of the two
> delays, to make sure things work reliably. If there is no VBT data,
> then those values will be initialized to zero, so we'll just use the
> values as programmed in the hardware.
> 
> This patch computes power-up and power-down delays, rather than using
> portions of the appropriate delay values as found in the hardware. The
> eDP specified delay between raising VCC and communicating over the aux
> channel includes both the power rise time (T1) and the aux channel
> communication delay (T3). The eDP specified delay between powering
> down the device and powering it back up includes both the power fall
> time (T11) and the device idle time (T12).
> 
> From the hardware, I'm taking the T3 value from the PP_OFF_DELAYS
> Power_Down_delay value, which is actually documented to be the 'T3
> time sequence' value used 'during power up'. There aren't separate T1
> and T2 values, but there is a combined T1+T2 value in the PP_ON_DELAYS
> register, so I use that instead.
> 
> VBT doesn't provide any values for T1 or T2, so we'll always just use
> the hardware value for that.
> 
> The panel power up delay is thus T1 + T2 + T3, which should be
> sufficient in all cases.
> 
> The panel power down delay is T1 + T2 + T12, using T1+T2 as a proxy
> for T11, which isn't available anywhere.
> 
> On the macbook air I'm testing with, this yields a power-up delay of
> over 200ms and a power-down delay of over 600ms. It all works now, but
> we're frobbing these power controls several times during mode setting,
> making the whole process take an awfully long time.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>

Awesome patch description and the code agrees with what I've cross-checked
on bspec. The only fear I have is that we currently ignore the backlight
on/off timings and some panel probably relies on use waiting for backlight
on/off + panel on/off in total. But that's material for another patch.

Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
