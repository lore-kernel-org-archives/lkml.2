Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab2GaNlh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 09:41:37 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:36422 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753519Ab2GaNlf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 09:41:35 -0400
Date: Tue, 31 Jul 2012 15:41:28 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: paulus@samba.org, a.p.zijlstra@chello.nl, linux-kernel@vger.kernel.org,
        mingo@redhat.com, emachado@linux.vnet.ibm.com, acme@ghostprotocols.net,
        prasad.krishnan@gmail.com
Subject: Re: [PATCH v2 RESEND] Hardware breakpoints: Invoke
 __perf_event_disable() if interrupts are already disabled
Message-ID: <20120731134124.GD17078@somewhere.redhat.com>
References: <20120706101653.7515.23309.stgit@localhost.localdomain>
 <20120718103046.7512.8326.stgit@localhost.localdomain>
 <20120718115700.GB6233@somewhere.redhat.com>
 <5007EC8C.7060200@linux.vnet.ibm.com>
 <500FD968.6000407@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500FD968.6000407@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 25, 2012 at 05:02:56PM +0530, Naveen N. Rao wrote:
> >>>@@ -453,7 +453,15 @@ int modify_user_hw_breakpoint(struct perf_event
> >>>*bp, struct perf_event_attr *att
> >>>      int old_type = bp->attr.bp_type;
> >>>      int err = 0;
> >>>
> >>>-    perf_event_disable(bp);
> >>>+    /*
> >>>+     * modify_user_hw_breakpoint can be invoked with IRQs disabled
> >>>and hence it
> >>>+     * will not be possible to raise IPIs that invoke
> >>>__perf_event_disable.
> >>>+     * So call the function directly.
> >>>+     */
> >>>+    if (irqs_disabled())
> >>>+        __perf_event_disable(bp);
> >>>+    else
> >>>+        perf_event_disable(bp);
> >>
> >>This only works if we are sure the bp is on the current CPU. Do we
> >>have that guarantee?
> >
> >Yes. This is being hit during bp exception processing and is specific to
> >ppc where we disable interrupts:
> >hw_breakpoint_handler->perf_bp_event->ptrace_triggered->modify_user_hw_breakpoint()
> 
> Frederick,
> Is this acceptable, or do you have other scenarios where this won't
> work? I can add a check to ensure we call __perf_event_disable only
> if the task is on the current CPU, but the above scenario is the
> only one where we're seeing this issue.

Yeah, please make sure that the targeted task is "current".
