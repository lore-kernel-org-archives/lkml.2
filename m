Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab1CUPqE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 11:46:04 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752220Ab1CUPqC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 11:46:02 -0400
Message-ID: <4D8772B6.80302@redhat.com>
Date: Mon, 21 Mar 2011 11:45:58 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100505 Fedora/3.0.4-2.el6 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-kernel@vger.kernel.org, dzickus@redhat.com
Subject: Re: [PATCH]: SMBIOS: Add initial code and export version via sysfs
References: <20110317135754.25241.88177.sendpatchset@prarit.bos.redhat.com> <20110317193023.GA16790@kroah.com> <4D826718.3030001@redhat.com> <20110317200701.GB17827@kroah.com>
In-Reply-To: <20110317200701.GB17827@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

gregkh wrote:
>Sounds good, how are you going to do this?  In binary way (like efivars
>does it) or in text files like the current DMI code does?

gregkh wrote:
>What exactly are you
>trying to achive?  What do you want to show in sysfs and how do you
>expect it to look?

Greg, sorry for repeating myself in some of the below.  You're right in your
implication that I was not explaining myself very well.  I figured the
best thing to do was to start my argument from the beginning...

The last update to the DMI specification was in 2003.  It has since been
replaced by SMBIOS.  A new SMBIOS specification was released in February
2011.

While looking at the SMBIOS related code in the kernel, I noticed that the
DMI code was actually being overloaded to include SMBIOS structures and
that other sections of code (ia64 setup, x86 setup & pci, Dell platform
driver(s), the new PCI sysfs labe codel, hotplug drivers, the HP watchdog
driver, and the sigmatel sound driver, all used a method to derive values
from the SMBIOS structs.  Please note, that this list is very likely
incomplete.  I only did a search on 'smbios' in the kernel.

As I previously said, it would be nice if we did this in a single location
instead of throughout the kernel, and fix the overloading of the DMI code
currently in the kernel.

For now, my intention is to leave the code as similar to the DMI code as
possible.  That is, export the SMBIOS information via text files in
sysfs (although the layout of the files will obviously change, see below).

In this way we would limit the amount of change to external packages
(ie, initscripts, network init, etc.) to hopefully only filename changes.

I will create a new sysfs class, to temporarily exist next to the
current /sys/devices/virtual/dmi entry, which would export values from
SMBIOS.  I want to introduce this slowly and in several stages:

1.  Introduce the new SMBIOS infrastructure in a [relatively] simple patch,
and export the smbios version # to the kernel.

The model I had in mind was:

/sys/devices/virtual/smbios/id/

/sys/devices/virtual/smbios/id/[type#]/...

ie) a straight mapping of the smbios tables.  It should be up to the
individual
drivers & subsystems to link back to the files.  Of course, the SMBIOS code
would provide lookup functions similar to the ones provided by the existing
DMI code to aid drivers in their lookups.

2.  Export all of the SMBIOS information in the current (Feb 2011) spec.  If
all goes well I think the correct thing to do is to update
feature-removal-schedule.txt with a well-defined timeline at this point.

3.  Modify drivers to use the new SMBIOS table lookups, etc, instead of
DMI table lookups.  This is relatively easy, IMO.  I will try to keep
dmi* functions identical to the new smbios* lookup functions.  That code
works
well, and isn't in need of change.

4.  Notify external userspace programs of the change.  To be honest, I
haven't
thought much about this other than to take a couple of systems and see what
is using those values and let them know of the impending change.

[This next part is wishful thinking ;)] ... I suppose at some point it
would be
possible to put in a printk into the *existing* DMI sysfs files to indicate
that they were being deprecated.  I can certainly see how that would be
frowned upon; while it would be a loud nasty warning, it also might be one
of those warnings people just learn to ignore.

5.  After a release (or some other set period of time defined in
feature-removal-schedule.txt), remove the old DMI code.

I'm hoping to lean on what you did for the udev change, Greg.  IIRC, you
kept the old code and the new udev code in place for a while and then made
the final change after some time.  I can see that would be the best idea
here...

P.

