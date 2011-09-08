Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932749Ab1IHNLa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 09:11:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932673Ab1IHNL3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 09:11:29 -0400
From: Steve Grubb <sgrubb@redhat.com>
Organization: Red Hat
To: Neil Horman <nhorman@redhat.com>
Subject: Re: [PATCH] random: add blocking facility to urandom
Date: Thu, 8 Sep 2011 09:11:12 -0400
User-Agent: KMail/1.13.7 (Linux/2.6.35.14-96.fc14.x86_64; KDE/4.6.5; x86_64; ; )
Cc: Tomas Mraz <tmraz@redhat.com>, Sasha Levin <levinsasha928@gmail.com>,
        "Ted Ts'o" <tytso@mit.edu>, Jarod Wilson <jarod@redhat.com>,
        linux-crypto@vger.kernel.org, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert.xu@redhat.com>,
        Stephan Mueller <stephan.mueller@atsec.com>,
        lkml <linux-kernel@vger.kernel.org>
References: <1314974248-1511-1-git-send-email-jarod@redhat.com> <1315464117.11199.51.camel@vespa.frost.loc> <20110908125234.GD13657@hmsreliant.think-freely.org>
In-Reply-To: <20110908125234.GD13657@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201109080911.12921.sgrubb@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, September 08, 2011 08:52:34 AM Neil Horman wrote:
> > to disk device - of course only if the device adds entropy into the
> > primary pool when there are writes on the device.
> 
> Yes, and thats a problem.  We're assuming in the above case that writes to
> disk generate interrupts which in turn generate entropy in the pool.  If
> that happens, then yes, it can be difficult (though far from impossible)
> to block on urandom with this patch and a sufficiently high blocking
> threshold.  But interrupt randomness is only added for interrupts flagged
> with
> IRQF_SAMPLE_RANDOM, and if you look, almost no hard irqs add that flag.  So
> its possible (and even likely) that writing to disk will not generate
> additional entropy.

The system being low on entropy is another problem that should be addressed. For our 
purposes, we cannot say take it from TPM or RDRND or any plugin board. We have to have 
the mathematical analysis that goes with it, we need to know where the entropy comes 
from, and a worst case entropy estimation. It has to be documented in detail. The only 
way we can be certain is if its based on system events. Linux systems are constantly 
low on entropy and this really needs addressing. But that is a separate issue. For 
real world use, I'd recommend everyone use a TPM chip + rngd and you'll never be short 
on random numbers. But in the case where we are certifying the OS, we need the 
mathematical argument to prove that unaided, things are correct.

 
> > Of course you can still easily make the /dev/urandom to occasionally
> > block with this patch, just read the data and drop it.
> > 
> > But you have to understand that the value that will be set with the
> > sysctl added by this patch will be large in the order of millions of
> > bits.
> 
> You can guarantee that?  

One proposal I made to Jarod was to add some minimum threshold that would prevent 
people from setting a value of 2, for example. Maybe the threshold could be set at 64K 
or higher depending on what number we get back from BSI.

> This sysctl allows for a setting of 2 just as  easily as it allows for a setting of
> 8,000,000.  And the former is sure to break or otherwise adversely affect
> applications that expect urandom to never block. Thats what Sasha was referring to,
> saying that patch makes it easy for admins to make serious mistakes.

Would a sufficiently high threshold make this easier to accept?

-Steve

