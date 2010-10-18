Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756211Ab0JROZI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 10:25:08 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:33141 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755800Ab0JROZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 10:25:06 -0400
X-Authority-Analysis: v=1.1 cv=exbvkCqEOBXDkHq+8n3wanotOBQtbe7qbIajSD+JluU= c=1 sm=0 a=zQt2nHbqRZ0A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=B3ipCHWoA8dl6TAOhn0A:9 a=Uloi9bEqdpN3dipN4KkA:7 a=-aF9pNPehcMFjWXiqI0DxaFHCdcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: BUG: dead loop in PowerPC hcall tracepoint (Was: [LTP] [PATCH
 v2] Add ftrace-stress-test to LTP)
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: subrata@linux.vnet.ibm.com, ltp-list@lists.sourceforge.net,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
        Anton Blanchard <anton@samba.org>, Paul Mackerras <paulus@samba.org>,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
In-Reply-To: <4CBBBCB0.8070406@cn.fujitsu.com>
References: <4C85A88D.10700@cn.fujitsu.com>
	 <1285689961.11429.12.camel@subratamodak.linux.ibm.com>
	 <1286954486.4893.15.camel@subratamodak.linux.ibm.com>
	 <4CB55FE6.6000604@cn.fujitsu.com> <4CB5615C.4070406@cn.fujitsu.com>
	 <4CB59825.7060504@cn.fujitsu.com>
	 <1286995066.4893.17.camel@subratamodak.linux.ibm.com>
	 <4CBBBCB0.8070406@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 18 Oct 2010 10:25:03 -0400
Message-ID: <1287411903.16971.275.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-18 at 11:19 +0800, Li Zefan wrote:

> This is a dead loop:
> 
> trace_hcall_entry() -> trace_clock_global() -> trace_hcall_entry() ..
> 
> And this is a PPC specific bug. Hope some ppc guys will fix it?
> Or we kill trace_clock_global() if no one actually uses it..

trace_clock_global() is used by many. I use it (and recommend using it)
on boxes where the TSC is horribly out of sync, and the trace needs
synchronization between CPUs.

The trace_hcall_entry and exit has wrappers already. Just add recursion
protection there.

Perhaps something like this:

(Not compiled nor ran)

+static DEFINE_PER_CPU(hcall_trace_disable);
+
 void hcall_tracepoint_regfunc(void)
 {
 	hcall_tracepoint_refcount++;
 }

 void hcall_tracepoint_unregfunc(void)
 {
 	hcall_tracepoint_refcount--;
 }

+int __trace_disable_check(void)
+{
+	if (!hcall_tracepoint_refcount)
+		return 1;
+
+	if (get_cpu_var(hcall_trace_disable)) {
+		put_cpu_var(hcall_trace_disable);
+		return 1;
+	}
+
+	__get_cpu_var(hcall_trace_disable)++;
+
+	return 0;
+}
+
+void __trace_disable_put(void)
+{
+	__get_cpu_var(hcall_trace_disable)--;
+	put_cpu_var(hcall_trace_disable);
+}
+
 void __trace_hcall_entry(unsigned long opcode, unsigned long *args)
 {
+	int trace_disable;
+
+	if (__trace_disable_check())
+		return;
+
 	trace_hcall_entry(opcode, args);
+	__trace_disable_put();
 }

 void __trace_hcall_exit(long opcode, unsigned long retval,
 			unsigned long *retbuf)
 {
+	if (__trace_disable_check())
+		return;
+
 	trace_hcall_exit(opcode, retval, retbuf);
+	__trace_disable_put();
 }

-- Steve


