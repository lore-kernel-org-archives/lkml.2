Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751739Ab1JLD40 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 23:56:26 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:48714 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750959Ab1JLD4Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 23:56:25 -0400
X-Authority-Analysis: v=1.1 cv=lfM0d0QHaVz67dfwwr9cyIw6NbaGR/pZhMD6XWNi0kk= c=1 sm=0 a=ZkT-yH-0OPkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=meVymXHHAAAA:8 a=_YYBcyo_tLlp08UuuFAA:9 a=HZI6gVFHuevpgdta3CcA:7 a=PUjeQqilurYA:10 a=jeBq3FmKZ4MA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1318391783.13262.11.camel@gandalf.stny.rr.com>
Subject: [PATCH][RT] slab: Fix __do_drain to use the right array cache
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        "Luis Claudio R. Goncalves" <lgoncalv@redhat.com>,
        Clark Williams <clark@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Date: Tue, 11 Oct 2011 23:56:23 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The array cache in __do_drain() was using the cpu_cache_get() function
which uses smp_processor_id() to get the proper array. On mainline, this
is fine as __do_drain() is called by for_each_cpu() which runs
__do_drain() on the CPU it is processing. In RT locks are used instead
and __do_drain() is only called from a single CPU. This can cause the
accounting to be off and trigger the following bug:

slab error in kmem_cache_destroy(): cache `nfs_write_data': Can't free all objects
Pid: 2905, comm: rmmod Not tainted 3.0.6-test-rt17+ #78
Call Trace:
 [<ffffffff810fb623>] kmem_cache_destroy+0xa0/0xdf
 [<ffffffffa03aaffb>] nfs_destroy_writepagecache+0x49/0x4e [nfs]
 [<ffffffffa03c0fe0>] exit_nfs_fs+0xe/0x46 [nfs]
 [<ffffffff8107af09>] sys_delete_module+0x1ba/0x22c
 [<ffffffff8109429d>] ? audit_syscall_entry+0x11c/0x148
 [<ffffffff814b6442>] system_call_fastpath+0x16/0x1b

This can be easily triggered by a simple while loop:

# while :; do modprobe nfs; rmmod nfs; done

The proper function to use is cpu_cache_get_on_cpu(). It works for both
RT and non-RT as the non-RT passes in smp_processor_id() into
__do_drain().

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Index: linux-rt.git/mm/slab.c
===================================================================
--- linux-rt.git.orig/mm/slab.c
+++ linux-rt.git/mm/slab.c
@@ -2601,7 +2601,7 @@ static void __do_drain(void *arg, unsign
 	struct array_cache *ac;
 	int node = cpu_to_mem(cpu);
 
-	ac = cpu_cache_get(cachep);
+	ac = cpu_cache_get_on_cpu(cachep, cpu);
 	spin_lock(&cachep->nodelists[node]->list_lock);
 	free_block(cachep, ac->entry, ac->avail, node);
 	spin_unlock(&cachep->nodelists[node]->list_lock);


