Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752663Ab1AYQsN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 11:48:13 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:55488 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab1AYQsM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 11:48:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=dnLDL3jrnGgH+d7riCsHcH1a2/q/QKyhJlHmA+No0WCGBBky2TnkeEVJPeSvHYolC0
         z+0V1t9V0FJwbO4obVAkFhhnW1rkuyJjt77q9HtQLaoBgF11xFOBcvVT7pj2fyTWcOLx
         RgNbT8a6u5Z5GNfXPwWfrjqDfWaJFI2Vhk7j4=
Date: Tue, 25 Jan 2011 08:48:03 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Mark Lord <kernel@teksavvy.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils ?
Message-ID: <20110125164803.GA19701@core.coreip.homeip.net>
References: <4D3E1A08.5060303@teksavvy.com>
 <20110125005555.GA18338@core.coreip.homeip.net>
 <4D3E4DD1.60705@teksavvy.com>
 <20110125042016.GA7850@core.coreip.homeip.net>
 <4D3E5372.9010305@teksavvy.com>
 <20110125045559.GB7850@core.coreip.homeip.net>
 <4D3E59CA.6070107@teksavvy.com>
 <4D3E5A91.30207@teksavvy.com>
 <20110125053117.GD7850@core.coreip.homeip.net>
 <4D3EB734.5090100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D3EB734.5090100@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 09:42:44AM -0200, Mauro Carvalho Chehab wrote:
> Em 25-01-2011 03:31, Dmitry Torokhov escreveu:
> > On Tue, Jan 25, 2011 at 12:07:29AM -0500, Mark Lord wrote:
> >> On 11-01-25 12:04 AM, Mark Lord wrote:
> >>> On 11-01-24 11:55 PM, Dmitry Torokhov wrote:
> >>>> On Mon, Jan 24, 2011 at 11:37:06PM -0500, Mark Lord wrote:
> >>> ..
> >>>>> This results in (map->size==10) for 2.6.36+ (wrong),
> >>>>> and a much larger map->size for 2.6.35 and earlier.
> >>>>>
> >>>>> So perhaps EVIOCGKEYCODE has changed?
> >>>>>
> >>>>
> >>>> So the utility expects that all devices have flat scancode space and
> >>>> driver might have changed so it does not recognize scancode 10 as valid
> >>>> scancode anymore.
> >>>>
> >>>> The options are:
> >>>>
> >>>> 1. Convert to EVIOCGKEYCODE2
> >>>> 2. Ignore errors from EVIOCGKEYCODE and go through all 65536 iterations.
> >>>
> >>> or 3. Revert/fix the in-kernel regression.
> >>>
> >>> The EVIOCGKEYCODE ioctl is supposed to return KEY_RESERVED for unmapped
> >>> (but value) keycodes, and only return -EINVAL when the keycode itself
> >>> is out of range.
> >>>
> >>> That's how it worked in all kernels prior to 2.6.36,
> >>> and now it is broken.  It now returns -EINVAL for any unmapped keycode,
> >>> even though keycodes higher than that still have mappings.
> >>>
> >>> This is a bug, a regression, and breaks userspace.
> >>> I haven't identified *where* in the kernel the breakage happened,
> >>> though.. that code confuses me.  :)
> >>
> >> Note that this device DOES have "flat scancode space",
> >> and the kernel is now incorrectly signalling an error (-EINVAL)
> >> in response to a perfectly valid query of a VALID (and mappable)
> >> keycode on the remote control
> >>
> >> The code really is a valid button, it just doesn't have a default mapping
> >> set by the kernel (I can set a mapping for that code from userspace and it works).
> >>
> > 
> > OK, in this case let's ping Mauro - I think he done the adjustments to
> > IR keymap hanlding.
> 
> I lost part of the thread, but a quick search via the Internet showed that you're using
> the input tools to work with a Remote Controller, right? Are you using a vanilla
> kernel, or are you using the media_build backports? There are some distros that are
> using those backports also like Fedora 14.
> 
> In the latter case, I found the reason why the backports were not working and I fixed
> it a couple days ago:
> 	http://git.linuxtv.org/media_build.git?a=commit;h=b83dc3e49d90527d8e1016d09e06f4842a6a847a
> 
> The issue is simple, and it is related on how the input.c used to handle EVIOSGKEYCODE.
> Basically, before allowing you to change a key, it used to call EVIOCGKEYCODE to check
> it that key exists. However, when you're creating a new association, the key didn't
> exist, and, to be strict with input rules, EVIOCGKEYCODE should return -EINVAL.

We should be able to handle the case where scancode is valid even though
it might be unmapped yet. This is regardless of what version of
EVIOCGKEYCODE we use, 1 or 2, and whether it is sparse keymap or not.

Is it possible to validate the scancode by driver?

-- 
Dmitry
