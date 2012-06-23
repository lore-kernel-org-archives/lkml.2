Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756512Ab2FWXVa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Jun 2012 19:21:30 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:48026 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754011Ab2FWXV2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Jun 2012 19:21:28 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Rob Landley <rob@landley.net>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Doug Ledford <dledford@redhat.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Joe Korty <joe.korty@ccur.com>, linux-doc@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20120623001206.GA22639@www.outflux.net>
Date: Sat, 23 Jun 2012 16:21:11 -0700
In-Reply-To: <20120623001206.GA22639@www.outflux.net> (Kees Cook's message of
	"Fri, 22 Jun 2012 17:12:06 -0700")
Message-ID: <87mx3twr6g.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+U8aatb0tHT9Yw6TJ+5RrWRXbhg8ZnS7E=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1342]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: 
Subject: Re: [PATCH v4] fs: make dumpable=2 only write to a pipe
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> When the suid_dumpable sysctl is set to "2", and there is no core
> dump pipe defined in the core_pattern sysctl, a local user can cause
> core files to be written to root-writable directories, potentially
> with user-controlled content. This means an admin can unknowningly
> reintroduce a variation of CVE-2006-2451, allowing local users to gain
> root privileges.

Is there a security exploit possible if a path is defined in the
core_pattern?

>From the description of the problem so far I don't think there is.
Requiring a program when a simple path will do seems excessive.

Eric


> $ cat /proc/sys/fs/suid_dumpable
> 2
> $ cat /proc/sys/kernel/core_pattern
> core
> $ ulimit -c unlimited
> $ cd /
> $ ls -l core
> ls: cannot access core: No such file or directory
> $ touch core
> touch: cannot touch `core': Permission denied
> $ OHAI="evil-string-here" ping localhost >/dev/null 2>&1 &
> $ pid=$!
> $ sleep 1
> $ kill -SEGV $pid
> $ ls -l core
> -rw------- 1 root kees 458752 Jun 21 11:35 core
> $ sudo strings core | grep evil
> OHAI=evil-string-here
>
> While cron has been fixed to abort reading a file when there is any
> parse error, there are still other sensitive directories that will read
> any file present and skip unparsable lines.
>
> Instead of introducing a suid_dumpable=3 mode and breaking all users
> of mode 2, this only disables the unsafe portion of mode 2 (writing to
> disk). Most users of mode 2 (e.g. Chrome OS) already use a core dump
> pipe handler, so this change will not break them. For the situations
> where a pipe handler is not defined but mode 2 is still active, crash
> dumps will no longer be written to disk, and will instead trigger a
> printk yelling about the lack of the pipe handler.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v4:
>  - drop mode 3 in favor of only half-breaking mode 2, requested by
>    Andrew Morton.
>  - yell loudly when encountering a mode 2 disk dump, suggested by
>    Andrew Morton.
> v3:
>  - use proper sysctl _conv function, fix commit description, suggested by
>   Eric W. Biederman.
> v2:
>  - switch to mode 3, remove mode 2, suggested by Alan Cox.
> ---
>  Documentation/sysctl/fs.txt |   18 +++++++++++-------
>  fs/exec.c                   |   37 ++++++++++++++++---------------------
>  2 files changed, 27 insertions(+), 28 deletions(-)
>
> diff --git a/Documentation/sysctl/fs.txt b/Documentation/sysctl/fs.txt
> index 13d6166..d20e2ea 100644
> --- a/Documentation/sysctl/fs.txt
> +++ b/Documentation/sysctl/fs.txt
> @@ -163,16 +163,20 @@ This value can be used to query and set the core dump mode for setuid
>  or otherwise protected/tainted binaries. The modes are
>  
>  0 - (default) - traditional behaviour. Any process which has changed
> -	privilege levels or is execute only will not be dumped
> +	privilege levels or is execute only will not be dumped.
>  1 - (debug) - all processes dump core when possible. The core dump is
>  	owned by the current user and no security is applied. This is
>  	intended for system debugging situations only. Ptrace is unchecked.
> -2 - (suidsafe) - any binary which normally would not be dumped is dumped
> -	readable by root only. This allows the end user to remove
> -	such a dump but not access it directly. For security reasons
> -	core dumps in this mode will not overwrite one another or
> -	other files. This mode is appropriate when administrators are
> -	attempting to debug problems in a normal environment.
> +	This is insecure as it allows regular users to examine the memory
> +	contents of privileged processes.
> +2 - (pipeonly) - any binary which normally would not be dumped is dumped
> +	anyway, but only if a core dump pipe handler is defined (see the
> +	"core_pattern" kernel sysctl). This mode is appropriate when
> +	administrators are attempting to debug problems in a normal
> +	environment, and have a core dump pipe handler that knows to
> +	treat privileged core dumps with care. If a core dump happens
> +	without a pipe handler, a message will be emitted to syslog
> +	warning about the lack of a pipe handler.
>  
>  ==============================================================
>  
> diff --git a/fs/exec.c b/fs/exec.c
> index da27b91..715d7cf 100644
> --- a/fs/exec.c
> +++ b/fs/exec.c
> @@ -2106,10 +2106,8 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  	struct core_name cn;
>  	struct mm_struct *mm = current->mm;
>  	struct linux_binfmt * binfmt;
> -	const struct cred *old_cred;
> -	struct cred *cred;
> +	bool pipeonly = false;
>  	int retval = 0;
> -	int flag = 0;
>  	int ispipe;
>  	static atomic_t core_dump_count = ATOMIC_INIT(0);
>  	struct coredump_params cprm = {
> @@ -2132,25 +2130,16 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  	if (!__get_dumpable(cprm.mm_flags))
>  		goto fail;
>  
> -	cred = prepare_creds();
> -	if (!cred)
> -		goto fail;
>  	/*
> -	 *	We cannot trust fsuid as being the "true" uid of the
> -	 *	process nor do we know its entire history. We only know it
> -	 *	was tainted so we dump it as root in mode 2.
> +	 * We cannot trust the environment when dumping in mode 2, so only
> +	 * write the dump to a pipe.
>  	 */
> -	if (__get_dumpable(cprm.mm_flags) == 2) {
> -		/* Setuid core dump mode */
> -		flag = O_EXCL;		/* Stop rewrite attacks */
> -		cred->fsuid = GLOBAL_ROOT_UID;	/* Dump root private */
> -	}
> +	if (__get_dumpable(cprm.mm_flags) == 2)
> +		pipeonly = true;
>  
>  	retval = coredump_wait(exit_code, &core_state);
>  	if (retval < 0)
> -		goto fail_creds;
> -
> -	old_cred = override_creds(cred);
> +		goto fail;
>  
>  	/*
>  	 * Clear any false indication of pending signals that might
> @@ -2220,11 +2209,20 @@ void do_coredump(long signr, int exit_code, struct pt_regs *regs)
>  	} else {
>  		struct inode *inode;
>  
> +		if (pipeonly) {
> +			printk(KERN_WARNING "Pid %d(%s) could not dump core "\
> +				"without a core dump pipe handler defined "\
> +				"via the core_pattern sysctl!\n",
> +			       task_tgid_vnr(current), current->comm);
> +			printk(KERN_WARNING "Skipping core dump\n");
> +			goto fail_unlock;
> +		}
> +
>  		if (cprm.limit < binfmt->min_coredump)
>  			goto fail_unlock;
>  
>  		cprm.file = filp_open(cn.corename,
> -				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE | flag,
> +				 O_CREAT | 2 | O_NOFOLLOW | O_LARGEFILE,
>  				 0600);
>  		if (IS_ERR(cprm.file))
>  			goto fail_unlock;
> @@ -2268,9 +2266,6 @@ fail_unlock:
>  	kfree(cn.corename);
>  fail_corename:
>  	coredump_finish(mm);
> -	revert_creds(old_cred);
> -fail_creds:
> -	put_cred(cred);
>  fail:
>  	return;
>  }
