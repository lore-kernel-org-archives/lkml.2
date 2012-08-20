Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab2HTEDl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 00:03:41 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42117 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755334Ab2HTEBt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 00:01:49 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Chris Clayron <chris2553@googlemail.com>, Avi Kivity <avi@redhat.com>
Subject: [ 42/46] KVM: VMX: Fix ds/es corruption on i386 with preemption
Date: Sun, 19 Aug 2012 20:59:18 -0700
Message-Id: <20120820035838.102511580@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.2.565.gbd578b5
In-Reply-To: <20120820035832.274275502@linuxfoundation.org>
References: <20120820035832.274275502@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Avi Kivity <avi@redhat.com>

(cherry picked from commit aa67f6096c19bcdb1951ef88be3cf3d2118809dc)

Commit b2da15ac26a0c ("KVM: VMX: Optimize %ds, %es reload") broke i386
in the following scenario:

  vcpu_load
  ...
  vmx_save_host_state
  vmx_vcpu_run
  (ds.rpl, es.rpl cleared by hardware)

  interrupt
    push ds, es  # pushes bad ds, es
    schedule
      vmx_vcpu_put
        vmx_load_host_state
          reload ds, es (with __USER_DS)
    pop ds, es  # of other thread's stack
    iret
  # other thread runs
  interrupt
    push ds, es
    schedule  # back in vcpu thread
    pop ds, es  # now with rpl=0
    iret
  ...
  vcpu_put
  resume_userspace
  iret  # clears ds, es due to mismatched rpl

(instead of resume_userspace, we might return with SYSEXIT and then
take an exception; when the exception IRETs we end up with cleared
ds, es)

Fix by avoiding the optimization on i386 and reloading ds, es on the
lightweight exit path.

Reported-by: Chris Clayron <chris2553@googlemail.com>
Signed-off-by: Avi Kivity <avi@redhat.com>
Signed-off-by: Marcelo Tosatti <mtosatti@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx.c |   20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

--- a/arch/x86/kvm/vmx.c
+++ b/arch/x86/kvm/vmx.c
@@ -1470,13 +1470,6 @@ static void __vmx_load_host_state(struct
 		loadsegment(ds, vmx->host_state.ds_sel);
 		loadsegment(es, vmx->host_state.es_sel);
 	}
-#else
-	/*
-	 * The sysexit path does not restore ds/es, so we must set them to
-	 * a reasonable value ourselves.
-	 */
-	loadsegment(ds, __USER_DS);
-	loadsegment(es, __USER_DS);
 #endif
 	reload_tss();
 #ifdef CONFIG_X86_64
@@ -6273,6 +6266,19 @@ static void __noclone vmx_vcpu_run(struc
 #endif
 	      );
 
+#ifndef CONFIG_X86_64
+	/*
+	 * The sysexit path does not restore ds/es, so we must set them to
+	 * a reasonable value ourselves.
+	 *
+	 * We can't defer this to vmx_load_host_state() since that function
+	 * may be executed in interrupt context, which saves and restore segments
+	 * around it, nullifying its effect.
+	 */
+	loadsegment(ds, __USER_DS);
+	loadsegment(es, __USER_DS);
+#endif
+
 	vcpu->arch.regs_avail = ~((1 << VCPU_REGS_RIP) | (1 << VCPU_REGS_RSP)
 				  | (1 << VCPU_EXREG_RFLAGS)
 				  | (1 << VCPU_EXREG_CPL)


