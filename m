Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757876Ab0EETkW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:40:22 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:55682 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754980Ab0EETkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:40:18 -0400
Date: Wed, 5 May 2010 20:39:52 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Matthew Garrett <mjg@redhat.com>, Brian Swetland <swetland@google.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505193951.GB11441@sirena.org.uk>
References: <20100505185225.GA4411@srcf.ucam.org> <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 03:13:52PM -0400, Alan Stern wrote:

> Should the audio driver be smart enough to know that the codec needs to
> remain powered up during every opportunistic suspend?

> Or only during opportunistic suspends while a call is in progress?  

I think for simplicity and maximum flexibility we should just ignore the
reason for suspend here, if I'm adding support for this in the drivers
the suspend reason is not going to be terribly useful and it makes the
feature more widely useful should people come up with other applications.

Note that we already have advanced runtime PM for embedded audio which
will drive modern CODECs into full off state when the device is idle
anyway, independently of any suspend or runtime PM that the system does.
Older CODECs need their bias levels maintaining but we can ignore the
difference there from this point of view.

> Does it know when a call is in progress?

Not at present.  This is relatively straightforward to add within ASoC,
especially for analogue links, if not completely trivial.  Digital
basebands are a bit more fun but not insurmountable (and need cleaning
up anyway, there's some ongoing work which should hit soon).

We currently drive everything into off state when we're told to suspend
since it's the right thing to do for most non-phone devices.  We'll
still need to drive some of the system into an off state (eg, some of
the drivers in the CPU) even when this is handled.

> Does Android use forced suspends?

Pass, but it's not been an issue users have raised with me - but then
we can't tell why the suspend happens and need to handle opportunistic
suspend anyway.

> If it does, are they supposed to shut down the codec?

I suspect it's a non-issue; if we're not actually using audio then ASoC
will drive a modern CODEC into power off anyway as part of its runtime
PM.  However, I believe some non-Android phone stacks are doing
something along that line.
