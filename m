Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757271Ab0KMTvt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Nov 2010 14:51:49 -0500
Received: from mail.perches.com ([173.55.12.10]:1090 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061Ab0KMTvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Nov 2010 14:51:46 -0500
Subject: Re: [PATCH] Fix dmesg_restrict build failure with
 CONFIG_EMBEDDED=y and CONFIG_PRINTK=n
From: Joe Perches <joe@perches.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dan Rosenberg <drosenberg@vsecurity.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Eugene Teo <eugeneteo@kernel.org>, Kees Cook <kees.cook@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
References: <1289669176.16461.12.camel@Joe-Laptop>
	 <AANLkTi=ut2O+mCbs1jOyg-aP=E+48h1B-MH8NxK5XyVf@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 13 Nov 2010 11:51:44 -0800
Message-ID: <1289677904.16461.82.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-11-13 at 09:50 -0800, Linus Torvalds wrote:
> On Sat, Nov 13, 2010 at 9:26 AM, Joe Perches <joe@perches.com> wrote:
> > dmesg_restrict is guarded by #ifdef CONFIG_PRINTK in kernel.h
> > Its uses need to be guarded as well.
> Fair enough, but I think this part:
> > diff --git a/security/commoncap.c b/security/commoncap.c
> > index 04b80f9..29f2368 100644
> > --- a/security/commoncap.c
> > +++ b/security/commoncap.c
> > @@ -895,8 +895,10 @@ int cap_syslog(int type, bool from_file)
> >  {
> >        if (type != SYSLOG_ACTION_OPEN && from_file)
> >                return 0;
> > +#ifdef CONFIG_PRINTK
> >        if (dmesg_restrict && !capable(CAP_SYS_ADMIN))
> >                return -EPERM;
> > +#endif
> >        if ((type != SYSLOG_ACTION_READ_ALL &&
> >             type != SYSLOG_ACTION_SIZE_BUFFER) && !capable(CAP_SYS_ADMIN))
> >                return -EPERM;
> 
> is incredibly ugly. If CONFIG_PRINTK isn't set, the whole function
> just becomes pointless, so why guard just that one part of it?
> 
> So I would suggest guarding the whole thing, and just returning 0 if
> CONFIG_PRINTK isn't set. Or preferably just move the dmesg_restrict
> test into do_syslog, and stop playing stupid games with
> "security_syslog()", which actually goes away if you disable the you
> disable CONFIG_SECURITY.
> 
> SECURITY_DMESG_RESTRICT is totally independent of CONFIG_SECURITY, so
> doing it in security_syslog() was a bug to begin with.
> 
> Or we should make SECURITY_DMESG_RESTRICT _depend_ on CONFIG_SECURITY,
> and move it entirely into security/commoncap.c, and not pollute
> kernel/printk.c at all with it.
> 
> Anyway, suggested replacement patch attached. Comments?
> 
>                          Linus

Maybe something like this?

Make CONFIG_SECURITY_DMESG_RESTRICT depend on CONFIG_SECURITY
Remove dependency on CONFIG_PRINTK

Uncompiled/untested

---
 include/linux/kernel.h |    5 ++++-
 kernel/sysctl.c        |    2 ++
 security/Kconfig       |    1 +
 security/commoncap.c   |    2 ++
 4 files changed, 9 insertions(+), 1 deletions(-)

diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index fc3da9e..b9595e8 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -130,6 +130,10 @@ extern const char linux_proc_banner[];
 
 extern int console_printk[];
 
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
+extern int dmesg_restrict;
+#endif
+
 #define console_loglevel (console_printk[0])
 #define default_message_loglevel (console_printk[1])
 #define minimum_console_loglevel (console_printk[2])
@@ -293,7 +297,6 @@ extern bool printk_timed_ratelimit(unsigned long *caller_jiffies,
 				   unsigned int interval_msec);
 
 extern int printk_delay_msec;
-extern int dmesg_restrict;
 
 /*
  * Print a one-time message (analogous to WARN_ONCE() et al):
diff --git a/kernel/sysctl.c b/kernel/sysctl.c
index b65bf63..5d7eaab 100644
--- a/kernel/sysctl.c
+++ b/kernel/sysctl.c
@@ -703,6 +703,7 @@ static struct ctl_table kern_table[] = {
 		.extra2		= &ten_thousand,
 	},
 #endif
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
 	{
 		.procname	= "dmesg_restrict",
 		.data		= &dmesg_restrict,
@@ -712,6 +713,7 @@ static struct ctl_table kern_table[] = {
 		.extra1		= &zero,
 		.extra2		= &one,
 	},
+#endif
 	{
 		.procname	= "ngroups_max",
 		.data		= &ngroups_max,
diff --git a/security/Kconfig b/security/Kconfig
index e80da95..c6583d6 100644
--- a/security/Kconfig
+++ b/security/Kconfig
@@ -41,6 +41,7 @@ config KEYS_DEBUG_PROC_KEYS
 
 config SECURITY_DMESG_RESTRICT
 	bool "Restrict unprivileged access to the kernel syslog"
+	depends on SECURITY
 	default n
 	help
 	  This enforces restrictions on unprivileged users reading the kernel
diff --git a/security/commoncap.c b/security/commoncap.c
index 04b80f9..37759b2 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -895,8 +895,10 @@ int cap_syslog(int type, bool from_file)
 {
 	if (type != SYSLOG_ACTION_OPEN && from_file)
 		return 0;
+#ifdef CONFIG_SECURITY_DMESG_RESTRICT
 	if (dmesg_restrict && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
+#endif
 	if ((type != SYSLOG_ACTION_READ_ALL &&
 	     type != SYSLOG_ACTION_SIZE_BUFFER) && !capable(CAP_SYS_ADMIN))
 		return -EPERM;


