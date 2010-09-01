Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab0IAQt4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 12:49:56 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:56796 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab0IAQtz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 12:49:55 -0400
X-Authority-Analysis: v=1.1 cv=F68j8apdn+AYvba2s2WjKYIAmW276Pjvg9wPu/ZwFig= c=1 sm=0 a=PPQCchlp-Q8A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=VwQbUJbxAAAA:8 a=20KFwNOVAAAA:8 a=vmLDa1wCAAAA:8 a=meVymXHHAAAA:8 a=Fa1AvFEMPlU1xxbysxcA:9 a=4czqq4PiGgnOW3LvmEUA:7 a=EQ3epl0WE1W9WnjghPSR2v5QBE4A:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=gv_BBZfBKR8A:10 a=jeBq3FmKZ4MA:10 a=syppNis662kIst5u:21 a=-7D8rBjEQY-rEMA4:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: [PATCH][GIT PULL] ring-buffer: Place duplicate expression into a
 single function
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Neil Brown <neilb@suse.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        "ksummit-2010-discuss@lists.linux-foundation.org" 
	<ksummit-2010-discuss@lists.linux-foundation.org>
In-Reply-To: <1283351527.2356.22.camel@gandalf.stny.rr.com>
References: <20100825052123.GA5237@linux.vnet.ibm.com>
	 <AANLkTinCaKNXadoTtOvBhO3K5mOyzHi=ZJw4guWWB1W6@mail.gmail.com>
	 <20100826210328.4ccd5aaf@notabene>
	 <1283220647.1377.69.camel@gandalf.stny.rr.com>
	 <20100831132708.GA2484@tuxdriver.com> <1283263428.2945.83.camel@powerslave>
	 <20100901080715.5834450d@notabene>
	 <1283295699.1377.732.camel@gandalf.stny.rr.com>
	 <20100901133653.GB2486@tuxdriver.com>
	 <1283351527.2356.22.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 01 Sep 2010 12:49:52 -0400
Message-ID: <1283359792.2356.39.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Ingo,

Please pull the latest tip/perf/core tree, which can be found at:

  git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-2.6-trace.git
tip/perf/core


Steven Rostedt (1):
      ring-buffer: Place duplicate expression into a single function

----
 kernel/trace/ring_buffer.c |   21 +++++++++++++++------
 1 files changed, 15 insertions(+), 6 deletions(-)
---------------------------
commit f6195aa09e618d712f52bf4fa33b5293820eb93d
Author: Steven Rostedt <srostedt@redhat.com>
Date:   Wed Sep 1 12:23:12 2010 -0400

    ring-buffer: Place duplicate expression into a single function
    
    While discussing the strictness of the 80 character limit on the
    Kernel Summit Discussion mailing list, I showed examples that I
    broke that limit slightly with some algorithms. In discussing with
    John Linville, what looked better, I realized that two of the
    80 char breaking culprits were an identical expression.
    
    As a clean up, this patch moves the identical expression into its
    own helper function and that is used instead. As a side effect,
    the offending code is now under the 80 character limit. :-)
    
    This clean up code also changes the expression from
    
    	(A - B) - C  to  A - (B + C)
    
    This makes the code look a little nicer too.
    
    Cc: John W. Linville <linville@tuxdriver.com>
    Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 19cccc3..ef27017 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -2606,6 +2606,19 @@ void ring_buffer_record_enable_cpu(struct ring_buffer *buffer, int cpu)
 }
 EXPORT_SYMBOL_GPL(ring_buffer_record_enable_cpu);
 
+/*
+ * The total entries in the ring buffer is the running counter
+ * of entries entered into the ring buffer, minus the sum of
+ * the entries read from the ring buffer and the number of
+ * entries that were overwritten.
+ */
+static inline unsigned long
+rb_num_of_entries(struct ring_buffer_per_cpu *cpu_buffer)
+{
+	return local_read(&cpu_buffer->entries) -
+		(local_read(&cpu_buffer->overrun) + cpu_buffer->read);
+}
+
 /**
  * ring_buffer_entries_cpu - get the number of entries in a cpu buffer
  * @buffer: The ring buffer
@@ -2614,16 +2627,13 @@ EXPORT_SYMBOL_GPL(ring_buffer_record_enable_cpu);
 unsigned long ring_buffer_entries_cpu(struct ring_buffer *buffer, int cpu)
 {
 	struct ring_buffer_per_cpu *cpu_buffer;
-	unsigned long ret;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
 		return 0;
 
 	cpu_buffer = buffer->buffers[cpu];
-	ret = (local_read(&cpu_buffer->entries) - local_read(&cpu_buffer->overrun))
-		- cpu_buffer->read;
 
-	return ret;
+	return rb_num_of_entries(cpu_buffer);
 }
 EXPORT_SYMBOL_GPL(ring_buffer_entries_cpu);
 
@@ -2684,8 +2694,7 @@ unsigned long ring_buffer_entries(struct ring_buffer *buffer)
 	/* if you care about this being correct, lock the buffer */
 	for_each_buffer_cpu(buffer, cpu) {
 		cpu_buffer = buffer->buffers[cpu];
-		entries += (local_read(&cpu_buffer->entries) -
-			    local_read(&cpu_buffer->overrun)) - cpu_buffer->read;
+		entries += rb_num_of_entries(cpu_buffer);
 	}
 
 	return entries;


