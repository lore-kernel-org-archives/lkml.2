Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758366Ab1KVLLO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:11:14 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:33844 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753074Ab1KVLLM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:11:12 -0500
Message-ID: <4ECB8346.8040806@parallels.com>
Date: Tue, 22 Nov 2011 15:11:02 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with given
 pids
References: <4EC4F2FB.408@parallels.com> <20111117154936.GB12325@redhat.com> <4EC52FBF.1010407@parallels.com> <20111118233055.GA29378@google.com> <4ECA1696.5060500@parallels.com> <20111121225019.GQ25776@google.com>
In-Reply-To: <20111121225019.GQ25776@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> +static int pid_ns_ctl_permissions(struct nsproxy *namespaces,
>> +			struct ctl_table *table, int op)
>> +{
>> +	int mode = 0644;
>> +
>> +	if ((op & MAY_OPEN) &&
>> +			current != namespaces->pid_ns->child_reaper)
>> +		/*
>> +		 * Writing to this sysctl is allowed only for init
>> +		 * and to whoever it grands the open file
>> +		 */
>> +		mode &= ~0222;
>> +
>> +	return sysctl_test_perm(mode, op);
>> +}
>> +
>> +static struct ctl_table_root pid_ns_root = {
>> +	.permissions = pid_ns_ctl_permissions,
>> +};
> 
> Hmmm... I hope this could be prettier.  I'm having trouble following
> where the MAY_OPEN comes from.  Can you please explain?

>From this calltrace:

 pid_ns_ctl_permissions
 sysctl_perm
 proc_sys_permission
 inode_permission
 do_last <<<<< MAY_OPEN appears here
 path_openat
 do_filp_open
 do_sys_open
 sys_open


> Can't we for now allow this for root and then later allow CAP_CHECKPOINT 
> that Cyrill suggested?  Or do we want to allow setting pids even w/o CR 
> for NS creator?

I think that systemd guys can play with it. E.g. respawning daemons with predefined
pids sounds like an interesting thing to play with.

>> +static int pid_ns_ctl_handler(struct ctl_table *table, int write,
>> +		     void __user *buffer, size_t *lenp, loff_t *ppos)
>> +{
>> +	struct ctl_table tmp = *table;
>> +	tmp.data = &current->nsproxy->pid_ns->last_pid;
>> +	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
>> +}
> 
> Probably better to call set_last_pid() on write path instead?

Why? The usage of this sysctl is going to be synchronized  by external locks,
so why should we care?

>> Well, after a bit more thinking I found one more pros for this
>> sysctl - when restoring a container we'll have the possibility to
>> set the last_pid to what we want to prevent the pids reuse after the
>> restore.
> 
> Hmmm... I personally like this one better.  Restoring multilevel pids
> would be more tedious but should still be possible and I really like
> that it's staying out of clone path and all modifications are to ns
> and pid code.  Oleg, what do you think?
> 
> Thank you.
> 

