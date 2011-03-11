Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752417Ab1CKR2J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 12:28:09 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:51742 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751041Ab1CKR2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 12:28:07 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=oTLRKlc7uOnq8tT6+hEsK5CQZPmBkevgiy5n8XrRHIHTb3YqqY/uDBclreQGKgyl/q2T4JvXSQod02WL+oQSuMW5zZAvbSyppXhDIMAUwm4VJzf0oo7RXJXWqLQTUbYx;
Date: Fri, 11 Mar 2011 09:27:51 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Indan Zupancic" <indan@nul.nu>
Cc: "Keith Packard" <keithp@keithp.com>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Takashi Iwai" <tiwai@suse.de>,
        "DRI mailing list" <dri-devel@lists.freedesktop.org>,
        "Chris Wilson" <chris@chris-wilson.co.uk>,
        "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Subject: Re: drm/i915: Fix DPMS and suspend interaction for intel_panel.c
Message-ID: <20110311092751.3812b03c@jbarnes-vaio.home>
In-Reply-To: <5e60ae646a15c73f5be0c309f51d1c63.squirrel@webmail.greenhost.nl>
References: <5e60ae646a15c73f5be0c309f51d1c63.squirrel@webmail.greenhost.nl>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.139.65.163 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 Mar 2011 02:35:45 +0100 (CET)
"Indan Zupancic" <indan@nul.nu> wrote:

> drm/i915: Fix DPMS and suspend interaction for intel_panel.c
> 
> When suspending intel_panel_disable_backlight() is never called,
> but intel_panel_enable_backlight() is called at resume. With the
> effect that if the brightness was ever changed after screen
> blanking, the wrong brightness gets restored at resume time.
> 
> Nothing guarantees that those calls will be balanced, so having
> backlight_enabled makes no sense, as the real state can change
> without the panel code noticing. So keep things as stateless as
> possible.
> 
> Signed-off-by: Indan Zupancic <indan@nul.nu>

Chris is right that we don't always control the backlight brightness
directly, so we'll want a more complete solution at any rate.

I don't think this one is urgent enough to send upstream now, and it
would be good to make a couple of other fixes as well, while you're
fixing things up. :)  Comments below.

> -/* i915_suspend.c */
> -extern int i915_save_state(struct drm_device *dev);
> -extern int i915_restore_state(struct drm_device *dev);
> -

Looks like a spurious cleanup hunk, should be a separate hunk (possibly
along with other save/restore state cleanups, like removing all the
ILK+ code that probably won't work well :).

> -void intel_panel_setup_backlight(struct drm_device *dev)
> -{
> -	struct drm_i915_private *dev_priv = dev->dev_private;
> -
> -	dev_priv->backlight_level = intel_panel_get_backlight(dev);
> -	dev_priv->backlight_enabled = dev_priv->backlight_level != 0;
>  }

This is getting pretty messy.  Your patch is a step in the right
direction, but I think we may as well go further:
  - suspend/resume of backlight state belongs in the backlight class
    driver
  - that driver should call into the registered i915 backlight handler
    if i915 is controlling it natively (PWM native, combo, legacy)
  - we need a backlight driver struct with function pointers for the
    various calls, so we can split out the PCH functions from the rest;
    might be good to separate native, combo, and legacy that way as
    well; even if results in some code duplication it might make each
    easier to read and less likely to break others when we make changes

Any thoughts about that?  I think Chris and Matthew have been talking
about it as well, so I'd be curious what our backlight final solution
ought to be.

Thanks,
Jesse
