Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759425Ab2EUWFo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 18:05:44 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42274 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753290Ab2EUWFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 18:05:42 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
References: <20120521175009.7bd4948c026d8acc61f26753@canb.auug.org.au>
Date: Mon, 21 May 2012 16:05:16 -0600
In-Reply-To: <20120521175009.7bd4948c026d8acc61f26753@canb.auug.org.au>
	(Stephen Rothwell's message of "Mon, 21 May 2012 17:50:09 +1000")
Message-ID: <87pq9x6vhf.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=208.38.5.102;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+/B+K8ThjuD9nJbw4+HeAuahTM8nGxm2E=
X-SA-Exim-Connect-IP: 208.38.5.102
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 TVD_RCVD_IP TVD_RCVD_IP
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Stephen Rothwell <sfr@canb.auug.org.au>
X-Spam-Relay-Country: 
Subject: Re: linux-next: build failure after merge of the userns tree
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> Hi Eric,
>
> After merging the userns tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>
> kernel/sched/numa.c: In function 'ng_allowed':
> kernel/sched/numa.c:1270:16: error: 'struct user_struct' has no member named 'user_ns'
> kernel/sched/numa.c:1270:40: error: 'struct user_struct' has no member named 'user_ns'
> kernel/sched/numa.c:1278:28: error: 'struct user_struct' has no member named 'user_ns'
>
> Caused by commit a2dae61eb839 ("sched/numa: Introduce sys_numa_{t,m}bind
> ()") from the tip tree interacting with commit d0bd6594e286 ("userns:
> Deprecate and rename the user_namespace reference in the user_struct")
> from the userns tree.
>
> I applied this merge fix up patch (more may be required):

The fix is right.

Peter Zijlstra, or Ingo any chance you could add the patch below to your
tree?

It is just a better idiom to access the user namespace pointer as
cred->user_ns, instead of cred->user->user_ns and has been for a few
kernel releases.

Once my usernamespace tree is merged into Linus's tree a little more
will be needed to build this code with user namespaces enabled, but
cred->user->user to cred->user_ns is an improvement whichever way
you look at it.

Otherwise I guess this merge failure will act as a reminder that this
code needs a few more changes.

> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Mon, 21 May 2012 17:40:55 +1000
> Subject: [PATCH] userns: fix up for user_ns move to struct cred
>
Reviewed-by: "Eric W. Biederman" <ebiederm@xmission.com>
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  kernel/sched/numa.c |    4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/sched/numa.c b/kernel/sched/numa.c
> index 8eb92f7..1149993 100644
> --- a/kernel/sched/numa.c
> +++ b/kernel/sched/numa.c
> @@ -1267,7 +1267,7 @@ static int ng_allowed(struct numa_group *ng, struct task_struct *p)
>  
>  	rcu_read_lock();
>  	tcred = __task_cred(p);
> -	if (cred->user->user_ns == tcred->user->user_ns &&
> +	if (cred->user_ns == tcred->user_ns &&
>  	    (cred->uid == tcred->euid &&
>  	     cred->uid == tcred->suid &&
>  	     cred->uid == tcred->uid  &&
> @@ -1275,7 +1275,7 @@ static int ng_allowed(struct numa_group *ng, struct task_struct *p)
>  	     cred->gid == tcred->sgid &&
>  	     cred->gid == tcred->gid))
>  		goto ok;
> -	if (ns_capable(tcred->user->user_ns, CAP_SYS_PTRACE))
> +	if (ns_capable(tcred->user_ns, CAP_SYS_PTRACE))
>  		goto ok;
>  	rcu_read_unlock();
>  	return -EPERM;
> -- 
> 1.7.10.280.gaa39
