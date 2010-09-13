Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754581Ab0IMKOW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 06:14:22 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:59287 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751867Ab0IMKOU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 06:14:20 -0400
X-AuditID: b753bd60-aa6d3ba000005dcc-61-4c8df97992d9
Message-ID: <4C8DF975.4040502@hitachi.com>
Date: Mon, 13 Sep 2010 19:14:13 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.9) Gecko/20100825 Thunderbird/3.1.3
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        akpm <akpm@linux-foundation.org>, 2nddept-manager@sdl.hitachi.co.jp
Subject: Re: [PATCH -next] optprobes: fix kconfig depends/selects
References: <20100812122641.fe88e846.randy.dunlap@oracle.com>	<AANLkTimu4zHZrpGkLVQkxsqax1DDefjZXwTn2cxy4WsL@mail.gmail.com>	<4C8D790B.8000807@hitachi.com>	<4C8DCFAE.4020700@hitachi.com> <AANLkTi=rAq7mGYD02bjZQ1j59J3U2ahHS0mqkULv-648@mail.gmail.com>
In-Reply-To: <AANLkTi=rAq7mGYD02bjZQ1j59J3U2ahHS0mqkULv-648@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/09/13 18:41), Felipe Contreras wrote:
> On Mon, Sep 13, 2010 at 10:15 AM, Masami Hiramatsu
> <masami.hiramatsu.pt@hitachi.com> wrote:
>> (2010/09/13 10:06), Masami Hiramatsu wrote:
>>> (2010/09/12 19:49), Felipe Contreras wrote:
>>>> On Thu, Aug 12, 2010 at 10:26 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>>>
>>>>> KALLSYMS and KALLSYMS_ALL depend on DEBUG_KERNEL, so add that dependency.
>>>>> KALLSYMS_ALL depends on KALLSYMS, so select both of them, not just KALLSYMS_ALL.
>>>>>
>>>>> warning: (OPTPROBES && KPROBES && HAVE_OPTPROBES && !PREEMPT || MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI || UBIFS_FS_DEBUG && MISC_FILESYSTEMS && UBIFS_FS || LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)
>>>>>
>>>>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>>>>> Cc:     Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>>>>> Cc:     Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
>>>>> Cc:     "David S. Miller" <davem@davemloft.net>
>>>>> Cc:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>>>> ---
>>>>>  arch/Kconfig |    2 ++
>>>>>  1 file changed, 2 insertions(+)
>>>>>
>>>>> --- linux-next-20100810.orig/arch/Kconfig
>>>>> +++ linux-next-20100810/arch/Kconfig
>>>>> @@ -45,6 +45,8 @@ config OPTPROBES
>>>>>        def_bool y
>>>>>        depends on KPROBES && HAVE_OPTPROBES
>>>>>        depends on !PREEMPT
>>>>> +       depends on DEBUG_KERNEL
>>>>> +       select KALLSYMS
>>>>>        select KALLSYMS_ALL
>>>>>
>>>>>  config HAVE_EFFICIENT_UNALIGNED_ACCESS
>>>>> --
>>>>
>>>> This causes another problem:
>>>>
>>>> arch/Kconfig:33:error: recursive dependency detected!
>>>> arch/Kconfig:33:     symbol KPROBES depends on KALLSYMS
>>>> init/Kconfig:825:    symbol KALLSYMS is selected by OPTPROBES
>>>> arch/Kconfig:44:     symbol OPTPROBES depends on KPROBES
>>>>
>>>> The 'select KALLSYMS' is redundant.
>>>>
>>>> Otherwise: Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>>>>
>>>
>>> Thanks, let me clear the dependency;
>>> Kprobes uses kallsyms_lookup for finding target function and checking
>>> instruction boundary, thus CONFIG_KPROBES should select CONFIG_KALLSYMS
>>> and CONFIG_KALLSYMS_ALL.
>>> Optprobe is a optional feature which is supported on x86 arch, and
>>> it also uses kallsyms_lookup for checking instructions in the target
>>> function. Anyway, since optprobe itself is depends on kprobes, it doesn't
>>> need to select both of KALLSYMS/KALLSYMS_ALL.
>>
>> Hmm, wait, I might misunderstand something here. I thought
>> KALLSYMS_ALL added symbols of static functions.
>> But, does KALLSYMS_ALL just add symbols of variables?
>> If so, both of KPROBES and OPTPROBES require only KALLSYMS.
>> It means that they don't need to care about CONFIG_DEBUG_KERNEL.
> 
> So:
> -       select KALLSYMS_ALL
> +       depends on KALLSYMS_ALL
> 
> Because KALLSYMS_ALL depends on DEBUG_KERNEL && KALLSYMS.

No, what I meant is;
-       select KALLSYMS_ALL

:-)



-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
