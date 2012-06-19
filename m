Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753789Ab2FSBDS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 21:03:18 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2630 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab2FSBDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 21:03:16 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ARy8Wg5PTaYA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=nW2dJv_3jwB65zfG-toA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340067793.25903.158.camel@gandalf.stny.rr.com>
Subject: Re: [RFC PATCH 0/2] libtraceevent/perf: Add support for trace-cmd
 plugins
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: David Ahern <dsahern@gmail.com>, acme@ghostprotocols.net,
        linux-kernel@vger.kernel.org, weisbec@gmail.com, namhyung.kim@lge.com,
        mingo@kernel.org, peterz@infradead.org
Date: Mon, 18 Jun 2012 21:03:13 -0400
In-Reply-To: <87d34wi0y3.fsf@sejong.aot.lge.com>
References: <1339695333-64591-1-git-send-email-dsahern@gmail.com>
	 <87lijlhv9v.fsf@sejong.aot.lge.com> <4FDF3D5C.1030209@gmail.com>
	 <87d34wi0y3.fsf@sejong.aot.lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-06-19 at 09:45 +0900, Namhyung Kim wrote:

> TRACE_EVENT(kvm_emulate_insn,
>         ...
> 	TP_printk("%x:%llx:%s (%s)%s",
> 		  __entry->csbase, __entry->rip,
> 		  __print_insn(__entry->insn, __entry->len),
> 		  __print_symbolic(__entry->flags,
> 				   kvm_trace_symbol_emul_flags),
> 		  __entry->failed ? " failed" : ""
> 		)
> 	);
> 
> And __print_insn is defined as:
> 
> #define __print_insn(insn, ilen) ({		                 \
> 	int i;							 \
> 	const char *ret = p->buffer + p->len;			 \
> 								 \
> 	for (i = 0; i < ilen; ++i)				 \
> 		trace_seq_printf(p, " %02x", insn[i]);		 \
> 	trace_seq_printf(p, "%c", 0);				 \
> 	ret;							 \
> 	})
> 
> The parse error is occurred at the beginning of the compound statment:
> 
>   Warning: bad op token {
>   Warning: failed to read event print fmt for kvm_emulate_insn
> 
> I don't think we can handle this kind of compound statments easily. So I
> just said it *seems* broken. :) Btw, calling trace_seq_printf() here also
> looks like a problem and I have no idea where the 'p' came from.

This is why we want the plugin. What the plugins do is registers how to
parse the data of the event. The event format file is still parsed to
find where the data is located, but the printf fmt: field (TP_printk) is
ignored. The plugin provides the format to print the data with.

Lets look at the kvm plugin for kvm_emulate_insn:

static int kvm_emulate_insn_handler(struct trace_seq *s, struct record *record,
                                    struct event_format *event, void *context)
{
        unsigned long long rip, csbase, len, flags, failed;
        int llen;
        uint8_t *insn;
        const char *disasm;

        if (pevent_get_field_val(s, event, "rip", record, &rip, 1) < 0)
                return -1;

        if (pevent_get_field_val(s, event, "csbase", record, &csbase, 1) < 0)
                return -1;

        if (pevent_get_field_val(s, event, "len", record, &len, 1) < 0)
                return -1;

        if (pevent_get_field_val(s, event, "flags", record, &flags, 1) < 0)
                return -1;

        if (pevent_get_field_val(s, event, "failed", record, &failed, 1) < 0)
                return -1;

        insn = pevent_get_field_raw(s, event, "insn", record, &llen, 1);
        if (!insn)
                return -1;

        disasm = disassemble(insn, len, rip,
                             flags & KVM_EMUL_INSN_F_CR0_PE,
                             flags & KVM_EMUL_INSN_F_EFL_VM,
                             flags & KVM_EMUL_INSN_F_CS_D,
                             flags & KVM_EMUL_INSN_F_CS_L);

        trace_seq_printf(s, "%llx:%llx: %s%s", csbase, rip, disasm,
                         failed ? " FAIL" : "");

        return 0;
}


You see, this uses the information from libtraceevent to get the
required fields. Then it prints it out nicely for users. Here's the
output of trace-cmd report after a trace-cmd record -e kvm and starting
a guest:

             kvm-6172  [000] 14669573.114126: kvm_entry:            vcpu 0
             kvm-6172  [000] 14669573.114127: kvm_exit:             reason IO_INSTRUCTION rip 0xffff357a info cfc0008 0
             kvm-6172  [000] 14669573.114130: kvm_emulate_insn:     0:ffff357a: ec
             kvm-6172  [000] 14669573.114130: kvm_pio:              pio_read at 0xcfc size 1 count 1
             kvm-6172  [000] 14669573.114131: kvm_userspace_exit:   reason KVM_EXIT_IO (2)
             kvm-6172  [000] 14669573.114134: kvm_entry:            vcpu 0
             kvm-6172  [000] 14669573.114135: kvm_exit:             reason IO_INSTRUCTION rip 0xffff34f9 info cf80003 0
             kvm-6172  [000] 14669573.114136: kvm_pio:              pio_write at 0xcf8 size 4 count 1
             kvm-6172  [000] 14669573.114136: kvm_userspace_exit:   reason KVM_EXIT_IO (2)

I can disable plugins to show you the result of what happens without
them:

trace-cmd report -N
[...]
             kvm-6172  [000] 14669573.114126: kvm_entry:            vcpu 0
             kvm-6172  [000] 14669573.114127: kvm_exit:             [FAILED TO PARSE] exit_reason=30 guest_rip=0xffff357a isa=1 info1=217841672 info2=0
             kvm-6172  [000] 14669573.114130: kvm_emulate_insn:     [FAILED TO PARSE] rip=4294915450 csbase=0 len=1 insn=ì[ÃWVS<89>Ã<89>Ö¨^Gu^Q^O^E flags=5 failed=0
             kvm-6172  [000] 14669573.114130: kvm_pio:              pio_read at 0xcfc size 1 count 1
             kvm-6172  [000] 14669573.114131: kvm_userspace_exit:   reason KVM_EXIT_IO (2)
             kvm-6172  [000] 14669573.114134: kvm_entry:            vcpu 0

This is the power of plugins. I would expect to add something like:

tools/events/plugins/

where these can be added for everyone.

-- Steve


