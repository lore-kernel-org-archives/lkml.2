Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608Ab1ETWkM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 18:40:12 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34806 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab1ETWkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 18:40:07 -0400
MIME-Version: 1.0
In-Reply-To: <201105202046.40696.arnd@arndb.de>
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>
	<201105050841.40576.arnd@arndb.de>
	<4DD6AD51.7090900@tilera.com>
	<201105202046.40696.arnd@arndb.de>
Date: Fri, 20 May 2011 15:40:06 -0700
Message-ID: <BANLkTimMndGzjZJ0xUNgStY7kwM0aW7Ojg@mail.gmail.com>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM driver
From: Eric Biederman <ebiederm@aristanetworks.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 11:46 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 20 May 2011 20:05:05 Chris Metcalf wrote:
>> This works well, except for the fact that we take advantage of the fact
>> that the hypervisor driver internally buffers up writes to the current
>> EEPROM sector, and flushes it to hardware only when explicitly told to do
>> so, or when we start writing to another sector.  This avoids excessive wear
>> on the EEPROM and also handles detection of whether we need to do a sector
>> erase before the re-write.  However, it also means that we need to be able
>> to issue the final explicit flush, or else the last write just sits in the
>> hypervisor buffer indefinitely.  To make that happen I think I need to
>> extend the bin_attribute structure, and the bin.c release() function, slightly:
>
> Yes, that would work. Another option would be to add a flush() callback
> to the bin_attribute. Since filp_close calls both fops->flush and
> fops->release, that would also make it possible to flush the buffer
> without closing it, if necessary.

Ouch!

Please do not make sysfs the direct access method to your device.

I may be wrong but I don't think any other driver relies exclusively on sysfs.
Certainly with the introduction of a flush you are introducing an completely
different usage paradigm from current users and will need an entirely different
set of tools.

You are vastly exceeding the one value per file rule of sysfs.

Please look at the i2c core and if at all possible build a proper interface to
your eeprom, that existing programs have a chance of utilizing rather than
extending sysfs in ways that means cli tools can not work with it.

Eric
