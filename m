Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753612Ab1BIKUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:20:50 -0500
Received: from smarthost1.greenhost.nl ([195.190.28.78]:53646 "EHLO
	smarthost1.greenhost.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751723Ab1BIKUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:20:48 -0500
Message-ID: <e2336ca0c80cf43f018fcb797de3441d.squirrel@webmail.greenhost.nl>
In-Reply-To: <b7da2f$qco1ng@fmsmga001.fm.intel.com>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
    <s5hfws1whq8.wl%tiwai@suse.de>
    <AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com>
    <AANLkTikE_Oa=HGhW3zpc_rdeBvOWckpZ6dfFWq=JnL9R@mail.gmail.com>
    <849307$bf0dak@azsmga001.ch.intel.
    <AANLkTinYnehdaXn=Om-hVdo_U9N47BWFTgFoJbjpzuo=@mail.gmail.com>
    <d41841c1e5f524f976edea8cdd075238.squirrel@webmail.greenhost.nl>
    <b7da2f$qco1ng@fmsmga001.fm.intel.com>
Date: Wed, 9 Feb 2011 11:20:46 +0100 (CET)
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
From: "Indan Zupancic" <indan@nul.nu>
To: "Chris Wilson" <chris@chris-wilson.co.uk>
Cc: "Jeff Chua" <jeff.chua.linux@gmail.com>, "Takashi Iwai" <tiwai@suse.de>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, "Len Brown" <lenb@kernel.org>,
        "LKML" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
X-Spam-Score: 0.0
X-Scan-Signature: 729ef2e9e2cd27dd49f9ca04774c95e6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, February 9, 2011 10:32, Chris Wilson wrote:
> On Wed, 9 Feb 2011 03:56:36 +0100 (CET), "Indan Zupancic" <indan@nul.nu> wrote:
>> All in all it seems quite wrong, no matter if it happens to work, because
>> it depends on the calling order done by the drm layer. If *_crtc_enable()
>> is called instead it won't do anything because of that active = true thing.
>> This seems to be happening in your case.
>
> The order is very well defined.
>
> modesetting (upon resume we set the previous mode):
>   for each enabled crtc:
>     crtc_helper->prepare -> intel_crtc_disable()
>     crtc->mode_set -> intel_crtc_mode_set()
>     crtc_helper->commit -> intel_crtc_enable()
>   for each !enabled crtc:
>     crtc->disable -> intel_crtc_disable()

Prepare for what? That could mean anything. Is it only used to
prepare changing a mode, or suspend, or what? Same for commit.
Should it have been named modes_set_prepare and mode_set_commit?

It's clear if you've worked a lot on the code, but if you're just
debugging it's had to tell when anything will be called, the
function pointer chasing isn't fun. And that doesn't guarantee
a driver function won't be called in a different way in the
future anyway.

I'd go as far as saying that if that's always the order, then
just get rid of prepare and commit and do what's needed in the
mode_set function. If prepare and commit don't have any other
purpose or reason for existence.

And back to the original thing, where does that reset() callback
fit in? It's absent from the very well defined order. And judging
by its name, it should be okay to call at any moment, but it seems
that isn't the case.

But the real wrong thing is fiddling with "active" outside of those
state changing functions to force a certain behaviour later on if a
specific function is called just after this (fingers crossed).

My advise is to just remove that active = true line and fix any
breakage that results in some other way. It acts as an out-of-band
message to *crtc_disable() to re-disable already disabled crtcs,
which doesn't always work (either now or in the future). If the state
wasn't already messed up, it is after doing the active = true thing.

Greetings,

Indan


