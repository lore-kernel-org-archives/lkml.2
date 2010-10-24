Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab0JXXlv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 19:41:51 -0400
Received: from borg.medozas.de ([188.40.89.202]:52188 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751316Ab0JXXlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 19:41:49 -0400
Date: Mon, 25 Oct 2010 01:41:48 +0200 (CEST)
From: Jan Engelhardt <jengelh@medozas.de>
To: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jens.axboe@oracle.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        gregkh@suse.de
Subject: Sync writeback still broken
In-Reply-To: <alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr>
Message-ID: <alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain> <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr> <20100215144938.GD3434@quack.suse.cz> <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr>
 <alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 2010-06-27 18:44, Jan Engelhardt wrote:
>On Monday 2010-02-15 16:41, Jan Engelhardt wrote:
>>On Monday 2010-02-15 15:49, Jan Kara wrote:
>>>On Sat 13-02-10 13:58:19, Jan Engelhardt wrote:
>>>> >> 
>>>> >> This fixes it by using the passed in page writeback count, instead of
>>>> >> doing MAX_WRITEBACK_PAGES batches, which gets us much better performance
>>>> >> (Jan reports it's up from ~400KB/sec to 10MB/sec) and makes sync(1)
>>>> >> finish properly even when new pages are being dirted.
>>>> >
>>>> >This seems broken.
>>>> 
>>>> It seems so. Jens, Jan Kara, your patch does not entirely fix this.
>>>> While there is no sync/fsync to be seen in these traces, I can
>>>> tell there's a livelock, without Dirty decreasing at all.
>
>What ultimately became of the discussion and/or the patch? 
>
>Your original ad-hoc patch certainly still does its job; had no need to 
>reboot in 86 days and still counting.

I still observe this behavior on 2.6.36-rc8. This is starting to 
get frustrating, so I will be happily following akpm's advise to 
poke people.

Thread entrypoint: http://lkml.org/lkml/2010/2/12/41

Previously, many concurrent extractions of tarballs and so on have been 
one way to trigger the issue; I now also have a rather small testcase 
(below) that freezes the box here (which has 24G RAM, so even if I'm 
lacking to call msync, I should be fine) sometime after memset finishes.

----
/* calculate all possible 32-bit hashes
   needs 16G of address space, so better have a 64-bit kernel at hand
 */
#define _GNU_SOURCE 1
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <errno.h>
#include <fcntl.h>
#include <limits.h>
#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
#define S_IRUGO (S_IRUSR | S_IRGRP | S_IROTH)
#define S_IWUGO (S_IWUSR | S_IWGRP | S_IWOTH)

#define jrot(x,k) (((x) << (k)) | ((x) >> (32 - (k))))

/* jhash_mix - mix 3 32-bit values reversibly. */
#define jhash_mix(a, b, c) { \
	a -= c; a ^= jrot(c,  4); c += b; \
	b -= a; b ^= jrot(a,  6); a += c; \
	c -= b; c ^= jrot(b,  8); b += a; \
	a -= c; a ^= jrot(c, 16); c += b; \
	b -= a; b ^= jrot(a, 19); a += c; \
	c -= b; c ^= jrot(b,  4); b += a; \
}

#define jhash_final(a, b, c) { \
	c ^= b; c -= jrot(b, 14); \
	a ^= c; a -= jrot(c, 11); \
	b ^= a; b -= jrot(a, 25); \
	c ^= b; c -= jrot(b, 16); \
	a ^= c; a -= jrot(c,  4);  \
	b ^= a; b -= jrot(a, 14); \
	c ^= b; c -= jrot(b, 24); \
}

static uint32_t hash_jlookup3(const void *vkey, size_t length)
{
	static const unsigned int JHASH_GOLDEN_RATIO = 0x9e3779b9;
	const uint8_t *key = vkey;
	uint32_t a, b, c;

	a = b = c = JHASH_GOLDEN_RATIO + length;
	/* All but the last block: affect some 32 bits of (a,b,c) */
	for (; length > 12; length -= 12, key += 12) {
		a += key[0] + ((uint32_t)key[1] << 8) +
		     ((uint32_t)key[2] << 16) + ((uint32_t)key[3] << 24);
		b += key[4] + ((uint32_t)key[5] << 8) +
		     ((uint32_t)key[6] << 16) + ((uint32_t)key[7] << 24);
		c += key[8] + ((uint32_t)key[9] << 8) +
		     ((uint32_t)key[10] << 16)+ ((uint32_t)key[11] << 24);
		jhash_mix(a, b, c);
	}

	switch (length) {
	case 12: c += ((uint32_t)key[11]) << 24;
	case 11: c += ((uint32_t)key[10]) << 16;
	case 10: c += ((uint32_t)key[9])  << 8;
	case  9: c += key[8];
	case  8: b += ((uint32_t)key[7]) << 24;
	case  7: b += ((uint32_t)key[6]) << 16;
	case  6: b += ((uint32_t)key[5]) << 8;
	case  5: b += key[4];
	case  4: a += ((uint32_t)key[3]) << 24;
	case  3: a += ((uint32_t)key[2]) << 16;
	case  2: a += ((uint32_t)key[1]) << 8;
	case  1: a += key[0];
		break;
	case  0: return c;
	}

	jhash_final(a,b,c);
	return c;
}

static uint32_t *freq;
static const unsigned long long freq_size = 0x100000000UL * sizeof(*freq);

static void map_freq(void)
{
	int fd;

	fd = open("jenkins3.frq", O_RDWR | O_CREAT, S_IRUGO | S_IWUGO);
	if (fd < 0) {
		perror("open");
		abort();
	}

	if (ftruncate(fd, freq_size) < 0) {
		perror("ftruncate");
		abort();
	}

	freq = mmap(NULL, freq_size, PROT_READ | PROT_WRITE,
	       MAP_SHARED, fd, 0);
	if (freq == NULL) {
		perror("mmap");
		abort();
	}
}

static inline void calc_all_hashes(void)
{
	uint32_t x, y;

	memset(freq, 0, freq_size);
	for (x = 0; x < UINT32_MAX; ++x) {
		if ((x & 0xFFFFF) == 0)
			fprintf(stderr, "\r\e[2K""fill: %08x", x);
		y = hash_jlookup3(&x, sizeof(x));
		if (freq[y] < UINT32_MAX)
			++freq[y];
	}
}

int main(void)
{
	map_freq();
	calc_all_hashes();
	return 0;
}
