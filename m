Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933335Ab2GYPKc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:10:32 -0400
Received: from li9-11.members.linode.com ([67.18.176.11]:41226 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933160Ab2GYPKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:10:31 -0400
Date: Wed, 25 Jul 2012 11:10:00 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
        zakir@umich.edu, greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org, DJ Johnson <dj.johnson@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 07/10] random: add new get_random_bytes_arch() function
Message-ID: <20120725151000.GA30996@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
	torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
	zakir@umich.edu, greg@kroah.com, mpm@selenic.com,
	nadiah@cs.ucsd.edu, jhalderm@umich.edu, tglx@linutronix.de,
	davem@davemloft.net, stable@kernel.org,
	DJ Johnson <dj.johnson@intel.com>, Ingo Molnar <mingo@kernel.org>
References: <1341511933-11169-1-git-send-email-tytso@mit.edu>
 <1341511933-11169-8-git-send-email-tytso@mit.edu>
 <500F69F3.3040905@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500F69F3.3040905@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 08:37:23PM -0700, H. Peter Anvin wrote:
> 
> As a compromise I offer the following patch; in terms of performance
> it is "the worst of both worlds" but it should provide the combined
> security of either; even if RDRAND is completely compromised by the
> NSA, Microsoft and the Illuminati all at once it will do no worse
> than the existing code, and (since RDRAND is so much faster than the
> existing code) it has only a modest performance cost.  More
> realistically, it will let many more users take advantage of a high
> entropy quick-reseeding random number generator, thus ending up with
> a major gain in security.

RDRAND is already getting mixed in already in xfer_secondary_pool() so
we are already taking advantage of Bull Mountain (or any other
CPU/architecture-specific hw RNG) if it is present.

Aside from whether it's better to do this step in
xfer_secondary_pool() or extract_entropy(), your patch looks very
wrong to me.  Nothing is actually *using* hash.l[], which is where the
results of the RDRAND generator is placed.

I assume you were planning on xor'ing hash.w and hash.l, but that's
not present in your patch.

I also don't understand why you are using a blind union here; it has
no real advantage that I can see, and so it's all downside.  It bloats
the patch (making it harder to see that your patch results in a net
*decrease* in security, since it removes the use of RDRAND in
xfer_security_pool, and replaces it with a no-op).

		    		    	   - Ted
