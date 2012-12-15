Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752078Ab2LOW75 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 17:59:57 -0500
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:24314 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab2LOW74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 17:59:56 -0500
X-RZG-AUTH: :P2ERcEykfu11Y98lp/T7+hdri+uKZK8DFCng/+ALmLZYRFnZn15ELiOAuLr3NkII
X-RZG-CLASS-ID: mo00
Message-ID: <50CD00E2.5050104@chronox.de>
Date: Sat, 15 Dec 2012 23:59:46 +0100
From: =?UTF-8?B?U3RlcGhhbiBNw7xsbGVy?= <smueller@chronox.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: =?UTF-8?B?T25kxZllaiBCw61sa2E=?= <neleai@seznam.cz>
CC: Andrew Morton <akpm@linux-foundation.org>, "Ted Ts'o" <tytso@mit.edu>,
        lkml <linux-kernel@vger.kernel.org>, Jeff Liu <jeff.liu@oracle.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH] avoid entropy starvation due to stack protection
References: <50C72800.20508@chronox.de> <20121212164321.a01c5641.akpm@linux-foundation.org> <50C98764.6050104@chronox.de> <20121215191549.GA11036@domone.kolej.mff.cuni.cz>
In-Reply-To: <20121215191549.GA11036@domone.kolej.mff.cuni.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.12.2012 20:15, schrieb Ondřej Bílka:
> Why not use nonblocking pool and seed nonblocking pool only with half of
> collected entropy to get /dev/random in almost all practical scenarios
> nonblocking?

I would not recommend changing /dev/urandom. First, we would change the 
characteristic of a kernel interface a lot of user space cryptographic 
components rely on. According to Linus that is typically a no-go. 
Moreover, the question can be raised, where do we pick the number of 
50%, why not 30% or 70%, why (re)seeding it at all?

Also, let us assume we pick 50% and we leave the create_elf_tables 
function as is (i.e. it pulls from get_random_bytes), I fear that we do 
not win at all. Our discussed problem is the depletion of the entropy 
via nonblocking_pool due to every execve() syscall requires 128 bits of 
data from nonblocking_pool. Even if we seed nonblocking_pool more 
rarely, we still deplete the entropy of the input_pool and thus deplete 
the entropy we want for cryptographic purposes a particular user has.

Thus, my recommendation is to disconnect the system entropy requirements 
from the user entropy requirements as much as possible. I am aware that 
there are in-kernel cryptographic requirements that must seed itself via 
the good entropy. And those users shall be rather left untouched -- i.e. 
they should still call get_random_bytes.

But for users that do not require cryptographic strength, but a strength 
against guessing of a random number on the local system for a decent 
time (like the stack protection or ASLR), we can use a slightly less 
perfect DRNG which is seeded with good entropy and never thereafter.

Ciao
Stephan
>
> On Thu, Dec 13, 2012 at 08:44:36AM +0100, Stephan Mueller wrote:
>> On 13.12.2012 01:43:21, +0100, Andrew Morton
>> <akpm@linux-foundation.org>  wrote:
>>
>> Hi Andrew,
>>> On Tue, 11 Dec 2012 13:33:04 +0100
>>> Stephan Mueller<smueller@chronox.de>  wrote:
>>>
>>>> Some time ago, I noticed the fact that for every newly
>>>> executed process, the function create_elf_tables requests 16 bytes of
>>>> randomness from get_random_bytes. This is easily visible when calling
>>>>
>>>> while [ 1 ]
>>>> do
>>>> 	cat /proc/sys/kernel/random/entropy_avail
>>>> 	sleep 1
>>>> done
>>> Please see
>>> http://ozlabs.org/~akpm/mmotm/broken-out/binfmt_elfc-use-get_random_int-to-fix-entropy-depleting.patch
>>>
>>> That patch is about one week from a mainline merge, btw.
>> Initially I was also thinking about get_random_int. But stack protection
>> depends on non-predictable numbers to ensure it cannot be defeated. As
>> get_random_int depends on MD5 which is assumed to be broken now, I
>> discarded the idea of using get_random_int.
>>
>> Moreover, please consider that get_cycles is an architecture-specific
>> function that on some architectures only returns 0 (For all
>> architectures where this is implemented, you have no guarantee that it
>> increments as a high-resolution timer). So, the quality of
>> get_random_int is questionable IMHO for the use as a stack protector.
>>
>> Also note, that other in-kernel users of get_random_bytes may be
>> converted to using the proposed kernel pool to avoid more entropy drainage.
>>
>> Please note that the suggested approach of fully seeding a deterministic
>> RNG never followed by a re-seeding is used elsewhere (e.g. the OpenSSL
>> RNG). Therefore, I think the suggested approach is viable.
>>
>> Ciao
>> Stephan
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/

