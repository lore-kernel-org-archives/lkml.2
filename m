Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab0DZH03 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 03:26:29 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:53363 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754533Ab0DZH02 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 03:26:28 -0400
Date: Mon, 26 Apr 2010 09:25:41 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Message-ID: <20100426072541.GA25961@elte.hu>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com>
 <201004242154.02421.arnd@arndb.de>
 <alpine.LFD.2.00.1004241258140.3739@i5.linux-foundation.org>
 <201004242240.51176.arnd@arndb.de>
 <alpine.LFD.2.00.1004241510530.3739@i5.linux-foundation.org>
 <20100425173912.GA5375@nowhere>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100425173912.GA5375@nowhere>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Frederic Weisbecker <fweisbec@gmail.com> wrote:

> > And don't try to conflate the issue of ioctl and BKL. There are still 
> > code-paths that do lock_kernel() without the ioctl's, so the whole ioctl 
> > renaming has _zero_ to do with CONFIG_BKL.
> 
> It's true, but once it gets pushed down/dropped from every core parts (which 
> is what we are working on currently in parallel), lock_kernel() and 
> .bkl_ioctl is only going to be used by unmaintained drivers. This is the 
> time where having a CONFIG_BKL is going to make sense. And it won't be a 
> question of saving some bytes but improve efficiency of schedule() for those 
> who don't need such old or unmaintained drivers.

The scheduler will be helped most by getting rid of the BKL altogether. We are 
in reaching distance of that now ...

CONFIG_BKL would really just elongate the migration period, unnecessarily so.

> May be we should only start to focus on this new config once this state is 
> reached.

Once that state is achived we can just get rid of the BKL and mass-push 
per-driver mutexes into those remaining drivers - in a possibly scripted way. 
Something like:

  foo-driver.c

  DEFINE_MUTEX(foo_mutex);

  foo_ioctl()
  {
	mutex_lock(&foo_mutex);
	...
	mutex_unlock(&foo_mutex);
  }

  foo_open()
  {
	mutex_lock(&foo_mutex);
	...
	mutex_unlock(&foo_mutex);
  }

This could be done all automated for a hundred old drivers if need to be. 
There would be no bkl_ioctl's left.

That, even if it looks somewhat coarse is still better than having _yet 
another_ 'temporary transition'. The Big Kernel Lock was supposed to be 
transitionary to begin with. It's been 10+ years and counting :-)

	Ingo
