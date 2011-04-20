Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754934Ab1DTNMc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 09:12:32 -0400
Received: from mail.aknet.ru ([78.158.192.28]:41146 "EHLO mail.aknet.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752811Ab1DTNMb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 09:12:31 -0400
Message-ID: <4DAEDBB5.8090006@aknet.ru>
Date: Wed, 20 Apr 2011 17:12:21 +0400
From: Stas Sergeev <stsp@aknet.ru>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Oleg Nesterov <oleg@redhat.com>,
        Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [path][rfc] add PR_DETACH prctl command [1/2]
References: <20110224132906.GA15733@redhat.com>	<4D6675B0.2010700@aknet.ru>	<20110224153221.GA22770@redhat.com>	<4D94A788.1050806@aknet.ru>	<20110331170244.GA13271@redhat.com>	<4D99D6E6.4070008@aknet.ru>	<20110404160351.GA23655@redhat.com>	<4D9A24A0.5050105@aknet.ru>	<20110405151549.GB17490@redhat.com>	<4D9B4265.6080403@aknet.ru>	<20110405164557.GA23248@redhat.com>	<4DADA22A.1010205@aknet.ru>	<20110419155830.7ad33312@lxorguk.ukuu.org.uk>	<4DADA581.9060700@aknet.ru> <20110419165429.71cb1508@lxorguk.ukuu.org.uk>
In-Reply-To: <20110419165429.71cb1508@lxorguk.ukuu.org.uk>
Content-Type: multipart/mixed;
 boundary="------------000400040800070103090505"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000400040800070103090505
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi Alan, Oleg.

I changed the patch the way you asked.
It now consumes much fewer per-thread bytes
(2 bytes + padding), and does much fewer suspicious
things on the hot path. And no zombies with ppid=1.

The attached patch adds do_signal_parent() function.
It is the same as do_notify_parent(), but can be used
when the child is not terminating, but (for example)
detaches with PR_DETACH.

--------------000400040800070103090505
Content-Type: text/plain;
 name="01_sigpar.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="01_sigpar.diff"

diff --git a/include/linux/sched.h b/include/linux/sched.h
index 777d8a5..e74882f 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -2096,6 +2096,7 @@ extern int kill_pgrp(struct pid *pid, int sig, int priv);
 extern int kill_pid(struct pid *pid, int sig, int priv);
 extern int kill_proc_info(int, struct siginfo *, pid_t);
 extern int do_notify_parent(struct task_struct *, int);
+extern int do_signal_parent(struct task_struct *, int, int, int);
 extern void __wake_up_parent(struct task_struct *p, struct task_struct *parent);
 extern void force_sig(int, struct task_struct *);
 extern int send_sig(int, struct task_struct *, int);
diff --git a/kernel/signal.c b/kernel/signal.c
index 4e3cff1..3e71e27 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1434,14 +1434,8 @@ ret:
 	return ret;
 }
 
-/*
- * Let a parent know about the death of a child.
- * For a stopped/continued status change, use do_notify_parent_cldstop instead.
- *
- * Returns -1 if our parent ignored us and so we've switched to
- * self-reaping, or else @sig.
- */
-int do_notify_parent(struct task_struct *tsk, int sig)
+int do_signal_parent(struct task_struct *tsk, int sig, int sicode,
+	int sistatus)
 {
 	struct siginfo info;
 	unsigned long flags;
@@ -1450,11 +1444,8 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 
 	BUG_ON(sig == -1);
 
- 	/* do_notify_parent_cldstop should have been called instead.  */
- 	BUG_ON(task_is_stopped_or_traced(tsk));
-
-	BUG_ON(!task_ptrace(tsk) &&
-	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
+	/* do_notify_parent_cldstop should have been called instead.  */
+	BUG_ON(task_is_stopped_or_traced(tsk));
 
 	info.si_signo = sig;
 	info.si_errno = 0;
@@ -1480,15 +1471,8 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	info.si_stime = cputime_to_clock_t(cputime_add(tsk->stime,
 				tsk->signal->stime));
 
-	info.si_status = tsk->exit_code & 0x7f;
-	if (tsk->exit_code & 0x80)
-		info.si_code = CLD_DUMPED;
-	else if (tsk->exit_code & 0x7f)
-		info.si_code = CLD_KILLED;
-	else {
-		info.si_code = CLD_EXITED;
-		info.si_status = tsk->exit_code >> 8;
-	}
+	info.si_code = sicode;
+	info.si_status = sistatus;
 
 	psig = tsk->parent->sighand;
 	spin_lock_irqsave(&psig->siglock, flags);
@@ -1510,9 +1494,10 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 		 * is implementation-defined: we do (if you don't want
 		 * it, just use SIG_IGN instead).
 		 */
-		ret = tsk->exit_signal = -1;
 		if (psig->action[SIGCHLD-1].sa.sa_handler == SIG_IGN)
 			sig = -1;
+		/* reap process now, rather than promoting to zombie */
+		ret = DEATH_REAP;
 	}
 	if (valid_signal(sig) && sig > 0)
 		__group_send_sig_info(sig, &info, tsk->parent);
@@ -1522,6 +1507,36 @@ int do_notify_parent(struct task_struct *tsk, int sig)
 	return ret;
 }
 
+/*
+ * Let a parent know about the death of a child.
+ * For a stopped/continued status change, use do_notify_parent_cldstop instead.
+ *
+ * Returns -1 if our parent ignored us and so we've switched to
+ * self-reaping, or else @sig.
+ */
+int do_notify_parent(struct task_struct *tsk, int sig)
+{
+	int sicode, sistatus, ret;
+
+	BUG_ON(!task_ptrace(tsk) &&
+	       (tsk->group_leader != tsk || !thread_group_empty(tsk)));
+
+	sistatus = tsk->exit_code & 0x7f;
+	if (tsk->exit_code & 0x80)
+		sicode = CLD_DUMPED;
+	else if (tsk->exit_code & 0x7f)
+		sicode = CLD_KILLED;
+	else {
+		sicode = CLD_EXITED;
+		sistatus = tsk->exit_code >> 8;
+	}
+
+	ret = do_signal_parent(tsk, sig, sicode, sistatus);
+	if (ret == DEATH_REAP)
+		tsk->exit_signal = -1;
+	return ret;
+}
+
 static void do_notify_parent_cldstop(struct task_struct *tsk, int why)
 {
 	struct siginfo info;

--------------000400040800070103090505--
