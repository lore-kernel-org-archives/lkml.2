Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752830Ab1G2VRQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 17:17:16 -0400
Received: from mga09.intel.com ([134.134.136.24]:58208 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab1G2VRP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 17:17:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,288,1309762800"; 
   d="scan'208";a="32003048"
Message-ID: <4E33235A.5050700@linux.intel.com>
Date: Fri, 29 Jul 2011 14:17:14 -0700
From: "H. Peter Anvin" <hpa@linux.intel.com>
Organization: Intel Open Source Technology Center
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Fenghua Yu <fenghua.yu@intel.com>, Matt Mackall <mpm@selenic.com>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-kernel@vger.kernel.org
Subject: Re: [RFD] Direct support for the x86 RDRAND instruction
References: <1311971867-25124-1-git-send-email-hpa@linux.intel.com> <4E3320A2.1040808@pobox.com>
In-Reply-To: <4E3320A2.1040808@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2011 02:05 PM, Jeff Garzik wrote:
> 
> This does not cover the one question I [predictably] have:  why not do 
> this in rngd, rather than the kernel?
> 

That is actually why I didn't do the /dev/random aspect of this.  I have
an rngd enabling patch in the works as well.

The reason for not using RDRAND *only* in rngd is that it is a poor
match -- RDRAND is designed as a /dev/urandom-type replacement, but it
is *way* faster than the in-kernel system (since it is all in
hardware)... plus it is reseeded far more frequently than what is
possible in software (the architectural spec guarantees a reseed every
512 reads; I am told by the hardware people that in reality it is way
more frequent than that.)

For /dev/random, we do want to be hyper-conservative, though.  rngd in
its current form doesn't deal with fractional entropy, which means
boiling it down to guaranteed pure entropy; this is an enormous data
reduction and about three orders of magnitude reduction in bandwidth.
For /dev/random, I think that is just fine; after all, if you're asking
for /dev/random, you're asking for security at every cost.

> Since many (all?) TPM chips include a random number generator, Dell has 
> made sure that most distros have a useful copy of the rng-tools 
> userspace pkg I've been maintaining.
> 
> It would seem straightforward to add this to rngd, and enable RDRAND on 
> older distros and kernels, as well as current distros / kernels.  This 
> also gets useful entropy to /dev/random as part of normal operation, 
> rather than only merely speeding up /dev/urandom.
> 
> Though for the record, I do agree that this is a nice, small and clean 
> kernel implementation.

As previously stated, I have that patch in the works as well.

	-hpa
