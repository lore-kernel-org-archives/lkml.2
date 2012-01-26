Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab2AZNi1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 08:38:27 -0500
Received: from mail7.hitachi.co.jp ([133.145.228.42]:44532 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2AZNiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 08:38:24 -0500
X-AuditID: b753bd60-9f483ba000000655-7e-4f21574dc100
X-AuditID: b753bd60-9f483ba000000655-7e-4f21574dc100
Message-ID: <4F21574A.9030507@hitachi.com>
Date: Thu, 26 Jan 2012 22:38:18 +0900
From: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Organization: Hitachi, Ltd., Japan
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH v9 3.2 1/9] uprobes: Install and remove breakpoints.
References: <20120110114821.17610.9188.sendpatchset@srdronam.in.ibm.com> <20120110114831.17610.88468.sendpatchset@srdronam.in.ibm.com> <CAK1hOcO3pz+zBLQKfdty3UwQG8zxXwBWo9euFaE+zKawiqTE2g@mail.gmail.com>
In-Reply-To: <CAK1hOcO3pz+zBLQKfdty3UwQG8zxXwBWo9euFaE+zKawiqTE2g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/01/26 0:13), Denys Vlasenko wrote:
> On Tue, Jan 10, 2012 at 12:48 PM, Srikar Dronamraju
> <srikar@linux.vnet.ibm.com> wrote:
>> +/*
>> + * If uprobe->insn doesn't use rip-relative addressing, return
>> + * immediately.  Otherwise, rewrite the instruction so that it accesses
>> + * its memory operand indirectly through a scratch register.  Set
>> + * uprobe->arch_info.fixups and uprobe->arch_info.rip_rela_target_address
>> + * accordingly.  (The contents of the scratch register will be saved
>> + * before we single-step the modified instruction, and restored
>> + * afterward.)
>> + *
>> + * We do this because a rip-relative instruction can access only a
>> + * relatively small area (+/- 2 GB from the instruction), and the XOL
>> + * area typically lies beyond that area.  At least for instructions
>> + * that store to memory, we can't execute the original instruction
>> + * and "fix things up" later, because the misdirected store could be
>> + * disastrous.
>> + *
>> + * Some useful facts about rip-relative instructions:
>> + * - There's always a modrm byte.
>> + * - There's never a SIB byte.
>> + * - The displacement is always 4 bytes.
>> + */
>> +static void handle_riprel_insn(struct mm_struct *mm, struct uprobe *uprobe,
>> +                                                       struct insn *insn)
>> +{
>> +       u8 *cursor;
>> +       u8 reg;
>> +
>> +       if (mm->context.ia32_compat)
>> +               return;
>> +
>> +       uprobe->arch_info.rip_rela_target_address = 0x0;
>> +       if (!insn_rip_relative(insn))
>> +               return;
>> +
>> +       /*
>> +        * Point cursor at the modrm byte.  The next 4 bytes are the
>> +        * displacement.  Beyond the displacement, for some instructions,
>> +        * is the immediate operand.
>> +        */
>> +       cursor = uprobe->insn + insn->prefixes.nbytes
>> +                       + insn->rex_prefix.nbytes + insn->opcode.nbytes;
>> +       insn_get_length(insn);
>> +
>> +       /*
>> +        * Convert from rip-relative addressing to indirect addressing
>> +        * via a scratch register.  Change the r/m field from 0x5 (%rip)
>> +        * to 0x0 (%rax) or 0x1 (%rcx), and squeeze out the offset field.
>> +        */
>> +       reg = MODRM_REG(insn);
>> +       if (reg == 0) {
>> +               /*
>> +                * The register operand (if any) is either the A register
>> +                * (%rax, %eax, etc.) or (if the 0x4 bit is set in the
>> +                * REX prefix) %r8.  In any case, we know the C register
>> +                * is NOT the register operand, so we use %rcx (register
>> +                * #1) for the scratch register.
>> +                */
>> +               uprobe->arch_info.fixups = UPROBES_FIX_RIP_CX;
>> +               /* Change modrm from 00 000 101 to 00 000 001. */
>> +               *cursor = 0x1;
>> +       } else {
>> +               /* Use %rax (register #0) for the scratch register. */
>> +               uprobe->arch_info.fixups = UPROBES_FIX_RIP_AX;
>> +               /* Change modrm from 00 xxx 101 to 00 xxx 000 */
>> +               *cursor = (reg << 3);
>> +       }
>> +
>> +       /* Target address = address of next instruction + (signed) offset */
>> +       uprobe->arch_info.rip_rela_target_address = (long)insn->length
>> +                                       + insn->displacement.value;
>> +       /* Displacement field is gone; slide immediate field (if any) over. */
>> +       if (insn->immediate.nbytes) {
>> +               cursor++;
>> +               memmove(cursor, cursor + insn->displacement.nbytes,
>> +                                               insn->immediate.nbytes);
>> +       }
>> +       return;
>> +}
> 
> It seems to be possible to store RIP value *without displacement*
> into AX/CX and convert rip-relative instruction into AX/CX *relative* one.
> Example:
> c7 05 78 56 34 12 2a 00 00 00 	movl   $0x2a,0x12345678(%rip)
> converts to:
> c7 81 78 56 34 12 2a 00 00 00 	movl   $0x2a,0x12345678(%rcx)
> 
> This way instruction size stays the same and you don't need
> to memmove immediate value.

Right, I agree there is a possibility of optimizing.
However, for ease of review, I think it's better to be
a separate patch.

Thank you,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
