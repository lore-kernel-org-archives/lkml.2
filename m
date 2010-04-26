Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752716Ab0DZL3m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 07:29:42 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:65121 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751052Ab0DZL3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 07:29:41 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Date: Mon, 26 Apr 2010 13:29:28 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, John Kacur <jkacur@redhat.com>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <20100425173912.GA5375@nowhere> <20100426072541.GA25961@elte.hu>
In-Reply-To: <20100426072541.GA25961@elte.hu>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004261329.28427.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX18gQmCT+mmIoRwebLC1OvQb7f6pTQiZWJ1PTCr
 BHFbAsW2V6C/G3szHvx2qOZK/vMnBn39/A7tpiJZY8ks4DBWgV
 HENaQMpkmcvJwzOOTcX5w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 26 April 2010, Ingo Molnar wrote:
> This could be done all automated for a hundred old drivers if need to be. 
> There would be no bkl_ioctl's left.

I don't think it can be fully automated. For the majority of the modules,
your approach would work fine, but there are still the well-known
pitfalls in corner cases:

- recursive uses in functions outside of ioctl (possibly none left
  after the TTY layer is done, but who knows)
- lock-order problems with other mutexes (see DRM)
- code that depends on autorelease to allow one ioctl while another
  is sleeping. (a small number of drivers)

Semi-automated should be fine though. These rules are relatively
easy to check, so we can mass-convert all the trivial cases.

Examples for nontrivial modules are mostly file systems, see ncpfs,
afs, hpfs, ...

> That, even if it looks somewhat coarse is still better than having _yet 
> another_ 'temporary transition'. The Big Kernel Lock was supposed to be 
> transitionary to begin with. It's been 10+ years and counting :-)

I think the immediate goal should be to get the BKL out of everthing
that's either used by real people or that's reasonably easy to do.
We have patches for almost all of these now [1], and I've been running
a kernel with CONFIG_BKL=n for a few weeks now. As we progress
through the remaining modules, an increasing number of systems can
run without this.

I see the next steps as:
1. make it possible to build a kernel without BKL, by removing the BKL
   from all core components for good, and making all users depend on
   CONFIG_BKL. Make it default y and put it under CONFIG_DEBUG.

2. Remove the BKL from all modules that are either easy to convert
   to a private mutex or that are relevant to real users (e.g.
   definitely DRM, but maybe not hpfs).

3. Change CONFIG_BKL to "default n, depends on DEPRECATED"

4. Remove the remaining modules that nobody knows how to fix
   or cares about. Possibly the number of modules here is close
   to zero.

5. Remove the implementation of the BKL, since no users are left.

Getting stage 1 done for 2.6.36 or even 2.6.35 should be possible but
still needs a lot of work. I think we should focus on that for now
and then see how much is left to do for the other stages.

This is still a temporary transition, but since we can't do all at
once, I don't see better way.

	Arnd

[1] http://kernelnewbies.org/BigKernelLock
