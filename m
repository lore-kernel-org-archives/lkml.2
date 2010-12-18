Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197Ab0LRWyk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Dec 2010 17:54:40 -0500
Received: from science.horizon.com ([71.41.210.146]:65255 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757186Ab0LRWyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Dec 2010 17:54:40 -0500
Date: 18 Dec 2010 17:54:36 -0500
Message-ID: <20101218225436.28264.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: bharrosh@panasas.com
Subject: Re: Big git diff speedup by avoiding x86 "fast string" memcmp
Cc: linux@horizon.com, linux-arch@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> static inline int dentry_memcmp_long(const unsigned char *cs,
> 				const unsigned char *ct, ssize_t count)
> {
> 	int ret;
> 	const unsigned long *ls = (const unsigned long *)cs;
> 	const unsigned long *lt = (const unsigned long *)ct;
> 
> 	while (count > 8) {
> 		ret = (*cs != *ct);
> 		if (ret)
> 			break;
> 		cs++;
> 		ct++;
> 		count-=8;
> 	}
> 	if (count) {
> 		unsigned long t = *ct & ((0xffffffffffffffff >> ((8 - count) * 8))
> 		ret = (*cs != t)
> 	}
> 
> 	return ret;
> }

First, let's get the code right, and use correct types, but also, there
are some tricks to reduce the masking cost.

As long as you have to mask one string, *and* don't have to worry about
running off the end of mapped memory, there's no additional cost to
masking both in the loop.  Just test (a ^ b) & mask.

#if 1	/* Table lookup */

static unsigned long const dentry_memcmp_mask[8] = {
#if defined(__LITTLE_ENDIAN)
	0xff, 0xffff, 0xffffff, 0xffffffff,
#if sizeof (unsigned long) > 4
	0xffffffffff, 0xffffffffffff, 0xffffffffffffff, 0xffffffffffffffff
#endif
#elif defined(__BIG_ENDIAN)
#if sizeof (unsigned long) == 4
	0xff000000, 0xffff0000, 0xffffff00, 0xffffffff
#else
	0xff00000000000000, 0xffff000000000000,
	0xffffff0000000000, 0xffffffff00000000,
	0xffffffffff000000, 0xffffffffffff0000,
	0xffffffffffffff00, 0xffffffffffffffff
#endif
#else
#error undefined endianness
#endif
};

#define dentry_memcmp_mask(count) dentry_memcmp_mask[(count)-1]

#else /* In-line code */

#if defined(__LITTLE_ENDIAN)
#define dentry_memcmp_mask(count) (-1ul >> (sizeof 1ul - (count)) * 8)
#elif defined(__BIG_ENDIAN)
#define dentry_memcmp_mask(count) (-1ul << (sizeof 1ul - (count)) * 8)
#else
#error undefined endianness

#endif

static inline bool dentry_memcmp_long(unsigned char const *cs,
				unsigned char const *ct, ssize_t count)
{
	unsigned long const *ls = (unsigned long const *)cs;
	unsigned long const *lt = (unsigned long const *)ct;

	while (count > sizeof *cs) {
		if (*cs != *ct)
			return true;
		cs++;
		ct++;
		count -= sizeof *cs;
	}
	/* Last 1..8 bytes */
	return ((*ct ^ *cs) & dentry_memcmp_mask(count)) != 0;
}

If your string is at least 8 bytes long, and the processor has fast unaligned
loads, you can skip the mask entirely by redundantly comparing some bytes
(although the code bloat is probably undesirable for inline code):

static inline bool dentry_memcmp_long(const unsigned char *cs,
				const unsigned char *ct, ssize_t count)
{
	unsigned long const *ls = (unsigned long const *)cs;
	unsigned long const *lt = (unsigned long const *)ct;

	if (count < sizeof *cs)
		return ((*ct ^ *cs) & dentry_memcmp_mask(count)) != 0;

	while (count > sizeof *cs) {
		if (*cs != *ct)
			return true;
		cs++;
		ct++;
		count -= sizeof *cs;
	}
	cs = (unsigned long const *)((char const *)cs + count - sizeof *cs);
	ct = (unsigned long const *)((char const *)ct + count - sizeof *ct);
	return *cs != *ct;
}
