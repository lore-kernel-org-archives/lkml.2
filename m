Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753225Ab2B0Gsd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 01:48:33 -0500
Received: from nctlincom01.orcon.net.nz ([60.234.4.74]:43263 "EHLO
	nctlincom01.orcon.net.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421Ab2B0Gsb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 01:48:31 -0500
Message-ID: <4F4B273C.9080506@orcon.net.nz>
Date: Mon, 27 Feb 2012 19:48:28 +1300
From: Michael Cree <mcree@orcon.net.nz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20120207 Icedove/3.0.11
MIME-Version: 1.0
To: Richard Henderson <rth@twiddle.net>
CC: Michel Lespinasse <walken@google.com>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matt Turner <mattst88@gmail.com>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: alpha: futex regression bisected
References: <4F420256.2090600@orcon.net.nz> <4F4282CA.5010502@twiddle.net>
In-Reply-To: <4F4282CA.5010502@twiddle.net>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-DSPAM-Check: by mx4.orcon.net.nz on Mon, 27 Feb 2012 19:48:29 +1300
X-DSPAM-Result: Innocent
X-DSPAM-Processed: Mon Feb 27 19:48:29 2012
X-DSPAM-Confidence: 0.7006
X-DSPAM-Probability: 0.0000
X-Bayes-Prob: 0.0001 (Score 0, tokens from: @@RPTN, default)
X-Spam-Score: 0.00 () [Hold at 5.00] 
X-CanIt-Geo: ip=60.234.221.162; country=NZ; region=E7; city=Auckland; latitude=-36.8667; longitude=174.7667; http://maps.google.com/maps?q=-36.8667,174.7667&z=6
X-CanItPRO-Stream: base:default
X-Canit-Stats-ID: 06GCSM54t - 7eabc50daf87 - 20120227
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/02/12 06:28, Richard Henderson wrote:
> On 02/20/12 00:20, Michael Cree wrote:
>> I have noticed some user space problems (pulseaudio crashes in pthread
>> code, glibc/nptl test suite failures, java compiler freezes on SMP alpha
>> systems) that arise when using a 2.6.39 or later kernel on Alpha.
>> Bisecting between 2.6.38 and 2.6.39 (using glibc/nptl test suite as
>> criterion for good/bad kernel) eventually leads to:
>>
>> 8d7718aa082aaf30a0b4989e1f04858952f941bc is the first bad commit
>> commit 8d7718aa082aaf30a0b4989e1f04858952f941bc
>> Author: Michel Lespinasse <walken@google.com>
>> Date:   Thu Mar 10 18:50:58 2011 -0800
>>
>>     futex: Sanitize futex ops argument types
>>
>>     Change futex_atomic_op_inuser and futex_atomic_cmpxchg_inatomic
>>     prototypes to use u32 types for the futex as this is the data type the
>>     futex core code uses all over the place.
> 
> 
> futex_atomic_cmpxchg_inatomic(u32 *uval, u32 __user *uaddr,
>                               u32 oldval, u32 newval)
> ...
>         :       "r"(uaddr), "r"((long)oldval), "r"(newval)
> 
> 
> There is no 32-bit compare instruction.  These are implemented by
> consistently extending the values to a 64-bit type.  Since the
> load instruction sign-extends, we want to sign-extend the other
> quantity as well (despite the fact it's logically unsigned).
> 
> So:
> 
> -        :       "r"(uaddr), "r"((long)oldval), "r"(newval)
> +        :       "r"(uaddr), "r"((long)(int)oldval), "r"(newval)
> 
> should do the trick.

Thanks, that fixes it.  Will you formally submit a patch with commit
message or should I?

You can have at least a Reviewed-by, or even an
Acked-by: Phil Carmody <ext-phil.2.carmody@nokia.com>
who correctly analysed the problem in response to when I suggested the
fix on the debian-alpha email list without explanation.

Cheers
Michael.
