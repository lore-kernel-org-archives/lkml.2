Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968Ab0D3XfP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 19:35:15 -0400
Received: from p01c12o149.mxlogic.net ([208.65.145.72]:51031 "EHLO
	p01c12o149.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759949Ab0D3XfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 19:35:09 -0400
X-MXL-Hash: 4bdb692d316e21cc-d33de790f02b809ffa418bc6506f2610ab7f0eee
X-MXL-Hash: 4bd9bdc5020042f3-86f98af4cb2d827aac24f9458eedacaf6b77196c
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: "dedekind1@gmail.com" <dedekind1@gmail.com>
CC: David Woodhouse <dwmw2@infradead.org>,
       "ryan@bluewatersys.com" <ryan@bluewatersys.com>,
       "andre@bluewatersys.com" <andre@bluewatersys.com>,
       "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
       Linux Kernel <linux-kernel@vger.kernel.org>
Date: Thu, 29 Apr 2010 12:11:05 -0500
Subject: RE: [PATCH] sst25l.c: simplify reading the device ManID/DevID
Thread-Topic: [PATCH] sst25l.c: simplify reading the device ManID/DevID
Thread-Index: AcrnX2bTS6vtTKVvRkG5/kSBnk57DAAXj34g
Message-ID: <0D753D10438DA54287A00B0270842697636E305B2F@AUSP01VMBX24.collaborationhost.net>
References: <0D753D10438DA54287A00B0270842697636D85BD7C@AUSP01VMBX24.collaborationhost.net>
 <1272519398.7750.67.camel@localhost>
In-Reply-To: <1272519398.7750.67.camel@localhost>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2000000000; CM=0.500; S=0.200(2010043001)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.32]
X-AnalysisOut: [v=1.0 c=1 a=Kt63NVUFlrcA:10 a=VphdPIyG4kEA:10 a=IkcTkHD0fZ]
X-AnalysisOut: [MA:10 a=zbe46bahRtDx8aUBN1lPzQ==:17 a=i00gxMtYAAAA:8 a=Jfr]
X-AnalysisOut: [nYn6hAAAA:8 a=rggnVFrEAAAA:8 a=bO_dZOUzwfqVMNHDz18A:9 a=yO]
X-AnalysisOut: [HZW6iAMyZ8uWC6am4A:7 a=WiJ4p5_hzLD7M6RLvsqzZfzTyFUA:4 a=QE]
X-AnalysisOut: [XdDO2ut3YA:10 a=x1WnkoZAwusA:10 a=3Rfx1nUSh_UA:10 a=ct-hs6]
X-AnalysisOut: [iedJYA:10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o3UNZRmE012066

On Wednesday, April 28, 2010 10:37 PM, Artem Bityutskiy wrote:
> On Tue, 2010-04-20 at 18:17 -0500, H Hartley Sweeten wrote:
>> The Read-ID command will continuously output the Manufacture ID and Device ID
>> until the command is terminated by a low to high transition on the CE# pin.
>> We can take advantage of this in the sst25l_match_device routine by reading
>> both bytes in one spi_write_then_read transaction.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: David Woodhouse <dwmw2@infradead.org>
>> Cc: Andre Renaud <andre@bluewatersys.com>
>> Cc: Ryan Mallon <ryan@bluewatersys.com>
>
> Pushed to l2-mtd-2.6.git / dunno.

Artem,

I have discovered that the Read-Status-Register command has the same problem.
With the SST25L SPI flash chips, if the chip enable is deasserted after sending
a command that command will get aborted.

I ran across this while testing a new spi master driver for the ep93xx on an
EDB9307A dev board.  That board uses the processors SFRMOUT signal as part of
the chip select logic.  Unfortunately the ep93xx only asserts the SFRMOUT
signal as long as the spi transmit fifo contains data.  As soon as the last
bit is clocked into the receive fifo it gets deasserted.  Many of the other
ep93xx based boards have that same issue.

I have an updated patch that changes both of these into one synchronous message
which fixes the sst25l_status and sst25l_match_device functions.  These changes
should be transparent to any users of this driver.

Could you drop the current patch and I will submit the updated one for review?

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
