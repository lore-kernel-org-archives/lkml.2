Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1CADhq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 22:37:46 -0500
Received: from qmta15.westchester.pa.mail.comcast.net ([76.96.59.228]:45270
	"EHLO qmta15.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752800Ab1CADhp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 22:37:45 -0500
X-Greylist: delayed 342 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Feb 2011 22:37:45 EST
Message-ID: <4D6C68A4.3020306@gentoo.org>
Date: Mon, 28 Feb 2011 22:31:48 -0500
From: Kumba <kumba@gentoo.org>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; en-US; rv:1.9.2.13) Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Can I nest kobjects to create directories under parent directories
 for my driver?
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I'm attempting to write my first kernel driver for an RTC chip (Dallas/Maxim 
DS1685/DS1687), and running into a problem with using sysfs properly.  First 
off, a patch for this specific RTC was sent int to rtc-linux about two years 
ago, but never made it anywhere.  I based off of that and have pretty much 
re-written the thing since then.  It's undergoing a second re-write after some 
initial feedback from the rtc-linux folks.

What I'm trying to do, is, in sysfs, create individual attributes for the bits 
in each control register.  DS1685 defines 6 control registers (4 are the 
standard DS1286-style, and 2 are "extended" in another address bank).

I want to organize it such that:

# ls /sys/devices/platform/rtc-ds1685/
driver@  misc/  modalias  nvram  regs/  rtc/  subsystem@  uevent

And in regs/:
ctrla/  ctrlb/  ctrlc/  ctrld/  ctrl4a/  ctrl4b/

And under each register folder, the available bits for that register.  When 
read, each bit returns either a 0 or a 1, and certain bits can be made writable 
to change their values.

So I started investigating how to do this.  I first got it setup such that the 
ctrla through ctrl4b folders appeared in the top-level folder 
(/sys/devices/platform/rtc-ds1685).  Reading/writing to those worked fine.  But 
when I changed my code to nest those attribute groups under a "regs" kobject, 
any attempt to read or write the registers resulted in an Oops (or unaligned 
access, page fault, etc).

So far, I've determined that by attaching the "regs" kobject to the parent 
dev->kobj, and then attaching each attribute group kobject to the "regs" 
kobject, I lose the reference to the device structure holding all the relevant 
data for the RTC.  Thus, when I try to readb() or writeb() the RTC registers, I 
hit a NULL pointer and its lights out.

So I know I'm doing it wrong.  Question is, how can I do it right?  I've already 
looked into (and tried) ksets.  I'm not setting those up properly because I run 
into the same issue in the custom "show" function I have to write out where I 
don't have a valid reference to the live device structure.

I've gone through the kobject and kset examples, polled through quite a few 
drivers (some in drivers/rtc, some elsewhere), and looked over the sysfs, 
kobject, and device headers.  But because I'm still learning, I'm not 100% what 
I need to look for to accomplish this.  Everything else in the driver mostly 
works.  All this kobject debugging pointed out a few improper uses of spinlocks, 
and I optimized some other bits, but by and large, this thing is about ready to 
ship to rtc-linux for review (again).

I should add, I'm developing this on an SGI O2 (mips), which actually uses one 
of these RTCs.  The O2 currently taps into the rtc-cmos driver, which appears to 
provide baseline functionality.  None of my debugging points at flaws in the 
mips base or in the RTC system, so I'm directing my inquiry here to see if 
anyone has advice I can use to get this working.

Are ksets what I need to use, or can I nest kobjects together to accomplish 
things?  Or is there another way that I need to study up on?


Thanks!

-- 
Joshua Kinard
Gentoo/MIPS
kumba@gentoo.org

"The past tempts us, the present confuses us, the future frightens us.  And our 
lives slip away, moment by moment, lost in that vast, terrible in-between."

--Emperor Turhan, Centauri Republic
