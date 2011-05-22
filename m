Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751606Ab1EVPZK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 11:25:10 -0400
Received: from science.horizon.com ([71.41.210.146]:36301 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750982Ab1EVPZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 11:25:06 -0400
Date: 22 May 2011 11:25:03 -0400
Message-ID: <20110522152503.16429.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: arend@broadcom.com, johannes@sipsolutions.net,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
Cc: linux@horizon.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> True, a different init value likely results in a different good value.

Actually, it doesn't.  The good value is only non-zero to compensate
for the final byte inversion.  You'll notice that it's equal to
crc8_table[0xff], where oxff is the XOR of the final result.

This is a little-endian CRC, so x^8+x^7+x^6+x^4+x^2+1 is encoded with
the x^7 coefficient in bit 0, and the x^0 coefficient in bit 7.  (And the
x^8 coefficient is implicit and suppressed.)

You can fill in a CRC table for an arbitrary polynomial with

#define POLY 0xAB	/* 1 + x^2 + x^4 + x^6 + x^7 (+ x^8) */
typedef uint8_t crc_type;	/* Must be an unsigned type */

void
crc_init_le(crc_type table[256], crc_type poly)
{
	int i, j;
	crc_type t = 1;

	table[0] = 0;

	for (i = 128; i; i >>= 1) {
		t = (t >> 1) ^ (t & 1 ? poly : 0);
		for (j = 0; j < 256; j += 2*i)
			table[i+j] = table[j] ^ t;
	}
}

void
crc_le(crc_type const table[256], crc_type crc, u8 const *buf, size_t len)
{
	while (len--)
		crc = (crc >> 8) ^ table[(crc ^ *buf++) & 0xff];
	return crc;
}

If you care, the corresponding code for a big-endian CRC
(data and CRC transmitted msbit-first) is:

void
crc_init_be(crc_type table[256], crc_type poly)
{
	int i, j;
	crc_type const msbit = ~(~(crc_type)0 >> 1);	/* Must be unsigned */
	crc_type t = msbit;

	table[0] = 0;

	for (i = 1; i < 256; i *= 2) {
		t = (t << 1) ^ (t & msbit ? poly : 0);
		for (j = 0; j < i; j++)
			table[i+j] = table[j] ^ t;
	}
}

void
crc_be(crc_type const table[256], crc_type crc, u8 const *buf, size_t len)
{
	while (len--)
		crc = (crc << 8) ^ table[(crc >> (8*sizeof crc - 8)) ^ *buf++];
	return crc;
}

This uses a left-justified CRC; the CRC is in the most significant bits
of the state variable.  To match the current crc7 code's result, it
must be right-shifted one bit.  (That would actually simplify all the
current users of the code, namely drivers/mmc/host/mmc_spi.c and
drivers/net/wireless/wl12??/spi.c, as well as the computation loop.)

The only other differences are the variable types and the actual polynomials.
