Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759924Ab1JGLZw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Oct 2011 07:25:52 -0400
Received: from mail9.hitachi.co.jp ([133.145.228.44]:39589 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759876Ab1JGLZv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Oct 2011 07:25:51 -0400
X-AuditID: b753bd60-a0aaaba0000019f4-5d-4e8ee1bcab34
X-AuditID: b753bd60-a0aaaba0000019f4-5d-4e8ee1bcab34
Message-ID: <4E8EE1B6.1030907@hitachi.com>
Date: Fri, 07 Oct 2011 20:25:42 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Systems Development Lab., Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        peterz@infradead.org, mingo@elte.hu, acme@redhat.com,
        ming.m.lin@intel.com, robert.richter@amd.com, ravitillo@lbl.gov
Subject: Re: [PATCH 07/12] perf_events: add LBR software filter support for
 Intel X86
References: <1317912555-9559-1-git-send-email-eranian@google.com> <1317912555-9559-8-git-send-email-eranian@google.com> <20111006153229.GJ14482@one.firstfloor.org> <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com>
In-Reply-To: <CABPqkBSNejhZ_ciyLTUFAybBqqGB-8QzVrPj8OTbAhQ_+mj4aw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/10/07 19:38), Stephane Eranian wrote:
> On Thu, Oct 6, 2011 at 5:32 PM, Andi Kleen <andi@firstfloor.org> wrote:
>>> +     kernel_insn_init(&insn, kaddr);
>>> +     insn_get_opcode(&insn);
>>
>> This makes me uncomfortable. AFAIK that's the first use of the opcode
>> decoder being used directly for user space. It has a quite large attack
>> surface. Who says it cannot be exploited?
>>
> This is not new, it's already used for the PEBS fixups and that includes
> user level fixups, if possible.

Oops, I've thought existing code is only for kernel. Hmm, I guess
this could cause a problem when running 32bit binary on x86-64.

As you know, there are differences between decoding routines of
x86-64 and -32. So insn_init() has the third parameter to give
a flag for changing it.
However, since the kernel itself runs on the native mode, I've added
kernel_insn_init() only for the kernel decoding.

----
/* Init insn for kernel text */
static inline void kernel_insn_init(struct insn *insn, const void *kaddr)
{
#ifdef CONFIG_X86_64
        insn_init(insn, kaddr, 1);
#else /* CONFIG_X86_32 */
        insn_init(insn, kaddr, 0);
#endif
}
----

Thus, I strongly recommend you to check the target instruction bitwidth
on x86-64 as (probably) below;

if (kernel_ip(addr) || !test_tsk_thread_flag(current, TIF_IA32))
	kernel_insn_init(insn, addr);
else
	insn_init(insn, addr, 0);

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
