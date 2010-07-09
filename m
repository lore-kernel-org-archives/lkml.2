Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751703Ab0GIEkJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 00:40:09 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:54013 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab0GIEkG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 00:40:06 -0400
To: Oleg Nesterov <oleg@redhat.com>
Cc: Pavel Emelyanov <xemul@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Containers <containers@lists.osdl.org>,
       linux-kernel@vger.kernel.org, Louis Rilling <Louis.Rilling@kerlabs.com>,
       Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
References: <20100623203652.GA25298@redhat.com>
	<1277399329-18087-1-git-send-email-louis.rilling@kerlabs.com>
	<20100624191843.GA14205@redhat.com>
	<20100625102303.GG3773@hawkmoon.kerlabs.com>
	<20100625183733.GA2627@us.ibm.com> <20100625192945.GA25532@redhat.com>
	<20100625212618.GA11917@us.ibm.com>
	<20100625212758.GA30474@redhat.com>
	<20100625220713.GA31123@us.ibm.com>
	<m1r5jd5l0v.fsf_-_@fess.ebiederm.org>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Thu, 08 Jul 2010 21:39:59 -0700
In-Reply-To: <m1r5jd5l0v.fsf_-_@fess.ebiederm.org> (Eric W. Biederman's message of "Thu\, 08 Jul 2010 21\:36\:32 -0700")
Message-ID: <m1mxu15kv4.fsf_-_@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  1.5 TR_Symld_Words too many words that have symbols inside
	* -3.0 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.1 XMSolicitRefs_0 Weightloss drug
	*  0.0 XM_SPF_Neutral SPF-Neutral
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
Subject: [RFC][PATCH 2/2] pidns: Remove proc flush races when a pid namespaces are exiting.
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Currently it is possible to put proc_mnt before we have flushed the
last process that will use the proc_mnt to flush it's proc entries.

This race is fixed by not flushing proc entries for dead pid
namespaces, and calling pid_ns_release_proc unconditionally from
zap_pid_ns_processes after the pid namespace has been declared dead.

To ensure we don't unnecessarily leak any dcache entries with skipped
flushes pid_ns_release_proc flushes the entire proc_mnt when it is
called.

Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
---
 fs/proc/base.c         |    9 +++++----
 fs/proc/root.c         |    3 +++
 kernel/pid_namespace.c |    1 +
 3 files changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/proc/base.c b/fs/proc/base.c
index acb7ef8..e9d84e1 100644
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -2742,13 +2742,14 @@ void proc_flush_task(struct task_struct *task)
 
 	for (i = 0; i <= pid->level; i++) {
 		upid = &pid->numbers[i];
+
+		/* Don't bother flushing dead pid namespaces */
+		if (test_bit(PIDNS_DEAD, &upid->ns->flags))
+			continue;
+
 		proc_flush_task_mnt(upid->ns->proc_mnt, upid->nr,
 					tgid->numbers[i].nr);
 	}
-
-	upid = &pid->numbers[pid->level];
-	if (upid->nr == 1)
-		pid_ns_release_proc(upid->ns);
 }
 
 static struct dentry *proc_pid_instantiate(struct inode *dir,
diff --git a/fs/proc/root.c b/fs/proc/root.c
index cfdf032..2298fdd 100644
--- a/fs/proc/root.c
+++ b/fs/proc/root.c
@@ -209,5 +209,8 @@ int pid_ns_prepare_proc(struct pid_namespace *ns)
 
 void pid_ns_release_proc(struct pid_namespace *ns)
 {
+	/* Flush any cached proc dentries for this pid namespace */
+	shrink_dcache_parent(ns->proc_mnt->mnt_root);
+
 	mntput(ns->proc_mnt);
 }
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 92032d1..43dec5d 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -189,6 +189,7 @@ void zap_pid_ns_processes(struct pid_namespace *pid_ns)
 		rc = sys_wait4(-1, NULL, __WALL, NULL);
 	} while (rc != -ECHILD);
 
+	pid_ns_release_proc(pid_ns);
 	acct_exit_ns(pid_ns);
 	return;
 }
-- 
1.6.5.2.143.g8cc62

