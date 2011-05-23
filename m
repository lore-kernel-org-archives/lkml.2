Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757363Ab1EWULD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:11:03 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:45708 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757287Ab1EWULB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:11:01 -0400
Message-ID: <4DDABF44.8010806@tilera.com>
Date: Mon, 23 May 2011 16:10:44 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Eric Biederman <ebiederm@aristanetworks.com>
CC: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@suse.de>,
        <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: [PATCH] arch/tile: add arch/tile/drivers/ directory with SROM
 driver
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>	<4DD6FB9E.2050604@tilera.com>	<20110521032102.GD19907@suse.de>	<201105211133.50238.arnd@arndb.de>	<4DD7C3A7.5010402@tilera.com> <BANLkTim-d-8w1_idg4u302aB3MqTo7q4Sg@mail.gmail.com>
In-Reply-To: <BANLkTim-d-8w1_idg4u302aB3MqTo7q4Sg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/2011 11:50 AM, Eric Biederman wrote:
> On Sat, May 21, 2011 at 6:52 AM, Chris Metcalf <cmetcalf@tilera.com> wrote:
>> Interesting!  I did in fact assume that most tools that read or write
>> eeproms would tend to be "batch" tools, i.e. they would read or write
>> whatever it was they wanted, then exit; the tool we have that modifies this
>> EEPROM is written like that, for example.  It sounds like you're saying
>> there are (or may be) tools that open the file descriptor and do writes to
>> it, then don't exit or close the file descriptor, but expect the last write
>> to have hit the device immediately.  It's fair to say that since my
>> suggested API does defer the last sector's worth of writes until the app
>> exits, it potentially violates that assumption, so it's a bad idea.
> Plus the other gigantic difference that I have seen very few eeproms
> that can hold a sectors worth of data.
>
> My reading of this conversation is that you are confusing a configuration
> eeprom with a nor flash boot device.  That is a bit like confusing a yellow
> sticky not with the Encyclopedia Britannica.   They aren't at all the
> same thing.

Well, I don't think I'm confusing the two types of hardware, per se.  The
issue is that the hypervisor provides an API to Linux (or other operating
systems) that attempts to make them look reasonably similar.  In
particular, for the SPI ROM, the hypervisor implicitly manages background
reading of the sector data, doing a "diff" of new data to determine whether
a sector erase is required, and deferring the actual sector write until the
client attempts to write to a different sector.  (This last feature is why
an explicit "flush" is required.)

This approach (unlike mtdchar) provides a "transparent" mode for accessing
the SPI ROM.  Users of our character driver don't need to know they are
writing a flash device, don't need to worry about erasing/rewriting
sectors, etc.  We could potentially rework our boot ROM management tool to
support the mtdchar API, but it would be a modest pain, particularly since
we still have to support the normal file mode without "erase" ioctls, etc.,
for use in the "cross-compiling" mode that we offer with this tool.  And,
another Tilera tool that stores data in the SPI ROM for bootup
configuration would also have to be similarly reworked.  And, if any of our
customers have taken advantage of the part of the SPI ROM that is reserved
for applications, they'd have to make that change as well.  This seems like
a problem.  Plus, for what it's worth, it would make it impossible for us
to use our tools on top of another OS, since they'd be dependent on a
Linux-only interface.

None of this is impossible to change, but my sense is that a basically
trivial character device that makes use of the existing Tilera hypervisor's
virtualization of the flash ROM should not be particularly problematic.  It
is true that it may not be worth grouping with other flash ROM character
devices, since it has almost no "flash ROM" characteristics due to the
hypervisor virtualization, but I will leave that up to Arnd.  I'm happy to
add some comments to the driver explaining what makes it different.

I hope this adequately addresses your concerns.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


