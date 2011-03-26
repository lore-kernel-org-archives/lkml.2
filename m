Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab1CZKTq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 06:19:46 -0400
Received: from smtp-vbr6.xs4all.nl ([194.109.24.26]:1777 "EHLO
	smtp-vbr6.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab1CZKTo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 06:19:44 -0400
From: Hans Verkuil <hverkuil@xs4all.nl>
To: Ondrej Zary <linux@rainbow-software.org>
Subject: Re: [RFC PATCH 1/3] tea575x-tuner: various improvements
Date: Sat, 26 Mar 2011 11:19:31 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc7-durdane; KDE/4.4.5; x86_64; ; )
Cc: "Takashi Iwai" <tiwai@suse.de>, jirislaby@gmail.com,
        alsa-devel@alsa-project.org,
        "Kernel development list" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
References: <201103121919.05657.linux@rainbow-software.org> <201103222002.31074.hverkuil@xs4all.nl> <201103252240.16051.linux@rainbow-software.org>
In-Reply-To: <201103252240.16051.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103261119.31897.hverkuil@xs4all.nl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, March 25, 2011 22:40:12 Ondrej Zary wrote:
> On Tuesday 22 March 2011 20:02:30 Hans Verkuil wrote:
> > BTW, can you run the v4l2-compliance utility for the two boards that use
> > this radio tuner?
> >
> > This utility is part of the v4l-utils repository
> > (http://git.linuxtv.org/v4l-utils.git).
> >
> > Run as 'v4l2-compliance -r /dev/radioX -v2'.
> >
> > I'm sure there will be some errors/warnings (warnings regarding
> > G/S_PRIORITY are to be expected). But I can use it to make a patch for
> > 2.6.40 that fixes any issues.
> 
> The output is the same for both fm801 and es1968 (see below). Seems that
> there are 4 errors:
>  1. multiple-open does not work
>  2. something bad with s_frequency
>  3. input functions are present
>  4. no extended controls

Thanks for testing! Some comments are below...

> 
> 
> 
> Running on 2.6.38
> 
> Driver Info:
> 	Driver name   : tea575x-tuner
> 	Card type     : TEA5757
> 	Bus info      : PCI
> 	Driver version: 0.0.2
> 	Capabilities  : 0x00050000
> 		Tuner
> 		Radio
> 
> Compliance test for device /dev/radio0 (not using libv4l2):
> 
> Required ioctls:
> 	test VIDIOC_QUERYCAP: OK
> 
> Allow for multiple opens:
> 	test second radio open: FAIL

I will fix this. Once 2.6.39-rc1 is released I can make a patch fixing this.

> 
> Debug ioctls:
> 	test VIDIOC_DBG_G_CHIP_IDENT: Not Supported
> 	test VIDIOC_DBG_G/S_REGISTER: Not Supported
> 	test VIDIOC_LOG_STATUS: Not Supported
> 
> Input ioctls:
> 	test VIDIOC_G/S_TUNER: OK
> 		fail: set rangehigh+1 frequency did not return EINVAL
> 	test VIDIOC_G/S_FREQUENCY: FAIL

Hmm, S_FREQUENCY apparently fails to check for valid frequency values.
Can you take a quick look at the code?

> 	test VIDIOC_ENUMAUDIO: Not Supported
> 		fail: radio can't have input support
> 	test VIDIOC_G/S/ENUMINPUT: FAIL

ENUMINPUT/G/S_INPUT are not allowed for radio devices. These ioctls are specific
for video. 90% of all radio driver use it, though :-)

I'll fix this when I go through all radio drivers.

> 	test VIDIOC_G/S_AUDIO: Not Supported
> 	Inputs: 0 Audio Inputs: 0 Tuners: 1
> 
> Output ioctls:
> 	test VIDIOC_G/S_MODULATOR: Not Supported
> 	test VIDIOC_G/S_FREQUENCY: OK
> 	test VIDIOC_ENUMAUDOUT: Not Supported
> 	test VIDIOC_G/S/ENUMOUTPUT: Not Supported
> 	test VIDIOC_G/S_AUDOUT: Not Supported
> 	Outputs: 0 Audio Outputs: 0 Modulators: 0
> 
> Control ioctls:
> 		fail: does not support V4L2_CTRL_FLAG_NEXT_CTRL
> 	test VIDIOC_QUERYCTRL/MENU: FAIL

I'll fix this as well. The drivers needs to be converted to the control
framework.

Regards,

	Hans


> 	test VIDIOC_G/S_CTRL: OK
> 	test VIDIOC_G/S/TRY_EXT_CTRLS: Not Supported
> 	Standard Controls: 0 Private Controls: 0
> 
> Input/Output configuration ioctls:
> 	test VIDIOC_ENUM/G/S/QUERY_STD: Not Supported
> 	test VIDIOC_ENUM/G/S/QUERY_DV_PRESETS: Not Supported
> 	test VIDIOC_G/S_DV_TIMINGS: Not Supported
> 
> Total: 21 Succeeded: 17 Failed: 4 Warnings: 0
> 
> 

-- 
Hans Verkuil - video4linux developer - sponsored by Cisco
