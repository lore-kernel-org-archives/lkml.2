Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756965Ab2B1JwF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 04:52:05 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:37468 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753769Ab2B1JwC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 04:52:02 -0500
X-AuditID: b753bd60-9d6c9ba00000029c-56-4f4ca3bf9302
X-AuditID: b753bd60-9d6c9ba00000029c-56-4f4ca3bf9302
Message-ID: <4F4CA3BC.7050909@hitachi.com>
Date: Tue, 28 Feb 2012 18:51:56 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, yrl.pp-manager.tt@hitachi.com,
        systemtap@sourceware.org, anderson@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: Re: Re: [PATCH v3 -tip] [BUGFIX] x86/kprobes: Fix to recover
 instructions on optimized path
References: <20120223083703.GA26781@elte.hu> <20120224095412.8462.55698.stgit@localhost.localdomain> <20120227093421.GA10078@elte.hu> <4F4C4182.1040706@hitachi.com> <20120228084828.GK21106@elte.hu>
In-Reply-To: <20120228084828.GK21106@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/28 17:48), Ingo Molnar wrote:
> 
> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
> 
>> (2012/02/27 18:34), Ingo Molnar wrote:
>>>
>>> * Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:
>>>
>>>> +
>>>> +#ifdef CONFIG_OPTPROBES
>>>> +static unsigned long __recover_optprobed_insn(struct kprobe *kp,
>>>> +					      kprobe_opcode_t *buf,
>>>> +					      unsigned long addr)
>>>> +{
>>>> +	long offs = addr - (unsigned long)kp->addr - 1;
>>>> +	struct optimized_kprobe *op = container_of(kp, struct optimized_kprobe, kp);
>>>> +
>>>> +	/*
>>>> +	 * If the kprobe can be optimized, original bytes which can be
>>>> +	 * overwritten by jump destination address. In this case, original
>>>> +	 * bytes must be recovered from op->optinsn.copied_insn buffer.
>>>> +	 */
>>>> +	memcpy(buf, (void *)addr, MAX_INSN_SIZE * sizeof(kprobe_opcode_t));
>>>> +	if (addr == (unsigned long)kp->addr) {
>>>> +		buf[0] = kp->opcode;
>>>> +		memcpy(buf + 1, op->optinsn.copied_insn, RELATIVE_ADDR_SIZE);
>>>> +	} else
>>>> +		memcpy(buf, op->optinsn.copied_insn + offs, RELATIVE_ADDR_SIZE - offs);
>>>> +
>>>> +	return (unsigned long)buf;
>>>> +}
>>>> +#endif
>>>
>>> Why not stick this into a new kprobes-opt.c file?
>>
>> Would you mean that I should split all optprobe stuffs into 
>> new file?
> 
> Yeah, that would be sensible I think - and it might help avoid 
> similar complications in the future.
> 
> Could (and probably should) be done in a separate patch - to 
> keep the bits that you already fixed and tested intact.

OK, I'll make a separate patch.

>>> This should be a separate, kprobes_recover_opt() method and 
>>> be inside kprobes-opt.c as well.
>>
>> OK, I'll do that. But I think it should be separated work. 
>> Just for the bugfix, I think this should go into this style, 
>> because this should be pushed into stable tree too.
> 
> I don't think we can push such a large and complex looking patch 
> into v3.3 (let alone into -stable) - it's v3.4 material, and 
> that's why I asked for the cleaner split-out as well. This
> optprobes code is really non-obvious at the moment and a 
> split-out might improve that and might make future fixes easier 
> to merge.

Yeah, agreed. it's bigger for stable tree.

Thank you,

> 
> Thanks,
> 
> 	Ingo
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
