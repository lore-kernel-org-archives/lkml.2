Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab1HHJ2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 05:28:31 -0400
Received: from science.horizon.com ([71.41.210.146]:25177 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751023Ab1HHJ22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 05:28:28 -0400
Date: 8 Aug 2011 05:28:26 -0400
Message-ID: <20110808092826.21881.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: fzago@systemfabricworks.com, linux-kernel@vger.kernel.org
Subject: [PATCH] add slice by 8 algorithm to crc32.c
Cc: akpm@linux-foundation.org, joakim.tjernlund@transmode.se,
        linux@horizon.com, rpearson@systemfabricworks.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry I didn't see this when first posted.

The "slice by 8" terminology is pretty confusing.  How about
"Extended Joakim Tjernlund's optimization from commit
836e2af92503f1642dbc3c3281ec68ec1dd39d2e to 8-way parallelism."

Which is essentally what you're doing.  The renaming of tab[0] to t0_le
and t0_be, and removal of the DO_CRC4 macro just increases the diff size.

If you're looking at speeding up the CRC through larger tables, have
you tried using 10+11+11-bit tables?  That would require 20K of tables
rather than 8K, but would reduce the number of table lookups per byte.


One more stunt you could try to increase parallelism: rather than maintain
the CRC in one register, maintain it in several, and only XOR and collapse
them at the end.

Start with your 64-bit code, but imagine that the second code block's
"q = *p32++" always loads 0, and therefore the whole block can be skipped.
(Since tab[0] = 0 for all CRC tables.)

This computes the CRC of the even words.  Then do a second one in parallel
for the odd words into a separate CRC register.  Then combine them at the end.
(Shift one up by 32 bits and XOR into the other.)

This would let you get away with 5K of tables: t4 through t7, and t0.
t1 through t3 could be skipped.


Ideally, I'd write all this code myself, but I'm a bit crunched at work
right now so wouldn't be able to get to it for a few days.



Another possible simplification to the startup code.  There's no need
to compute init_bytes explicitly; just loop until the pointer is aligned:

	while ((unsigned)buf & 3) {
		if (!len--)
			goto done;
#ifdef __LITTLE_ENDIAN
		i0 = *buf++ ^ crc;
		crc = t0_le[i0] ^ (crc >> 8);
#else
		i0 = *buf++ ^ (crc >> 24);
		crc = t0_le[i0] ^ (crc << 8);
#endif  
	}
	p32 = (u32 const *)buf;
	words = len >> 2;
	end_bytes = len & 3;


... although I'd prefer to keep the DO_CRC() and DO_CRC4 macros, and
extend them to the 64-bit case, to avoid the nested #ifdefs.  That would
make:

	while ((unsigned)buf & 3) {
		if (!len--)
			goto done;
		DO_CRC(*buf++);
	}
	p32 = (u32 const *)buf;
	words = len >> 2;
	end_bytes = len & 3;
