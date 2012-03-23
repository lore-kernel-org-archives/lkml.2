Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546Ab2CWWCn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 18:02:43 -0400
Received: from out06.mta.xmission.com ([166.70.13.236]:44910 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754574Ab2CWWCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 18:02:41 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>,
        Darren Hart <dvhart@linux.intel.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, David Howells <dhowells@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com,
        spender@grsecurity.net,
        Linux Containers <containers@lists.linux-foundation.org>
References: <20120323190855.GA27213@www.outflux.net>
Date: Fri, 23 Mar 2012 15:06:02 -0700
In-Reply-To: <20120323190855.GA27213@www.outflux.net> (Kees Cook's message of
	"Fri, 23 Mar 2012 12:08:55 -0700")
Message-ID: <m1fwczvuph.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18+i18l1fM1GnPImKlssjN7xeIXn+9zgcw=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Kees Cook <keescook@chromium.org>
X-Spam-Relay-Country: **
Subject: Re: [PATCH v2] futex: mark get_robust_list as deprecated
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:

> Notify get_robust_list users that the syscall is going away.

Has anyone asked the question if the folks working on checkpoint/restart
are going to need this.

This seems like important information to know if you want to checkpoint
a process.

Eric

> Suggested-by: Thomas Gleixner <tglx@linutronix.de>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
> v2:
>  - add note to feature-removal-schedule.txt.
> ---
>  Documentation/feature-removal-schedule.txt |   10 ++++++++++
>  kernel/futex.c                             |    2 ++
>  kernel/futex_compat.c                      |    2 ++
>  3 files changed, 14 insertions(+), 0 deletions(-)
>
> diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
> index 4bfd982..e3bf119 100644
> --- a/Documentation/feature-removal-schedule.txt
> +++ b/Documentation/feature-removal-schedule.txt
> @@ -543,3 +543,13 @@ When:	3.5
>  Why:	The old kmap_atomic() with two arguments is deprecated, we only
>  	keep it for backward compatibility for few cycles and then drop it.
>  Who:	Cong Wang <amwang@redhat.com>
> +
> +----------------------------
> +
> +What:	get_robust_list syscall
> +When:	2013
> +Why:	There appear to be no production users of the get_robust_list syscall,
> +	and it runs the risk of leaking address locations, allowing the bypass
> +	of ASLR. It was only ever intended for debugging, so it should be
> +	removed.
> +Who:	Kees Cook <keescook@chromium.org>
> diff --git a/kernel/futex.c b/kernel/futex.c
> index d701be5..e2b0fb9 100644
> --- a/kernel/futex.c
> +++ b/kernel/futex.c
> @@ -2449,6 +2449,8 @@ SYSCALL_DEFINE3(get_robust_list, int, pid,
>  	if (!futex_cmpxchg_enabled)
>  		return -ENOSYS;
>  
> +	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
> +
>  	rcu_read_lock();
>  
>  	ret = -ESRCH;
> diff --git a/kernel/futex_compat.c b/kernel/futex_compat.c
> index a9642d5..83e368b 100644
> --- a/kernel/futex_compat.c
> +++ b/kernel/futex_compat.c
> @@ -142,6 +142,8 @@ compat_sys_get_robust_list(int pid, compat_uptr_t __user *head_ptr,
>  	if (!futex_cmpxchg_enabled)
>  		return -ENOSYS;
>  
> +	WARN_ONCE(1, "deprecated: get_robust_list will be deleted in 2013.\n");
> +
>  	rcu_read_lock();
>  
>  	ret = -ESRCH;
