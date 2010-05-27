Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932220Ab0E0O7S (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 10:59:18 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:43092 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757894Ab0E0O7O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 10:59:14 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 May 2010 10:59:13 EDT
X-IronPort-AV: E=Sophos;i="4.53,311,1272844800"; 
   d="scan'208";a="123088"
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-ID: <19454.34430.471499.222290@mariner.uk.xensource.com>
Date: Thu, 27 May 2010 15:49:34 +0100
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
       "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
       Don Dutile <ddutile@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [Xen-devel] Re: [PATCH 11/11] Unplug emulated disks and nics
Newsgroups: chiark.mail.xen.devel
In-Reply-To: <m2n.s.1OHcBK-0018DA@chiark.greenend.org.uk>
References: <alpine.DEB.2.00.1005241615300.25605@kaball-desktop>
	<1274725657-1149-11-git-send-email-stefano.stabellini@eu.citrix.com>
	<4BFC3390.4060503@goop.org>
	<alpine.DEB.2.00.1005261325110.25605@kaball-desktop>
	<4BFD8BB0.90301@goop.org>
	<m2n.s.1OHcBK-0018DA@chiark.greenend.org.uk>
X-Mailer: VM 8.0.9 under Emacs 21.4.1 (i486-pc-linux-gnu)
From: Ian Jackson <Ian.Jackson@eu.citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefano Stabellini writes ("[Xen-devel] Re: [PATCH 11/11] Unplug emulated disks and nics"):
> On Wed, 26 May 2010, Jeremy Fitzhardinge wrote:
> > Wow, this interface is perverse.  It reuses the same IO port but changes
> > function depending on the size of the IO?  Again, wow.
>  
> Yeah, before you ask, I didn't write it :)

Yes, neither did I :-).  However, I did document it and now I also
maintain the "product number" registry.  Did you find the interface
spec ?  Enclosed below in case not.

I hereby allocate you ("pvops PV-on-HVM Linux, upstream") product
number 3.  Does the kernel have a way to distinguish between upstream
and other versions ?  Eg, there's the kernel version name suffix
thingy if I remember rightly.  Perhaps we should allocate a different
number for "some pvops pv-on-hvm Linux with a nonempty kernel version
name suffix".  Please advise.

You are welcome to use whatever you like for the "build number".
Perhaps the best thing would a two-byte encoding of the kernel version
number if that is possible.  As the purpose is logging and
blacklisting, it's not that critical although it's better to reuse the
same number for excessively similar builds than to use a random scheme
which might generate accidental clashes between unrelated versions.

Ian.


MAGIC IOPORT 0x10 PROTOCOL

The protocol covers three basic things:

-- Disconnecting emulated devices.
-- Getting log messages out of the drivers and into dom0.
-- Allowing dom0 to block the loading of specific drivers.  This is
   intended as a backwards-compatibility thing: if we discover a bug
   in some old version of the drivers, then rather than working around
   it in Xen, we have the option of just making those drivers fall
   back to emulated mode.

The current protocol works like this (from the point of view of
drivers):

1) When the drivers first come up, they check whether the unplug logic
   is available by reading a two-byte magic number from IO port 0x10.
   These should be 0x49d2.  If the magic number doesn't match, the
   drivers don't do anything.

2) The drivers read a one-byte protocol version from IO port 0x12.  If
   this is 0, skip to 6.

3) The drivers write a two-byte product number to IO port 0x12.  At
   the moment, the only drivers using this protocol are our
   closed-source ones, which use product number 1.

4) The drivers write a four-byte build number to IO port 0x10.

5) The drivers check the magic number by reading two bytes from 0x10
   again.  If it's changed from 0x49d2 to 0xd249, the drivers are
   blacklisted and should not load.

6) The drivers write a two-byte bitmask of devices to unplug to IO
   port 0x10.  The defined fields are:

   1 -- All IDE disks (not including CD drives)
   2 -- All emulated NICs
   4 -- All IDE disks except for the primary master (not including CD
	drives)

   The relevant emulated devices then disappear from the relevant
   buses.  For most guest operating systems, you want to do this
   before device enumeration happens.

...) Once the drivers have checked the magic number, they can send log
     messages to qemu which will be logged to wherever qemu's logs go
     (/var/log/xen/qemu-dm.log on normal Xen, dom0 syslog on
     XenServer).  These messages are written to IO port 0x12 a byte at
     a time, and are terminated by newlines.  There's a fairly
     aggressive rate limiter on these messages, so they shouldn't be
     used for anything even vaguely high-volume, but they're rather
     useful for debugging and support.

     It is still permitted for a driver to use this logging feature if
     it is blacklisted, but ONLY if it has checked the magic number
     and found it to be 0x49d2 or 0xd249.

This isn't exactly a pretty protocol, but it does solve the problem.


The blacklist is, from qemu's point of view, handled mostly through
xenstore.  A driver version is considered to be blacklisted if
/mh/driver-blacklist/{product_name}/{build_number} exists and is
readable, where {build_number} is the build number from step 4 as a
decimal number.  {product_name} is a string corresponding to the
product number in step 3.

The master registry of product names and numbers is in
qemu-xen-unstable's xenstore.c.
