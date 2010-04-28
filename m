Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732Ab0D1NVT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 09:21:19 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64137 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0D1NVR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 09:21:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=TvPNiZpyGlPg5OxJuDbeDHuEd6JDu8f9IOCwfa/G8qesFS6F5HrPPPsMPmMuJBM7u4
         AzsUilwpFrY4187g0HmcVwBiTP3Ug4tPA5rMoTrRjIDmyWQ1JbNyL3Is7aqZ2VXzhkTX
         bTW9Zn+DznGXN5sNCg91K/4zUdkxTBCXDZXv4=
Date: Wed, 28 Apr 2010 15:21:15 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Arnd Bergmann <arnd@arndb.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>,
       Jan Blunck <jblunck@suse.de>, John Kacur <jkacur@redhat.com>
Subject: Re: [GIT PULL v2] Preparation for BKL'ed ioctl removal
Message-ID: <20100428132112.GC12017@nowhere>
References: <1271390201-20431-1-git-send-regression-fweisbec@gmail.com> <20100425173912.GA5375@nowhere> <20100426072541.GA25961@elte.hu> <201004261329.28427.arnd@arndb.de> <20100427092530.GD11348@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100427092530.GD11348@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 27, 2010 at 11:25:30AM +0200, Ingo Molnar wrote:
> 
> * Arnd Bergmann <arnd@arndb.de> wrote:
> 
> > On Monday 26 April 2010, Ingo Molnar wrote:
> > > This could be done all automated for a hundred old drivers if need to be. 
> > > There would be no bkl_ioctl's left.
> > 
> > I don't think it can be fully automated. [...]
> 
> Corner cases are not a problem as long as the risk of them going unnoticed is 
> lower than the risk of a manual conversion introducing bugs.
> 
> > [...] For the majority of the modules, your approach would work fine, but 
> > there are still the well-known pitfalls in corner cases:
> > 
> > - recursive uses in functions outside of ioctl (possibly none left
> >   after the TTY layer is done, but who knows)
> 
> Not a problem even if there's any such usage left: lockdep will sort those out 
> very quickly.
> 
> > - lock-order problems with other mutexes (see DRM)
> 
> This too will be mapped out very quickly via lockdep.


And the hung task detector too which is the last resort to detect
uncovered resource dependencies (was really useful for reiserfs).

But the problem is among those people who may use such ancient drivers,
I guess few of them will have those debug config enabled.

And because there are almost no testers of these drivers, nobody/few will ever
notice the problem.

 
> > - code that depends on autorelease to allow one ioctl while another
> >   is sleeping. (a small number of drivers)
> 
> This is a real issue, and in fact it's an unknown: there may be an unknown 
> number of random sleep points within BKL codepaths that is being relied on in 
> creative ways.
> 
> Note that by introducing a mutex we (in most cases) make the locking 
> _stricter_, so the biggest risk from that is a lockup - which will be 
> debuggable via lockdep.


So, as explained above, lockdep won't even help here.

I mean, for callsites that are obvious, say when it is clear that
the bkl is leaf lock or doesn't introduce uncovered resource dependencies due
to non-release on sleep, we should do such conversion. And I guess most
drivers that use the bkl follow this scheme.

But for the others (rares I think), the operation looks unsafe to me.
If we don't have the hardware to test the driver, then lockdep and hung
task detectors are going to be useless.

That said, once we reach that point with 4 users of bkl remaining, may
be that will be time to buy such hardware for a symbolic $1 in obscure
places and do the tests. Or just git-rm if we are too lazy.

