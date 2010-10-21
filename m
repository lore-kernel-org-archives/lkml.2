Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752209Ab0JUIhX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 04:37:23 -0400
Received: from t111.niisi.ras.ru ([193.232.173.111]:45329 "EHLO
	t111.niisi.ras.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab0JUIhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 04:37:20 -0400
Message-ID: <4CBFFF3F.2050700@niisi.msk.ru>
Date: Thu, 21 Oct 2010 12:52:15 +0400
From: "Gleb O. Raiko" <raiko@niisi.msk.ru>
Organization: NIISI RAN
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: "Maciej W. Rozycki" <macro@linux-mips.org>
CC: Ralf Baechle <ralf@linux-mips.org>, Kevin Cernekee <cernekee@gmail.com>,
        Shinya Kuribayashi <skuribay@pobox.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH resend 5/9] MIPS: sync after cacheflush
References: <17ebecce124618ddf83ec6fe8e526f93@localhost> <17d8d27a2356640a4359f1a7dcbb3b42@localhost> <4CBC4F4E.5010305@pobox.com> <AANLkTinpry=XG-ZDgXJK-VB6QkBL2TO4-vrsV5Tc1eEs@mail.gmail.com> <alpine.LFD.2.00.1010190146360.15889@eddie.linux-mips.org> <20101019123441.GJ27377@linux-mips.org> <alpine.LFD.2.00.1010192039550.15889@eddie.linux-mips.org> <4CBEA2D6.6050507@niisi.msk.ru> <alpine.LFD.2.00.1010201750060.15889@eddie.linux-mips.org>
In-Reply-To: <alpine.LFD.2.00.1010201750060.15889@eddie.linux-mips.org>
Content-Type: text/plain; charset=KOI8-R; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: Dr.Web (R) for Mail Servers on t111.niisi.ras.ru host
X-Antivirus-Code: 100000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20.10.2010 21:26, Maciej W. Rozycki wrote:
> On Wed, 20 Oct 2010, Gleb O. Raiko wrote:
>   I'm not sure what you mean: whether the processor will snoop the value to
> read in the store buffer or will it stall until the buffer has drained and
> issue the load on the external bus?
I meant the latter.

>   I can't see the behaviour of uncached loads wrt uncached stores clearly
> documented anywhere for the R4400 processor (DEC used the SC variation,
> BTW).  There's no mention of uncached loads to have SYNC properties.
I agree the docs are unclear here. They contain an example of cached and 
uncached stores (Ralf has pointed to already), but no clear explanation 
for mix of loads and stores. Sure, it's safer to keep both sync and 
uncached load.

> Therefore in the context of one or more pending uncached stores I can
> assume one of the three for an uncached load:
>
> 1. If the addresses match, then the value loaded is snooped in (retrieved
>     from) the store buffer, no external cycle on the bus is seen.  This is
>     what the R2020 WB did.
>
> 2. The load bypasses the stores and therefore reaches the external bus
>     before the stores.  This is what the R3220 MB did and I believe the
>     R2020 WB defaulted to in the case of no address match.
>
> 3. The load stalls until the outstanding stores have completed and only
>     then appears on the external bus.
>
> There's no hurt from using SYNC here and its semantics make it clear it
> enforces the case #3 above even if not otherwise guaranteed.  Otherwise I
> think the case #2 would be a reasonable default (i.e. one I'd recommend to
> a processor designer) as draining the store buffer on any uncached load
> whether needed or not is a waste of performance.
There is no such thing like performance in case of uncached loads.
The case #2 requires:
1. sync
2. additional operations (usually just a read) to pull data behind input 
buffers on an IO bus.

While it's ok to put that in MMIO reads/writes as you've done, it's 
almost impossible to program X server in that way, for example. This 
beast considers a frame buffer as an memory array with strong ordering. 
That's why I'd vote for the case #3. Not because it outperforms #2 in 
the real life (who cares for 0.0001% gain), but because IO devices 
requires strong ordering.

Gleb.
