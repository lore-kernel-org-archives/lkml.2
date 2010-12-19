Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab0LSO2n (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 09:28:43 -0500
Received: from daytona.panasas.com ([67.152.220.89]:44053 "EHLO
	daytona.panasas.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753938Ab0LSO2l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 09:28:41 -0500
Message-ID: <4D0E1693.3040106@panasas.com>
Date: Sun, 19 Dec 2010 16:28:35 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: George Spelvin <linux@horizon.com>
CC: linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
References: <20101218225436.28264.qmail@science.horizon.com>
In-Reply-To: <20101218225436.28264.qmail@science.horizon.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 19 Dec 2010 14:28:37.0967 (UTC) FILETIME=[0690A5F0:01CB9F89]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2010 12:54 AM, George Spelvin wrote:
>> static inline int dentry_memcmp_long(const unsigned char *cs,
>> 				const unsigned char *ct, ssize_t count)
>> {
>> 	int ret;
>> 	const unsigned long *ls = (const unsigned long *)cs;
>> 	const unsigned long *lt = (const unsigned long *)ct;
>>
>> 	while (count > 8) {
>> 		ret = (*cs != *ct);
>> 		if (ret)
>> 			break;
>> 		cs++;
>> 		ct++;
>> 		count-=8;
>> 	}
>> 	if (count) {
>> 		unsigned long t = *ct & ((0xffffffffffffffff >> ((8 - count) * 8))
>> 		ret = (*cs != t)
>> 	}
>>
>> 	return ret;
>> }
> 
> First, let's get the code right, and use correct types, but also, there
> are some tricks to reduce the masking cost.
> 
> As long as you have to mask one string, *and* don't have to worry about
> running off the end of mapped memory, there's no additional cost to
> masking both in the loop.  Just test (a ^ b) & mask.
> 
> #if 1	/* Table lookup */
> 
> static unsigned long const dentry_memcmp_mask[8] = {
> #if defined(__LITTLE_ENDIAN)
> 	0xff, 0xffff, 0xffffff, 0xffffffff,
> #if sizeof (unsigned long) > 4
> 	0xffffffffff, 0xffffffffffff, 0xffffffffffffff, 0xffffffffffffffff
> #endif
> #elif defined(__BIG_ENDIAN)
> #if sizeof (unsigned long) == 4
> 	0xff000000, 0xffff0000, 0xffffff00, 0xffffffff
> #else
> 	0xff00000000000000, 0xffff000000000000,
> 	0xffffff0000000000, 0xffffffff00000000,
> 	0xffffffffff000000, 0xffffffffffff0000,
> 	0xffffffffffffff00, 0xffffffffffffffff
> #endif
> #else
> #error undefined endianness
> #endif
> };
> 
> #define dentry_memcmp_mask(count) dentry_memcmp_mask[(count)-1]
> 
> #else /* In-line code */
> 
> #if defined(__LITTLE_ENDIAN)
> #define dentry_memcmp_mask(count) (-1ul >> (sizeof 1ul - (count)) * 8)
> #elif defined(__BIG_ENDIAN)
> #define dentry_memcmp_mask(count) (-1ul << (sizeof 1ul - (count)) * 8)
> #else
> #error undefined endianness
> 
> #endif
> 

Thanks Yes that fixes the _ENDIANness problem. and unsigned maths 

I was considering the table as well. The table might be better or not,
considering the pipe-line and the multiple-instructions-per-clock. x86
specially likes the operating on cost values. It should be tested
with both #ifs

> static inline bool dentry_memcmp_long(unsigned char const *cs,
> 				unsigned char const *ct, ssize_t count)
> {
> 	unsigned long const *ls = (unsigned long const *)cs;
> 	unsigned long const *lt = (unsigned long const *)ct;
> 
> 	while (count > sizeof *cs) {
> 		if (*cs != *ct)
> 			return true;
> 		cs++;
> 		ct++;
> 		count -= sizeof *cs;
> 	}
> 	/* Last 1..8 bytes */

what if at this point count == 0, I think you need the if (count) still

> 	return ((*ct ^ *cs) & dentry_memcmp_mask(count)) != 0;

	OK I like it, my version could be equally fast if the compiler
	would use cmov but not all ARChs have it.

> }
> 
> If your string is at least 8 bytes long, and the processor has fast unaligned
> loads, you can skip the mask entirely by redundantly comparing some bytes
> (although the code bloat is probably undesirable for inline code):
> 
> static inline bool dentry_memcmp_long(const unsigned char *cs,
> 				const unsigned char *ct, ssize_t count)
> {
> 	unsigned long const *ls = (unsigned long const *)cs;
> 	unsigned long const *lt = (unsigned long const *)ct;
> 
> 	if (count < sizeof *cs)
> 		return ((*ct ^ *cs) & dentry_memcmp_mask(count)) != 0;
> 
> 	while (count > sizeof *cs) {
> 		if (*cs != *ct)
> 			return true;
> 		cs++;
> 		ct++;
> 		count -= sizeof *cs;
> 	}
> 	cs = (unsigned long const *)((char const *)cs + count - sizeof *cs);
> 	ct = (unsigned long const *)((char const *)ct + count - sizeof *ct);
> 	return *cs != *ct;
> }

As Linus said, All this is mute, the qstr part of the compare is not long aligned
at the start. So I guess we come up loosing.

Thanks
Boaz
