Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755333Ab1JAJ6i (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 05:58:38 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:55865 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754526Ab1JAJ6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 05:58:34 -0400
Date: Sat, 1 Oct 2011 11:59:09 +0200
From: Daniel Vetter <daniel@ffwll.ch>
To: Keith Packard <keithp@keithp.com>
Cc: Daniel Vetter <daniel@ffwll.ch>, Dave Airlie <airlied@redhat.com>,
        intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH 14/21] drm/i915: Correct eDP panel power sequencing delay
 computations
Message-ID: <20111001095908.GB2807@phenom.ffwll.local>
Mail-Followup-To: Keith Packard <keithp@keithp.com>,
	Dave Airlie <airlied@redhat.com>, intel-gfx@lists.freedesktop.org,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <20110923085243.6e4b7b4c@jbarnes-x220>
 <1317344993-24945-1-git-send-email-keithp@keithp.com>
 <1317344993-24945-15-git-send-email-keithp@keithp.com>
 <20110930181644.GR2859@phenom.ffwll.local>
 <yunoby15qwu.fsf@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yunoby15qwu.fsf@aiko.keithp.com>
X-Operating-System: Linux phenom 3.1.0-rc4+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 08:31:13PM -0700, Keith Packard wrote:
> On Fri, 30 Sep 2011 20:16:44 +0200, Daniel Vetter <daniel@ffwll.ch> wrote:
> 
> > Awesome patch description and the code agrees with what I've cross-checked
> > on bspec. The only fear I have is that we currently ignore the backlight
> > on/off timings and some panel probably relies on use waiting for backlight
> > on/off + panel on/off in total. But that's material for another patch.
> 
> Ok, I've just read through the VBIOS source code to figure out how it
> converts the edp_power_seq table into the panel delay register settings.
> 
> intel_bios.h says:
> 
>         struct edp_power_seq {
>         	u16 t3;
>         	u16 t7;
>         	u16 t9;
>         	u16 t10;
>         	u16 t12;
>         } __attribute__ ((packed));
> 
> The VBIOS source code says that these five words are:
>                             Data        Code               
>         DW      xxxx        T1+T2       T1_T2   (Power Up Delay)
>         DW      yyyy        T3          T5      (Power-On to backlight On)
>         DW      zzzz        T4          T6      (Backlight off to power off)
>         DW      wwww        T5          T3      (power down delay)
>         DW      tttt        T7          T4      (power cycle delay)
> 
> ('Data' is how the initialized data is labeled, 'Code' is how the
> struct is defined and used. Yes, they appear to be different).
> 
> And, reading the code that programs the eDP registers
> 
>         PP_ON_DELAYS = (T1_T2 << 16) | T5
>         PP_OFF_DELAYS = (T3 << 16) | T6
>         PP_DIVISOR = T4 / 1000 + 1
> 
> The BSPEC/BIOS names don't agree with the eDP spec. Here's my plan:
> 
> Data    Code            eDP spec        intel_dp name           What I'm using this for:
> 
> T1+T2   T1_T2           T1+T3           panel_power_up_delay    VCC on to AUX channel
> T3      T5              T6+T8           backlight_on_delay      Link training to backlight on
> T4      T6              T9              backlight_off_delay     Backlight off to video off
> T5      T3              T10             panel_power_down_delay  Video off to VCC off
> T7      T4              T11+T12         panel_power_cycle_delay VCC off to VCC on
> 
> It's trivial to pull the values back out of the PP registers, so I'll do
> that and use the maximum of the two instead of preferring one or the
> other. Waiting too long shouldn't ever hurt.
> 
> As far as the edp_power_seq register goes, I'd love to know where those
> names came from. They don't quite match my interpretation, in
> particular, the 't7' is almost certainly not the eDP T7 value, which is
> the delay from valid video data on the link to a correct display,
> which isn't a useful value as it doesn't impact the source at all.
> 
> Ok, so a bit more whacking of code and I'll post an updated patch that
> uses all of these values as above.

Sounds like a plan. On further bspec review I've noticed that the
backlight power sequencing values exist since the introduction of on-chip
panel power/lvds output control for the i855gm. Currently we ignore them
for lvds panels, too. I'm hoping a bit that this causes the occasional
"backlight doesn't light up after dpms on/out of resume" issue I sometimes
see on about all my laptops here.

So while you bang your head against this, can you add the backlight power
sequencing delays for lvds panels, too? The lvds panel power sequencing
should be imo safe - we just msleep-spin with wait_for until the power
sequencer has completed the request.

-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48
