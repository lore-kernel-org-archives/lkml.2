Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab1IHNuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:50:18 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48011 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932789Ab1IHNuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:50:16 -0400
Date: Thu, 8 Sep 2011 09:49:51 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: Steve Grubb <sgrubb@redhat.com>
Cc: Neil Horman <nhorman@redhat.com>, Tomas Mraz <tmraz@redhat.com>,
        Sasha Levin <levinsasha928@gmail.com>, "Ted Ts'o" <tytso@mit.edu>,
        Jarod Wilson <jarod@redhat.com>, linux-crypto@vger.kernel.org,
        Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] random: add blocking facility to urandom
Message-ID: <20110908134951.GA13633@hmsreliant.think-freely.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com>
 <1315464117.11199.51.camel@vespa.frost.loc>
 <20110908125234.GD13657@hmsreliant.think-freely.org>
 <201109080911.12921.sgrubb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109080911.12921.sgrubb@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: 0.2 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 08, 2011 at 09:11:12AM -0400, Steve Grubb wrote:
> On Thursday, September 08, 2011 08:52:34 AM Neil Horman wrote:
> > > to disk device - of course only if the device adds entropy into the
> > > primary pool when there are writes on the device.
> > 
> > Yes, and thats a problem.  We're assuming in the above case that writes to
> > disk generate interrupts which in turn generate entropy in the pool.  If
> > that happens, then yes, it can be difficult (though far from impossible)
> > to block on urandom with this patch and a sufficiently high blocking
> > threshold.  But interrupt randomness is only added for interrupts flagged
> > with
> > IRQF_SAMPLE_RANDOM, and if you look, almost no hard irqs add that flag.  So
> > its possible (and even likely) that writing to disk will not generate
> > additional entropy.
> 
> The system being low on entropy is another problem that should be addressed. For our 
> purposes, we cannot say take it from TPM or RDRND or any plugin board. We have to have 
> the mathematical analysis that goes with it, we need to know where the entropy comes 
> from, and a worst case entropy estimation. It has to be documented in detail. The only 
> way we can be certain is if its based on system events. Linux systems are constantly 
> low on entropy and this really needs addressing. But that is a separate issue. For 
> real world use, I'd recommend everyone use a TPM chip + rngd and you'll never be short 
> on random numbers. But in the case where we are certifying the OS, we need the 
> mathematical argument to prove that unaided, things are correct.
> 
I agree, it would be great if we had more entropy as a rule, but thats not
really what this patch is about.  Its about how we behave in our various
interfaces when we don't have entropy.

>  
> > > Of course you can still easily make the /dev/urandom to occasionally
> > > block with this patch, just read the data and drop it.
> > > 
> > > But you have to understand that the value that will be set with the
> > > sysctl added by this patch will be large in the order of millions of
> > > bits.
> > 
> > You can guarantee that?  
> 
> One proposal I made to Jarod was to add some minimum threshold that would prevent 
> people from setting a value of 2, for example. Maybe the threshold could be set at 64K 
> or higher depending on what number we get back from BSI.
> 
> > This sysctl allows for a setting of 2 just as  easily as it allows for a setting of
> > 8,000,000.  And the former is sure to break or otherwise adversely affect
> > applications that expect urandom to never block. Thats what Sasha was referring to,
> > saying that patch makes it easy for admins to make serious mistakes.
> 
> Would a sufficiently high threshold make this easier to accept?
> 

I don't know, but IMO, no.  The problems with this implementation go beyond just
picking the appropriate threshold.  As several others have commented, theres
problems:

1) With having a threshold at all - I still don't think its clear what a 'good'
theshold is and why.  I've seen 8,000,000 bytes beyond zero entropy tossed
about.  I presume thats used because its been shown that after 8,000,000 bytes
read beyond zero entropy, the internal state of the urandom device can be
guessed?  If so, how?  If not, what the magic number?

2) With the implementation.  There are still unaddressed concerns about
applications which expect urandom to never block living in conjunction with
applications that can tolerate it.  As you noted above entropy is in short
supply in Linux systems.  Regardless of what threshold you set, its possible
that it will not be high enough to prevent urandom blocking for indefinate
periods of time.  Not addressing this I think is a complete show stopper.  The
CUSE driver has been proposed as a solution here and I think its a good one.  It
lets those that are worried about this sort of attack mitigate it and leaves the
rest of the world alone (and ostensibly is auditable)

Neil

> -Steve
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-crypto" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
