Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab0HHT6w (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Aug 2010 15:58:52 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37115 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab0HHT6v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Aug 2010 15:58:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=NPQxfhub81x3tsfdPcfF6ydNzlCACTQAiGSnref0O1RePRJF+59mMRnvnRqkKTPQtz
         joMlM3V+ptZqATBOvIS2y405QJnTu1ph0eub/EHarodgM2XS9R9h8HVdXh4c23K9t0vb
         r6Urq3rvjUFr7WLT9wFHnFjQ3l6vxu+8EU5Bg=
Date: Sun, 8 Aug 2010 21:58:42 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Heiko Carstens <heiko.carstens@de.ibm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Li Zefan <lizf@cn.fujitsu.com>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>, Don Zickus <dzickus@redhat.com>
Subject: Re: [PATCH] lockup_detector: Make DETECT_HUNT_TASK default depend
	on LOCKUP_DETECTOR
Message-ID: <20100808195839.GA5387@nowhere>
References: <4C58C7FF.5060906@cn.fujitsu.com> <20100806005801.GB5436@nowhere> <20100807070135.GC23108@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100807070135.GC23108@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(More Cc)

On Sat, Aug 07, 2010 at 09:01:35AM +0200, Ingo Molnar wrote:
> 
> (Linus Cc:-ed)
> 
> * Frederic Weisbecker <fweisbec@gmail.com> wrote:
> 
> > On Wed, Aug 04, 2010 at 09:53:03AM +0800, Li Zefan wrote:
> > > CONFIG_DETECT_SOFTLOCKUP has been removed, so switch the
> > > default value to LOCKUP_DETECTOR.
> > > 
> > > Also fix the help text of BOOT_PRINTK_DELAY.
> > > 
> > > Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
> > > ---
> > 
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > 
> > Thanks.
> 
> The thing is, CONFIG_DETECT_SOFTLOCKUP was default-y before, so many people 
> had it enabled [and had it forced-enabled if DEBUG_KERNEL was off], even if 
> they didnt really want or need it.



Hmm. It was:

config DETECT_SOFTLOCKUP
	bool "Detect Soft Lockups"
	depends on DEBUG_KERNEL && !S390
	default y


It means it's default enabled only if DEBUG_KERNEL, right?
Then if you don't select CONFIG_DEBUG_KERNEL, it's fine as it won't
be selected.

But I agree with you. There is a bunch of config options for which
selection is a duty when you are a kernel developer:
PROVE_LOCKING, DETECT_HUNG_TASK, DEBUG_PREEMPT, PROVE_RCU, etc...
Because they all show (or prove we can have) bugs that one might miss
without these options. Softlockups are rarely part of them because even
without the lockup detector enabled, you'll observe something is wrong.



> So i turned off the new generic watchdog code's default intentionally - as it 
> clearly does not cure cancer ;-)


:-)


 
> I think distros will enable it, and most testers will as well. Those who dont 
> enable it and run into a lockup have an easy option to enable.



Why distros would want to enable it? The lockup detector introduces overhead.



> Maybe a better change would be to make it more generally available - right now 
> it's:
> 
>  config LOCKUP_DETECTOR
>          bool "Detect Hard and Soft Lockups"
>          depends on DEBUG_KERNEL && !S390
> 
> which means that it cannot be enabled when DEBUG_KERNEL is off.
> 
> So i think we should:
> 
>  - Remove the s390 hack and add an ARCH_HAS_LOCKUP_DETECTOR flag



If we do this, we'll need to add this config on every archs but s390.
We should better have ARCH_WANT_NO_LOCKUP_DETECTOR. I know that
"negative" meaning configs suck, but otherwise we would lose this
support on many archs.

Why s390 doesn't want the softlockup detector to begin with?



>  - Remove the DEBUG_KERNEL dependency


Yeah.

