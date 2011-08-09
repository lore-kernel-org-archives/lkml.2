Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753040Ab1HILVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Aug 2011 07:21:21 -0400
Received: from science.horizon.com ([71.41.210.146]:31535 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752641Ab1HILVU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Aug 2011 07:21:20 -0400
Date: 9 Aug 2011 07:21:14 -0400
Message-ID: <20110809112114.3943.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        joakim.tjernlund@transmode.se, linux-kernel@vger.kernel.org,
        linux@horizon.com, rpearson@systemfabricworks.com
Subject: Re: [patch v3 6/7] crc32: add-slicing-by-8.diff
In-Reply-To: <4E40C55F.8070703@systemfabricworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While writing up some documentation of this algorithm, I came up with
a potential speedup.  Or, at least, realized why slicing by more than
4 is so much faster than slicing by 4 or less.

Note that the inner loop of the algorithm is as follows:

+#  define DO_CRC8a (tab[7][(q) & 255] ^ \
+		tab[6][(q >> 8) & 255] ^ \
+		tab[5][(q >> 16) & 255] ^ \
+		tab[4][(q >> 24) & 255])
+#  define DO_CRC8b (tab[3][(q) & 255] ^ \
+		tab[2][(q >> 8) & 255] ^ \
+		tab[1][(q >> 16) & 255] ^ \
+		tab[0][(q >> 24) & 255])

+	for (--b; middle_len; --middle_len) {
+		u32 q;
+		q = crc ^ *++b;
+		crc = DO_CRC8a;
+		q = *++b;
+		crc ^= DO_CRC8b;
 	}

Note the data dependencies: DO_CRC8a depends on the
previous crc, which depends on the previous DO_CRC8b.
But DO_CRC8b does not depend on anything except the
input data at *++b.

It would increase parallelism to schedule DO_CRC8b before DO_CRC8a,
to start those loads before the previous crc value is available.

Maybe the compiler and/pr processor can find this parallelism already,
but if not, it might be useful to try reordering it:

#  define DO_CRC8a(x) (tab[7][(x) & 255] ^ \
		tab[6][((x) >> 8) & 255] ^ \
		tab[5][((x) >> 16) & 255] ^ \
		tab[4][((x) >> 24) & 255])
#  define DO_CRC8b(x) (tab[3][(x) & 255] ^ \
		tab[2][((x) >> 8) & 255] ^ \
		tab[1][((x) >> 16) & 255] ^ \
		tab[0][((x) >> 24) & 255])

	for ( ; middle_len; --middle_len, b += 2) {
		u32 q = DO_CRC8b(b[1]);
		crc ^= b[0];
		crc = q ^ DO_CRC8a(crc);
	}
