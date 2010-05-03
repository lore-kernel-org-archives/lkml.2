Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759264Ab0ECNlK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 09:41:10 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:61710 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754605Ab0ECNlH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 09:41:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=G1pHH4yEcfvvpdDvP7HGtJesbCHMegkMpVyFPtZCtCY2HUoIWENXKQc87FGcC9AdKb
         m3v6uy8crORyO5VqeDHWWSIc+9E0tbp3Vdv1JxDiWqiAcywYPaOuukEznAjw5wX0ki2m
         nadJoHIifByKBw3ooZmIb7wSL4VGRJvYfffI4=
Date: Mon, 3 May 2010 15:39:45 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mackerras <paulus@samba.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [GIT PULL] perf and breakpoints updates
Message-ID: <20100503133942.GA5497@nowhere>
References: <1272682436-10682-1-git-send-regression-fweisbec@gmail.com> <20100503065032.GC15241@elte.hu> <20100503070059.GA31397@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503070059.GA31397@elte.hu>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 09:00:59AM +0200, Ingo Molnar wrote:
> 
> note, when merged into tip:master there's a new build failure with these 
> changes:
> 
> kernel/hw_breakpoint.c:58:1: error: pasting "__pcpu_scope_" and "*" does not give a valid preprocessing token
> kernel/hw_breakpoint.c:58:1: error: pasting "__pcpu_unique_" and "*" does not give a valid preprocessing token
> kernel/hw_breakpoint.c:58:1: error: pasting "__pcpu_unique_" and "*" does not give a valid preprocessing token
> 
> config attached.
> 
> 	Ingo


Ah indeed.

I can reproduce, it happens if CONFIG_DEBUG_FORCE_WEAK_PER_CPU,
because we concatenate someting with the name and we have the "*" in
the name.

The right fix seems to be the following, but I prefer to test it further before
submitting it, that said it builds:


diff --git a/kernel/hw_breakpoint.c b/kernel/hw_breakpoint.c
index 684b710..7a56b22 100644
--- a/kernel/hw_breakpoint.c
+++ b/kernel/hw_breakpoint.c
@@ -55,7 +55,7 @@
 static DEFINE_PER_CPU(unsigned int, nr_cpu_bp_pinned[TYPE_MAX]);
 
 /* Number of pinned task breakpoints in a cpu */
-static DEFINE_PER_CPU(unsigned int, *nr_task_bp_pinned[TYPE_MAX]);
+static DEFINE_PER_CPU(unsigned int *, nr_task_bp_pinned[TYPE_MAX]);
 
 /* Number of non-pinned cpu/task breakpoints in a cpu */
 static DEFINE_PER_CPU(unsigned int, nr_bp_flexible[TYPE_MAX]);


