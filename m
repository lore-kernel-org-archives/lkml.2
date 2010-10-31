Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab0JaL61 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Oct 2010 07:58:27 -0400
Received: from smtp.nokia.com ([192.100.122.233]:30809 "EHLO
	mgw-mx06.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab0JaL6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Oct 2010 07:58:24 -0400
Subject: Re: sysfs and power management
From: Onkalo Samu <samu.p.onkalo@nokia.com>
Reply-To: samu.p.onkalo@nokia.com
To: ext Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Greg KH <gregkh@suse.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "alan@linux.intel.com" <alan@linux.intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <20101030140047.GA24464@khazad-dum.debian.net>
References: <1288177143.12206.22.camel@4fid08082>
	 <20101027124816.7087436a@linux.intel.com>
	 <62697B07E9803846BC582181BD6FB6B836EB2994F4@NOK-EUMSG-02.mgdnok.nokia.com>
	 <20101027152809.39701917@lxorguk.ukuu.org.uk>
	 <20101029195039.GA26401@suse.de>
	 <20101030140047.GA24464@khazad-dum.debian.net>
Content-Type: text/plain; charset="UTF-8"
Organization: Nokia Oyj
Date: Sun, 31 Oct 2010 13:57:55 +0200
Message-ID: <1288526275.2313.14.camel@noppispoppis.nmp.nokia.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 31 Oct 2010 11:58:02.0335 (UTC) FILETIME=[DEAADEF0:01CB78F2]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-30 at 16:00 +0200, ext Henrique de Moraes Holschuh
wrote:
> On Fri, 29 Oct 2010, Greg KH wrote:
> > back to sleep.  That's probably the best way to do this, as userspace
> > isn't going to open the sysfs file and not close it instantly anyway
> > after it has read the data (seeking on a sysfs file isn't really
> > recommended, even if it sometimes seems to work.)
> 
> Well, it is documented that seek(start of file) on sysfs works, and it
> is ABI already (some userspace uses it on poll/select-capable
> attributes).  So, maybe seek(somewhere that is not the start of the
> file) doesn't work -- and it should return an error in that case if it
> doesn't already...  but it is a lot more deterministic than "sometimes"
> ;-)
> 
> So yes, userspace will open() and not close() a sysfs attribute immediately
> afterwards.  It is not only shell crap that interfaces to the kernel over
> sysfs :-)
> 

What I would like to do is:

Control sensors operating mode and regulators based on the userspace
activity. If no-one is interested about the sensor, it can be turned
totally off including its operating power via regulator framework.

So far the only accepted interface for the small sensor seems to be
sysfs. I tried use misc device but it was not accepted.

For example ambient light sensor or proximity sensor may operate fully
under interrupts. There is no need to poll status which is fine with
sysfs. However, problem is that kernel driver have no idea if someone
keeps some sysfs entry open and waits for the data.

What I would like to have is just an indication that at least one of the
sysfs entries is opened by some application. When that condition is
true, the sensor would be powered on and kept running.
And similarly, then all the users has gone, turn the device off.

I can prepare a patch to show what I mean.

-Samu

> It would make a lot of sense to support the poll/select model on any
> sensor for which you have event-driven notifications of change from the
> hardware or firmware.
> 
> I don't know about open/close notifications, however.  Usually you need
> those when you're going to stream something to userspace, and there are FAR
> better interfaces to use in that case, such as the ring buffers used by the
> data acquisition devices, netlink (which userspace programmers seems not to
> like much :p), input devices, and generic character devices...
> 


