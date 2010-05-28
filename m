Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755682Ab0E1TN5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 15:13:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:17469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755128Ab0E1TNy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 15:13:54 -0400
Date: Fri, 28 May 2010 21:12:09 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Cc: Roland McGrath <roland@redhat.com>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Richard Henderson <rth@twiddle.net>,
       wezhang@redhat.com, linux-kernel@vger.kernel.org,
       Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: [PATCH 1/2] change sys_personality() to accept "unsigned int"
	instead of u_long
Message-ID: <20100528191209.GC12090@redhat.com>
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com> <20100527153548.GB13858@redhat.com> <alpine.LFD.2.00.1005270921540.3689@i5.linux-foundation.org> <20100527171530.GA18284@redhat.com> <alpine.LFD.2.00.1005271048590.3689@i5.linux-foundation.org> <20100528191139.GB12090@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528191139.GB12090@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

task_struct->pesonality is "unsigned int", but sys_personality() paths
use "unsigned long pesonality". This means that every assignment or
comparison is not right. In particular, if this argument does not fit
into "unsigned int" __set_personality() changes the caller's personality
and then sys_personality() returns -EINVAL.

Turn this argument into "unsigned int" and avoid overflows. Obviously,
this is the user-visible change, we just ignore the upper bits. But
this can't break the sane application.

There is another thing which can confuse the poorly written applications.
User-space thinks that this syscall returns int, not long. This means that
the returned value can be negative and look like the error code. But note
that libc won't be confused and thus errno won't be set, and with this
patch the user-space can never get -1 unless sys_personality() really fails.
And, most importantly, the negative RET != -1 is only possible if that app
previously called personality(RET).

Pointed-out-by: Wenming Zhang <wezhang@redhat.com>
Suggested-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
---

 include/linux/personality.h |    2 +-
 include/linux/syscalls.h    |    2 +-
 kernel/exec_domain.c        |   18 +++++++++---------
 3 files changed, 11 insertions(+), 11 deletions(-)

--- 34-rc1/include/linux/personality.h~1_CHANGE_SIGNATURE	2009-07-13 17:39:44.000000000 +0200
+++ 34-rc1/include/linux/personality.h	2010-05-28 17:07:03.000000000 +0200
@@ -12,7 +12,7 @@ struct pt_regs;
 
 extern int		register_exec_domain(struct exec_domain *);
 extern int		unregister_exec_domain(struct exec_domain *);
-extern int		__set_personality(unsigned long);
+extern int		__set_personality(unsigned int);
 
 #endif /* __KERNEL__ */
 
--- 34-rc1/include/linux/syscalls.h~1_CHANGE_SIGNATURE	2010-03-11 13:11:50.000000000 +0100
+++ 34-rc1/include/linux/syscalls.h	2010-05-28 17:07:03.000000000 +0200
@@ -308,7 +308,7 @@ asmlinkage long sys_capget(cap_user_head
 				cap_user_data_t dataptr);
 asmlinkage long sys_capset(cap_user_header_t header,
 				const cap_user_data_t data);
-asmlinkage long sys_personality(u_long personality);
+asmlinkage long sys_personality(unsigned int personality);
 
 asmlinkage long sys_sigpending(old_sigset_t __user *set);
 asmlinkage long sys_sigprocmask(int how, old_sigset_t __user *set,
--- 34-rc1/kernel/exec_domain.c~1_CHANGE_SIGNATURE	2010-05-28 14:31:14.000000000 +0200
+++ 34-rc1/kernel/exec_domain.c	2010-05-28 18:23:25.000000000 +0200
@@ -27,7 +27,7 @@ static struct exec_domain *exec_domains 
 static DEFINE_RWLOCK(exec_domains_lock);
 
 
-static u_long ident_map[32] = {
+static unsigned long ident_map[32] = {
 	0,	1,	2,	3,	4,	5,	6,	7,
 	8,	9,	10,	11,	12,	13,	14,	15,
 	16,	17,	18,	19,	20,	21,	22,	23,
@@ -56,10 +56,10 @@ default_handler(int segment, struct pt_r
 }
 
 static struct exec_domain *
-lookup_exec_domain(u_long personality)
+lookup_exec_domain(unsigned int personality)
 {
-	struct exec_domain *	ep;
-	u_long			pers = personality(personality);
+	unsigned int pers = personality(personality);
+	struct exec_domain *ep;
 
 	read_lock(&exec_domains_lock);
 	for (ep = exec_domains; ep; ep = ep->next) {
@@ -70,7 +70,7 @@ lookup_exec_domain(u_long personality)
 
 #ifdef CONFIG_MODULES
 	read_unlock(&exec_domains_lock);
-	request_module("personality-%ld", pers);
+	request_module("personality-%d", pers);
 	read_lock(&exec_domains_lock);
 
 	for (ep = exec_domains; ep; ep = ep->next) {
@@ -135,7 +135,7 @@ unregister:
 }
 
 int
-__set_personality(u_long personality)
+__set_personality(unsigned int personality)
 {
 	struct exec_domain	*ep, *oep;
 
@@ -188,9 +188,9 @@ static int __init proc_execdomains_init(
 module_init(proc_execdomains_init);
 #endif
 
-SYSCALL_DEFINE1(personality, u_long, personality)
+SYSCALL_DEFINE1(personality, unsigned int, personality)
 {
-	u_long old = current->personality;
+	unsigned int old = current->personality;
 
 	if (personality != 0xffffffff) {
 		set_personality(personality);
@@ -198,7 +198,7 @@ SYSCALL_DEFINE1(personality, u_long, per
 			return -EINVAL;
 	}
 
-	return (long)old;
+	return old;
 }
 
 

