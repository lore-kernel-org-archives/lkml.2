Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754878Ab1IBTMj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Sep 2011 15:12:39 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:44709 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754342Ab1IBTMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Sep 2011 15:12:35 -0400
Message-ID: <4E612A9E.5000807@gmail.com>
Date: Fri, 02 Sep 2011 13:12:30 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0) Gecko/20110816 Thunderbird/6.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, peterz@infradead.org, fweisbec@gmail.com,
        paulus@samba.org, tglx@linutronix.de, anton@samba.org
Subject: Re: [PATCH v2] perf tool: fix endianness handling of u32 data in
 samples
References: <1314979426-29356-1-git-send-email-dsahern@gmail.com> <20110902181818.GD17970@ghostprotocols.net>
In-Reply-To: <20110902181818.GD17970@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2011 12:18 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Sep 02, 2011 at 10:03:46AM -0600, David Ahern escreveu:
>>  	if (type & PERF_SAMPLE_RAW) {
>> -		u32 *p = (u32 *)array;
>> +		u.val64 = *array;
>> +		if (swapped) {
>> +			static bool show_warn = true;
>> +
>> +			/* undo swap of u64, then swap on individual u32s */
>> +			u.val64 = bswap_64(u.val64);
>> +			u.val32[0] = bswap_32(u.val32[0]);
>> +			u.val32[1] = bswap_32(u.val32[1]);
>> +
>> +			if (show_warn) {
>> +				pr_warning("Endianness of raw data not corrected!\n");
>> +				show_warn = false;
>> +			}
>> +		}
> 
> Can you use WARN_ONCE? Would become:
> 	
> 		if (WARN_ONCE(swapped, "Endianness of raw data not corrected!\n")) {
> 			/* undo swap of u64, then swap on individual u32s */
> 			u.val64 = bswap_64(u.val64);
> 			u.val32[0] = bswap_32(u.val32[0]);
> 			u.val32[1] = bswap_32(u.val32[1]);
> 		}

That's not quite what we need. The bswap's happen all the time; the warn
once is to tell the user one time that samples in the file contain raw
data and those cannot be programmatically adjusted for endianness.

ie., more like:
    WARN_ONCE(swapped, "Endianness of raw data not corrected!\n");
and no action taken (the 'if (WARN_ONCE())'part).

David


> 
> We have that and its the usual idiom in the kernel proper :-)
> 
> See tools/perf/util/include/asm/bug.h and net/can/af_can.c can_rcv for
> an example.
> 
> Thanks,
> 
> - Arnaldo
