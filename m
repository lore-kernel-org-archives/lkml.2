Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933452Ab2GYPUe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 11:20:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:55938 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933187Ab2GYPUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 11:20:33 -0400
Message-ID: <50100E93.1030809@zytor.com>
Date: Wed, 25 Jul 2012 08:19:47 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        torvalds@linux-foundation.org, w@1wt.eu, ewust@umich.edu,
        zakir@umich.edu, greg@kroah.com, mpm@selenic.com, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, tglx@linutronix.de, davem@davemloft.net,
        stable@kernel.org, DJ Johnston <dj.johnston@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH 07/10] random: add new get_random_bytes_arch() function
References: <1341511933-11169-1-git-send-email-tytso@mit.edu> <1341511933-11169-8-git-send-email-tytso@mit.edu> <500F69F3.3040905@zytor.com> <20120725151000.GA30996@thunk.org>
In-Reply-To: <20120725151000.GA30996@thunk.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 08:10 AM, Theodore Ts'o wrote:
>
> RDRAND is already getting mixed in already in xfer_secondary_pool() so
> we are already taking advantage of Bull Mountain (or any other
> CPU/architecture-specific hw RNG) if it is present.
>

You generate an arbitrary 16 or 32 bytes of RDRAND in one place, but 
that could be substantially less than the actual consumption.

My original tack was looking at doing this in extract_entropy and 
extract_entropy_user, but then I moved it to extract_buf since it looked 
simpler.

> Aside from whether it's better to do this step in
> xfer_secondary_pool() or extract_entropy(), your patch looks very
> wrong to me.  Nothing is actually *using* hash.l[], which is where the
> results of the RDRAND generator is placed.
>
> I assume you were planning on xor'ing hash.w and hash.l, but that's
> not present in your patch.
>
> I also don't understand why you are using a blind union here; it has
> no real advantage that I can see, and so it's all downside.  It bloats
> the patch (making it harder to see that your patch results in a net
> *decrease* in security, since it removes the use of RDRAND in
> xfer_security_pool, and replaces it with a no-op).
>

I don't know the term "blind union", but it is not an unnamed union is 
that is what you mean:

+	union {
+		__u32 w[5];
+		unsigned long l[LONGS(EXTRACT_SIZE)];
+	} hash;

This is a standard C declaration for hash.w and hash.l occupying the 
same memory, so your statement that "nothing uses hash.l" is just plain 
incorrect.  The reasons for using a union here is to make sure that the 
buffer is suitably aligned and padded to be able to be safely accessed 
via "unsigned long", even on architectures with alignment requirements. 
  Thus, xoring into hash.l modifies hash.w as well, so this is NOT a no-op.

Incidentally, this is exactly the same union construct you use before:

-	union {
-		__u32	tmp[OUTPUT_POOL_WORDS];
-		long	hwrand[4];
-	} u;

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

