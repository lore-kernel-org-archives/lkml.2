Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755387Ab1LAWi7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 17:38:59 -0500
Received: from ozlabs.org ([203.10.76.45]:60043 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755024Ab1LAWi6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 17:38:58 -0500
Date: Fri, 2 Dec 2011 09:38:33 +1100
From: Anton Blanchard <anton@samba.org>
To: David Ahern <dsahern@gmail.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] perf stat: Failure with "Operation not supported"
Message-ID: <20111202093833.5fef7226@kryten>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


perf stat is failing on PowerPC:


# perf stat /bin/true
  Error: open_counter returned with 95 (Operation not supported). /bin/dmesg may provide additional information.

  Fatal: Not all events could be opened.


commit 370faf1dd046 (perf stat: Fail softly on unsupported events)
added a check for failure returning ENOENT, but the POWER backend
returns EOPNOTSUPP. It looks like alpha, blackfin and mips do the
same.

With the patch applied, things work as expected:


# perf stat /bin/true
 Performance counter stats for '/bin/true':

          0.362176 task-clock                #    0.623 CPUs utilized          
                 0 context-switches          #    0.000 M/sec                  
                 0 CPU-migrations            #    0.000 M/sec                  
                28 page-faults               #    0.077 M/sec                  
         1,677,020 cycles                    #    4.630 GHz                    
   <not supported> stalled-cycles-frontend 
   <not supported> stalled-cycles-backend  
           431,220 instructions              #    0.26  insns per cycle        
           101,889 branches                  #  281.325 M/sec                  
             4,145 branch-misses             #    4.07% of all branches        

       0.000581361 seconds time elapsed


Signed-off-by: Anton Blanchard <anton@samba.org>
Cc: <stable@kernel.org> # 3.0+
---

Index: linux/tools/perf/builtin-stat.c
===================================================================
--- linux.orig/tools/perf/builtin-stat.c	2011-12-02 09:09:17.993942921 +1100
+++ linux/tools/perf/builtin-stat.c	2011-12-02 09:10:15.978939340 +1100
@@ -463,7 +463,8 @@ static int run_perf_stat(int argc __used
 
 	list_for_each_entry(counter, &evsel_list->entries, node) {
 		if (create_perf_stat_counter(counter, first) < 0) {
-			if (errno == EINVAL || errno == ENOSYS || errno == ENOENT) {
+			if (errno == EINVAL || errno == ENOSYS ||
+			    errno == ENOENT || errno == EOPNOTSUPP) {
 				if (verbose)
 					ui__warning("%s event is not supported by the kernel.\n",
 						    event_name(counter));
