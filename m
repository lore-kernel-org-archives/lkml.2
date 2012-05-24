Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932183Ab2EXKMY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:12:24 -0400
Received: from www.linutronix.de ([62.245.132.108]:49727 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab2EXKMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:12:22 -0400
Date: Thu, 24 May 2012 12:12:14 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: "Luck, Tony" <tony.luck@intel.com>
cc: Chen Gong <gong.chen@linux.intel.com>, "bp@amd64.org" <bp@amd64.org>,
        "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: RE: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop
 CMC storm
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F30C0@ORSMSX104.amr.corp.intel.com>
Message-ID: <alpine.LFD.2.02.1205241033460.3231@ionos>
References: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com> <alpine.LFD.2.02.1205230859190.3231@ionos> <3908561D78D1C84285E8C5FCA982C28F192F2DD6@ORSMSX104.amr.corp.intel.com> <alpine.LFD.2.02.1205232044150.3231@ionos>
 <3908561D78D1C84285E8C5FCA982C28F192F30C0@ORSMSX104.amr.corp.intel.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 May 2012, Luck, Tony wrote:
> > If that's the case, then I really can't understand the 5 CMCIs per
> > second threshold for defining the storm and switching to poll mode.
> > I'd rather expect 5 of them in a row.
> 
> We don't have a lot of science to back up the "5" number (and
> can change it to conform to any better numbers if someone has
> some real data).
...
> needs - so I'd prefer to see some "good enough" number
> that meets the needs, rather than yet another /sys/...
> file that people can tweak.

Right. We are better of with a sane hard coded setting.

Now back to the design of this thing.

It switches into poll mode when it sees 5 CMCIs in a second. Now it
gets interesting.

The queued work will disable cmci on all cpus, but only set the poll
timer to CMCI poll interval on the cpu which handles the work, then
keep polling with the original poll interval. All other cpus are still
using the standard poll rate and observe the global state
cmci_storm_detected which they can reset at any arbitray point in time
and reenable the cmci.

So can you please explain how this is better than having this strict
per cpu and avoid all the mess which comes with that patch? The
approach of letting global state be modified in a random manner is
just doomed.

There is nothing wrong with having a cpu in poll mode and the other in
interrupt mode except there is a hardware requirement for that.

And as far as I understand the SDM there is no requirement. CMCI does
not require global state. It's explicitely per thread.

And for the case where an CMCI affects siblings or the whole package,
the CMCI is delivered to all affected ones. So in case of storm all of
them will be in the cmci interrupt handler and try to switch to poll
mode. So what's the point of doing that global instead of letting them
do their local thing?

That MCE code is convoluted enough already, so we really are better of
to do the straight forward and simple solution instead of artificially
doing a global state dance.

Thanks,

	tglx
