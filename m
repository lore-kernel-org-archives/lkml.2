Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab1I2HNf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 03:13:35 -0400
Received: from mout.perfora.net ([74.208.4.194]:63454 "EHLO mout.perfora.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751286Ab1I2HNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 03:13:34 -0400
Date: Thu, 29 Sep 2011 03:13:14 -0400
From: Stephen Wilson <wilsons@start.ca>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Stephen Wilson <wilsons@start.ca>, Al Viro <viro@zeniv.linux.org.uk>,
        Johannes Weiner <jweiner@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: Q: proc: hold cred_guard_mutex in check_mem_permission()
Message-ID: <20110929071314.GA7734@wicker.gateway.2wire.net>
References: <20110928202020.GA3164@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110928202020.GA3164@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:N+vyCRHyT7IlaHslbGzH895k8DefTN9I+lnInqq96tU
 a/0PVCVylYXA1yz3jC1cS3C+NyGwP17hcYQDpLUwJ/pfTgB16y
 u8DEYIa80NhG8g9VKXNdtaxeDDMs/myP2yCwYsiHsbhXi+fxqA
 XMmhoSt3TkHZ7YNj0U8qCdqrBrkCmlyEIqngrVjaCePVUUjouZ
 VkHhZkV/G11bFDYl+//PAJhvlZeLDXLwmnvnxVljIwpAVBQhra
 9RhZ1LovwVuClgqfPoq/+CEG4mQuoMBBLkH7lEXSYSk5GM/GYl
 6gUiwyo0KrEy6UdMH20EZKyNbUd+7E10Ze6FdgOJgr8NweHSKS
 DPXyLvzOzGxKlAQW4SRM/OUEw8RbhTBfTWxBj3vp/e01wFpZrq
 SAYsz9xPfEQkg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 10:20:20PM +0200, Oleg Nesterov wrote:
> Another change we probably need to backport, 18f661bc
> "proc: hold cred_guard_mutex in check_mem_permission()".
> 
> From the changelog:
> 
>     Avoid a potential race when task exec's and we get a new ->mm but
>     check against the old credentials in ptrace_may_access().
> 
> Could you please explain? How can we race with exec?

My understanding of the race is this:

sequence during execve():

	1) cred_guard_mutex is taken in prepare_bprm_creds()
	2) new mm is installed via exec_mmap()
	3) new creds are pushed via install_exec_creds() which releases
	   cred_guard_mutex

so if we get_task_mm() and ptrace_may_access() between 2 and 3 we
obtain a reference to the new mm validated against old creds.

Perhaps (the fairly old) commit 704b836c helps? 


> This task is either current, or it is TASK_TRACED and we are the
> tracer. In the latter case nobody can resume it except SIGKILL.
> And the killed task obviously can't exec.
> 
> Afaics, all we need is: we should read task->mm after the
> task_is_traced() check, we do not need the mutex.

Checking ptrace_parent() against current was introduced in 0d094efeb,  but the
commit message gives no clue as to why the check was added.  It does seem to
go against the comment "would also be permitted to freshly attach with
ptrace".  Not sure what to think ATM..

> IOW, what do you think about the patch below? I have no idea how
> can I test it (and it wasn't even applied/compiled).
>
> Also, I'd appreciate if you can explain the PTRACE_MODE_ATTACH
> check. Again, we are already the tracer.

If we are the tracer then that ptrace_may_access() check is redundant and the
whole race thing is a non-issue, right?  But perhaps the correct move is to
relax the restriction that current be the tracer.  I might be overlooking
something though.


Thanks,


-- 
steve

