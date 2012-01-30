Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2A3I6F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 03:58:05 -0500
Received: from newsmtp5.atmel.com ([204.2.163.5]:40448 "EHLO
	sjogate2.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2A3I6D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 03:58:03 -0500
Message-ID: <4F265B7E.6060806@atmel.com>
Date: Mon, 30 Jan 2012 09:57:34 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: "Voss, Nikolaus" <N.Voss@weinmann.de>,
        "'dedekind1@gmail.com'" <dedekind1@gmail.com>
CC: "'linux-mtd@lists.infradead.org'" <linux-mtd@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mtd: atmel_nand: fix access to 16 bit NAND devices
References: <201201251217.q0PCHmRe027024@gatekeeper.vosshq.de> <1327670996.26648.43.camel@sauron.fi.intel.com> <EF2E73589CA71846A15D0B2CDF79505D08AD3E5453@wm021.weinmann.com>
In-Reply-To: <EF2E73589CA71846A15D0B2CDF79505D08AD3E5453@wm021.weinmann.com>
X-Enigmail-Version: 1.3.4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2012 08:57 AM, Voss, Nikolaus :
> Artem Bityutskiy wrote on 2012-01-27:
>> On Wed, 2012-01-18 at 10:16 +0100, Nikolaus Voss wrote:
>>> commit fb5427508abbd635e877fabdf55795488119c2d6 optimizes PIO
>>> NAND accesses by using IO memcpy instead of IO read/write
>>> repeated functions.
>>>
>>> This breaks access to 16 bit NAND devices as memcpy_fromio()/toio()
>>> _always_ use byte accesses (see arch/arm/kernel/io.c), so with
>>> 16 bit NAND, one byte gets lost per NAND access cycle and NAND
>>> address count is wrong.
>>>
>>> Using memcpy() instead of the IO memcpy functions fixes this, but
>>> depends on correct word alignment of the buffer and length has to
>>> be a multiple of four, otherwise it might issue byte accesses and
>>> possibly break 16 bit NAND access (cf arch/arm/lib/copy_template.S).
>>>
>>> Memcpy variants seem to be the wrong approach here, since the
>>> NAND controller doesn't make the NAND appear as truely randomly
>>> accessible memory (as opposed to the DRAM controller which does
>>> exactly that).
>>>
>>> So, my proposal is to use 32 bit IO read/write (and let SMC
>>> map it to 8 bit or 16 bit NAND accesses) and account for
>>> length % 4 > 0 with two additional IO read/writes.
>>>
>>> Signed-off-by: Nikolaus Voss <n.voss@weinmann.de>
>>
>> Why not to revert fb5427508abbd635e877fabdf55795488119c2d6 instead, it
>> is in my opinion a bit more readable?
> 
> No objections. I've tried to save the idea of
> fb5427508abbd635e877fabdf55795488119c2d6 but that length % 4 > 0 stuff
> uglifies it a little bit...

After double checking with designers, I must admit that I misunderstood
the way of optimizing accesses to SMC. 16 bit nand is not so common
those days...

So yes, Nikolaus your correction makes sense.

What I would have liked is to optimize the possibility to trigger
incremental bursts from the processor to the SMC on internal bus. I
suspect that this will need further investigation (moreover, note that
if we use assembly code, we should also think about AVR32).

In conclusion, maybe simply reverting the initial commit will allow us
to rework this part of code from simpler basis.

Artem, do you want me to prepare a patch for reverting initial commit or
you just need my "Acked-by" (feel free to add though)?

Best regards,
-- 
Nicolas Ferre
