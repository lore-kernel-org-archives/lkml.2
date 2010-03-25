Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753305Ab0CYIq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 04:46:57 -0400
Received: from mga10.intel.com ([192.55.52.92]:5318 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751651Ab0CYIqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 04:46:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.51,306,1267430400"; 
   d="scan'208";a="551973289"
Subject: Re: [PATCH 3/3] perf events: Change perf parameter --pid to
 process-wide collection instead of thread-wide
From: "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Avi Kivity <avi@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       linux-kernel@vger.kernel.org, Sheng Yang <sheng@linux.intel.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Marcelo Tosatti <mtosatti@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       kvm@vger.kernel.org, zhiteng.huang@intel.com,
       Zachary Amsden <zamsden@redhat.com>
In-Reply-To: <4BAB1881.8020500@cn.fujitsu.com>
References: <1268904666.2813.172.camel@localhost>
	 <4BAB1881.8020500@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Thu, 25 Mar 2010 16:47:44 +0800
Message-Id: <1269506864.2078.75.camel@ymzhang.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.0 (2.28.0-2.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-25 at 16:02 +0800, Li Zefan wrote:
> Zhang, Yanmin wrote:
> > From: Zhang, Yanmin <yanmin_zhang@linux.intel.com>
> > 
> > Parameter --pid (or -p) of perf currently means a thread-wide collection.
> > For exmaple, if a process whose id is 8888 has 10 threads, 'perf top -p 8888'
> > just collects the main thread statistics. That's misleading. Users are
> > used to attach a whole process when debugging a process by gdb. To follow
> > normal usage style, the patch change --pid to process-wide collection and
> > add --tid (-t) to mean a thread-wide collection.
> > 
> > Usage example is:
> > #perf top -p 8888
> > #perf record -p 8888 -f sleep 10
> > #perf stat -p 8888 -f sleep 10
> > Above commands collect the statistics of all threads of process 8888.
> > 
> > Signed-off-by: Zhang Yanmin <yanmin_zhang@linux.intel.com>
> > 
> 
> Seems this patch causes seg faults:
> 
> # ./perf sched record
> Segmentation fault
> # ./perf kmem record
> Segmentation fault
> # ./perf timechart record
> Segmentation fault

Thanks for reporting it. Arnaldo, could you pick up below patch?
Zefan, Could you try it?

mmap_array[][][] is not reset to 0 after malloc. Below patch against
tip/master of March 24th fixes it with a zalloc.

Reported-by:	Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by:	Zhang Yanmin <yanmin_zhang@linux.intel.com>

---

diff -Nraup linux-2.6_tip0324/tools/perf/builtin-record.c linux-2.6_tip0324_perfkvm/tools/perf/builtin-record.c
--- linux-2.6_tip0324/tools/perf/builtin-record.c	2010-03-25 10:58:13.308912201 +0800
+++ linux-2.6_tip0324_perfkvm/tools/perf/builtin-record.c	2010-03-25 16:14:18.201475298 +0800
@@ -751,7 +751,7 @@ int cmd_record(int argc, const char **ar
 	for (i = 0; i < MAX_NR_CPUS; i++) {
 		for (j = 0; j < MAX_COUNTERS; j++) {
 			fd[i][j] = malloc(sizeof(int)*thread_num);
-			mmap_array[i][j] = malloc(
+			mmap_array[i][j] = zalloc(
 				sizeof(struct mmap_data)*thread_num);
 			if (!fd[i][j] || !mmap_array[i][j])
 				return -ENOMEM;
diff -Nraup linux-2.6_tip0324/tools/perf/builtin-top.c linux-2.6_tip0324_perfkvm/tools/perf/builtin-top.c
--- linux-2.6_tip0324/tools/perf/builtin-top.c	2010-03-25 10:58:13.284848937 +0800
+++ linux-2.6_tip0324_perfkvm/tools/perf/builtin-top.c	2010-03-25 16:14:56.875266645 +0800
@@ -1371,7 +1371,7 @@ int cmd_top(int argc, const char **argv,
 	for (i = 0; i < MAX_NR_CPUS; i++) {
 		for (j = 0; j < MAX_COUNTERS; j++) {
 			fd[i][j] = malloc(sizeof(int)*thread_num);
-			mmap_array[i][j] = malloc(
+			mmap_array[i][j] = zalloc(
 				sizeof(struct mmap_data)*thread_num);
 			if (!fd[i][j] || !mmap_array[i][j])
 				return -ENOMEM;


