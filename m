Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab1BQUih (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 15:38:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab1BQUig (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 15:38:36 -0500
Date: Thu, 17 Feb 2011 21:29:59 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xemul@openvz.org, sukadev@us.ibm.com,
        ebiederm@xmission.com
Subject: Re: [PATCH 2/2] pidns: Support unsharing the pid namespace.
Message-ID: <20110217202959.GA16076@redhat.com>
References: <1297788824-20534-1-git-send-email-daniel.lezcano@free.fr> <1297788824-20534-2-git-send-email-daniel.lezcano@free.fr> <20110215190118.GA16707@redhat.com> <4D5C6219.8060207@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5C6219.8060207@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Daniel Lezcano wrote:
>
> On 02/15/2011 08:01 PM, Oleg Nesterov wrote:
>>
>> I have to admit, I can't say I like this very much. OK, if we need
>> this, can't we just put something into, say, signal->flags so that
>> copy_process can check and create the new namespace.
>>
>> Also. I remember, I already saw something like this and google found
>> my questions. I didn't actually read the new version, perhaps my
>> concerns were already answered...
>>
>> 	But what if the task T does unshare(CLONE_NEWPID) and then, say,
>> 	pthread_create() ? Unless I missed something, the new thread won't
>> 	be able to see T ?
>
> Right. Is it really a problem ? I mean it is a weird use case where we
> fall in a weird situation.

But this is really weird! How it is possible that the parent can't see
its own child? No matter which thread did fork(), the new process is
the child of any sub-thread. More precisely, it is the child of thread
group.

> I suppose we can do the same weird combination with clone.

No, or we have the bug. If nothing else, kill() or wait() should work
equally for any sub-thread. (OK, __WNOTHREAD hack is the only exception).

>> 	and, in this case the exiting sub-namespace init also kills its
>> 	parent?
>
> I don't think so because the zap_pid_ns_processes does not hit the
> parent process when it browses the pidmap.

OK... Honestly, right now I can't understand my own question, it was
written a long ago. Probably I missed something.... but I'll recheck ;)

>> 	OK, suppose it does fork() after unshare(), then another fork().
>> 	In this case the second child lives in the same namespace with
>> 	init created by the 1st fork, but it is not descendant ? This means
>> 	in particular that if the new init exits, zap_pid_ns_processes()->
>> 	do_wait() can't work.
>
> Hmm, good question. IMO, we should prevent such case for now in the same
> way we added the flag 'dead', IOW adding a flag 'busy' for example.

I dunno.

As I said, I do not like this approach at all. But please feel free to
ignore, it is very easy to blaim somebody else's code without suggesting
the alternative ;)

Oleg.

