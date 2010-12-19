Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab0LSPqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 10:46:12 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34512 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932271Ab0LSPqK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 10:46:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=a30H+I/A7KgL0a6zy6G58VOekGk267eEIClwdE1mEtl997t9a8FxdcEZVce92KHr4W
         PVycV1z52qXHOfR2gh19fJii0MvEhG2Xz5eET9c8GKHuYaHI0f+HD7W8lpylYXt03wDB
         1eOXdflH0jLkaYIbr6pLjIm4tdr9soSFc+ELo=
MIME-Version: 1.0
In-Reply-To: <20101218225436.28264.qmail@science.horizon.com>
References: <20101218225436.28264.qmail@science.horizon.com>
Date: Mon, 20 Dec 2010 02:46:07 +1100
Message-ID: <AANLkTikwUEBd1Ez75pQ7gw7ShZitwQOQcH6CvCdJV2np@mail.gmail.com>
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
From: Nick Piggin <npiggin@gmail.com>
To: George Spelvin <linux@horizon.com>
Cc: bharrosh@panasas.com, linux-arch@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 19, 2010 at 9:54 AM, George Spelvin <linux@horizon.com> wrote:
>> static inline int dentry_memcmp_long(const unsigned char *cs,
>>                               const unsigned char *ct, ssize_t count)
>> {
>>       int ret;
>>       const unsigned long *ls = (const unsigned long *)cs;
>>       const unsigned long *lt = (const unsigned long *)ct;
>>
>>       while (count > 8) {
>>               ret = (*cs != *ct);
>>               if (ret)
>>                       break;
>>               cs++;
>>               ct++;
>>               count-=8;
>>       }
>>       if (count) {
>>               unsigned long t = *ct & ((0xffffffffffffffff >> ((8 - count) * 8))
>>               ret = (*cs != t)
>>       }
>>
>>       return ret;
>> }
>
> First, let's get the code right, and use correct types, but also, there

You still used the wrong vars in the loop.

> are some tricks to reduce the masking cost.
>
> As long as you have to mask one string, *and* don't have to worry about
> running off the end of mapped memory, there's no additional cost to
> masking both in the loop.  Just test (a ^ b) & mask.

Using a lookup table I considered, but maybe not well enough. It is
another cacheline, but common to all lookups. So it could well be
worth it, let's keep your code around...

The big problem for CPUs that don't do well on this type of code is
what the string goes through during the entire syscall.

First, a byte-by-byte strcpy_from_user of the whole name string to
kernel space. Then a byte-by-byte chunking and hashing component
paths according to '/'. Then a byte-by-byte memcmp against the
dentry name.

I'd love to do everything with 8 byte loads, do the component
separation and hashing at the same time as copy from user, and
have the padded and aligned component strings and their hash
available... but complexity.

On my Westmere system, time to do a stat is 640 cycles plus 10
cycles for every byte in the string (this cost holds perfectly
from 1 byte name up to 32 byte names in my test range).
`git diff` average path name strings are 31 bytes, although this
is much less cache friendly, and over several components (my
test is just a single component).

But still, even if the base cost were doubled, it may still
spend 20% or so kernel cycles in name string handling.

This 8 byte memcpy takes my microbenchmark down to 8 cycles per
byte, so it may get several more % on git diff.

A careful thinking about the initial strcpy_from_user, and
hashing code could shave another few cycles off it. Well
worth investigating I think.
