Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751104Ab0FUELB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 00:11:01 -0400
Received: from n3d.bullet.mail.ac4.yahoo.com ([76.13.13.87]:31017 "HELO
	n3d.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750749Ab0FUELA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 00:11:00 -0400
X-Greylist: delayed 396 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Jun 2010 00:10:59 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 894491.55451.bm@omp118.mail.gq1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type;
  b=bHk4J+YYwA1ozWkGooNyqKnufn7Z5LVFHtQkApHL53JYNOfJApzu680e/SRoWCHmQyO0fXKlG1A0mIA394ITL21VdY/Fh3gEwGM3bizcupkkaB6cmb6X1JytHcCYG0nIHFEimVORobp0Nx5ICNoiT9KE+l0raaSQ/gKe+PHBLtk=;
Message-ID: <799617.66764.qm@web180304.mail.gq1.yahoo.com>
X-YMail-OSG: kD6agbsVM1ll67E5XfUF0eC0Mx.7pL06.ml9C5vh_FIy7Cw
 hvdLAxt.734xhnQpSnnciIXV.bV_OGJdJfJTg3lfc6YJAfZpzJib1GA72eix
 Qjg3tJTfOn.ogODDjcu4VXCuFBdVqFal_XqIYAfo5TjVVUTFmv51EG.FHdyU
 MXPXNWS7WxNPSPaYyPuUCzZuwMCIeET2l8PSfohFnyyDanifYXbWT24PYXuy
 Qcpb1MlusGCIESyUS2QrOLzg9dQRbSuiLjMzzyXbACMneYn6wiVUWTb0I_XO
 yzbczN8UnaFzUHIEqvA--
X-Mailer: YahooMailClassic/11.1.4 YahooMailWebService/0.8.103.269680
Date: Sun, 20 Jun 2010 21:04:22 -0700 (PDT)
From: David Brownell <david-b@pacbell.net>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Avoid losing wakeup events during suspend
To: markgross@thegnar.org, Alan Stern <stern@rowland.harvard.edu>
Cc: mark gross <640e9920@gmail.com>, Neil Brown <neilb@suse.de>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org
In-Reply-To: <Pine.LNX.4.44L0.1006202223440.29532-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > Indeed, the same problem arises if the event
> isn't delivered to
> > > userspace until after userspace is frozen.

Can we put this more directly:  the problem is
that the *SYSTEM ISN'T FULLY SUSPENDED* when the
hardware wake event triggers?  (Where "*SYSTEM*
includes userspace not just kernel.  In fact the
overall system is built from many subsystems,
some in the kernel and some in userspace.

At the risk of being prematurely general:  I'd
point out that these subsystems probably have
sequencing requirements.  kernel-then-user is
a degenerate case, and surely oversimplified.
There are other examples, e.g. between kernel
subsystems...  Like needing to suspend a PMIC
before the bus it uses, where that bus uses
a task to manage request/response protocols.
(Think I2C or SPI.)

This is like the __init/__exit sequencing mess...

In terms of userspace event delivery, I'd say
it's a bug in the event mechanism if taking the
next step in suspension drops any event.  It
should be queued, not lost...  As a rule the
hardware queuing works (transparently)...

> Of course, the underlying
> > > issue here is that the kernel has no direct way
> to know when userspace
> > > has finished processing an event.


Again said more directly:  there's no current
mechanism to coordinate subsystems.  Userspace
can't communicate "I'm ready" to kernel, and
vice versa.  (a few decades ago, APM could do
that ... we dropped such mechanisms though, and
I'm fairly sure APM's implementation was holey.)




