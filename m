Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756443Ab2DSURU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 16:17:20 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:58694 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751577Ab2DSURR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 16:17:17 -0400
Message-ID: <4F9072CA.6030903@gmail.com>
Date: Thu, 19 Apr 2012 13:17:14 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Borislav Petkov <bp@amd64.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        David Daney <ddaney@caviumnetworks.com>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
References: <1334794610-5546-1-git-send-email-hpa@zytor.com> <20120419092255.GA29542@aftab> <20120419092630.GD29542@aftab> <4F904541.2030200@zytor.com> <CA+55aFwMsm7zVqPjKptm38zJAbJpF=9e51ew7BP6S5YnoJa3ig@mail.gmail.com> <20120419173802.GI3221@aftab.osrc.amd.com> <4F90527B.7020005@zytor.com> <CA+55aFxhY1Ug5esj==Sm=o1Epg+NFnvFs74syqRxbYDbPQJEFA@mail.gmail.com> <9ff2e09c-57e4-455e-8614-1b3b17b652f4@email.android.com>
In-Reply-To: <9ff2e09c-57e4-455e-8614-1b3b17b652f4@email.android.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/19/2012 11:55 AM, H. Peter Anvin wrote:
> Either way I suggest picking up David's presorting patchset since it is already done and use its infrastructure for any further improvements.
>

It does have the advantage of already being implemented.  There was a 
little feedback on the kbuild portions of the patch.

If you would like, I will send an updated version of the patch.

> As far as a linear probe you get an average of n lookups with a packing density of 1-1/n so you are right; a linear probe with a density of say 1/2 is probably best.
>

I usually see exception table sizes on the order of 2^10 entries, so I 
have to wonder how much you really gain from an O(1) implementation.

David Daney

> Linus Torvalds<torvalds@linux-foundation.org>  wrote:
>
>> On Thu, Apr 19, 2012 at 10:59 AM, H. Peter Anvin<hpa@zytor.com>  wrote:
>>>
>>> I would argue that the O(1) hash makes things simpler as there is no
>>> need to deal with collisions at all.
>>
>> Most of the O(1) hashes I have seen more than made up for the trivial
>> complexity of a few linear lookups by making the hash function way
>> more complicated.
>>
>> A linear probe with a step of one really is pretty simple. Sure, you
>> might want to make the initial hash "good enough" to not often hit the
>> probing code, but doing a few linear probes is cheap.
>>
>> In contrast, the perfect linear hashes do crazy things like having
>> table lookups *JUST TO COMPUTE THE HASH*.
>>
>> Which is f*cking stupid, really. They'll miss in the cache just at
>> hash compute time, never mind at hash lookup. The table-driven
>> versions look beautiful in microbenchmarks that have the tables in the
>> L1 cache, but for something like the exception handling, I can
>> guarantee that *nothing* is in L1, and probably not even L2.
>>
>> So what you want is:
>> - no table lookups for hashing
>> - simple code (ie a normal "a multiply and a shift/mask or two") to
>> keep the I$ footprint down too
>> - you *will* take a cache miss on the actual hash table lookup, that
>> cannot be avoided, but linear probing at least hopefully keeps it to
>> that single cache miss even if you have to do a probe or two.
>>
>> Remember: this is very much a "cold-cache behavior matters" case. We
>> would never ever call this in a loop, at most we have loads that get a
>> fair amount of exceptions (but will go through the exception code, so
>> the L1 is probably blown even then).
>>
>>                          Linus
>

