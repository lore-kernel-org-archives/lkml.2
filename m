Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab2CYSrX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 14:47:23 -0400
Received: from nm7-vm0.access.bullet.mail.mud.yahoo.com ([66.94.237.189]:25891
	"HELO nm7-vm0.access.bullet.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756773Ab2CYSrW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 14:47:22 -0400
X-Yahoo-Newman-Id: 886917.24740.bm@smtp102.biz.mail.gq1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: ilhKRVcVM1mLT5VDYmpfKlB3kIxE3GVhP3JdvKOpaD6I3sZ
 6lQB3kGiakkULpFDMokMmp.ELUR8d3n6VOCKmmX7VUiBdSzkpJCpPabmWsr0
 Fqh5zfVXntKWGDFJORs7KZ2DbSV5aOBStaqeoDddGXnxgeMs85Qatz7oJnW9
 zANHokLJIJM6vv1s6dB0PLe9z5bkj3CaGEObSKsHVkuwF0pmrxPJ_XMTr4TF
 PC5vmI5uTF2XP2K2G9obcucitJlkusgTwKHzggiw5ChMto1w.UbwPEc_rvWz
 5Fnia2JusJl_jUAGe.eVafPVOON7pDtYuJhsceSX14e9zhZArySc0e4qAJHt
 ymktFzACDoAbNFGMeWy5R1Olu4wt9.D0cU6RyKWagWl89xwy7uupd52XGDss
 vaUIf6DiJufdORDBsFmfXhBebbDspVBvzSm14BXO71MBdtXrzKw--
X-Yahoo-SMTP: OIJXglSswBDfgLtXluJ6wiAYv6_cnw--
Message-ID: <4F6F6839.6020605@schaufler-ca.com>
Date: Sun, 25 Mar 2012 11:47:21 -0700
From: Casey Schaufler <casey@schaufler-ca.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Kees Cook <keescook@chromium.org>
CC: linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH] audit: always report seccomp violations
References: <20120323233212.GA18484@www.outflux.net>
In-Reply-To: <20120323233212.GA18484@www.outflux.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/23/2012 4:32 PM, Kees Cook wrote:
> When a program violates its own seccomp rules, that is a pretty dire
> situation, and the audit message should always be reported (not just
> when there is already a rule active for the process).

Hmm. If the program is never going to violate its own
seccomp rules it seems sort of silly to have them in the
first place, doesn't it? Oh, I know that the expectation
of seccomp is that the application would only try something
you've disallowed if it gets compromised. Problem is that
Modern Programmers tend to rely very heavily on the opaque
behavior of APIs that they don't understand nor particularly
care if they understand. When assumptions are made about the
behavior of the API code, and the API code changes, as
occurs with amazing frequency on today's mobile devices,
there are going to be surprises. I would wager that the
modern frequency of API changes will result in this behavior
being very unpopular.

>
> This change makes the audit_seccomp() logic similar to audit_core_dumps()
> (it does not require an active context). Since core dumps are more
> common, they sit behind an "audit_enabled" test. Audit reports of seccomp
> failures should always be visible, and fall back to printk when auditd
> is not running.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  include/linux/audit.h |    8 +-------
>  kernel/auditsc.c      |   11 +++++++++--
>  2 files changed, 10 insertions(+), 9 deletions(-)
>
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index ed3ef19..596077f 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -463,7 +463,7 @@ extern void audit_putname(const char *name);
>  extern void __audit_inode(const char *name, const struct dentry *dentry);
>  extern void __audit_inode_child(const struct dentry *dentry,
>  				const struct inode *parent);
> -extern void __audit_seccomp(unsigned long syscall);
> +extern void audit_seccomp(unsigned long syscall);
>  extern void __audit_ptrace(struct task_struct *t);
>  
>  static inline int audit_dummy_context(void)
> @@ -508,12 +508,6 @@ static inline void audit_inode_child(const struct dentry *dentry,
>  }
>  void audit_core_dumps(long signr);
>  
> -static inline void audit_seccomp(unsigned long syscall)
> -{
> -	if (unlikely(!audit_dummy_context()))
> -		__audit_seccomp(syscall);
> -}
> -
>  static inline void audit_ptrace(struct task_struct *t)
>  {
>  	if (unlikely(!audit_dummy_context()))
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index af1de0f..a5caecd 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -2693,7 +2693,7 @@ static void audit_log_abend(struct audit_buffer *ab, char *reason, long signr)
>   * @signr: signal value
>   *
>   * If a process ends with a core dump, something fishy is going on and we
> - * should record the event for investigation.
> + * should record the event for investigation, if auditing is enabled.
>   */
>  void audit_core_dumps(long signr)
>  {
> @@ -2710,7 +2710,14 @@ void audit_core_dumps(long signr)
>  	audit_log_end(ab);
>  }
>  
> -void __audit_seccomp(unsigned long syscall)
> +/**
> + * audit_seccomp - record information about processes that violate seccomp
> + * @syscall: syscall number that triggered the seccomp violation
> + *
> + * If a process violates its own seccomp rules, something has gone very
> + * wrong, and this event should always be reported for investigation.
> + */
> +void audit_seccomp(unsigned long syscall)
>  {
>  	struct audit_buffer *ab;
>  

