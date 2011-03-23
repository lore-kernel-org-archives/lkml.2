Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932874Ab1CWNJK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 09:09:10 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57677 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932810Ab1CWNJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 09:09:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=xO33nohURKDBYIV1854wWe0GV2nWbZdqxFf5ftwfFJYRW9sjVXxrv/BYiS/HqyD2C6
         HjO/ZV4vEdp8sh129EJ9cGfDlG2OQCziyx/YbkUP/Cx5PYeFtyrE2vfNVcNjJAvQy7H/
         hEUe3Z7NowCVMPT5/YIUpshjnPlLoDkQ2M4IE=
Subject: Re: [tip:x86/cleanups] x86, dumpstack: Use frame pointer during
 stack trace
From: Namhyung Kim <namhyung@gmail.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
In-Reply-To: <20110310230222.GB1837@nowhere>
References: <1299584662-24421-4-git-send-email-namhyung@gmail.com>
	 <tip-2f8058ae197236f9d5641850ce27f67d8f3e0b39@git.kernel.org>
	 <20110310230222.GB1837@nowhere>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 Mar 2011 22:08:54 +0900
Message-ID: <1300885734.1479.6.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011-03-11 (금), 00:02 +0100, Frederic Weisbecker:
> On Thu, Mar 10, 2011 at 10:26:07PM +0000, tip-bot for Namhyung Kim wrote:
> > Commit-ID:  2f8058ae197236f9d5641850ce27f67d8f3e0b39
> > Gitweb:     http://git.kernel.org/tip/2f8058ae197236f9d5641850ce27f67d8f3e0b39
> > Author:     Namhyung Kim <namhyung@gmail.com>
> > AuthorDate: Tue, 8 Mar 2011 20:44:22 +0900
> > Committer:  Thomas Gleixner <tglx@linutronix.de>
> > CommitDate: Thu, 10 Mar 2011 23:20:30 +0100
> > 
> > x86, dumpstack: Use frame pointer during stack trace
> > 
> > If CONFIG_FRAME_POINTER is set then use the frame pointer for the
> > stack backtrace rather than scanning whole stack blindly.
> 
> We don't do it blindly, we actually check the reliability with the
> frame pointer.
> 
> I'm not sure this patch is a good idea. stack dumps need to stay very
> robust and not exclusively rely on the frame pointer to be correct.
> At least walking blindly the stack provides a best effort dump as a last
> resort.
> 

Sounds reasonable. How about adding a boot param to control it then?


diff --git a/arch/x86/kernel/dumpstack.c b/arch/x86/kernel/dumpstack.c
index 809d027de28f..0d7efd90c588 100644
--- a/arch/x86/kernel/dumpstack.c
+++ b/arch/x86/kernel/dumpstack.c
@@ -177,6 +177,16 @@ static const struct stacktrace_ops print_trace_ops
#endif
 };
 
+static int __init nofptrace_setup(char *s)
+{
+	struct stacktrace_ops *ops;
+
+	ops = (struct stacktrace_ops *) &print_trace_ops;
+	ops->walk_stack = walk_context_stack;
+	return 0;
+}
+early_param("nofptrace", nofptrace_setup);
+
 void
 show_trace_log_lvl(struct task_struct *task, struct pt_regs *regs,
 		unsigned long *stack, unsigned long bp, char *log_lvl)



-- 
Regards,
Namhyung Kim


