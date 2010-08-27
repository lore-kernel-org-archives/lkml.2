Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753327Ab0H0NVg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 09:21:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:49434 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753225Ab0H0NVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 09:21:33 -0400
Date: Fri, 27 Aug 2010 14:38:44 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Cochran <richardcochran@gmail.com>
Cc: john stultz <johnstul@us.ibm.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org, Krzysztof Halasa <khc@pm.waw.pl>,
        Rodolfo Giometti <giometti@linux.it>, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH 1/5] ptp: Added a brand new class driver for ptp clocks.
Message-ID: <20100827143844.646eccf6@lxorguk.ukuu.org.uk>
In-Reply-To: <20100827123849.GC11657@riccoc20.at.omicron.at>
References: <cover.1281956490.git.richard.cochran@omicron.at>
	<363bd749a38d0b785d8431e591bf54c38db4c2d7.1281956490.git.richard.cochran@omicron.at>
	<AANLkTik_2MKMhOuDGOmu8Kzyq-ipLe+Bxrb3FaD+Tv4U@mail.gmail.com>
	<20100817085324.GB3330@riccoc20.at.omicron.at>
	<1282090963.1734.97.camel@localhost>
	<20100818071942.GA4096@riccoc20.at.omicron.at>
	<1282176776.2865.100.camel@localhost.localdomain>
	<20100819055518.GA4084@riccoc20.at.omicron.at>
	<1282594125.3111.344.camel@localhost.localdomain>
	<20100827123849.GC11657@riccoc20.at.omicron.at>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 2007. If we can justify adding a clock id in this case, surely we can
> add one for PTP as well!

But PTP isn't really a clock - its a time sync protocol. You can (and may
need to) have multiple clocks of this form on the same host because it's
master based and you may have to deal with multiple masters who disagree.

> > Further, if we're using PTP to synchoronize the system time, then there
> > shouldn't be any measurable difference between CLOCK_PTP and
> > CLOCK_REALTIME, no?
> 
> When using software timestamping, then the clocks are one in the same.

Technically the POSIX clock is UTC, IEEE1588v2 is TAI.

> It would be possible, but not too nice, IMHO. In contrast to NTP,
> there is no real need to place the servo in the kernel. Having the
> protocol code and servo in user space makes life much easier.

We can't currently put it in the kernel anyway for other good reasons.

> viable approach. After the lkml discussion, I think it is even cleaner
> and nicer to just offer a new clock id.

PTP is not a clock, it's many clocks so a clock id doesn't really work.
You could assume a single time domain and add a CLOCK_TAI plus then use
PTP to track it I guess ?

The question then is who would consume it and how ?

Generic applications want POSIX time, which is managed by NTP but could
in userspace also be slewed via the existing API to track a PTP source if
someone wanted and if there is a GPS source around they can compute UTC
from it.

Specialist applications will presumably need to know which time source or
sources they are tracking and synchronizing too out of multiple potential
PTP sources

Kernel stuff is more of a problem.

I'm not sure shoehorning a source of many clocks and time sync bases into
a jump up and down and make it fit single time assumption is wise. Making
system time bimble track a source makes sense just as with NTP but making
it a new clock seems the wrong model extending a non-too-bright API when
you can just put the time sources in a file tree.

Alan
