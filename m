Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753722Ab0IMJmA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 05:42:00 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63392 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415Ab0IMJl6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 05:41:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aNctUC1Lanjh2OKjIJj0fAKR8bjdKib5Muu0RZO0FrPjvONjkVoJYKj9+LUcwTj88j
         WfhumeDiSyC/AmtBEGICz8iadD4iXQ+7XUW9O1p3nLyaPhM9HYVdxCntbtOLcIsdBcbO
         LbozCO+omokzcusY5/eaIUcPdkYqO9BxU8TRw=
MIME-Version: 1.0
In-Reply-To: <4C8DCFAE.4020700@hitachi.com>
References: <20100812122641.fe88e846.randy.dunlap@oracle.com>
	<AANLkTimu4zHZrpGkLVQkxsqax1DDefjZXwTn2cxy4WsL@mail.gmail.com>
	<4C8D790B.8000807@hitachi.com>
	<4C8DCFAE.4020700@hitachi.com>
Date: Mon, 13 Sep 2010 12:41:57 +0300
Message-ID: <AANLkTi=rAq7mGYD02bjZQ1j59J3U2ahHS0mqkULv-648@mail.gmail.com>
Subject: Re: [PATCH -next] optprobes: fix kconfig depends/selects
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>,
        lkml <linux-kernel@vger.kernel.org>, linux-next@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        akpm <akpm@linux-foundation.org>, 2nddept-manager@sdl.hitachi.co.jp
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 13, 2010 at 10:15 AM, Masami Hiramatsu
<masami.hiramatsu.pt@hitachi.com> wrote:
> (2010/09/13 10:06), Masami Hiramatsu wrote:
>> (2010/09/12 19:49), Felipe Contreras wrote:
>>> On Thu, Aug 12, 2010 at 10:26 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>>>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>>>
>>>> KALLSYMS and KALLSYMS_ALL depend on DEBUG_KERNEL, so add that dependency.
>>>> KALLSYMS_ALL depends on KALLSYMS, so select both of them, not just KALLSYMS_ALL.
>>>>
>>>> warning: (OPTPROBES && KPROBES && HAVE_OPTPROBES && !PREEMPT || MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI || UBIFS_FS_DEBUG && MISC_FILESYSTEMS && UBIFS_FS || LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)
>>>>
>>>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>>>> Cc:     Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>>>> Cc:     Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
>>>> Cc:     "David S. Miller" <davem@davemloft.net>
>>>> Cc:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>>>> ---
>>>>  arch/Kconfig |    2 ++
>>>>  1 file changed, 2 insertions(+)
>>>>
>>>> --- linux-next-20100810.orig/arch/Kconfig
>>>> +++ linux-next-20100810/arch/Kconfig
>>>> @@ -45,6 +45,8 @@ config OPTPROBES
>>>>        def_bool y
>>>>        depends on KPROBES && HAVE_OPTPROBES
>>>>        depends on !PREEMPT
>>>> +       depends on DEBUG_KERNEL
>>>> +       select KALLSYMS
>>>>        select KALLSYMS_ALL
>>>>
>>>>  config HAVE_EFFICIENT_UNALIGNED_ACCESS
>>>> --
>>>
>>> This causes another problem:
>>>
>>> arch/Kconfig:33:error: recursive dependency detected!
>>> arch/Kconfig:33:     symbol KPROBES depends on KALLSYMS
>>> init/Kconfig:825:    symbol KALLSYMS is selected by OPTPROBES
>>> arch/Kconfig:44:     symbol OPTPROBES depends on KPROBES
>>>
>>> The 'select KALLSYMS' is redundant.
>>>
>>> Otherwise: Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
>>>
>>
>> Thanks, let me clear the dependency;
>> Kprobes uses kallsyms_lookup for finding target function and checking
>> instruction boundary, thus CONFIG_KPROBES should select CONFIG_KALLSYMS
>> and CONFIG_KALLSYMS_ALL.
>> Optprobe is a optional feature which is supported on x86 arch, and
>> it also uses kallsyms_lookup for checking instructions in the target
>> function. Anyway, since optprobe itself is depends on kprobes, it doesn't
>> need to select both of KALLSYMS/KALLSYMS_ALL.
>
> Hmm, wait, I might misunderstand something here. I thought
> KALLSYMS_ALL added symbols of static functions.
> But, does KALLSYMS_ALL just add symbols of variables?
> If so, both of KPROBES and OPTPROBES require only KALLSYMS.
> It means that they don't need to care about CONFIG_DEBUG_KERNEL.

So:
-       select KALLSYMS_ALL
+       depends on KALLSYMS_ALL

Because KALLSYMS_ALL depends on DEBUG_KERNEL && KALLSYMS.

-- 
Felipe Contreras
