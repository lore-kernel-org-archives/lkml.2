Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab0G3EhN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 00:37:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49474 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab0G3EhL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 00:37:11 -0400
MIME-Version: 1.0
In-Reply-To: <4C51E36F.6060906@redhat.com>
References: <20100722101541.GU15652@nb.net.home> <1280410435-7017-1-git-send-email-mbroz@redhat.com> 
	<AANLkTikKAPToXUSecEThgXfufM73huircg2YB-UiG_ZY@mail.gmail.com> 
	<4C518AC9.4040208@redhat.com> <AANLkTikseiXY0zZ7AsyJgUXrqWsbjCgHqCabeg_SdWzZ@mail.gmail.com> 
	<20100729145827.GB1981@nb.net.home> <AANLkTinq4TUobEwnfpMFAkCugTokSZ-8KQ-ryuv6jXCc@mail.gmail.com> 
	<20100729195616.GF1981@nb.net.home> <4C51E36F.6060906@redhat.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Fri, 30 Jul 2010 06:36:55 +0200
Message-ID: <AANLkTimq0UVtR-ooutKTfOOE=cS-vxR4gR-aVc1feOzJ@mail.gmail.com>
Subject: Re: [PATCH] loop: add some basic read-only sysfs attributes
To: Milan Broz <mbroz@redhat.com>
Cc: Karel Zak <kzak@redhat.com>, util-linux-ng@vger.kernel.org,
        linux-kernel@vger.kernel.org, axboe@kernel.dk
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 22:24, Milan Broz <mbroz@redhat.com> wrote:
> On 07/29/2010 09:56 PM, Karel Zak wrote:
>>> Sure it does. Sysfs attributes need to be created _before_ uevents are
>>> sent out. The current behavior is that all blockdev attributes are
>>> safely created before the event is sent. These loop attributes are
>>> created _after_ the event is sent.
>>>
>>> The question is if we can rely on the fact, that 'add' events never
>>> want to look at any of these attributes, and all can be deferred to
>
> The problem is that add_disk() initializes kobject and announces device.
> How can I add some new attributes (subdir) with the current code
> before it happens?

Use attribute groups, and assign them to the class, or in this case to
the device before it is registered. All this stuff is created by the
core before the event is sent out. It also takes care of the subdir,
instead rolling your own kobject stuff, does proper error handling,
and cleans-up things in the proper order, without any further custom
code.

Alternatively, these attributes could be created and removed/created
with the ioctl, and before the 'change' event, only if there is an
active backing file, but I would expect the attribute group at the
device to work just fine.

> And why it is problem at all? After configuration there is always change
> event and at this time attributes are there.

As said, if we can rely on this fact, and there will never be any
attribute now, or added in the future, to this block of attributes,
this might be just fine, that's why I ask ...

We spent a lot of time to get the sysfs timing right, fix all the
subsystems, and make udev work with all sorts of attributes which have
been created like this. To add out-of-band attribute creation timing
today, there needs to be a very good reason to do so.

If you need any help with a try to a switch to the attribute group,
please let me know.

Kay
