Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab1C3Rea (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:34:30 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:20945 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754527Ab1C3Re3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:34:29 -0400
Message-ID: <4D9369A4.7060505@oracle.com>
Date: Wed, 30 Mar 2011 10:34:28 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: dedekind1@gmail.com
CC: lkml <linux-kernel@vger.kernel.org>, linux-mtd@lists.infradead.org,
        Adrian Hunter <adrian.hunter@nokia.com>
Subject: Re: [PATCH v2] ubifs: fix kconfig dependency warning
References: <20110328134016.deb5d0c8.randy.dunlap@oracle.com>	 <1301382178.2816.69.camel@localhost> <4D91F432.2070406@oracle.com>	 <1301411055.21445.13.camel@localhost>	 <20110329084855.0de29fff.randy.dunlap@oracle.com> <1301472729.2755.19.camel@localhost>
In-Reply-To: <1301472729.2755.19.camel@localhost>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt356.oracle.com [141.146.40.156]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D93699C.007A,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/30/2011 1:12 AM, Artem Bityutskiy wrote:
> On Tue, 2011-03-29 at 08:48 -0700, Randy Dunlap wrote:
>> On Tue, 29 Mar 2011 18:04:15 +0300 Artem Bityutskiy wrote:
>>
>>> On Tue, 2011-03-29 at 08:01 -0700, Randy Dunlap wrote:
>>>> On 03/29/11 00:02, Artem Bityutskiy wrote:
>>>>> On Mon, 2011-03-28 at 13:40 -0700, Randy Dunlap wrote:
>>>>>> From: Randy Dunlap<randy.dunlap@oracle.com>
>>>>>>
>>>>>> Fix another kconfig dependency warning, this time in ubifs.
>>>>>>
>>>>>> warning: (UBIFS_FS_DEBUG&&  LOCKDEP&&  LATENCYTOP) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL&&  KALLSYMS)
>>>>>>
>>>>>> Without this patch, we can have:
>>>>>> # CONFIG_KALLSYMS is not set
>>>>>> CONFIG_KALLSYMS_ALL=y
>>>>>> which is useless (does nothing unless KALLSYMS is enabled).
>>>>>>
>>>>>> However, ubifs builds successfully with or without this patch,
>>>>>> and it builds with this line completely deleted,
>>>>>> so what was this 'select' for?  Just developer convenience?
>>>>>
>>>>> Well, here is the idea. You can compile UBIFS with debugging and without
>>>>> debugging. Without debugging the resulting ubifs.ko is much smaller, so
>>>>> some embedded people prefer it this way.
>>>>>
>>>>> If you select debugging support, then we'll compile it a lot of
>>>>> assertions, self-checks, test-modes, extra error messages with detailed
>>>>> dumps. And we want to see stackdumps when errors or problems happen,
>>>>> this is why we select KALLSYMS_ALL.
>>>>>
>>>>> So I guess instead we should do:
>>>>>
>>>>> select KALLSYMS
>>>>> select KALLSYMS_ALL
>>>>
>>>> Yes, that should do it.  Thanks for the explanation.
>>>
>>> Will you submit a patch? Alternatively, I can make it myself. What is
>>> your preference?
>>
>> Here's an updated patch.  But since KALLSYMS_ALL depends on DEBUG_KERNEL,
>> the lines above aren't quite sufficient and I don't care to select
>> DEBUG_KERNEL.
>
> What is the real difference between KALLSYMS_ALL and KALLSYMS? It looks
> like for stack dumps KALLSYMS is enough. The Kconfig help text is not
> very helpful. And when I look at the help text of
> CONFIG_KALLSYMS_EXTRA_PASS I get feeling that this area needs some
> clean-up work.

Yes, KALLSYMS is enough for most of us.

You can see what KALLSYMS_ALL does by looking at scripts/kallsyms.c,
the --all-symbols option:

>         /* if --all-symbols is not specified, then symbols outside the text
>          * and inittext sections are discarded */



> Anyway, any idea why we wouldn't just kill KALLSYMS_ALL by merging it
> with KALLSYMS?

KALLSYMS_ALL probably generates noise for most use cases.

---
