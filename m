Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab1BQWgT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:36:19 -0500
Received: from mtagate5.uk.ibm.com ([194.196.100.165]:53597 "EHLO
	mtagate5.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1BQWgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:36:16 -0500
Message-ID: <4D5DA2CF.5010200@fr.ibm.com>
Date: Thu, 17 Feb 2011 23:35:59 +0100
From: Greg Kurz <gkurz@fr.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Daniel Lezcano <daniel.lezcano@free.fr>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [PATCH 2/2] pidns: Support unsharing the pid namespace.
References: <1297788824-20534-1-git-send-email-daniel.lezcano@free.fr> <1297788824-20534-2-git-send-email-daniel.lezcano@free.fr> <20110215190118.GA16707@redhat.com> <4D5C6219.8060207@free.fr> <20110217202959.GA16076@redhat.com>
In-Reply-To: <20110217202959.GA16076@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17/2011 09:29 PM, Oleg Nesterov wrote:
> On 02/17, Daniel Lezcano wrote:
>>
>> On 02/15/2011 08:01 PM, Oleg Nesterov wrote:
>>>
>>> I have to admit, I can't say I like this very much. OK, if we need
>>> this, can't we just put something into, say, signal->flags so that
>>> copy_process can check and create the new namespace.
>>>
>>> Also. I remember, I already saw something like this and google found
>>> my questions. I didn't actually read the new version, perhaps my
>>> concerns were already answered...
>>>
>>> 	But what if the task T does unshare(CLONE_NEWPID) and then, say,
>>> 	pthread_create() ? Unless I missed something, the new thread won't
>>> 	be able to see T ?
>>
>> Right. Is it really a problem ? I mean it is a weird use case where we
>> fall in a weird situation.
>
> But this is really weird! How it is possible that the parent can't see
> its own child? No matter which thread did fork(), the new process is

Hmmm... I guess you mean the opposite. The way pid namespaces are 
nested, parents always see their children. But indeed, the child thread 
can't see its group leader and that's kind of unusual. Unshare a pid 
namespace at your own risk. :)

> the child of any sub-thread. More precisely, it is the child of thread
> group.
>
>> I suppose we can do the same weird combination with clone.
>
> No, or we have the bug. If nothing else, kill() or wait() should work
> equally for any sub-thread. (OK, __WNOTHREAD hack is the only exception).
>
>>> 	and, in this case the exiting sub-namespace init also kills its
>>> 	parent?
>>
>> I don't think so because the zap_pid_ns_processes does not hit the
>> parent process when it browses the pidmap.
>
> OK... Honestly, right now I can't understand my own question, it was
> written a long ago. Probably I missed something.... but I'll recheck ;)
>
>>> 	OK, suppose it does fork() after unshare(), then another fork().
>>> 	In this case the second child lives in the same namespace with
>>> 	init created by the 1st fork, but it is not descendant ? This means
>>> 	in particular that if the new init exits, zap_pid_ns_processes()->
>>> 	do_wait() can't work.
>>
>> Hmm, good question. IMO, we should prevent such case for now in the same
>> way we added the flag 'dead', IOW adding a flag 'busy' for example.
>
> I dunno.
>
> As I said, I do not like this approach at all. But please feel free to
> ignore, it is very easy to blaim somebody else's code without suggesting
> the alternative ;)
>
> Oleg.
>
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers


-- 
Gregory Kurz                                     gkurz@fr.ibm.com
Software Engineer @ IBM/Meiosys                  http://www.ibm.com
Tel +33 (0)534 638 479                           Fax +33 (0)561 400 420

"Anarchy is about taking complete responsibility for yourself."
         Alan Moore.
