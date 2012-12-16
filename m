Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752882Ab2LPMqL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Dec 2012 07:46:11 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.161]:24102 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752754Ab2LPMqK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Dec 2012 07:46:10 -0500
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8DFCng/+ALmLZYRFnZn15ELiOAuLr3NkII
X-RZG-CLASS-ID: mo00
Message-ID: <50CDC289.1030405@chronox.de>
Date: Sun, 16 Dec 2012 13:46:01 +0100
From: =?ISO-8859-1?Q?Stephan_M=FCller?= <smueller@chronox.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>, Jeff Liu <jeff.liu@oracle.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] avoid entropy starvation due to stack protection
References: <50C72800.20508@chronox.de> <20121212164321.a01c5641.akpm@linux-foundation.org> <50C98764.6050104@chronox.de> <50CB63A9.80409@chronox.de> <20121216003020.GC9016@thunk.org>
In-Reply-To: <20121216003020.GC9016@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.12.2012 01:30, schrieb Theodore Ts'o:
> On Fri, Dec 14, 2012 at 06:36:41PM +0100, Stephan Mueller wrote:
>>>> That patch is about one week from a mainline merge, btw.
>>> Initially I was also thinking about get_random_int. But stack protection
>>> depends on non-predictable numbers to ensure it cannot be defeated. As
>>> get_random_int depends on MD5 which is assumed to be broken now, I
>>> discarded the idea of using get_random_int.
> The original use of get_random_int() was for applications where the
> speed impact of using a heavierweight cryptographic primitive was not
> something which could be tolerated.
>
> However, the strength of get_random_int() is actually pretty good.
> Note that we never expose the full MD5 hash; we only export the first
> 32-bits of the hash.   So even if you ignore the effects of:
>
> 	hash[0] += current->pid + jiffies + get_cycles();

I see that, but I consider that just getting some time stamps, where the 
interesting high-resolution time stamp is not guaranteed to exist, 
calculate a broken hash and take some parts of that hash as a random 
value does not sound very promising, even for stack protection.

...
>
> What I would do instead is use an AES-based cryptographic random
> number generator.  That is, at boot time, grab enough randomness to
> for an AES key, and then use that key to create a cryptographic random
> number generator by encrypting a counter with said AES key.  This is a
> cryptographic primitive which has been very carefully studied, and for
> architectures where you have a hardware support for AES (including
> ARMv8, Power 7, Sparc T4, as well as x86 processors with the AES-NI
> instructions), this will be much faster and require much less memory
> and CPU resources than replicating the /dev/urandom infrastructure.

Well, we already have such an RNG in the kernel: the ansi_cprng out of 
the kernel crypto API. That RNG implements an ANSI X9.31 RNG with an AES 
core.

Maybe that RNG should be given more centerstage where it is seeded with 
good entropy where the seed key and the seed is at least having each 256 
bits of entropy? In this case we have a standard CSPRNG seeded with 
hardware-based entropy.

>
> Whether or not we really need this level of paranoia for hardening
> stack randomization I'll leave for someone else to decide.
> Personally, my philosophy is if someone has managed to get
> unprivileged shell acess, trying to protect against a privilege
> escalation attack is largely hopeless on most Linux systems.  The name

I would not concur with that statement because it would render all 
attempts to make the local system more secure irrelevant. ;-)

But that is just my view.

> of the game is to protect against someone who does not yet have the
> ability to run arbitrary unprivileged code on the system of interest.
> In that case, the attacker isn't going to be able to get access to the
> output of get_random_int(), so even if there was a cryptographic
> weakness where an attacker who had access to the get_random_int()
> output stream could guess the internal state of the MD5-based RNG, in
> the case of a remote attacker, they wouldn't have access to the output
> of the RNG in the first place.

Ciao
Stephan
