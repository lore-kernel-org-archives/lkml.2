Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753104Ab1HKPeH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 11:34:07 -0400
Received: from science.horizon.com ([71.41.210.146]:49698 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752231Ab1HKPeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 11:34:04 -0400
Date: 11 Aug 2011 11:34:01 -0400
Message-ID: <20110811153401.21426.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: akpm@linux-foundation.org, fzago@systemfabricworks.com,
        joakim.tjernlund@transmode.se, linux-kernel@vger.kernel.org,
        linux@horizon.com, rpearson@systemfabricworks.com
Subject: Re: [patch v5 7/8] crc32-add-slicing-by-8.diff
In-Reply-To: <4E4309E4.2080108@systemfabricworks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I don't know if you care, but here's some slightly more compact code for
creating the tables.  It produces the same results, and I don't think
it's any slower.

I can explain it if anyone's confused, but it's hopefully fairly
easy to figure out assuming a backgriund in CRC math.

(Tested against existing code, not in kernel.)
Signed-off-by: George Spelvin <linux@horizon.com>

static void crc32init_le(void)
{
	unsigned i, j, k;
	uint32_t crc = 1;

	for (i = 0; i < LE_TABLE_ROWS; i++) {
		crc32table_le[i][0] = 0;
		for (j = LE_TABLE_SIZE >> 1; j; j >>= 1) {
			crc = (crc >> 1) ^ (crc & 1 ? CRCPOLY_LE : 0);
			for (k = 0; k < LE_TABLE_SIZE; k += 2 * j)
				crc32table_le[i][j + k] = crc ^ crc32table_le[i][k];
		}
	}
}

static void crc32init_be(void)
{
	unsigned i, j, k;
	uint32_t crc = 0x80000000;

	for (i = 0; i < BE_TABLE_ROWS; i++) {
		crc32table_be[i][0] = 0;
		for (j = 1; j < BE_TABLE_SIZE; j <<= 1) {
			crc = (crc << 1) ^ (crc & 0x80000000 ? CRCPOLY_BE : 0);
			for (k = 0; k < j; k++)
				crc32table_be[i][j + k] = crc ^ crc32table_be[i][k];
		}
	}
}
