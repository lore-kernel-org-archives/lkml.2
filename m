Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755365Ab1IBUGQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 16:06:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63420 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab1IBUGO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 16:06:14 -0400
Message-ID: <4E613730.4080508@gmail.com>
Date: Fri, 02 Sep 2011 14:06:08 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de, anton@samba.org
Subject: Re: [PATCH] perf tool: fix endianness handling of u32 data in samples
References: <1314992511-1235-1-git-send-email-dsahern@gmail.com> <20110902200255.GG17970@ghostprotocols.net>
In-Reply-To: <20110902200255.GG17970@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/02/2011 02:02 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Sep 02, 2011 at 01:41:51PM -0600, David Ahern escreveu:
>> @@ -423,18 +449,25 @@ int perf_event__parse_sample(const union perf_event *event, u64 type,
>>  	}
>>  
>>  	if (type & PERF_SAMPLE_RAW) {
>> -		u32 *p = (u32 *)array;
>> +		u.val64 = *array;
>> +		if (swapped) {
>> +			/* undo swap of u64, then swap on individual u32s */
>> +			u.val64 = bswap_64(u.val64);
>> +			u.val32[0] = bswap_32(u.val32[0]);
>> +			u.val32[1] = bswap_32(u.val32[1]);
>> +
>> +			WARN_ONCE(swapped, "Endianness of raw data not corrected!\n");
>> +		}
> 
> That works too, but then we'll be always testing swapped two times :-)
> 
> - Arnaldo


I did not see a WARN_ONCE with no 'condition' variable, so I went with
the redundant test. I guess swapped really could be changed to '1' --
like an example I saw in the acpi code.

David
