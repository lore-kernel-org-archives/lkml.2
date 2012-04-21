Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab2DUBhJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 21:37:09 -0400
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:42810
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751261Ab2DUBhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 21:37:06 -0400
X-SpamScore: -12
X-BigFish: VPS-12(zzc89bh936eK1432N98dKzz1202hzzz2dh668h839h941hd25h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0M2T353-02-12F-02
X-M-MSG: 
From: "Lu, Aaron" <Aaron.Lu@amd.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Lin Ming <ming.m.lin@intel.com>, Len Brown <lenb@kernel.org>,
        linux-acpi <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, "Huang, Ying" <ying.huang@intel.com>
Subject: Re: [PATCH v2] ACPI: D3 states cleanup
Thread-Topic: [PATCH v2] ACPI: D3 states cleanup
Thread-Index: AQHNHpOrWF7Jlsxu+k2twS9uk1hIcJai++GA//+Jk4CAAKizgP//ffaAgACqbID//7NDAAAu7bmX
Date: Sat, 21 Apr 2012 01:36:36 +0000
Message-ID: <BF35EBA5-A9E1-47C4-A2E2-197C8FE457F5@amd.com>
References: <1334884749.4927.6.camel@minggr>
 <1334900255.4927.36.camel@minggr>
 <20120420074725.GA30140@localhost.amd.com>,<201204201312.54949.rjw@sisk.pl>
In-Reply-To: <201204201312.54949.rjw@sisk.pl>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q3L1cGOi007981


ÔÚ 2012-4-20£¬ÏÂÎç7:08£¬"Rafael J. Wysocki" <rjw@sisk.pl> Ğ´µÀ£º

> On Friday, April 20, 2012, Aaron Lu wrote:
>> Hi,
>> 
>> On Fri, Apr 20, 2012 at 01:37:35PM +0800, Lin Ming wrote:
>>>>>>> There are two ACPI D3 states defined now:
>>>>>>> ACPI_STATE_D3 and ACPI_STATE_D3_COLD.
>>>>>>> 
>>>>>>> But the uses of these states are not clear/correct in some code.
>>>>>>> For example, some code refer ACPI_STATE_D3 as D3hot and others refer
>>>>>>> it as D3cold.
>>>>>>> 
>>>>>>> This patch introduces ACPI_STATE_D3_HOT to refer to ACPI D3hot state.
>>>>>>> And changes ACPI_STATE_D3 to refer to ACPI D3cold state only.
>>>>>>> Also redefines ACPI_STATE_D3_COLD the same as ACPI_STATE_D3.
>>>>>>> 
>>>>>> 
>>>>>> With this patch now, if a device has _PS3, then we will set its D3hot
>>>>>> flag valid. This doesn't feel right to me, since per our discussion the
>>>>>> other day, we should assume _PS3 will put the device into D3cold.
>>>>>> 
>>>>>> Or do you mean: if _PS3 is available, then both D3hot and D3cold is
>>>>>> valid from the perspective of acpi, it is the individual driver's
>>>>>> responsibility to decide which state is actually valid and will be used.
>>>>> 
>>>>> Right.
>>>>> 
>>>>> ACPI_STATE_D3(same as ACPI_STATE_D3_COLD now) is always valid.
>>>>> 
>>>> 
>>>> I mean, if _PS3 is available, can we say D3hot is valid?
>>> 
>>> Yes.
>>> 
>> 
>> OK, now I'm confused...
>> 
>> First, let me try to clarify the meaning of acpi power state's valid
>> flag.
>> 
>> By valid, I suppose it means the device can be in that state, instead of
>> we have a way to program this device to go into that state.
>> 
>> e.g. D0 is valid means the device can be in D0 state, and D3_cold is
>> valid means the device can be in D3_cold state. We unconditionally set
>> these two states as valid, because we know every device supports these
>> two states. But we might not be able to put the device into that state
>> in software, since we might not have _PS0 or _PS3 control methods for it.
>> 
>> And if we do have the _PSx or _PRx control methods, we knows we have a
>> way to put the device into that state, and hence the device should be
>> able to support that power state, so we will set that state as valid too.
>> 
>> Is this correct?
>> 
>> For D3hot, obviously not all device supports this state, so we will need
>> to figure it out through the acpi table.
>> I remembered Rafael said the following words the other day in a reply to
>> my evaluate_ps3_when_entering_d3_cold_patch:
>> 
>> -----------------------------------------------------------------------
>> I'd rather say that with _PR3 we have the opportunity to avoid removing
>> power completely from the device.  In other words, D3_hot is supported (and
>> it is supported _only_ in that case).
>> -----------------------------------------------------------------------
>> 
>> So I think here is a problem, that if a device has only _PS3, why should
>> we say D3hot is supported? Is there a reason for this that I missed?
> 
> OK, I agree.  We need to special case the situation in which _PR3 is not
> present, but _PS3 is.  IOW, we should do something like this in the loop in
> acpi_bus_get_power_flags():
> 
> 
>        /* State is valid if we have some power control */
>        if (ps->resources.count
>            || (ps->flags.explicit_set && i < ACPI_STATE_D3))
>            ps->flags.valid = 1;
> 

Looks good to me, thanks.

-Aaron

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
