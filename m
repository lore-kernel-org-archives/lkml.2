Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab1BPXrv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 18:47:51 -0500
Received: from smtp5-g21.free.fr ([212.27.42.5]:49358 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816Ab1BPXrr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 18:47:47 -0500
Message-ID: <4D5C6219.8060207@free.fr>
Date: Thu, 17 Feb 2011 00:47:37 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xemul@openvz.org, sukadev@us.ibm.com,
        ebiederm@xmission.com
Subject: Re: [PATCH 2/2] pidns: Support unsharing the pid namespace.
References: <1297788824-20534-1-git-send-email-daniel.lezcano@free.fr> <1297788824-20534-2-git-send-email-daniel.lezcano@free.fr> <20110215190118.GA16707@redhat.com>
In-Reply-To: <20110215190118.GA16707@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/15/2011 08:01 PM, Oleg Nesterov wrote:
> On 02/15, Daniel Lezcano wrote:
>> - Pass both nsproxy->pid_ns and task_active_pid_ns to copy_pid_ns
>>    As they can now be different.
> But since they can be different we have to convert some users of
> current->nsproxy first? But that patch was dropped.
>
>> Unsharing of the pid namespace unlike unsharing of other namespaces
>> does not take effect immediately.  Instead it affects the children
>> created with fork and clone.
> IOW, unshare(CLONE_NEWPID) implicitly affects the subsequent fork(),
> using the very subtle way.
>
> I have to admit, I can't say I like this very much. OK, if we need
> this, can't we just put something into, say, signal->flags so that
> copy_process can check and create the new namespace.
>
> Also. I remember, I already saw something like this and google found
> my questions. I didn't actually read the new version, perhaps my
> concerns were already answered...
>
> 	But what if the task T does unshare(CLONE_NEWPID) and then, say,
> 	pthread_create() ? Unless I missed something, the new thread won't
> 	be able to see T ?

Right. Is it really a problem ? I mean it is a weird use case where we 
fall in a weird situation.
I suppose we can do the same weird combination with clone.
IMHO, the userspace is responsible of how it uses the syscalls. Until 
the system is safe, everything is ok, no ?

> 	and, in this case the exiting sub-namespace init also kills its
> 	parent?

I don't think so because the zap_pid_ns_processes does not hit the 
parent process when it browses the pidmap.

I tried the following program without problem:

#include <stdio.h>
#define _GNU_SOURCE
#include <sched.h>
#include <pthread.h>

void *routine(void *data)
{
         printf("pid %d!\n", getpid());
         return NULL;
}

int main(int argc, char *argv[])
{
         char **aux = &argv[1];
         pthread_t t;

         if (unshare(CLONE_NEWPID)) {
                 perror("unshare");
                 return -1;
         }

         if (pthread_create(&t, NULL, routine, NULL)) {
                 perror("pthread_create");
                 return -1;
         }

         if (pthread_join(t, NULL)) {
                 perror("pthread_join");
                 return -1;
         }

         printf("joined\n");

         return 0;
}

> 	OK, suppose it does fork() after unshare(), then another fork().
> 	In this case the second child lives in the same namespace with
> 	init created by the 1st fork, but it is not descendant ? This means
> 	in particular that if the new init exits, zap_pid_ns_processes()->
> 	do_wait() can't work.

Hmm, good question. IMO, we should prevent such case for now in the same 
way we added the flag 'dead', IOW adding a flag 'busy' for example.

