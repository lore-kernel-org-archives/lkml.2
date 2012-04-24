Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab2DXVPb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:15:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:51224 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754233Ab2DXVP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:15:29 -0400
Message-ID: <4F9717E6.8030506@amacapital.net>
Date: Tue, 24 Apr 2012 14:15:18 -0700
From: Andy Lutomirski <luto@amacapital.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: [RFC][PATCH 0/3] gcc work-around and math128
References: <20120424161039.293018424@chello.nl>
In-Reply-To: <20120424161039.293018424@chello.nl>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2012 09:10 AM, Peter Zijlstra wrote:
> Hi all,
> 
> The SCHED_DEADLINE review resulted in the following three patches;
> 
> The first is a cleanup of various copies of the same GCC loop optimization
> work-around. I don't think this patch is too controversial, at worst I've
> picked a wrong name, but I wanted to get it out there in case people
> know more sites.
> 
> The second two implement a few u128 operations so we can do 128bit math.. I
> know a few people will die a little inside, but having nanosecond granularity
> time accounting leads to very big numbers very quickly and when you need to
> multiply them 64bit really isn't that much.

I played with some of this stuff awhile ago, and for timekeeping, it
seemed like a 64x32->96 bit multiply followed by a right shift was
enough, and that operation is a lot faster on 32-bit architectures than
a full 64x64->128 multiply.  Something like:

uint64_t mul_64_32_shift(uint64_t a, uint32_t mult, uint32_t shift)
{
  return (uint64_t)( ((__uint128_t)a * (__uint128_t)mult) >> shift );
}

or (untested, but compilable 32-bit gcc)

uint64_t mul_64_32_shift(uint64_t a, uint32_t mult, uint32_t shift)
{
  uint64_t part1 = ((a & 0xFFFFFFFFULL) * mult) >> shift;
  uint64_t part2 = ((a >> 32) * mult) << (32 - shift);
  return part1 + part2;
}

--Andy
