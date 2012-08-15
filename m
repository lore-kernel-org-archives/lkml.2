Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752311Ab2HOPRU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 11:17:20 -0400
Received: from smtprelay.restena.lu ([158.64.1.62]:43228 "EHLO
	smtprelay.restena.lu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828Ab2HOPRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 11:17:18 -0400
Date: Wed, 15 Aug 2012 17:16:35 +0200
From: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 0/7] HID: picoLCD updates
Message-ID: <20120815171635.2564a4a8@neptune.home>
In-Reply-To: <alpine.LNX.2.00.1208151409500.7026@pobox.suse.cz>
References: <20120730213656.0a9f6d30@neptune.home>
	<alpine.LNX.2.00.1208151016221.7026@pobox.suse.cz>
	<20120815114236.0f7db40e@neptune.home>
	<alpine.LNX.2.00.1208151409500.7026@pobox.suse.cz>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Wed, 15 August 2012 Jiri Kosina <jkosina@suse.cz> wrote:
> I see. Alan Stern has fixed a huge pile of things in this area in 3.6-rc1. 
> I have expected all of those to actually be on theoretical problems not 
> ever having happened in the wild, but it might be that you are actually 
> chasing on of those.
>
> Could you please retest with latest Linus' tree (or at least eb055fd0560b) 
> to see whether this hasn't actually been fixed already by Alan's series?

I've started trying that out, it seems Alan's work improved things.

For the first few attempts I have not seen SLAB corruptions, though after
a few rounds I hit accumulation of the following messages:
[  297.174828] hid-picolcd 0003:04D8:C002.0003: output queue full
[  297.181098] hid-picolcd 0003:04D8:C002.0003: output queue full
[  297.187820] hid-picolcd 0003:04D8:C002.0003: output queue full
[  297.194087] hid-picolcd 0003:04D8:C002.0003: output queue full

with sporadically in between:
[  292.668019] hid-picolcd 0003:04D8:C002.0003: usb_submit_urb(out) failed: -1

At first glance I think the queue filling up and never draining is caused
by hid_hw_stop() stalling the queue and the time between both being just too
short.
Maybe me (un)binding on hid-picolcd driver level is the major cause of this
and (un)binding at lower usb level would kill the queue thus preventing
it just growing until full...


Is there a proper way to do rate-limiting or throttling when submitting
reports (which are the urbs deeper in the stack) and catch -ENODEV early
while remove() is delayed for locking reasons?
At least until 3.5 submitting reports provides no return value for driver
which could convey errors like -ENODEV, -EBUSY.



After a few bind-unbind iterations I have also hit a race in hid-picolcd
with regard to fbdefio.
That looks like chicken-egg release sequencing between hid-picolcd and
fb_info subdev -- though I'm wondering how that happens as the only framebuffer
user I know of - fbcon - should have stopped using it after
unregister_framebuffer() returned and released the last reference!

But that part can be improved rather easily with a new spinlock synchronizing
interoperation between hid side and framebuffer side.

Thanks,
Bruno
