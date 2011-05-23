Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757380Ab1EWUQv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 16:16:51 -0400
Received: from mms3.broadcom.com ([216.31.210.19]:3124 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932937Ab1EWUQs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 16:16:48 -0400
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
Message-ID: <4DDAC0A0.2040906@broadcom.com>
Date: Mon, 23 May 2011 22:16:32 +0200
From: "Arend van Spriel" <arend@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17)
 Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: "George Spelvin" <linux@horizon.com>
cc: "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] lib: crc8: add new library module providing crc8
References: <20110522152503.16429.qmail@science.horizon.com>
In-Reply-To: <20110522152503.16429.qmail@science.horizon.com>
X-WSS-ID: 61C41E0A4NS11137649-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2011 05:25 PM, George Spelvin wrote:
>> This is a little-endian CRC, so x^8+x^7+x^6+x^4+x^2+1 is encoded with
>> the x^7 coefficient in bit 0, and the x^0 coefficient in bit 7.  (And the
>> x^8 coefficient is implicit and suppressed.)

Thanks. However, your code example is confusing.
>> You can fill in a CRC table for an arbitrary polynomial with
>>
>> #define POLY 0xAB	/* 1 + x^2 + x^4 + x^6 + x^7 (+ x^8) */
>> typedef uint8_t crc_type;	/* Must be an unsigned type */
>>
>> void
>> crc_le(crc_type const table[256], crc_type crc, u8 const *buf, size_t len)
>> {
>> 	while (len--)
>> 		crc = (crc>>  8) ^ table[(crc ^ *buf++)&  0xff];

Here is where my confusion starts. Shifting crc by 8 bits basically 
means 0 ^ table[], right?

>> 	return crc;
>> }
>>
>> If you care, the corresponding code for a big-endian CRC
>> (data and CRC transmitted msbit-first) is:
>>
>> void
>> crc_init_be(crc_type table[256], crc_type poly)
>> {
>> 	int i, j;
>> 	crc_type const msbit = ~(~(crc_type)0>>  1);	/* Must be unsigned */
>> 	crc_type t = msbit;
>>
>> 	table[0] = 0;
>>
>> 	for (i = 1; i<  256; i *= 2) {
>> 		t = (t<<  1) ^ (t&  msbit ? poly : 0);
>> 		for (j = 0; j<  i; j++)
>> 			table[i+j] = table[j] ^ t;
>> 	}
>> }
>>
>> void
>> crc_be(crc_type const table[256], crc_type crc, u8 const *buf, size_t len)
>> {
>> 	while (len--)
>> 		crc = (crc<<  8) ^ table[(crc>>  (8*sizeof crc - 8)) ^ *buf++];

Here is the other shift of crc that does not make sense to me.

Gr. AvS

-- 
Almost nobody dances sober, unless they happen to be insane.
-- H.P. Lovecraft --


