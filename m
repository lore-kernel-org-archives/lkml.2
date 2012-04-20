Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2DTO1l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 10:27:41 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:46647 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756359Ab2DTO1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 10:27:38 -0400
MIME-Version: 1.0
In-Reply-To: <1334906476.3197.11.camel@pasglop>
References: <1334906476.3197.11.camel@pasglop>
Date: Fri, 20 Apr 2012 08:27:37 -0600
X-Google-Sender-Auth: wftq3ILM9-eOgcaPa9U8Uzi6hWk
Message-ID: <CAMLZHHTpNPbbMwrNmZf5Japk2b3gNZ7eAhU5xoG+a1jEPk96ig@mail.gmail.com>
Subject: Re: Multitouch regression in 3.3 on thinkpad X220 clickpad
From: Daniel Drake <dsd@laptop.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Peter Hutterer <peter.hutterer@who-t.net>,
        "X.Org Devel List" <xorg-devel@lists.freedesktop.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 1:21 AM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
> So Peter and I have been discussing a problem I observed on my brand new
> ThinkPad X220 and it's multitouch "clickpad". I've been digging a bit
> more today and bisected the regression to:
>
> commit 7968a5dd492ccc38345013e534ad4c8d6eb60ed1
> Input: synaptics - add support for Relative mode
>
> Without that commit, I can draw two "traces" when using two fingers in
> mtview (after removing the device from X), each follow one finger.
>
> With that commit applied, this doesn't work anymore: it appears to be
> unable to track more than one finger. IE. If i put a finger on the
> touchpad, I can draw, but a second finger is then ignored (or causes one
> or two spots in a random place to appear but that's about it).
>
> Now other multitouch operations such as two finger scrolling seem to
> work in X. I'm not familiar with the inner workings of the input layer
> or the synaptic touchpads. I'll dig a bit more this week-end if I have
> time, but it would save me plenty of that precious time if you guys
> could hint me at things to look at :-)

Sorry to cause you this trouble.
It's the first I've heard of issues with this patch, and unfortunately
I don't have any immediate diagnosis for you.
The patch isn't supposed to change behaviour of the existing default
mode which is called "absolute mode".

What I would suggest looking at is
synaptics_set_advanced_gesture_mode(). Is this being called, does it
run to completion?
You could also look at the the values passed to synaptics_mode_cmd() -
how do they compare from good and bad drivers?

Does this line change over good/bad drivers?
psmouse serio1: synaptics: Touchpad model: 1, fw: 8.0, id: 0x1e2b1,
caps: 0xd001a3/0x940300/0x120c00

Another approach may be to compare the communication with the device
between good and bad drivers. This can be done with
   echo 1 > /sys/module/i8042/parameters/debug

The device specs are public and remarkably good:
http://www.synaptics.com/sites/default/files/511-000275-01_RevB.pdf

Daniel
