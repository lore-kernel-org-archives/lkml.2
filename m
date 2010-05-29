Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753579Ab0E2IWB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 04:22:01 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:56567 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab0E2IV4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 04:21:56 -0400
Date: Sat, 29 May 2010 09:21:52 +0100
From: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Stefan Hajnoczi <stefanha@gmail.com>, linux-perf-users@vger.kernel.org,
       linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Avi Kivity <avi@redhat.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: Perf trace event parse errors for KVM events
Message-ID: <20100529082151.GA2738@stefan-thinkpad.transitives.com>
References: <20100526123443.GB8905@stefan-thinkpad.transitives.com>
 <AANLkTil8BiuzrmacV7Lpx1wES0EvLSiVmcfwtSY6Zis2@mail.gmail.com>
 <1275083157.22648.593.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1275083157.22648.593.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 05:45:57PM -0400, Steven Rostedt wrote:
> On Fri, 2010-05-28 at 17:42 +0100, Stefan Hajnoczi wrote:
> > I get parse errors when using Steven Rostedt's trace-cmd tool, too.
> > 
> > Any ideas what is going on here?  I can provide more info (e.g. trace
> > files) if necessary.
> 
> Does trace-cmd fail on the same tracepoints? Have you checkout the
> latest code?.

$ sudo trace-cmd record -e kvm:kvm_pio
$ trace-cmd report
version = 6
  bad op token {
  failed to read event print fmt for kvm_mmu_get_page
  bad op token {
  failed to read event print fmt for kvm_mmu_sync_page
  bad op token {
  failed to read event print fmt for kvm_mmu_unsync_page
  bad op token {
  failed to read event print fmt for kvm_mmu_zap_page
  Error: expected type 4 but read 7
  Error: expected type 5 but read 0
  failed to read event print fmt for kvm_apic
  function ftrace_print_symbols_seq not defined
  failed to read event print fmt for kvm_exit
  Error: expected type 4 but read 7
  Error: expected type 5 but read 0
  failed to read event print fmt for kvm_inj_exception
  function ftrace_print_symbols_seq not defined
  failed to read event print fmt for kvm_nested_vmexit
  function ftrace_print_symbols_seq not defined
  failed to read event print fmt for kvm_nested_vmexit_inject
  bad op token {
  failed to read event print fmt for kvm_emulate_insn

These are different from those reported by perf.

Yes, I use trace-cmd.git master branch (currently built from
b530a23f0442be322b1717e6dbce2bd502634cb4).

My kernel is 2.6.34 based.

> I do know it fails on some of the KVM tracerpoints since the formatting
> they use is obnoxious.
> 
> Could you show the "print-fmt" of the failing events?

Here are the details along with my amateur comments on what might have gone wrong:

$ for event in kvmmmu/kvm_mmu_get_page kvmmmu/kvm_mmu_sync_page kvmmmu/kvm_mmu_unsync_page kvmmmu/kvm_mmu_zap_page kvm/kvm_apic kvm/kvm_exit kvm/kvm_inj_exception kvm/kvm_nested_vmexit kvm/kvm_nested_vmexit_inject kvm/kvm_emulate_insn; do echo -n "$event: "; grep 'print fmt:' /sys/kernel/debug/tracing/events/$event/format; done

kvmmmu/kvm_mmu_get_page: print fmt: "%s %s", ({ const char *ret = p->buffer + p->len; static const char *access_str[] = { "---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux" }; union kvm_mmu_page_role role; role.word = REC->role; trace_seq_printf(p, "sp gfn %llx %u%s q%u%s %s%s" " %snxe root %u %s%c", REC->gfn, role.level, role.cr4_pae ? " pae" : "", role.quadrant, role.direct ? " direct" : "", access_str[role.access], role.invalid ? " invalid" : "", role.nxe ? "" : "!", REC->root_count, REC->unsync ? "unsync" : "sync", 0); ret; }), REC->created ? "new" : "existing"
kvmmmu/kvm_mmu_sync_page: print fmt: "%s", ({ const char *ret = p->buffer + p->len; static const char *access_str[] = { "---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux" }; union kvm_mmu_page_role role; role.word = REC->role; trace_seq_printf(p, "sp gfn %llx %u%s q%u%s %s%s" " %snxe root %u %s%c", REC->gfn, role.level, role.cr4_pae ? " pae" : "", role.quadrant, role.direct ? " direct" : "", access_str[role.access], role.invalid ? " invalid" : "", role.nxe ? "" : "!", REC->root_count, REC->unsync ? "unsync" : "sync", 0); ret; })
kvmmmu/kvm_mmu_unsync_page: print fmt: "%s", ({ const char *ret = p->buffer + p->len; static const char *access_str[] = { "---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux" }; union kvm_mmu_page_role role; role.word = REC->role; trace_seq_printf(p, "sp gfn %llx %u%s q%u%s %s%s" " %snxe root %u %s%c", REC->gfn, role.level, role.cr4_pae ? " pae" : "", role.quadrant, role.direct ? " direct" : "", access_str[role.access], role.invalid ? " invalid" : "", role.nxe ? "" : "!", REC->root_count, REC->unsync ? "unsync" : "sync", 0); ret; })
kvmmmu/kvm_mmu_zap_page: print fmt: "%s", ({ const char *ret = p->buffer + p->len; static const char *access_str[] = { "---", "--x", "w--", "w-x", "-u-", "-ux", "wu-", "wux" }; union kvm_mmu_page_role role; role.word = REC->role; trace_seq_printf(p, "sp gfn %llx %u%s q%u%s %s%s" " %snxe root %u %s%c", REC->gfn, role.level, role.cr4_pae ? " pae" : "", role.quadrant, role.direct ? " direct" : "", access_str[role.access], role.invalid ? " invalid" : "", role.nxe ? "" : "!", REC->root_count, REC->unsync ? "unsync" : "sync", 0); ret; })
kvm/kvm_emulate_insn: print fmt: "%x:%llx:%s (%s)%s", REC->csbase, REC->rip, ({ int i; const char *ret = p->buffer + p->len; for (i = 0; i < REC->len; ++i) trace_seq_printf(p, " %02x", REC->insn[i]); trace_seq_printf(p, "%c", 0); ret; }), __print_symbolic(REC->flags, { 0, "real" }, { (1 << 0) | (1 << 1), "vm16" }, { (1 << 0), "prot16" }, { (1 << 0) | (1 << 2), "prot32" }, { (1 << 0) | (1 << 3), "prot64" }), REC->failed ? " failed" : ""

Macro expanded into C code that shouldn't have?

kvm/kvm_apic: print fmt: "apic_%s %s = 0x%x", REC->rw ? "write" : "read", __print_symbolic(REC->reg, { 0x20, "APIC_" "ID" }, { 0x30, "APIC_" "LVR" }, { 0x80, "APIC_" "TASKPRI" }, { 0x90, "APIC_" "ARBPRI" }, { 0xA0, "APIC_" "PROCPRI" }, { 0xB0, "APIC_" "EOI" }, { 0xC0, "APIC_" "RRR" }, { 0xD0, "APIC_" "LDR" }, { 0xE0, "APIC_" "DFR" }, { 0xF0, "APIC_" "SPIV" }, { 0x100, "APIC_" "ISR" }, { 0x180, "APIC_" "TMR" }, { 0x200, "APIC_" "IRR" }, { 0x280, "APIC_" "ESR" }, { 0x300, "APIC_" "ICR" }, { 0x310, "APIC_" "ICR2" }, { 0x320, "APIC_" "LVTT" }, { 0x330, "APIC_" "LVTTHMR" }, { 0x340, "APIC_" "LVTPC" }, { 0x350, "APIC_" "LVT0" }, { 0x360, "APIC_" "LVT1" }, { 0x370, "APIC_" "LVTERR" }, { 0x380, "APIC_" "TMICT" }, { 0x390, "APIC_" "TMCCT" }, { 0x3E0, "APIC_" "TDCR" }, { 0x3F0, "APIC_" "SELF_IPI" }, { 0x400, "APIC_" "EFEAT" }, { 0x410, "APIC_" "ECTRL" }), REC->val
kvm/kvm_inj_exception: print fmt: "%s (0x%x)", __print_symbolic(REC->exception, { 0, "#" "DE" }, { 1, "#" "DB" }, { 3, "#" "BP" }, { 4, "#" "OF" }, { 5, "#" "BR" }, { 6, "#" "UD" }, { 7, "#" "NM" }, { 8, "#" "DF" }, { 10, "#" "TS" }, { 11, "#" "NP" }, { 12, "#" "SS" }, { 13, "#" "GP" }, { 14, "#" "PF" }, { 16, "#" "MF" }, { 18, "#" "MC" }), REC->has_error ? REC->error_code : 0

String literal concatenation not handled by parser?

kvm/kvm_exit: print fmt: "reason %s rip 0x%lx", ftrace_print_symbols_seq(p, REC->exit_reason, kvm_x86_ops->exit_reasons_str), REC->guest_rip
kvm/kvm_nested_vmexit: print fmt: "rip: 0x%016llx reason: %s ext_inf1: 0x%016llx ext_inf2: 0x%016llx ext_int: 0x%08x ext_int_err: 0x%08x", REC->rip, ftrace_print_symbols_seq(p, REC->exit_code, kvm_x86_ops->exit_reasons_str), REC->exit_info1, REC->exit_info2, REC->exit_int_info, REC->exit_int_info_err
kvm/kvm_nested_vmexit_inject: print fmt: "reason: %s ext_inf1: 0x%016llx ext_inf2: 0x%016llx ext_int: 0x%08x ext_int_err: 0x%08x", ftrace_print_symbols_seq(p, REC->exit_code, kvm_x86_ops->exit_reasons_str), REC->exit_info1, REC->exit_info2, REC->exit_int_info, REC->exit_int_info_err

ftrace_print_symbols_seq() not implemented in trace-cmd?

There are four problem cases in scsi too:

  function scsi_trace_parse_cdb not defined
  failed to read event print fmt for scsi_dispatch_cmd_start
  function scsi_trace_parse_cdb not defined
  failed to read event print fmt for scsi_dispatch_cmd_error

/sys/kernel/debug/tracing/events/scsi/scsi_dispatch_cmd_done/format:FORMAT TOO BIG
/sys/kernel/debug/tracing/events/scsi/scsi_dispatch_cmd_timeout/format:FORMAT TOO BIG

Stefan
