Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932271Ab0DVUJJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 16:09:09 -0400
Received: from kroah.org ([198.145.64.141]:60084 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758047Ab0DVUBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 16:01:55 -0400
X-Mailbox-Line: From gregkh@kvm.kroah.org Thu Apr 22 12:54:17 2010
Message-Id: <20100422195417.808901346@kvm.kroah.org>
User-Agent: quilt/0.48-4.4
Date: Thu, 22 Apr 2010 12:55:01 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org, Greg KH <greg@kroah.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       Eric Dumazet <dada1@cosmosbay.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>, Tejun Heo <tj@kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>
Subject: [124/139] module: fix __module_ref_addr()
In-Reply-To: <20100422195715.GA25490@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

The __module_ref_addr() problem disappears in 2.6.34-rc kernels because these
percpu accesses were re-factored.

__module_ref_addr() should use per_cpu_ptr() to obfuscate the pointer
(RELOC_HIDE is needed for per cpu pointers).

This non-standard per-cpu pointer use has been introduced by commit
720eba31f47aeade8ec130ca7f4353223c49170f

It causes a NULL pointer exception on some configurations when CONFIG_TRACING is
enabled on 2.6.33. This patch fixes the problem (acknowledged by Randy who
reported the bug).

It did not appear to hurt previously because most of the accesses were done
through local_inc, which probably obfuscated the access enough that no compiler
optimizations were done. But with local_read() done when CONFIG_TRACING is
active, this becomes a problem. Non-CONFIG_TRACING is probably affected as well
(module.c contains local_set and local_read that use __module_ref_addr()), but I
guess nobody noticed because we've been lucky enough that the compiler did not
generate the inappropriate optimization pattern there.

This patch should be queued for the 2.6.29.x through 2.6.33.x stable branches.
(tested on 2.6.33.1 x86_64)

Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Tested-by: Randy Dunlap <randy.dunlap@oracle.com>
CC: Eric Dumazet <dada1@cosmosbay.com>
CC: Rusty Russell <rusty@rustcorp.com.au>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Tejun Heo <tj@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>
CC: Andrew Morton <akpm@linux-foundation.org>
CC: Linus Torvalds <torvalds@linux-foundation.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>
CC: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 include/linux/module.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/module.h
+++ b/include/linux/module.h
@@ -457,7 +457,7 @@ void symbol_put_addr(void *addr);
 static inline local_t *__module_ref_addr(struct module *mod, int cpu)
 {
 #ifdef CONFIG_SMP
-	return (local_t *) (mod->refptr + per_cpu_offset(cpu));
+	return (local_t *) per_cpu_ptr(mod->refptr, cpu);
 #else
 	return &mod->ref;
 #endif


