Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750947Ab1BIFpZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 00:45:25 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:64408 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750815Ab1BIFpY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 00:45:24 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=TsiWiwGS7DSY6NAydxnDSpqImnyfOCkSz64NXnuTc5IhZEvRR+SP3Dhq127ly5GxTG
         KXE+wuLOWR4/UWR4hrFseXqakLQFVh+HRFpvM2M6lGJJZJETEmobPTNVf0dWXw/pYIpQ
         6b2oAgIadA7jK9JEtXh7s3qOZMveCVu61aVVs=
MIME-Version: 1.0
In-Reply-To: <d41841c1e5f524f976edea8cdd075238.squirrel@webmail.greenhost.nl>
References: <AANLkTi=h+H+N=f4m4pE+RZ4n5h7oxQuwzmK-qmmWAGtL@mail.gmail.com>
	<s5hfws1whq8.wl%tiwai@suse.de>
	<AANLkTi=iHL+eVPRPzFXRMBZkXU7nXwkeZQiQUcyqSS-H@mail.gmail.com>
	<AANLkTikE_Oa=HGhW3zpc_rdeBvOWckpZ6dfFWq=JnL9R@mail.gmail.com>
	<AANLkTinYnehdaXn=Om-hVdo_U9N47BWFTgFoJbjpzuo=@mail.gmail.com>
	<d41841c1e5f524f976edea8cdd075238.squirrel@webmail.greenhost.nl>
Date: Wed, 9 Feb 2011 13:45:23 +0800
Message-ID: <AANLkTikWdpvDCf=tGry1WrJx9SrOjdSnEw75DSihcg0h@mail.gmail.com>
Subject: Re: Commit 500f7147cf5bafd139056d521536b10c2bc2e154 breaks _resume_
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Indan Zupancic <indan@nul.nu>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <lenb@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 9, 2011 at 10:56 AM, Indan Zupancic <indan@nul.nu> wrote:
> On Wed, February 9, 2011 02:05, Jeff Chua wrote:
>> On Wed, Feb 9, 2011 at 8:55 AM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>>
>>> And the console hangs even without starting X.
>>
>> I went back to retry suspending without starting X and realized that
>> it's only the "screen" that's hang .. and that's without drm and i915
>> loaded.
>
> According to the dmesg you sent, you do have drm (and probably i915 too) loaded.
> It seems the hang is the first bit, and then you rebooted into X to capture the
> log.
>
> Perhaps relevant message (probably not):
>
> "No ACPI video bus found"
>
>> On the console, I could still reboot the machine normally, but
>> not when in X (everything hangs including keybard).
>>
>> Here's the kernel log without X.
>>
>> Thanks.
>> Jeff
>>
>
> Looking at the commit, all it does is changing the timing.
>
> It used to set active to true when intel_crtc_init() was called, but now
> it does it always when the drm reset() callback is called.
>
> intel_crtc->active = true; /* force the pipe off on setup_init_config */
>
> I can't find a setup_init_config anywhere, but looking at the other code
> it assumes that *_crtc_disable() will be called just after the forced true.
>
> All in all it seems quite wrong, no matter if it happens to work, because
> it depends on the calling order done by the drm layer. If *_crtc_enable()
> is called instead it won't do anything because of that active = true thing.
> This seems to be happening in your case.
>
> So I'd get rid of that dodgy active = true assignment altogether. Isn't
> the introduction of the reset() callback done to avoid exactly this kind
> of subtle state fiddling? And removing it might solve the original problem
> that the move tried to fix as well.
>
> I can't check the rest of the code as I'm still on patched 37 (won't move
> till the fix for bug 23472 is upstream), but my gut feeling is that removing
> that weird active = true will solve most problems.

This may help a little. I added printk("intel_crtc 2") inside
intel_crtc_reset() and added printk("intel_crtc 1") before calling
intel_crtc_reset().

Looking at  dmesg, it looks like something else is calling
intel_crtc_reset() and not from intel_crtc_init() during resume.

intel_crtc 2 ffff880239cdf000
intel_crtc 2 ffff880239cdf800


Jeff.
