Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753264Ab2IHXZg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 19:25:36 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:59021 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751089Ab2IHXZe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 19:25:34 -0400
From: Ming Lei <ming.lei@canonical.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Takashi Iwai <tiwai@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC PATCH 0/5] driver core: driver probe asynchronously
Date: Sun,  9 Sep 2012 07:25:15 +0800
Message-Id: <1347146720-28596-1-git-send-email-ming.lei@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset implements asynchronous driver probe for driver_register,
and try to address the below problems about driver init during
kernel boot:
	- help to solve some dependency problem during kernel boot
	(such as, request_firmware is called inside probe when driver
	is built in kernel[1])

The idea behind the patch is very simple:

	- seperate driver probe from driver_register and run this part
	in one standalone kernel thread context

	- so driver_register will become two parts: register the driver
	on the bus, and trigger to schedule a kernel thread to do the
	driver probe if autoprobe is set

Fortunately, my OMAP4 based Pandaboard boots fine with the patchset, and
looks it may work well.

More or less, some problems might be triggered by these patchset, but
it should be helpful and not a big deal:
	- the dependency problem may be found, and it either exposes
	the driver's probelm or help to improve the asynchronous probe
	approach

	- can use driver_register_sync to work around it

In summary, there are at least two advantages about asynchronous driver
probe:
	- speedup kernel boot when many drivers are built in kernel
	- make driver's probe() not need to consider running something
	asynchronously(such as, scsi scan, request_firmware_no_wait, ...),
	so easier to write drivers

It should a very simple way to help to solve the problem[1], without
any changes on current drivers which call request_firmware() in its
probe(). BTW, the patchset doesn't solve the problem completely, and
still some work is needed.


[1], http://marc.info/?t=134676416100002&r=1&w=2


