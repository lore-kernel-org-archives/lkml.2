Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0HJHlB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 03:41:01 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:47797 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753575Ab0HJHkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 03:40:55 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Tue, 10 Aug 2010 09:42:31 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv2 2/3] lib: vsprintf: optimised put_dec() for 32-bit
 machines
In-reply-to: <201008100615.52510.vda.linux@googlemail.com>
To: Michal Nazarewicz <mina86@mina86.com>,
        Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kernel@vger.kernel.org, "Douglas W. Jones" <jones@cs.uiowa.edu>,
        Andrew Morton <akpm@linux-foundation.org>
Message-id: <op.vg7o05wa7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <6f90103dea29739de0f4f0ede3f3da68afe84343.1281295424.git.mina86@mina86.com>
 <419733287a42072a658f0f74d0b1901132178b75.1281295424.git.mina86@mina86.com>
 <201008100615.52510.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Sunday 08 August 2010 21:29, Michal Nazarewicz wrote:
>> Compared to previous version: the code is used only if:
>> 1. if long long is 64-bit (ie. ULLONG_MAX == 2**64-1), and
>> 2. user did not select optimisation for size with Kconfig.

On Tue, 10 Aug 2010 06:15:52 +0200, Denys Vlasenko <vda.linux@googlemail.com> wrote:
> I measured the size and it does not seem to make sense
> to exclude it on -Os. On x86:
>
> put_dec_full change: 0x93 -> 0x47 bytes
> put_dec      change: 0x12c -> 0x137 bytes
>
> IOW, there is net code size reduction (compared to current kernel,
> it may be a slight growth compared to patch 1).
>
> So, please use the optimized code even for CONFIG_CC_OPTIMIZE_FOR_SIZE.

Will do.

>> Here are the results (normalised to the fastest/smallest):
>>                     :        ARM       Atom
>> -- Speed ----------------------------------
>> orig_put_dec        :   9.333822   2.083110  Original
>> mod1_put_dec        :   9.282045   1.904564
>> mod2_put_dec        :   9.260409   1.910302
>> mod3_put_dec        :   9.320053   1.905689  Proposed by previous patch
>> mod4_put_dec        :   9.297146   1.933971
>> mod5_put_dec        :  13.034318   2.434942
>> mod6_put_dec        :   1.000000   1.000000  Proposed by this patch
>> mod7_put_dec        :   1.009574   1.014147
>> mod8_put_dec        :   7.226004   1.953460
>> -- Size -----------------------------------
>> orig_put_dec        :   1.000000   1.000000  Original
>> mod1_put_dec        :   1.000000   1.000000
>> mod2_put_dec        :   1.361111   1.403226
>> mod3_put_dec        :   1.000000   1.000000  Proposed by previous patch
>> mod4_put_dec        :   1.361111   1.403226
>> mod5_put_dec        :   1.000000   1.000000
>> mod6_put_dec        :   2.555556   3.508065  Proposed by this patch
>> mod7_put_dec        :   2.833333   3.911290
>> mod8_put_dec        :   2.027778   2.258065
>
> I believe these are old results? Size growth is just too big.

Hmm...  I think those are new results, but I might have messed something
up.  I'll redo them.

>> +#if BITS_PER_LONG != 32 || defined CONFIG_CC_OPTIMIZE_FOR_SIZE || \
>> +	ULLONG_MAX != 18446744073709551615ULL
>
> I think it's better to say "if BITS_PER_LONG > 32 and ULLONG_MAX > 2^64-1",
> since it expresses your intent better. Also, add comments explaining
> what case you optimize for:

Will do.

>> +static noinline_for_stack
>> +char *put_dec(char *buf, unsigned long long n)
>> +{
>> +	uint32_t d3, d2, d1, q;
>> +
>> +	if (!n) {
>> +		*buf++ = '0';
>> +		return buf;
>> +	}

> You may as well use the above shortcut for n <= 9, not only for 0.

Will do.

>> +	buf = put_dec_full4(buf, q % 10000);
>> +	q   = q / 10000;
>> +
>> +	d1  = q + 7671 * d3 + 9496 * d2 + 6 * d1;
>> +	buf = put_dec_full4(buf, d1 % 10000);
>> +	q   = d1 / 10000;
>
> I experimented with moving division up, before put_dec_full4:
> q   = d1 / 10000;
> buf = put_dec_full4(buf, d1 % 10000);
> but gcc appears to be smart emough to do this transformation
> itself. But you may still do it for older (dumber) gcc's.

I wasn't sure where would be a better place to put this line.  I'll
follow your advice on this one then.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
