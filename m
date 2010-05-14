Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759299Ab0ENTId (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 15:08:33 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:55559 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759205Ab0ENTIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 15:08:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=PYB1vmCXkhQ98LhkOt1AOyY70znCyHBnT1vgk8ksYkYk+g++4hHg3Kkcdlj2DpZNKi
         nFNN2pTmwz+snlMOnaMtYHnNLI2L5wzV4IAONc+LLQmne0MXlHECjL3fpVJfpOTrGHNR
         0Bxz9t2ERaTR0TaVB0n4KJ/dMVeDOKwYCLGjE=
Date: Fri, 14 May 2010 23:08:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -tip/master] x86,perf: P4 PMU - fix counters management
	logic
Message-ID: <20100514190815.GG13509@lenovo>
References: <20100514185822.GF13509@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100514185822.GF13509@lenovo>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jaswinder reported GP:
|
| Message from syslogd@ht at May 14 09:39:32 ...
| kernel:[  314.908612] EIP: [<c100ccca>]
| x86_perf_event_set_period+0x19d/0x1b2 SS:ESP 0068:edac3d70
|

Ming has narrowed it down to comparision issue between arguments with
different sizes and signs. As result event index reached wrong value
which in turn led to GP fault.

Same time was found that p4_next_cntr has a broken logic and should
return counter index if only it was not yet borrowed for another event.

Reported-by: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Reported-by: Lin Ming <ming.m.lin@intel.com>
Bisected-by: Lin Ming <ming.m.lin@intel.com>
Tested-by: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Ingo Molnar <mingo@elte.hu>
CC: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
---

Forgot to CC LKML in first place, sorry for message duplication.

 arch/x86/kernel/cpu/perf_event_p4.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
=====================================================================
--- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
+++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
@@ -18,7 +18,7 @@
 struct p4_event_bind {
 	unsigned int opcode;			/* Event code and ESCR selector */
 	unsigned int escr_msr[2];		/* ESCR MSR for this event */
-	unsigned char cntr[2][P4_CNTR_LIMIT];	/* counter index (offset), -1 on abscence */
+	char cntr[2][P4_CNTR_LIMIT];		/* counter index (offset), -1 on abscence */
 };
 
 struct p4_cache_event_bind {
@@ -747,11 +747,11 @@ static int p4_get_escr_idx(unsigned int 
 static int p4_next_cntr(int thread, unsigned long *used_mask,
 			struct p4_event_bind *bind)
 {
-	int i = 0, j;
+	int i, j;
 
 	for (i = 0; i < P4_CNTR_LIMIT; i++) {
-		j = bind->cntr[thread][i++];
-		if (j == -1 || !test_bit(j, used_mask))
+		j = bind->cntr[thread][i];
+		if (j != -1 && !test_bit(j, used_mask))
 			return j;
 	}
 
