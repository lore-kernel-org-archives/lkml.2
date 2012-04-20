Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753258Ab2DTRBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:01:40 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:63410 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab2DTRBj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:01:39 -0400
Date: Fri, 20 Apr 2012 10:01:32 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Daniel Drake <dsd@laptop.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        "X.Org Devel List" <xorg-devel@lists.freedesktop.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Multitouch regression in 3.3 on thinkpad X220 clickpad
Message-ID: <20120420170132.GA32261@core.coreip.homeip.net>
References: <1334906476.3197.11.camel@pasglop>
 <CAMLZHHTpNPbbMwrNmZf5Japk2b3gNZ7eAhU5xoG+a1jEPk96ig@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMLZHHTpNPbbMwrNmZf5Japk2b3gNZ7eAhU5xoG+a1jEPk96ig@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 08:27:37AM -0600, Daniel Drake wrote:
> On Fri, Apr 20, 2012 at 1:21 AM, Benjamin Herrenschmidt
> <benh@kernel.crashing.org> wrote:
> > So Peter and I have been discussing a problem I observed on my brand new
> > ThinkPad X220 and it's multitouch "clickpad". I've been digging a bit
> > more today and bisected the regression to:
> >
> > commit 7968a5dd492ccc38345013e534ad4c8d6eb60ed1
> > Input: synaptics - add support for Relative mode
> >
> > Without that commit, I can draw two "traces" when using two fingers in
> > mtview (after removing the device from X), each follow one finger.
> >
> > With that commit applied, this doesn't work anymore: it appears to be
> > unable to track more than one finger. IE. If i put a finger on the
> > touchpad, I can draw, but a second finger is then ignored (or causes one
> > or two spots in a random place to appear but that's about it).
> >
> > Now other multitouch operations such as two finger scrolling seem to
> > work in X. I'm not familiar with the inner workings of the input layer
> > or the synaptic touchpads. I'll dig a bit more this week-end if I have
> > time, but it would save me plenty of that precious time if you guys
> > could hint me at things to look at :-)
> 
> Sorry to cause you this trouble.
> It's the first I've heard of issues with this patch, and unfortunately
> I don't have any immediate diagnosis for you.
> The patch isn't supposed to change behaviour of the existing default
> mode which is called "absolute mode".
> 
> What I would suggest looking at is
> synaptics_set_advanced_gesture_mode(). Is this being called, does it
> run to completion?

It looks we lost a condition in synaptics_set_advanced_gesture_mode().
It used to be:


	if (!(SYN_CAP_ADV_GESTURE(priv->ext_cap_0c) ||
			SYN_CAP_IMAGE_SENSOR(priv->ext_cap_0c)))
		return 0;

and now simply is:

	if (!SYN_CAP_ADV_GESTURE(priv->ext_cap_0c))
		return 0;

Could you try restoring the condition and see if it fixes the
regression?

Thanks.

-- 
Dmitry
