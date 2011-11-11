Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753779Ab1KKQzu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 11:55:50 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:8900 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753159Ab1KKQzt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 11:55:49 -0500
Message-ID: <4EBD5391.2070802@parallels.com>
Date: Fri, 11 Nov 2011 20:55:45 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Glauber Costa <glommer@parallels.com>, Nathan Lynch <ntl@pobox.com>,
        Tejun Heo <tj@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Serge Hallyn <serue@us.ibm.com>, Daniel Lezcano <dlezcano@fr.ibm.com>
Subject: Re: [PATCH 3/3] pids: Make it possible to clone tasks with given
 pids
References: <4EBC0696.9030103@parallels.com> <4EBC06DB.3090202@parallels.com> <20111110184654.GA1006@redhat.com> <20111110185603.GA1757@redhat.com> <4EBCF4E7.4090002@parallels.com> <20111111152532.GA22640@redhat.com> <4EBD461E.1000106@parallels.com> <20111111163926.GA25106@redhat.com>
In-Reply-To: <20111111163926.GA25106@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> This will make it impossible to fork() children on restore in parallel. And
>> I don't want to lose this ability :(
> 
> Yes, this is true. You need some form of synchronization in user-space.
> But, otoh, prctl/sysctl/whatever is much simpler. Both from implementation
> pov and from understanding/using. You can even do, say, pthread_create()
> to make a thread with the desired tid. And of course I like the fact we
> do not add the new hacks into copy_process's paths.
> 
> And. If you want to restore the process tree, then these new children
> have to cooperate anyway. Say, nobody can clone() without
> CLONE_CHILD_USEPIDS before we restore all pids.
> 
> Yes, sysctl+clone should be "atomic", but that is all. Does it really
> hurt? OK, if nothing else, can't you do somthing like
> 
> 	int fork_with_pid(int pid)
> 	{
> 		int ret;
> 		int pipefd[2];
> 
> 		pipe(pipefd);
> 
> 	retry:
> 		prcrl(PR_SET_LAST_PID, pid-1);
> 		ret = fork();
> 
> 		if (ret == 0) {
> 			/* child, wait from parent's ACK */
> 			read(pipefd[0], 1, NULL);
> 			return 0;
> 		}
> 
> 		/* raced with another user of PR_SET_LAST_PID */
> 		if (unlikely(ret != pid) {
> 			kill(ret, SIGKILL);
> 			waitpid(ret);
> 			goto retry;
> 		}
> 
> 		close(pipefd[1]);
> 		return pid;
> 	}
> 
> ?

Nope, as I said to Tejun, we will most likely not forks children in the depth-first
order, since tasks can share resources and we'll have to calculate the necessary fork
order. Thus this simple interaction simply won't work, more complexity will be required.

But I don't insist. If the CLONE_CHILD_USEPIDS has absolutely no way in the kernel we'll 
have to go the uglier path.

> Oleg.
