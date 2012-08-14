Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754548Ab2HNI3D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 04:29:03 -0400
Received: from www.linutronix.de ([62.245.132.108]:56877 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754286Ab2HNI27 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 04:28:59 -0400
Message-ID: <502A0C43.2000906@linutronix.de>
Date: Tue, 14 Aug 2012 10:28:51 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Roland McGrath <roland@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, stan_shebs@mentor.com
Subject: Re: [PATCH v2 2/5] x86/uprobes: implement x86 specific arch_uprobe_*_step
References: <1344355952-2382-1-git-send-email-bigeasy@linutronix.de> <1344355952-2382-3-git-send-email-bigeasy@linutronix.de> <20120808125709.GA4504@redhat.com> <50226700.9000606@linutronix.de> <20120808145345.GA8171@redhat.com> <20120809044356.GA3163@in.ibm.com> <20120809170953.GA27835@linutronix.de> <20120813132443.GB5269@redhat.com>
In-Reply-To: <20120813132443.GB5269@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/13/2012 03:24 PM, Oleg Nesterov wrote:
> On 08/09, Sebastian Andrzej Siewior wrote:
>>
>> v1..v2: re-use auprobe->fixups for fixups
>
> Yes, but
>
>> @@ -46,6 +46,8 @@ struct arch_uprobe_task {
>>   #ifdef CONFIG_X86_64
>>   	unsigned long			saved_scratch_register;
>>   #endif
>> +#define UPROBE_CLEAR_TF			(1<<  0)
>> +	unsigned int			restore_flags;
>>   };
>
> this patch still adds restore_flags into arch_uprobe_task.

Yes, but

>>   static void prepare_fixups(struct arch_uprobe *auprobe, struct insn *insn)
>>   {
>> -	bool fix_ip = true, fix_call = false;	/* defaults */
>> +	bool fix_ip = true, fix_call = false, fix_tf = false;	/* defaults */
>>   	int reg;
>>
>>   	insn_get_opcode(insn);	/* should be a nop */
>>
>>   	switch (OPCODE1(insn)) {
>> +	case 0x9d:
>> +		/* popf */
>> +		fix_tf = true;
>> +		break;
>>   	case 0xc3:		/* ret/lret */
>>   	case 0xcb:
>>   	case 0xc2:
>> @@ -277,6 +284,8 @@ static void prepare_fixups(struct arch_uprobe *auprobe, struct insn *insn)
>>   		auprobe->fixups |= UPROBE_FIX_IP;
>>   	if (fix_call)
>>   		auprobe->fixups |= UPROBE_FIX_CALL;
>> +	if (fix_tf)
>> +		auprobe->fixups |= UPROBE_TF_CHANGES;
>>   }
>
> I won't insist, but do we really need fix_tf? "case 0x9d" could simply
> add UPROBE_TF_CHANGES.

if it is not 0x9d (in most cases) we need to decide on per-process
basis (not per-breakpoint) whether the task has gdb watching it or not.
So this code is evaluated once (by the time the breakpoint is
installed) but it may be executed two times: once with gdb and once
without it. On first execution the SIGTRAP will wakeup gdb, on the
second the SIGTRAP will terminate the program because there is no TRAP
handler installed.

> Oleg.

Sebastian
