Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751642Ab1F0Oyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 10:54:50 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:56556 "EHLO
	test.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab1F0Oyp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 10:54:45 -0400
Date: Mon, 27 Jun 2011 10:54:42 -0400
From: "Ted Ts'o" <tytso@mit.edu>
To: Sandy Harris <sandyinchina@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: random(4) driver questions
Message-ID: <20110627145442.GA2729@thunk.org>
Mail-Followup-To: Ted Ts'o <tytso@mit.edu>,
	Sandy Harris <sandyinchina@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <BANLkTinC7vfaRWf5TK9gJuQVtVwDkEQFcQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTinC7vfaRWf5TK9gJuQVtVwDkEQFcQ@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on test.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 25, 2011 at 01:51:07PM +0800, Sandy Harris wrote:
> There was a paper some time back by a group of Israeli researchers
> and looking at the Linux /dev/random driver, and claiming to find
> it wanting in several ways. www.pinkas.net/PAPERS/gpr06.pdf
> 
> To what extent have their objections been dealt with. If some
> were considered bogus, is there documentation somewhere
> explaining why?

Suffice it to say the random generator has changed significantly since
2006.  There is now a secondary pool, which uses catastrophic
reseeding, etc.

> One problem they pointed out is that there may be little
> entropy available on a Linux-based router; no keyboard or
> mouse, solid state storage so no disk entropy, and an
> enemy might observe network activity, so network
> interrupts give little or no useful entropy.

Sure, but a Linux-based router shouldn't be doing crypto work.  If it
*is* and it is important crypto work, then it needs a hardware random
number generator.  There's no magic here.

If you don't want to pay the cost of a random number generator, you
can do things such as at installation time, bootstrapping the random
number generator with some cryptographically secure randomness
available by the installation system.

> The only in-kernel solution I can think of would be
> to add something in the system call interface to
> make very system call throw timing information
> into the pool. I very much doubt, though, that that
> is a good idea. What do others think, and does
> anyone have a better idea?

It won't hurt (aside from wasting CPU time, assuming you don't add any
entropy credits), but won't necessarily help, either.

> What happens to /dev/random when it runs on
> a virtual machine and all the things it relies on
> for entropy get virtualised away?
> 
> The server that the VM is hosted on will usually
> have plenty of entropy, often a hardware RNG.
> Is there an interface that makes that visible
> from the VM? Perhaps a virtual "hardware"
> RNG driven by /dev/urandom on the host?

Yes, paravirtualizing the random number generator would be a big help.
Probably what I would do is to periodically add entropy from the host
OS to the guest OS, via some paravirt channel.  This would add a new
"catastrophic reseeding", and if the virtual guest can mix in some
other unknown material, again that can only help.

						- Ted
