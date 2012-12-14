Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756850Ab2LNRgy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 12:36:54 -0500
Received: from mail.eperm.de ([89.247.134.16]:1149 "EHLO mail.eperm.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752622Ab2LNRgx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 12:36:53 -0500
X-AuthUser: sm@eperm.de
Message-ID: <50CB63A9.80409@chronox.de>
Date: Fri, 14 Dec 2012 18:36:41 +0100
From: Stephan Mueller <smueller@chronox.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "Ted Ts'o" <tytso@mit.edu>, lkml <linux-kernel@vger.kernel.org>,
        Jeff Liu <jeff.liu@oracle.com>, Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] avoid entropy starvation due to stack protection
References: <50C72800.20508@chronox.de> <20121212164321.a01c5641.akpm@linux-foundation.org> <50C98764.6050104@chronox.de>
In-Reply-To: <50C98764.6050104@chronox.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.12.2012 08:44:36, +0100, Stephan Mueller <smueller@chronox.de> wrote:

Hi Andrew,
> On 13.12.2012 01:43:21, +0100, Andrew Morton
> <akpm@linux-foundation.org> wrote:
>
> Hi Andrew,
>> On Tue, 11 Dec 2012 13:33:04 +0100
>> Stephan Mueller <smueller@chronox.de> wrote:
>>
>>> Some time ago, I noticed the fact that for every newly
>>> executed process, the function create_elf_tables requests 16 bytes of
>>> randomness from get_random_bytes. This is easily visible when calling
>>>
>>> while [ 1 ]
>>> do
>>> 	cat /proc/sys/kernel/random/entropy_avail
>>> 	sleep 1
>>> done
>> Please see
>> http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
>>
>> That patch is about one week from a mainline merge, btw.
> Initially I was also thinking about get_random_int. But stack protection
> depends on non-predictable numbers to ensure it cannot be defeated. As
> get_random_int depends on MD5 which is assumed to be broken now, I
> discarded the idea of using get_random_int.
>
> Moreover, please consider that get_cycles is an architecture-specific
> function that on some architectures only returns 0 (For all
> architectures where this is implemented, you have no guarantee that it
> increments as a high-resolution timer). So, the quality of
> get_random_int is questionable IMHO for the use as a stack protector.
>
> Also note, that other in-kernel users of get_random_bytes may be
> converted to using the proposed kernel pool to avoid more entropy drainage.
>
> Please note that the suggested approach of fully seeding a deterministic
> RNG never followed by a re-seeding is used elsewhere (e.g. the OpenSSL
> RNG). Therefore, I think the suggested approach is viable.

I would like to add one more thing to consider. As the get_random_int
state depends on a relatively predictable timer reading, especially on
architectures without get_cycles(), hashed by MD5, it gains strength
(read unpredictability, entropy) over time. I.e. the more random numbers
are *randomly* extracted, the more random the value is.

Since many applications that are intended to benefit from stack
protection are started during boot time (e.g. the SSH daemon, Web
servers, Mail servers, other networking servers), I would conclude that
at the time these applications need random values, the strength behind
get_random_int is very low.

With my proposed patch, we have a similar strength than /dev/urandom but
without the drag on entropy during normal operation time -- i.e. the
time when cryptography comes into play triggered by normal users. Only
at that time the system needs to conserve entropy.
>
> Ciao
> Stephan
>

-- 
| Cui bono? |

