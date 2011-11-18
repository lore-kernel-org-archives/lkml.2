Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756841Ab1KRWLA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Nov 2011 17:11:00 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:57218 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752382Ab1KRWK6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Nov 2011 17:10:58 -0500
MIME-Version: 1.0
In-Reply-To: <CAOJsxLFLxKGTzxjotAYv-d7Qzn5cqc1AGhXX0FSiK1i3to19Tg@mail.gmail.com>
References: <4EC4DA15.7090106@parallels.com> <20111117124831.688adbeb.akpm@linux-foundation.org>
 <4EC6246A.6020807@parallels.com> <20111118110716.c854b4bd.akpm@linux-foundation.org>
 <20111118200342.GC21041@moon> <20111118123728.554b45e7.akpm@linux-foundation.org>
 <20111118210322.GD21041@moon> <CAOJsxLFLxKGTzxjotAYv-d7Qzn5cqc1AGhXX0FSiK1i3to19Tg@mail.gmail.com>
From: Kyle Moffett <kyle@moffetthome.net>
Date: Fri, 18 Nov 2011 17:10:37 -0500
Message-ID: <CAGZ=bqJBWboHrh_zc4mWNK5DuY3vy1+QhrMosXK4nusfqDbRSQ@mail.gmail.com>
Subject: Re: [PATCH v2 0/4] Checkpoint/Restore: Show in proc IDs of objects
 that can be shared between tasks
To: Pekka Enberg <penberg@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Glauber Costa <glommer@parallels.com>,
        Andi Kleen <andi@firstfloor.org>, Tejun Heo <tj@kernel.org>,
        Matt Helsley <matthltc@us.ibm.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Vasiliy Kulikov <segoon@openwall.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 18, 2011 at 16:09, Pekka Enberg <penberg@kernel.org> wrote:
> On Fri, Nov 18, 2011 at 11:03 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>>> Of course.  But
>>>
>>> a) I'm not sure that this scheme actually protects the kernel
>>>    addresses - there may be way in which cunning userspace can work out
>>>    the random mask.
>>
>> Well, in case of hw-rng it should not be that easy, still of course
>> there is no 100% guarantee that there is absolutely no way to predict
>> this mask (espec since it's generated once at lives here forever). But
>> whatever makes attacker life harder -- is a good thing. After all we might
>> simply take some hash on kernel address here (such as sha256) since it's
>> not a time-critical operation and as far as I know collision is not found
>> for it yet (??).
>
> XOR cipher is very easy to crack with frequency analysis. I'd also
> consider using SHA256 or similar hash for this.

Some of the bits you don't even need to guess.  On 32-bit PPC, for
example, all kernel addresses have the top two bits set (0xC0000000 -
0xFFFFFFFF) and some of that space is reserved for virtual maps and
kernel code.  Additionally, all your significant datastructures are
probably allocated with kmalloc() and have 16-byte alignment or more,
so you only have maybe 24 or 25 bits (out of 32) with relevant
randomness.

Even then I'm sure you can brute-force that primitive XOR masking
pretty easily.  Just use memory pressure to get some large contiguous
chunks of free memory and then create lots of the relevant
datastructures... which will occur in linearly ascending order!
Examine the values from each "cookie" after large numbers of
allocations, if the highest bit to change was bit 20 and almost all of
the bits underneath it flip at the same time, then you know the real
value of bit X just changed from a 0 to a 1, so you know what the XOR
value for that bit is.

The #1 rule of one-time pads is never use it for more than one thing,
and you use it here for every object in the system.

If you actually want to be able to compare uniqueness without exposing
anything vulnerable to various kinds of guessing, you should generate
a random 64-bit value for each class of object and then use a proper
cryptographic hash function on it:
  crypto_hash(concat(object_ptr, random_value))

Even given the best possible practical attacks against SHA1 or MD5
today both still provides more than enough security to prevent someone
from guessing "object_ptr" in less than an absurd amount of time.

Cheers,
Kyle Moffett

-- 
Curious about my work on the Debian powerpcspe port?
I'm keeping a blog here: http://pureperl.blogspot.com/
