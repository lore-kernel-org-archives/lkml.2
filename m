Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759322Ab2IETzx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 15:55:53 -0400
Received: from smtp05.smtpout.orange.fr ([80.12.242.127]:58159 "EHLO
	smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759281Ab2IETzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 15:55:51 -0400
Message-ID: <5047AECE.80409@laposte.net>
Date: Wed, 05 Sep 2012 21:58:06 +0200
From: Yann Cantin <yann.cantin@laposte.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.7) Gecko/20120826 Thunderbird/10.0.7
MIME-Version: 1.0
To: Oliver Neukum <oneukum@suse.de>
CC: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org, jikos@suse.cz
Subject: Re: [eBeam PATCH 2/2] input: misc: New USB eBeam input driver.
References: <1346539923-9704-1-git-send-email-yann.cantin@laposte.net> <1346539923-9704-3-git-send-email-yann.cantin@laposte.net> <3991181.oZKWSZGdK8@linux-lqwf.site>
In-Reply-To: <3991181.oZKWSZGdK8@linux-lqwf.site>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le 05/09/2012 09:29, Oliver Neukum a écrit :
> before we add yet another sysfs interface, we should ask whether calibration
> isn't a problem that should be solved with a common API.

Short answer : no.

##
Long answer (may be oot) :

Existing calibration tools or procedures (in kernel modules or xorg) for absolute
devices deals with hardware axis mostly matching system's ones (X screen mainly), modulo
switching XY, inversion or simple tweaks. Plus you know from the beginning the ranges
used, and all parameters are stable.

eBeam device track an active stylus in his fov, usually on a whiteboard where a
video-projector cast the computer screen. It then compute the stylus's position
and send it to the kernel in his own fixed 2D cartesian coordinate system relative
to the device.

The device is by design mobile (you stuck it anywhere on the border of the
projection plane for a session), his axis never match screen's ones, neither in range
nor orientation. Even worse, due to projection artifact, the two coordinates
systems (ebeam and screen) can even not be linearly correlated.

Manufacturer's so-called drivers seems to use second order interpolations,
i use an homography transformation (which is the right mathematical tool for
the problem, and seems quicker) to transform between coordinates systems. Anyway,
this need lot of parameters.

As ebeams are the only devices to my knowledge that work that way, i don't think
a common API can be common, unless we mean an in-kernel generic purpose calibration
API for input devices (stellar away for me), or a userland one (where should it be
in the stack ?). Sincerely, this look overkill.

In the other hand, the actual ebeam module transformation feeding events subsys
works very well and expose straight and usable data to userland (xorg evdev for now,
and any program that can eat kernel's input data).

##

I understand the sysfs interface is a problem. Eventually, in last resort, i can reduce
it to 4 files : pass the 9 matrix parameters as one big string, removing min values. But
i think this obfuscate the api for a marginal gain.


-- 
Yann Cantin
A4FEB47F
--
