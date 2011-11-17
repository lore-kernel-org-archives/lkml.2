Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab1KQPty (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 10:49:54 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:17213 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab1KQPtx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 10:49:53 -0500
Message-ID: <4EC52D14.8090701@parallels.com>
Date: Thu, 17 Nov 2011 19:49:40 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@linux.intel.com>, Roland McGrath <roland@hack.frob.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Cyrill Gorcunov <gorcunov@openvz.org>,
        James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
 pids
References: <4EC4F2FB.408@parallels.com> <4EC4F348.6020101@parallels.com> <20111117153200.GA12325@redhat.com>
In-Reply-To: <20111117153200.GA12325@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 07:32 PM, Oleg Nesterov wrote:
> On 11/17, Pavel Emelyanov wrote:
>>
>> +static int set_pidmap(struct pid_namespace *pid_ns, int pid)
>> +{
>> +	int offset;
>> +	struct pidmap *map;
>> +
>> +	/*
>> +	 * When creating a new pid namespace we must make its init
>> +	 * have pid == 1 in it.
>> +	 */
>> +	if (pid_ns->child_reaper == NULL)
>> +		return 0;
> 
> Do we really need this check? please see below...
> 
>> +	/*
>> +	 * Don't allow to create a task with a pid which has recently
>> +	 * belonged to some other (dead already) task. Only init (of
>> +	 * a freshly created namespace) and his clones can do this.
>> +	 */
>> +	if (pid_ns->last_pid != 1)
>> +		return -EPERM;
> 
> ->last_pid == 1. This means that pid_nr == 1 was already created
> in this namespace via CLONE_NEWPID, and the child with this pid
> must be ->child_reaper, no?

If you use the CLONE_NEWPID | CLONE_CHILD_USEPIDS then you should provide the 1st
pid in array is 1. Otherwise init in this new pid namespace will have pid != 1 and
the child_reaper assignment (yes, the 45a68628 commit) will be lost :(

> IOW. if copy_process() allocs the first pid in the new pid_ns, it
> always sets ->child_reaper.

Fixup - if it allocates pid == 1, then it sets the child reaper.

> Cough. I really think 45a68628 should be reverted ;) IMHO it
> complicates the understanding of CLONE_NEWPID logic.

If we remove it, then it's OK to remove the check above, but in this case we
make it possible to have an init with pid != 1. This is flexible, but ... strange.

> Oleg.
> 
> .
> 

