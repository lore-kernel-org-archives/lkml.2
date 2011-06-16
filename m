Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab1FPPds (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:33:48 -0400
Received: from mtagate4.uk.ibm.com ([194.196.100.164]:43318 "EHLO
	mtagate4.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab1FPPdr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:33:47 -0400
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was
 Vpid:)
From: Greg Kurz <gkurz@fr.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Cedric Le Goater <clg@vnet.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, containers@lists.osdl.org,
        akpm@linux-foundation.org, xemul@openvz.org
In-Reply-To: <m1y611bysa.fsf@fess.ebiederm.org>
References: <20110615145527.4016.70157.stgit@bahia.local>
	 <20110615190302.GA16440@redhat.com>	<1308223158.8230.66.camel@bahia.local>
	 <4DF9F657.7030605@fr.ibm.com>  <m1y611bysa.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Jun 2011 17:33:32 +0200
Message-ID: <1308238412.8230.95.camel@bahia.local>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-16 at 08:07 -0700, Eric W. Biederman wrote:
> > Finally, we thought that the 'ActivePid' information was interesting 
> > enough to be exposed in /proc and was solving the case we're facing 
> > rather easily with some framework (cgroups) in user space.
> 
> The pid number by which a process knows itself doesn't seem
> unreasonable.  I'm not totally 
> 
> After having a second look at the code in proc we already have
> a reference to the struct pid we want to print.  So simply
> printing
> pid->numbers[pid->level].nr
> seems reasonable, and race free.
> 
> Alternatively that could be written.
> pid_nr_ns(pid, ns_of_pid(pid));
> 
> Eric

So we end up with the following, since pid is valid:

diff --git a/fs/proc/array.c b/fs/proc/array.c
index 5e4f776..b7316cc 100644
--- a/fs/proc/array.c
+++ b/fs/proc/array.c
@@ -183,12 +183,14 @@ static inline void task_state(struct seq_file *m,
struct pid_namespace *ns,
 		"Pid:\t%d\n"
 		"PPid:\t%d\n"
 		"TracerPid:\t%d\n"
+		"ActivePid:\t%d\n"
 		"Uid:\t%d\t%d\t%d\t%d\n"
 		"Gid:\t%d\t%d\t%d\t%d\n",
 		get_task_state(p),
 		task_tgid_nr_ns(p, ns),
 		pid_nr_ns(pid, ns),
 		ppid, tpid,
+		pid_nr_ns(pid, ns_of_pid(pid)),
 		cred->uid, cred->euid, cred->suid, cred->fsuid,
 		cred->gid, cred->egid, cred->sgid, cred->fsgid);

-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
        Alan Moore.

