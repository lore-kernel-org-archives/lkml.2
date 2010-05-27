Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757656Ab0E0Qn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 12:43:28 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54027 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754206Ab0E0Qn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 12:43:27 -0400
Date: Thu, 27 May 2010 09:39:41 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
cc: Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Richard Henderson <rth@twiddle.net>, wezhang@redhat.com,
       linux-kernel@vger.kernel.org, Michael Kerrisk <mtk.manpages@gmail.com>,
       William Cohen <wcohen@redhat.com>
Subject: Re: [PATCH 1/3] sys_personality: validate personality before
 set_personality()
In-Reply-To: <20100527153548.GB13858@redhat.com>
Message-ID: <alpine.LFD.2.00.1005270921540.3689@i5.linux-foundation.org>
References: <20100525141720.GA2253@redhat.com> <20100525193348.83F1549A54@magilla.sf.frob.com> <20100526123622.GA26033@redhat.com> <20100526203105.59D7849A56@magilla.sf.frob.com> <20100527153522.GA13858@redhat.com> <20100527153548.GB13858@redhat.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 27 May 2010, Oleg Nesterov wrote:
> 
> --- 34-rc1/kernel/exec_domain.c~1_CK_OVERFLOW_EARLIER	2009-04-06 00:03:42.000000000 +0200
> +++ 34-rc1/kernel/exec_domain.c	2010-05-27 15:15:12.000000000 +0200
> @@ -193,9 +193,9 @@ SYSCALL_DEFINE1(personality, u_long, per
>  	u_long old = current->personality;
>  
>  	if (personality != 0xffffffff) {
> -		set_personality(personality);
> -		if (current->personality != personality)
> +		if ((unsigned int)personality != personality)
>  			return -EINVAL;
> +		set_personality(personality);
>  	}

I think this is total random noise. The whole type system is crazy - don't 
just paper over it.

The thing shouldn't use "u_long" in the first place. That's a totally 
bogus type to start with (hint: do a "git grep u_long" and see that most 
of them are in badly done drivers, and the _only_ hits inside kernel/ are 
in that broken personality handling)

And if we decide that the field must fit in an unsigned int (reasonable), 
then let's just ignore the top bits, and make it work right even if 
somebody passes in an unsigned int!

IOW, we should just clean the mess up entirely. Like the appended, I 
think.

NOTE! Untested, of course. But our whole system call infrastructure should 
mean that on architectures like 64-bit powerpc that needs wrappers to make 
sure that 32-bit arguments are properly sign-extended, this should all 
work fine. We'll only look at the low bits.

(That "ident_map" should be "unsigned int" or even "unsigned char", but 
that's a separate thing. I just got rid of the bogus "u_long" crap).

		Linus

---
 include/linux/personality.h |    2 +-
 include/linux/syscalls.h    |    2 +-
 kernel/exec_domain.c        |   18 +++++++++---------
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/include/linux/personality.h b/include/linux/personality.h
index 1261208..eec3bae 100644
--- a/include/linux/personality.h
+++ b/include/linux/personality.h
@@ -12,7 +12,7 @@ struct pt_regs;
 
 extern int		register_exec_domain(struct exec_domain *);
 extern int		unregister_exec_domain(struct exec_domain *);
-extern int		__set_personality(unsigned long);
+extern int		__set_personality(unsigned int);
 
 #endif /* __KERNEL__ */
 
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 057929b..7a858d6 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -312,7 +312,7 @@ asmlinkage long sys_capget(cap_user_header_t header,
 				cap_user_data_t dataptr);
 asmlinkage long sys_capset(cap_user_header_t header,
 				const cap_user_data_t data);
-asmlinkage long sys_personality(u_long personality);
+asmlinkage long sys_personality(unsigned int personality);
 
 asmlinkage long sys_sigpending(old_sigset_t __user *set);
 asmlinkage long sys_sigprocmask(int how, old_sigset_t __user *set,
diff --git a/kernel/exec_domain.c b/kernel/exec_domain.c
index c35452c..e016d3c 100644
--- a/kernel/exec_domain.c
+++ b/kernel/exec_domain.c
@@ -27,7 +27,7 @@ static struct exec_domain *exec_domains = &default_exec_domain;
 static DEFINE_RWLOCK(exec_domains_lock);
 
 
-static u_long ident_map[32] = {
+static unsigned long ident_map[32] = {
 	0,	1,	2,	3,	4,	5,	6,	7,
 	8,	9,	10,	11,	12,	13,	14,	15,
 	16,	17,	18,	19,	20,	21,	22,	23,
@@ -56,10 +56,10 @@ default_handler(int segment, struct pt_regs *regp)
 }
 
 static struct exec_domain *
-lookup_exec_domain(u_long personality)
+lookup_exec_domain(unsigned int personality)
 {
-	struct exec_domain *	ep;
-	u_long			pers = personality(personality);
+	struct exec_domain *ep;
+	unsigned int pers = personality(personality);
 
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
 
@@ -188,9 +188,9 @@ static int __init proc_execdomains_init(void)
 module_init(proc_execdomains_init);
 #endif
 
-SYSCALL_DEFINE1(personality, u_long, personality)
+SYSCALL_DEFINE1(personality, unsigned int, personality)
 {
-	u_long old = current->personality;
+	unsigned int old = current->personality;
 
 	if (personality != 0xffffffff) {
 		set_personality(personality);
@@ -198,7 +198,7 @@ SYSCALL_DEFINE1(personality, u_long, personality)
 			return -EINVAL;
 	}
 
-	return (long)old;
+	return old;
 }
 
 
