Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752307Ab0IDEtw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Sep 2010 00:49:52 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:52660 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789Ab0IDEtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Sep 2010 00:49:51 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6094"; a="53231999"
Message-ID: <4C81CFEF.6060701@codeaurora.org>
Date: Fri, 03 Sep 2010 21:49:51 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Heiko Carstens <heiko.carstens@de.ibm.com>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
References: <4C61EE55.5030506@codeaurora.org>	<201008251414.16411.arnd@arndb.de>	<20100825125451.GH2153@osiris.boeblingen.de.ibm.com>	<201008251555.53653.arnd@arndb.de>	<20100825144040.GI2153@osiris.boeblingen.de.ibm.com>	<4C7867D4.10404@codeaurora.org> <20100828074304.GA2183@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100828074304.GA2183@osiris.boeblingen.de.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/28/2010 12:43 AM, Heiko Carstens wrote:
> On Fri, Aug 27, 2010 at 06:35:16PM -0700, Stephen Boyd wrote:
>> On 08/25/2010 07:40 AM, Heiko Carstens wrote:
>>> On Wed, Aug 25, 2010 at 03:55:53PM +0200, Arnd Bergmann wrote:
>>>>
>>>> If you don't want to see the warnings, then just remove the strict checks.
>>>> We already concluded that there is little value in them on s390 since it only
>>>> shows false postives.
>>>>
>>>> Maybe the easiest way would be to rename the option on s390 and move all
>>>> the other ones into a common place.
>>>
>>> Yes, feel free to do that.
>>
>> Can you put up the false positives somewhere? I don't have easy access
>> to an s390 toolchain to test build with and I'm interested to see how
>> bad the false positives are.
>>
>> I'm slightly concerned that we'll just have this problem again when
>> another arch comes along with false positives. But ignoring that issue
>> is probably fine. I'll respin with a patch to move s390 to something
>> like DEBUG_WARN_USER_COPY_CHECKS.
> 
> Sure:
> 
> In function 'copy_from_user',
>     inlined from 'write_enabled_file_bool' at kernel/kprobes.c:1973:
> /linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
> In function 'copy_from_user',
>     inlined from 'perf_copy_attr' at kernel/perf_event.c:4988,
>     inlined from 'SYSC_perf_event_open' at kernel/perf_event.c:5092,
>     inlined from 'SyS_perf_event_open' at kernel/perf_event.c:5077:
[snip]
>     inlined from 'compat_sys_socketcall' at net/compat.c:783:
> /linux-2.6/arch/s390/include/asm/uaccess.h:297: warning: call to 'copy_from_user_overflow' declared with attribute warning: copy_from_user() buffer size is not provably correct
> 

Thanks. I'm a bit confused now since these files are compiled on x86 too
and I don't see any warnings on that architecture. Which compiler is wrong?

Anyway, tile has joined the strict copy from user checks arena and it's
acting like s390 by only enabling warnings when the option is set. Sigh....

I would really like to just merge all this code. How about a config
DEBUG_USER_COPY_CHECKS which just does warnings, and then a config
DEBUG_STRICT_USER_COPY_CHECKS that depends on DEBUG_USER_COPY_CHECKS
that upgrades the warnings to errors? This would allow us to merge most
of the code and still be mostly backwards compatible.

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
