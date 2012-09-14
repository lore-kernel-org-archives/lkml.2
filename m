Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111Ab2INNY7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:24:59 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37451 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751544Ab2INNY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:24:57 -0400
MIME-Version: 1.0
In-Reply-To: <1347628339.21322.16.camel@shinybook.infradead.org>
References: <1347627426-3813-1-git-send-email-grant.likely@secretlab.ca>
 <84c8a8$5o3dgr@orsmga001.jf.intel.com> <CACxGe6u0+LC4G-87PsEK3ys7qqeJ2WnqnCdaegMK7=M9xpA8ug@mail.gmail.com>
 <1347628339.21322.16.camel@shinybook.infradead.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 14 Sep 2012 14:24:36 +0100
X-Google-Sender-Auth: JHY0A77rvxuBqcF-mdMnBBGxaGw
Message-ID: <CACxGe6szLVwsdNOvpB9v8pGDrygu+Go5Vf3bvpE19v3+Hkv4ww@mail.gmail.com>
Subject: Re: [PATCH] i915: Quirk out disconnected backlight
To: David Woodhouse <dwmw2@infradead.org>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Airlie <airlied@linux.ie>, Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 14, 2012 at 2:12 PM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Fri, 2012-09-14 at 14:09 +0100, Grant Likely wrote:
>> On Fri, Sep 14, 2012 at 2:01 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> > On Fri, 14 Sep 2012 13:57:06 +0100, Grant Likely <grant.likely@secretlab.ca> wrote:
>> >> Some platforms (for instance MacbookPros) have custom backlight drivers
>> >> and don't use the integrated i915 backlight control. This patch adds a
>> >> quirk to disable registering the intel backlight when unused on a
>> >> platform.
>> >>
>> >> Tested on MacbookPro8,3. Without this patch both the intel_backlight and
>> >> gmux_backlight devices get registered and userspace doesn't know which
>> >> it should use.
>> >
>> > Userspace is informed throught the backlight/type property.
>>
>> Perhaps, but userspace (Ubuntu) isn't doing anything with it, and it
>> still remains that it makes no sense whatsoever to register a
>> backlight device that doesn't exist.
>
> Indeed. Userspace (well, gnome-settings-daemon) will use the backlight
> provided by X, in preference to anything it finds
> in /sys/class/backlight. So if the Intel one is present (and thus
> exposed via X) then userspace will never bother with comparing types and
> choosing the sanest backlight to use.
>
> See https://bugzilla.redhat.com/show_bug.cgi?id=752595

In that bug you mention that the intel backlight sets a bogus max of
'1' when a backlight isn't present. I saw that too here. Here's the
offending code:

u32 intel_panel_get_max_backlight(struct drm_device *dev)
{
        struct drm_i915_private *dev_priv = dev->dev_private;
        u32 max;

        max = i915_read_blc_pwm_ctl(dev_priv);
        if (max == 0) {
                /* XXX add code here to query mode clock or hardware clock
                 * and program max PWM appropriately.
                 */
                pr_warn_once("fixme: max PWM is zero\n");
                return 1;
        }

I used a quirk in my patch, but I could instead change the driver to
bail here instead of trying to limp along.

g.
