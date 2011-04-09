Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755729Ab1DINKy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Apr 2011 09:10:54 -0400
Received: from ganesha.gnumonks.org ([213.95.27.120]:32911 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752176Ab1DINKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Apr 2011 09:10:53 -0400
Date: Sat, 9 Apr 2011 15:09:45 +0200
From: Harald Welte <laforge@gnumonks.org>
To: Lauro Ramos Venancio <lauro.venancio@openbossa.org>
Cc: linux-kernel@vger.kernel.org,
        Aloisio Almeida <aloisio.almeida@openbossa.org>,
        Arnd Bergmann <arnd@arndb.de>, Waldemar.Rymarkiewicz@tieto.com
Subject: Re: [RFC] NFC subsystem prototype
Message-ID: <20110409130945.GC3248@prithivi.gnumonks.org>
References: <BANLkTik1wb6Px+K+bBkzkt=dEMi_Xx3T3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTik1wb6Px+K+bBkzkt=dEMi_Xx3T3Q@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lauro,

On Wed, Apr 06, 2011 at 07:17:19PM -0300, Lauro Ramos Venancio wrote:
> As previously mentioned in this list, a NFC (Near Field Communication)
> subsystem is required to standardize the NFC device drivers
> development and create an unified userspace interface. This email
> describes our NFC subsystem proposal.

given that I've done quite some work on RFID (mifare, iso14443) and NFC
software + hardware some years ago, here is some feedback from my side:

0) why not create a general RFID subsystem instead of locking it down to
   NFC?  NFC is sort-of a superset of ISO 14443, so it would make more
   sense to have a generic framework that can support not only Mifare + NFC
   but all types of ISO 14443 (A / B) as well as ISO 15693.  This would mean
   other applications like electronic ID cards and ICAO-compliant passports
   would fit into the picture - even though not being NFC

1) do you really think a kernel subsystem is the best idea for this? 
   normally, the RFID/NFC ASIC is attached either to USB or serial lines,
   and there are no timing constraints against userspace drivers using libusb,
   like the existing libnfc or librfid.

   Yes, there may be multiple applications using RFID/NFC services, but
   if you look at e.g. the smart card frameworks like OpenCT and/or pcsc-lite,
   they can do that very well in userspace, without any kernel support.

   If you're worried about SPI-attached RFID/NFC ASICs, then I think the
   propper approach is to have a generic support for exporting SPI devices to
   userspace (similar to what we have with usb + libusb).

   I simply do not see the advantage of having this in the kenrel.  There are
   no latency/timing constraints, and the amount of data you are moving is so
   small, that performance considerations also don't really play any role.

2) even if you go for an in-kernel subsystem, what is your strategy for the
   many existing CL-RC5xx / CL-RC6xx ASIC based RFID/NFC readers?  For them,
   you typically need your own software implementation of the anti-collision
   procedures of 14443-3 (a+b) and the T=CL (14443-4) code.  All of this has
   been implemented in userspace e.g. librfid - but do you want to port or
   re-implement it all in kernel-land, and then 'glue' it below your current
   NFC subsystem approach?

Regards,
	Harald
-- 
- Harald Welte <laforge@gnumonks.org>           http://laforge.gnumonks.org/
============================================================================
"Privacy in residential applications is a desirable marketing option."
                                                  (ETSI EN 300 175-7 Ch. A6)
