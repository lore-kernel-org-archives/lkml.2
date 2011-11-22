Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757000Ab1KVQaw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 11:30:52 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:21511 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751668Ab1KVQav (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 11:30:51 -0500
Message-ID: <4ECBCE30.30001@parallels.com>
Date: Tue, 22 Nov 2011 20:30:40 +0400
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
References: <4EC4F2FB.408@parallels.com> <20111117154936.GB12325@redhat.com> <4EC52FBF.1010407@parallels.com> <20111118233055.GA29378@google.com> <4ECA1696.5060500@parallels.com> <20111121225019.GQ25776@google.com> <4ECB8346.8040806@parallels.com> <20111122152312.GB322@google.com>
In-Reply-To: <20111122152312.GB322@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/22/2011 07:23 PM, Tejun Heo wrote:
> Hello,
> 
> On Tue, Nov 22, 2011 at 03:11:02PM +0400, Pavel Emelyanov wrote:
>>> Hmmm... I hope this could be prettier.  I'm having trouble following
>>> where the MAY_OPEN comes from.  Can you please explain?
>>
>> From this calltrace:
>>
>>  pid_ns_ctl_permissions
>>  sysctl_perm
>>  proc_sys_permission
>>  inode_permission
>>  do_last <<<<< MAY_OPEN appears here
>>  path_openat
>>  do_filp_open
>>  do_sys_open
>>  sys_open
> 
> Thanks a lot. :)
> 
>>> Can't we for now allow this for root and then later allow CAP_CHECKPOINT 
>>> that Cyrill suggested?  Or do we want to allow setting pids even w/o CR 
>>> for NS creator?
>>
>> I think that systemd guys can play with it. E.g. respawning daemons with predefined
>> pids sounds like an interesting thing to play with.
> 
> But wouldn't CAP_CHECKPOINT be enough for systemd?

It would, but what's the point in granting to a systemd (which can be a container's
init by the way) the ability to use the _whole_ checkpoint/restore engine?

Even more - protecting with the capability implies, that any task might want to play
with it. But what's the point for an arbitrary task, that just _lives_ in a pid namespace
to set the last_pid of its namespace?

>>>> +static int pid_ns_ctl_handler(struct ctl_table *table, int write,
>>>> +		     void __user *buffer, size_t *lenp, loff_t *ppos)
>>>> +{
>>>> +	struct ctl_table tmp = *table;
>>>> +	tmp.data = &current->nsproxy->pid_ns->last_pid;
>>>> +	return proc_dointvec(&tmp, write, buffer, lenp, ppos);
>>>> +}
>>>
>>> Probably better to call set_last_pid() on write path instead?
>>
>> Why? The usage of this sysctl is going to be synchronized  by external locks,
>> so why should we care?
> 
> I think the question should usually be the other way around.  Why
> deviate when the deviation doesn't earn any tangible benefit?  If you
> think setting it explicitly is justified, explain why in the comment
> of the setter and places where those explicit settings are.

The set_last_pid() is the way to update the last_pid by two concurrent updaters. Since
setting the last_pid via sysctl is racy by its nature, using that race protection is
just pointless.

And yes, I agree, that writing this comment is a good idea :)

> Thanks.
> 

