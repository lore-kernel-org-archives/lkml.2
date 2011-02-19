Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758717Ab1BSA12 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 19:27:28 -0500
Received: from www.tglx.de ([62.245.132.106]:36208 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753509Ab1BSA1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 19:27:24 -0500
Date: Sat, 19 Feb 2011 01:27:04 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
cc: David Brownell <dbrownell@users.sourceforge.net>,
        Grant Likely <grant.likely@secretlab.ca>,
        LKML <linux-kernel@vger.kernel.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: Deadlock in gpiolib
In-Reply-To: <20110218225407.GL22310@pengutronix.de>
Message-ID: <alpine.LFD.2.00.1102190028400.2701@localhost6.localdomain6>
References: <20110218225407.GL22310@pengutronix.de>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-1463795968-1491873736-1298075226=:2701"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---1463795968-1491873736-1298075226=:2701
Content-Type: TEXT/PLAIN; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT

On Fri, 18 Feb 2011, Uwe Kleine-König wrote:

Brilliant move to not CC the ones who explained you in detail why this
lockdep splat triggers and why it can lead to a real deadlock.

<SNIP>
 
> I tried to wrap my head around all that sysfs stuff and the implied
> locking, but I failed.

You did not even think about providing the information about the
already decoded problem and instead you post your findings as
something completely new and unexplainable.

Dude, that sucks and I'm seriously grumpy about that. As you are too
tired, I sat down and retrieved from the IRC logs what avoids people
to twist their brain around that clusterf*ck over and over.

<peterz>  
	 well, if you, like mentioned, assume sysfs_get/put_active() is a lock,
	 then what it did is: sysfs_get_active_lock(); mutex_lock(sysfs_lock);
	 vs mutex_lock(sysfs_lock); sysfs_deactivate();
	 where, sysfs_deactivate() can be considered to also want a ref
	 which gets you AB-BA

<tglx>
	export does
	lock(sysfs_lock) -> create sysfs entries 
	read does -> "read-lock(sysfs-entry)" -> lock(sysfs_lock)
	unexport does
	lock(sysfs_lock) -> remove sysfs entries, which needs to read_lock them 
	and looking at the implementation it can actually deadlock
	assume one reader vs one unexporter
	cat gpio74/value is in progress while on the other side you do echo 74 >unexport
	then the unexport will hang in wait for completion
	while the reader is waiting for sysfs lock in gpio

There is more info in those logs, but i'm too tired to extract it, so
here is my tentative conclusion in clear text:

sysfs_lock in gpio is only useful to serialize export
vs. unexport. The comment above the lock declaration 

/* lock protects against unexport_gpio() being called while
 * sysfs files are active.
 */

is stupid.

The only real concern is a concurrent instantiation of that sysfs
export vs. a teardown. That might be eventually be handled by the
EXPORT bit in the flags of that gpio chip, but I have not had time to
look at it closely.

Taking the gpio:sysfs_lock inside of the particular read/write
functions is pointless. If sysfs is not preventing the teardown of
that entry while access in progress then sysfs needs fixing.

AFAICT the refcounting in sysfs (which leads to that lockdep splat)
does the right thing, so taking gpiolib:sysfs_lock inside those
read/write functions which are associated with an exported gpio is
simply wrong.

I leave the deeper analysis to the gpio crowd and sysfs experts, but I
would be surprised if I'm wrong.

Thanks,

	tglx
---1463795968-1491873736-1298075226=:2701--
