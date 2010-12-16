Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755962Ab0LPNNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 08:13:52 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37764 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab0LPNNt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 08:13:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=fSJIftD7AW2Gx8IvaLHdaVD116p+7YcgnheG0SyLp2DQUwIcVXTsJMfboSHU8oipwR
         crJZzv7xCOcyYvBM7P27GlZn6pJH6//I3n8x+zzgiWmCbwfJtXu/XeW8RUmc2t92WiC4
         TOlq+qzU4JEWlUf1V7XfM8GUnba8CbvL7JoM4=
MIME-Version: 1.0
In-Reply-To: <4D09E185.2040600@panasas.com>
References: <12853.1292353313@jrobl>
	<AANLkTinjkcciZhJM5FmUkh_YCJ6bc9aTq8zV=SACDb1O@mail.gmail.com>
	<4D08BF5D.1060509@panasas.com>
	<20101215.100055.226772943.davem@davemloft.net>
	<4D09E185.2040600@panasas.com>
Date: Fri, 17 Dec 2010 00:13:47 +1100
Message-ID: <AANLkTin3v0BLYAuuqTgEzKgSOpVg4GJaJCEds=2ePrBH@mail.gmail.com>
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
From: Nick Piggin <npiggin@gmail.com>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: David Miller <davem@davemloft.net>, hooanon05@yahoo.co.jp,
        npiggin@kernel.dk, torvalds@linux-foundation.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 16, 2010 at 8:53 PM, Boaz Harrosh <bharrosh@panasas.com> wrote:
> On 12/15/2010 08:00 PM, David Miller wrote:
>> From: Boaz Harrosh <bharrosh@panasas.com>
>> Date: Wed, 15 Dec 2010 15:15:09 +0200
>>
>>> I agree that the byte-compare or long-compare should give you very close
>>> results in modern pipeline CPUs. But surly 12 increments-and-test should
>>> show up against 3 (or even 2). I would say it must be a better plan.
>>
>> For strings of these lengths the setup code necessary to initialize
>> the inner loop and the tail code to handle the sub-word ending cases
>> eliminate whatever gains there are.
>>
>
> You miss understood me. I'm saying that we know the beggining of the
> string is aligned and Nick offered to pad the last long, so surly
> a shift by 2 (or 3) + the reduction of the 12 dec-and-test to 3
> should give you an optimization?

Masking is still going to take a bit more code, but perhaps. We're talking
a handful of cycles here, so if you add a branch mispredict, or icache
miss, you'll kill your savings.

This is what I've got at the moment, which adds only 8 bytes over the
rep cmp variant, in the __d_lookup_rcu function.

static inline int dentry_memcmp(const unsigned char *cs,
                               const unsigned char *ct, size_t count)
{
       int ret;
       do {
               ret = (*cs != *ct);
               if (ret)
                       break;
               cs++;
               ct++;
               count--;
       } while (count);
       return ret;
}

Now if we pad and zero fill the dentry name, then we can compare with
the path string, but we still have to mask that guy (unfortunately, I
didn't consider that earlier) so it's not trivial and adds quite a bit of code
size and branches:

static inline int dentry_memcmp_long(const unsigned char *cs,
                               const unsigned char *ct, ssize_t count)
{
        const unsigned long *ls = (const unsigned long *)cs;
        const unsigned long *lt = (const unsigned long *)ct;

       int ret;
       do {
                unsigned long t = *lt;
                unsigned long s = *ls;
                int shift = 0;

                if (count < 8)
                        shift = (8 - count) * 8;
                t = t & (0xffffffffffffffff >> shift);
               ret = (s != t);
               if (ret)
                       break;
               ls++;
               lt++;
               count-=8;
       } while (count > 0);
       return ret;
}

Something like this should work on little endian. You'd have to coax gcc to
generate a cmov to get rid of that branch I think, because it won't be
predictable for small string lengths. But then you have to think about
icache...
