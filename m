Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab0F3Pxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 11:53:49 -0400
Received: from smtp.outflux.net ([198.145.64.163]:42872 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751758Ab0F3Pxr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 11:53:47 -0400
Date: Wed, 30 Jun 2010 08:53:45 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Eric Paris <eparis@parisplace.org>
Cc: linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Yama: add PTRACE exception tracking
Message-ID: <20100630155345.GN4837@outflux.net>
References: <20100630003844.GE4837@outflux.net>
 <20100630004027.GG4837@outflux.net>
 <AANLkTim_RShqD7CKwjyeeGf3-1NZaVE4K2XUlrsoS1xx@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim_RShqD7CKwjyeeGf3-1NZaVE4K2XUlrsoS1xx@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Wed, Jun 30, 2010 at 11:41:26AM -0400, Eric Paris wrote:
> On Tue, Jun 29, 2010 at 8:40 PM, Kees Cook <kees.cook@canonical.com> wrote:
> > Some application suites have external crash handlers that depend on
> > being able to use PTRACE to generate crash reports (KDE, Chromium, etc).
> > Since the inferior process generally knows the PID of the debugger,
> > it can use PR_SET_PTRACER to allow a specific PID and its descendants
> > to perform the PTRACE instead of only a direct ancestor.
> >
> > Signed-off-by: Kees Cook <kees.cook@canonical.com>
> 
> any normal unpriv application:
> 
> while(1) {
>         prctl(PR_SET_PTRACER, 1, 0, 0, 0);
> }
> 
> watch kernel run out of memory and bring down the box.  Seems like
> quite the DoS.....

Yes, thanks for noticing this; it seems the version I sent did not
include the fixes I made at some point to correctly replace exceptions:


diff --git a/security/yama/yama_lsm.c b/security/yama/yama_lsm.c
index f24b6b3..4f160db 100644
--- a/security/yama/yama_lsm.c
+++ b/security/yama/yama_lsm.c
@@ -32,7 +32,7 @@ static LIST_HEAD(ptracer_relations);
 static DEFINE_SPINLOCK(ptracer_relations_lock);
 
 /**
- * yama_ptracer_add - add an exception for this tracer/tracee pair
+ * yama_ptracer_add - add/replace an exception for this tracer/tracee pair
  * @tracer: the task_struct of the process doing the PTRACE
  * @tracee: the task_struct of the process to be PTRACEd
  *
@@ -41,18 +41,30 @@ static DEFINE_SPINLOCK(ptracer_relations_lock);
 static int yama_ptracer_add(struct task_struct *tracer,
 			    struct task_struct *tracee)
 {
-	struct ptrace_relation *relation;
+	int rc = 0;
+	struct ptrace_relation *entry, *relation = NULL;
 
-	relation = kmalloc(sizeof(*relation), GFP_KERNEL);
-	if (!relation)
-		return -ENOMEM;
-	relation->tracer = tracer;
-	relation->tracee = tracee;
 	spin_lock(&ptracer_relations_lock);
-	list_add(&relation->node, &ptracer_relations);
+	list_for_each_entry(entry, &ptracer_relations, node)
+		if (entry->tracee == tracee) {
+			relation = entry;
+			break;
+		}
+	if (!relation) {
+		relation = kmalloc(sizeof(*relation), GFP_KERNEL);
+		if (!relation) {
+			rc = -ENOMEM;
+			goto unlock_out;
+		}
+		relation->tracee = tracee;
+		list_add(&relation->node, &ptracer_relations);
+	}
+	relation->tracer = tracer;
+
+unlock_out:
 	spin_unlock(&ptracer_relations_lock);
 
-	return 0;
+	return rc;
 }
 
 /**


-Kees

-- 
Kees Cook
Ubuntu Security Team
