Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756049Ab2BIB1K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 20:27:10 -0500
Received: from mail9.hitachi.co.jp ([133.145.228.44]:60068 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab2BIB1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 20:27:08 -0500
X-AuditID: b753bd60-9645cba00000359c-67-4f3320e9b7cf
X-AuditID: b753bd60-9645cba00000359c-67-4f3320e9b7cf
Message-ID: <4F3320E5.1050707@hitachi.com>
Date: Thu, 09 Feb 2012 10:27:01 +0900
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
Subject: Re: Re: [PATCH v10 3.3-rc2 1/9] uprobes: Install and remove breakpoints.
References: <20120202141840.5967.39687.sendpatchset@srdronam.in.ibm.com> <20120202141851.5967.68000.sendpatchset@srdronam.in.ibm.com> <20120207171707.GA24443@linux.vnet.ibm.com> <CAK1hOcOd3hd31vZYw1yAVGK=gMV=vQotL1mRZkVgM=7M8mbMyw@mail.gmail.com>
In-Reply-To: <CAK1hOcOd3hd31vZYw1yAVGK=gMV=vQotL1mRZkVgM=7M8mbMyw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/02/08 18:40), Denys Vlasenko wrote:
> On Tue, Feb 7, 2012 at 6:17 PM, Srikar Dronamraju
> <srikar@linux.vnet.ibm.com> wrote:
>> Changelog: (Since v10): Add code to clear REX.B prefix pointed out by Denys Vlasenko
>> and fix suggested by Masami Hiramatsu.
> ...
>> +       /*
>> +        * Point cursor at the modrm byte.  The next 4 bytes are the
>> +        * displacement.  Beyond the displacement, for some instructions,
>> +        * is the immediate operand.
>> +        */
>> +       cursor = uprobe->insn + insn_offset_modrm(insn);
>> +       insn_get_length(insn);
>> +       if (insn->rex_prefix.nbytes)
>> +               *cursor &= 0xfe;        /* Clearing REX.B bit */
> 
> It looks like cursor points to mod/reg/rm byte, not rex byte.
> Comment above says it too. You seem to be clearing a bit
> in a wrong byte. I think it should be

Right, but...

> 
>         /* Clear REX.b bit (extension of MODRM.rm field):
>          * we want to encode rax/rcx, not r8/r9.
>          */
>         if (insn->rex_prefix.nbytes)
>                 insn->rex_prefix.bytes[0] &= 0xfe;

No, that is a meaningless operation.
As I originally said,

> insn_get_length(insn);
> if (insn->rex_prefix.nbytes) {
> 	cursor = uprobe->insn + insn_offset_rex_prefix(insn);
> 	*cursor &= 0xfe;	/* Clearing REX.B bit */
> }

You have to move the cursor itself, since the .rex_prefix
is just a copied data...

Thanks,

-- 
Masami HIRAMATSU
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., Yokohama Research Laboratory
E-mail: masami.hiramatsu.pt@hitachi.com
