Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757992Ab2B2NUu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 08:20:50 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:53287 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754620Ab2B2NUt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 08:20:49 -0500
X-AuditID: b753bd60-9a2c4ba00000029c-4d-4f4e262e8368
X-AuditID: b753bd60-9a2c4ba00000029c-4d-4f4e262e8368
Message-ID: <4F4E262B.9030806@hitachi.com>
Date: Wed, 29 Feb 2012 22:20:43 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        systemtap@sourceware.org, anderson@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH v3 -tip] [BUGFIX] x86/kprobes: Fix to recover instructions
 on optimized path
References: <20120223083703.GA26781@elte.hu> <20120224095412.8462.55698.stgit@localhost.localdomain> <20120227093421.GA10078@elte.hu> <4F4C4182.1040706@hitachi.com> <20120228084828.GK21106@elte.hu> <4F4CA3BC.7050909@hitachi.com> <20120228095953.GA17149@elte.hu>
In-Reply-To: <20120228095953.GA17149@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/28 18:59), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2012/02/28 17:48), Ingo Molnar wrote:
>>>
>>> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>
>>>> (2012/02/27 18:34), Ingo Molnar wrote:
>>>>>
>>>>> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>>>
>>>>>> +
>>>>>> +#ifdef CONFIG_OPTPROBES
>>>>>> +static unsigned long __recover_optprobed_insn(struct kprobe *kp,
>>>>>> +					      kprobe_opcode_t *buf,
>>>>>> +					      unsigned long addr)
>>>>>> +{
>>>>>> +	long offs = addr - (unsigned long)kp->addr - 1;
>>>>>> +	struct optimized_kprobe *op = container_of(kp, struct optimized_kprobe, kp);
>>>>>> +
>>>>>> +	/*
>>>>>> +	 * If the kprobe can be optimized, original bytes which can be
>>>>>> +	 * overwritten by jump destination address. In this case, original
>>>>>> +	 * bytes must be recovered from op->optinsn.copied_insn buffer.
>>>>>> +	 */
>>>>>> +	memcpy(buf, (void *)addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
>>>>>> +	if (addr == (unsigned long)kp->addr) {
>>>>>> +		buf[0] = kp->opcode;
>>>>>> +		memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
>>>>>> +	} else
>>>>>> +		memcpy(buf, op->optinsn.copied_insn + offs, RELATIVE_ADDR_SIZE - offs);
>>>>>> +
>>>>>> +	return (unsigned long)buf;
>>>>>> +}
>>>>>> +#endif
>>>>>
>>>>> Why not stick this into a new kprobes-opt.c file?
>>>>
>>>> Would you mean that I should split all optprobe stuffs into 
>>>> new file?
>>>
>>> Yeah, that would be sensible I think - and it might help avoid 
>>> similar complications in the future.
>>>
>>> Could (and probably should) be done in a separate patch - to 
>>> keep the bits that you already fixed and tested intact.
>>
>> OK, I'll make a separate patch.
> 
> Could be done on top of your existing patch, to keep things 
> simpler for you - a split-up patch done before your fix would 
> create a lot of conflicts in the fix patch.

I see. And in the previous patch, I've just find a small
racing bug. I'll update it too.

Thank you,


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
