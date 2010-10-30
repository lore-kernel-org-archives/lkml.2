Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762194Ab0J3A6F (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 20:58:05 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57536 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752187Ab0J3A6C convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 20:58:02 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr>
References: <20100212091609.GB1025@kernel.dk> <alpine.LFD.2.00.1002120722270.7792@localhost.localdomain>
 <alpine.LSU.2.01.1002131356250.20838@obet.zrqbmnf.qr> <20100215144938.GD3434@quack.suse.cz>
 <alpine.LSU.2.01.1002151629380.27775@obet.zrqbmnf.qr> <alpine.LSU.2.01.1006271842220.1495@obet.zrqbmnf.qr>
 <alpine.LNX.2.01.1010250115360.16022@obet.zrqbmnf.qr>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 29 Oct 2010 17:57:31 -0700
Message-ID: <AANLkTikBmewDmBJWHzdTerJE2W4GqRYMxLCdAJyz5JDB@mail.gmail.com>
Subject: Re: Sync writeback still broken
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        Greg KH <gregkh@suse.de>, Jens Axboe <jaxboe@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Guys, what is the status of this?

The original patch in that email thread still makes no sense and the
commit log for it cannot be the real issue. But the _problem_ seems to
be real, and the code is apparently a total mess, still.

And the chunking is necessary - as even quoted in that whole thread:

  On Tue, Feb 23, 2010 at 01:53:50PM +1100, Dave Chinner wrote:
  >
  > Ignoring nr_to_write completely can lead to issues like we used to
  > have with XFS - it would write an entire extent (8GB) at a time and
  > starve all other writeback. Those starvation problems - which were
  > very obvious on NFS servers - went away when we trimmed back the
  > amount to write in a single pass to saner amounts...

so we can't just stay with one single inode and do that one
completely. At the same time, the VFS chunking code itself is at least
supposed to try to write out 4MB at a time, which means that the whole
"only 400kB/s throughput" thing is pretty damn unlikely - but if it's
true, then that obviously means that the chunking is somehow broken.

IOW, we haven't seemed to get anywhere, and I haven't seen anybody
reply to Jan's plaintive email. Anybody?

                         Linus

On Sun, Oct 24, 2010 at 4:41 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
>>
>>What ultimately became of the discussion and/or the patch?
>>
>>Your original ad-hoc patch certainly still does its job; had no need to
>>reboot in 86 days and still counting.
>
> I still observe this behavior on 2.6.36-rc8. This is starting to
> get frustrating, so I will be happily following akpm's advise to
> poke people.
>
> Thread entrypoint: http://lkml.org/lkml/2010/2/12/41
>
> Previously, many concurrent extractions of tarballs and so on have been
> one way to trigger the issue; I now also have a rather small testcase
> (below) that freezes the box here (which has 24G RAM, so even if I'm
> lacking to call msync, I should be fine) sometime after memset finishes.
>
> ----
> /* calculate all possible 32-bit hashes
>   needs 16G of address space, so better have a 64-bit kernel at hand
>  */
> #define _GNU_SOURCE 1
> #include <sys/mman.h>
> #include <sys/stat.h>
> #include <sys/types.h>
> #include <errno.h>
> #include <fcntl.h>
> #include <limits.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
>
> #define ARRAY_SIZE(x) (sizeof(x) / sizeof(*(x)))
> #define S_IRUGO (S_IRUSR | S_IRGRP | S_IROTH)
> #define S_IWUGO (S_IWUSR | S_IWGRP | S_IWOTH)
>
> #define jrot(x,k) (((x) << (k)) | ((x) >> (32 - (k))))
>
> /* jhash_mix - mix 3 32-bit values reversibly. */
> #define jhash_mix(a, b, c) { \
>        a -= c; a ^= jrot(c,  4); c += b; \
>        b -= a; b ^= jrot(a,  6); a += c; \
>        c -= b; c ^= jrot(b,  8); b += a; \
>        a -= c; a ^= jrot(c, 16); c += b; \
>        b -= a; b ^= jrot(a, 19); a += c; \
>        c -= b; c ^= jrot(b,  4); b += a; \
> }
>
> #define jhash_final(a, b, c) { \
>        c ^= b; c -= jrot(b, 14); \
>        a ^= c; a -= jrot(c, 11); \
>        b ^= a; b -= jrot(a, 25); \
>        c ^= b; c -= jrot(b, 16); \
>        a ^= c; a -= jrot(c,  4);  \
>        b ^= a; b -= jrot(a, 14); \
>        c ^= b; c -= jrot(b, 24); \
> }
>
> static uint32_t hash_jlookup3(const void *vkey, size_t length)
> {
>        static const unsigned int JHASH_GOLDEN_RATIO = 0x9e3779b9;
>        const uint8_t *key = vkey;
>        uint32_t a, b, c;
>
>        a = b = c = JHASH_GOLDEN_RATIO + length;
>        /* All but the last block: affect some 32 bits of (a,b,c) */
>        for (; length > 12; length -= 12, key += 12) {
>                a += key[0] + ((uint32_t)key[1] << 8) +
>                     ((uint32_t)key[2] << 16) + ((uint32_t)key[3] << 24);
>                b += key[4] + ((uint32_t)key[5] << 8) +
>                     ((uint32_t)key[6] << 16) + ((uint32_t)key[7] << 24);
>                c += key[8] + ((uint32_t)key[9] << 8) +
>                     ((uint32_t)key[10] << 16)+ ((uint32_t)key[11] << 24);
>                jhash_mix(a, b, c);
>        }
>
>        switch (length) {
>        case 12: c += ((uint32_t)key[11]) << 24;
>        case 11: c += ((uint32_t)key[10]) << 16;
>        case 10: c += ((uint32_t)key[9])  << 8;
>        case  9: c += key[8];
>        case  8: b += ((uint32_t)key[7]) << 24;
>        case  7: b += ((uint32_t)key[6]) << 16;
>        case  6: b += ((uint32_t)key[5]) << 8;
>        case  5: b += key[4];
>        case  4: a += ((uint32_t)key[3]) << 24;
>        case  3: a += ((uint32_t)key[2]) << 16;
>        case  2: a += ((uint32_t)key[1]) << 8;
>        case  1: a += key[0];
>                break;
>        case  0: return c;
>        }
>
>        jhash_final(a,b,c);
>        return c;
> }
>
> static uint32_t *freq;
> static const unsigned long long freq_size = 0x100000000UL * sizeof(*freq);
>
> static void map_freq(void)
> {
>        int fd;
>
>        fd = open("jenkins3.frq", O_RDWR | O_CREAT, S_IRUGO | S_IWUGO);
>        if (fd < 0) {
>                perror("open");
>                abort();
>        }
>
>        if (ftruncate(fd, freq_size) < 0) {
>                perror("ftruncate");
>                abort();
>        }
>
>        freq = mmap(NULL, freq_size, PROT_READ | PROT_WRITE,
>               MAP_SHARED, fd, 0);
>        if (freq == NULL) {
>                perror("mmap");
>                abort();
>        }
> }
>
> static inline void calc_all_hashes(void)
> {
>        uint32_t x, y;
>
>        memset(freq, 0, freq_size);
>        for (x = 0; x < UINT32_MAX; ++x) {
>                if ((x & 0xFFFFF) == 0)
>                        fprintf(stderr, "\r\e[2K""fill: %08x", x);
>                y = hash_jlookup3(&x, sizeof(x));
>                if (freq[y] < UINT32_MAX)
>                        ++freq[y];
>        }
> }
>
> int main(void)
> {
>        map_freq();
>        calc_all_hashes();
>        return 0;
> }
>
