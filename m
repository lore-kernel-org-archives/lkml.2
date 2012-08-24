Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758031Ab2HXBNZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 21:13:25 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33604 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754598Ab2HXBLj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 21:11:39 -0400
Date: Thu, 23 Aug 2012 18:11:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>, "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] x86, apm: Make on_cpu0() use workqueue instead of
 work_on_cpu()
Message-ID: <20120824011134.GB21325@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make APM schedule a work item on CPU0 instead of using the expensive
work_on_cpu(); hopefully, this is the last user of work_on_cpu() and
we can take out work_on_cpu() in not too distant future.

Tested both paths.  Seems to work fine.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 arch/x86/kernel/apm_32.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index d65464e..2bdb8c4 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -605,28 +605,43 @@ static long __apm_bios_call(void *_call)
 	return call->eax & 0xff;
 }
 
+struct on_cpu0_arg {
+	struct work_struct	work;
+	long			(*fn)(void *);
+	struct apm_bios_call	*call;
+	int			ret;
+};
+
+static void on_cpu0_workfn(struct work_struct *work)
+{
+	struct on_cpu0_arg *arg = container_of(work, struct on_cpu0_arg, work);
+
+	arg->ret = arg->fn(arg->call);
+}
+
 /* Run __apm_bios_call or __apm_bios_call_simple on CPU 0 */
 static int on_cpu0(long (*fn)(void *), struct apm_bios_call *call)
 {
-	int ret;
+	struct on_cpu0_arg arg = { .fn = fn, .call = call };
 
-	/* Don't bother with work_on_cpu in the common case, so we don't
-	 * have to worry about OOM or overhead. */
+	/* directly invoke on_cpu0_workfn() in the common case */
 	if (get_cpu() == 0) {
-		ret = fn(call);
+		on_cpu0_workfn(&arg.work);
 		put_cpu();
 	} else {
 		put_cpu();
-		ret = work_on_cpu(0, fn, call);
+		INIT_WORK_ONSTACK(&arg.work, on_cpu0_workfn);
+		schedule_work_on(0, &arg.work);
+		flush_work(&arg.work);
 	}
 
 	/* work_on_cpu can fail with -ENOMEM */
-	if (ret < 0)
-		call->err = ret;
+	if (arg.ret < 0)
+		call->err = arg.ret;
 	else
 		call->err = (call->eax >> 8) & 0xff;
 
-	return ret;
+	return arg.ret;
 }
 
 /**
