Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758849Ab0ENSCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 14:02:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.158]:32688 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757586Ab0ENSB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 14:01:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ID/NjbfqnZDQfvAZtk/tYLFjFcIccyFZt0WXCboo+kURnevcOSiSkSnc4m0sInKdnr
         l4i+/2cxhCOfwsJVMhzaqnn3QXhA9xQsN94dycFTB2DM+GeyvLLcqAdSED445onejLt1
         4IbLNKyzZWMAJsROCh+42+9AjiF9Kn99DDs+E=
Date: Fri, 14 May 2010 22:01:48 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: Performance Events hangs with Intel P4 system
Message-ID: <20100514180148.GE13509@lenovo>
References: <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com> <1273834571.3530.82.camel@minggr.sh.intel.com> <20100514115655.GA18069@elte.hu> <20100514135240.GA4952@lenovo> <20100514145213.GA13509@lenovo> <AANLkTik6rwpU665xKUWfaOhV-h3Xgm_xeSiXH0Ax-n2u@mail.gmail.com> <20100514162813.GB13509@lenovo> <AANLkTinSAEATJbnj5MwhuKlBtXEGzpdeoktkzktrESvw@mail.gmail.com> <20100514164057.GC13509@lenovo> <AANLkTinQL16caUSZnFFr4gs_vfT93mwkNTK7I_eShZvA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinQL16caUSZnFFr4gs_vfT93mwkNTK7I_eShZvA@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 11:18:52PM +0530, Jaswinder Singh Rajput wrote:
... 
> Earlier I given the command 'ls' which was very small only 601636
> instructions so branches
> and branch-misses came up with <not counted>
> 
> When I given a bigger command 'ls -lR /dev' with 10159428
> instructions, so I get branches and branch-misses count.
> 
> Thanks,
> --
> Jaswinder Singh.
> 

Jaswinder, could you give this patch a shot so that I will be
able to put your tested-by tag and send it upstream? (it's slightly
tuned from previous but should be same on bin level). This GP
issue need to be fixed before any other things.

	-- Cyrill
---
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
 
