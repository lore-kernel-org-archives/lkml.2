Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab1ALAzM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 19:55:12 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:54975 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756406Ab1ALAzI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 19:55:08 -0500
X-Greylist: delayed 1151 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2011 19:55:07 EST
Message-ID: <b34be07ef0c3e8fc82c29d4299f262e4.squirrel@webmail.greenhost.nl>
In-Reply-To: <1bdc18$j7rfh5@fmsmga002.fm.intel.com>
References: <AANLkTikKA-nStyNjkdsVa8hd=PFQR3tYTJh3MnfpNkD8@mail.gmail.com>
    <20110106104816.GA4026@tiehlicka.suse.cz>
    <20110111171744.GA3854@tiehlicka.suse.cz>
    <1bdc18$j7rfh5@fmsmga002.fm.intel.com>
Date: Wed, 12 Jan 2011 01:35:49 +0100 (CET)
Subject: Re: Linux 2.6.37
From: "Indan Zupancic" <indan@nul.nu>
To: "Chris Wilson" <chris@chris-wilson.co.uk>
Cc: "Michal Hocko" <mhocko@suse.cz>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 3cea6f85c46863b7448b52c7b19d39b8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, January 11, 2011 18:39, Chris Wilson wrote:
> On Tue, 11 Jan 2011 18:19:17 +0100, Michal Hocko <mhocko@suse.cz> wrote:
>> [Let's CC Indan - author of the bugzilla patches]
>>
>> On Thu 06-01-11 11:48:16, Michal Hocko wrote:
>> > Hi,
>> >
>> > On Tue 04-01-11 17:15:45, Linus Torvalds wrote:
>> > [...]
>> > > We did have another revert to fix hopefullythe last "blank screen"
>> > > regression on intel graphics.
>> >
>> > It seems that there is still a regression for intel graphic cards
>> > backlight. One report is https://bugzilla.kernel.org/show_bug.cgi?id=22672.
>> > I can reproduce the problem easily by:
>> > xset dpms force standby; sleep 3s; xset dpms force on
>> >
>> > backlight doesn't get up (there is really dark picture though which
>> > doesn't get brighter by function keys which work normally) after dpms on
>> > until I close and open lid.
>> >
>> > The problem wasn't present in 2.6.36
>>
>> I can confirm that this problem is not present if both patches from
>> bko#22672 are applied on top of 2.6.37 kernel.
>> I haven't tried both patches separately, but I can surely try it if it
>> makes any sense.
>
> The second patch is wrong in that it will prevent changing resolutions
> using the panel fitter.

I can confirm that with the second patch changing resolutions doesn't always go right.

$ xrandr
Screen 0: minimum 320 x 200, current 1024 x 768, maximum 2048 x 2048
LVDS1 connected 1024x768+0+0 (normal left inverted right x axis y axis) 0mm x 0mm
   1024x768       50.0*+   85.0     75.0     70.1     60.0
   832x624        74.6
   800x600        85.1     72.2     75.0     60.3     56.2
   640x480        85.0     72.8     75.0     59.9
   720x400        85.0
   640x400        85.1
   640x350        85.1
VGA1 disconnected (normal left inverted right x axis y axis)

Going from xrandr -s 1, 2 or 3 back to 0 works, but not from 4, 5 or 6 to 0.

The second patch was really a stab in the dark, I'm happy it was in the right
direction at least.

> The first patch looks along the right lines, just
> misses the possibility that the backlight can be modified by other means.

I'm not sure about that. All it does is avoiding setting backlight_level to
0. If it's modified some other way and intel_panel_get_backlight() returns 0,
backlight_level is just never set and will stay zero. If there is a way to
switch between ways to modify the backlight then I can see how this may not
always work, because then backlight_level is stuck on the last non-zero value
before it was switched to intel_panel_set_backlight(0) and the different method.

Alex reported a slightly dimmer display after resume, so I wonder what I missed
in my patch. Larry's problem was probably fixed with just the first patch, but
then I wonder why he reported that it didn't work first. Maybe he meant the
setpci thing, or made a mistake.

> So hopefully, you just need the first patch.
> -Chris

Yeah, the second patch is a bit of a desperate attempt because Larry reported that
it didn't fix his problem.

About your patch, you still do:

+void intel_panel_setup_backlight(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+
+	dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
+	dev_priv->backlight_enabled = dev_priv->backlight_level != 0;
+}

While my patch changes that to:

+	u32 level;

-	if (dev_priv->backlight_level == 0)
-		dev_priv->backlight_level = intel_panel_get_max_backlight(dev);
+	if (dev_priv->backlight_level == 0) {
+		level = intel_panel_get_backlight(dev);
+		if (level == 0)
+			level = intel_panel_get_max_backlight(dev);
+		dev_priv->backlight_level = level;
+	}

Your patch uses intel_panel_get_max_backlight() to check if the backlight is
enabled. Is this always correct, or may it cause bugs in the future?

Anyway, my main concern with unconditionally setting the backlight level to
the maximum is that any stored brightness level (by the BIOS or whatever) may
be lost, and that the screen is set to maximum brightness at each boot. This
is certainly the behaviour I've seen with an unpatched kernel. So I propose to
do what my patch does and set it to intel_panel_get_backlight(dev) if that
returns non-zero. Something like this:

+void intel_panel_setup_backlight(struct drm_device *dev)
+{
+	struct drm_i915_private *dev_priv = dev->dev_private;
+	u32 max, level;
+
+	max = intel_panel_get_max_backlight(dev);
+	if (max) {
+		dev_priv->backlight_enabled = 1;
+		level = intel_panel_get_backlight(dev);
+		if (!level)
+			level = max;
+		dev_priv->backlight_level = level;
+	}
+}

While I'm glad this problem is being fixed upstream, it would be nice to get
some credit for finding the source of the problem.

Greetings,

Indan


