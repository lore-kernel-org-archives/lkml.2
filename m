Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab0IWUPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 16:15:15 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57688 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755091Ab0IWUPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 16:15:13 -0400
Date: Thu, 23 Sep 2010 21:36:54 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Richard Cochran <richardcochran@gmail.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, Christoph Lameter <cl@linux.com>,
        David Miller <davem@davemloft.net>, John Stultz <johnstul@us.ibm.com>,
        Krzysztof Halasa <khc@pm.waw.pl>,
        Peter Zijlstra <peterz@infradead.org>,
        Rodolfo Giometti <giometti@linux.it>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH v6 0/8] ptp: IEEE 1588 hardware clock support
Message-ID: <20100923213654.0c64b047@lxorguk.ukuu.org.uk>
In-Reply-To: <cover.1285261533.git.richard.cochran@omicron.at>
References: <cover.1285261533.git.richard.cochran@omicron.at>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>    So as far as the POSIX standard is concerned, offering a clock id
>    to represent the PHC would be acceptable.

But completely useless as you may have more than one entirely different
time managed by PTP and in which you are not master but must work with
the timebases provided.


>     /sys/class/timesource/<name>/id
>     /sys/class/ptp/ptp_clock_X/id
> 
>     Note: I am not too sure that this is exactly what people imagined,
>           but it is my best understanding so far. I gleaned two
>           different ideas about where to offer the clock id. In order
>           to keep just one way, I will be happy to remove the less
>           popular one.

I see no fix proposed for the race condition I pointed out. This doesn't
work.


>    If the Linux system time is synchronized to the PHC via the PPS

To which PHC we can have several

>    + Intel IXP465
>      - Auxiliary Slave/Master Mode Snapshot (optional interrupt)
>      - Target Time (optional interrupt)

And about 40 already supported by char driver interface clocks and rtcs
in the kernel...


I'd say the inability to have multiple clocks and the race condition
because of the clockid stuff leaves the proposal dead in the water.

It also ignores the existing APIs we have floating around attached to
devices.

You need to make one small important change. You need to take the POSIX
crap about enumerating things out and shoot it, bury it at a crossroads
and sprinkle holy water on it.

Drop the clockid_t and swap it for a file handle like a proper Unix or
Linux interface. The rest is much the same

	fd = open /sys/class/timesource/[whatever]

	various queries you may want to do to check the name etc

	fclock_adjtime(fd, ...)
	

The posix interface is fundamentally flawed. It only works for staticly
enumerable objects. Unix avoided that forty years ago by making the
identifier a handle which immediately cures all your object lifetime
problems in one swoop.

Namespace -> file handle translations are dynamic, but once you have it
open you hold on to the same object, which means you can check what you
have.



Alan
