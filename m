Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab0IMBG2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 21:06:28 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:33820 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754126Ab0IMBG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 21:06:26 -0400
X-AuditID: b753bd60-aa6d3ba000005dcc-49-4c8d790f3d5a
Message-ID: <4C8D790B.8000807@hitachi.com>
Date: Mon, 13 Sep 2010 10:06:19 +0900
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
References: <20100812122641.fe88e846.randy.dunlap@oracle.com> <AANLkTimu4zHZrpGkLVQkxsqax1DDefjZXwTn2cxy4WsL@mail.gmail.com>
In-Reply-To: <AANLkTimu4zHZrpGkLVQkxsqax1DDefjZXwTn2cxy4WsL@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-FMFTCR: RANGEC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/09/12 19:49), Felipe Contreras wrote:
> On Thu, Aug 12, 2010 at 10:26 PM, Randy Dunlap <randy.dunlap@oracle.com> wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> KALLSYMS and KALLSYMS_ALL depend on DEBUG_KERNEL, so add that dependency.
>> KALLSYMS_ALL depends on KALLSYMS, so select both of them, not just KALLSYMS_ALL.
>>
>> warning: (OPTPROBES && KPROBES && HAVE_OPTPROBES && !PREEMPT || MTD_UBI_DEBUG && MTD && SYSFS && MTD_UBI || UBIFS_FS_DEBUG && MISC_FILESYSTEMS && UBIFS_FS || LOCKDEP && DEBUG_KERNEL && TRACE_IRQFLAGS_SUPPORT && STACKTRACE_SUPPORT && LOCKDEP_SUPPORT || LATENCYTOP && HAVE_LATENCYTOP_SUPPORT) selects KALLSYMS_ALL which has unmet direct dependencies (DEBUG_KERNEL && KALLSYMS)
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc:     Ananth N Mavinakayanahalli <ananth@in.ibm.com>
>> Cc:     Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>
>> Cc:     "David S. Miller" <davem@davemloft.net>
>> Cc:     Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
>> ---
>>  arch/Kconfig |    2 ++
>>  1 file changed, 2 insertions(+)
>>
>> --- linux-next-20100810.orig/arch/Kconfig
>> +++ linux-next-20100810/arch/Kconfig
>> @@ -45,6 +45,8 @@ config OPTPROBES
>>        def_bool y
>>        depends on KPROBES && HAVE_OPTPROBES
>>        depends on !PREEMPT
>> +       depends on DEBUG_KERNEL
>> +       select KALLSYMS
>>        select KALLSYMS_ALL
>>
>>  config HAVE_EFFICIENT_UNALIGNED_ACCESS
>> --
> 
> This causes another problem:
> 
> arch/Kconfig:33:error: recursive dependency detected!
> arch/Kconfig:33:	symbol KPROBES depends on KALLSYMS
> init/Kconfig:825:	symbol KALLSYMS is selected by OPTPROBES
> arch/Kconfig:44:	symbol OPTPROBES depends on KPROBES
> 
> The 'select KALLSYMS' is redundant.
> 
> Otherwise: Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> 

Thanks, let me clear the dependency;
Kprobes uses kallsyms_lookup for finding target function and checking
instruction boundary, thus CONFIG_KPROBES should select CONFIG_KALLSYMS
and CONFIG_KALLSYMS_ALL.
Optprobe is a optional feature which is supported on x86 arch, and
it also uses kallsyms_lookup for checking instructions in the target
function. Anyway, since optprobe itself is depends on kprobes, it doesn't
need to select both of KALLSYMS/KALLSYMS_ALL.

Thank you,

-- 
Masami HIRAMATSU
2nd Dept. Linux Technology Center
Hitachi, Ltd., Systems Development Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
