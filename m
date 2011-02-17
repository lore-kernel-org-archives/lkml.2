Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020Ab1BQVEX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 16:04:23 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751781Ab1BQVEV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 16:04:21 -0500
Date: Thu, 17 Feb 2011 21:54:58 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: Daniel Lezcano <daniel.lezcano@free.fr>
Cc: akpm@linux-foundation.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, xemul@openvz.org, sukadev@us.ibm.com,
        ebiederm@xmission.com
Subject: Re: [PATCH 1/2] pidns: Don't allow new pids after the namespace is
	dead.
Message-ID: <20110217205458.GB16076@redhat.com>
References: <1297788824-20534-1-git-send-email-daniel.lezcano@free.fr> <20110215183028.GA15568@redhat.com> <4D5C5BE8.5020803@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D5C5BE8.5020803@free.fr>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/17, Daniel Lezcano wrote:
>
> On 02/15/2011 07:30 PM, Oleg Nesterov wrote:
>> On 02/15, Daniel Lezcano wrote:
>>> In the case of unsharing or joining a pid namespace, it becomes
>>> possible to attempt to allocate a pid after zap_pid_namespace has
>>> killed everything in the namespace.  Close the hole for now by simply
>>> not allowing any of those pid allocations to succeed.
>> Daniel, please explain more. It seems, a long ago I knew the reason
>> for this patch, but now I can't recall and can't understand this change.
>
> The idea behind unsharing the pid namespace is the current pid is not
> mapped in the newly created pid namespace and appears as the pid 0.

Well, not exactly afaics... but doesn't matter.

> When
> it forks, the child process becomes the init pid of the new pid
> namespace.

Yes, I see. And this is what I personally dislike. Because, iow,
unshare(PID) changes current->nspory->pid_ns to affect the behaviour
of copy_process() , this really looks like "action at a distance" to
me. Too subtle and fragile. But, once again, this is just imho, feel
free to ignore.

> When this pid namespace dies because the init pid exited, the
> parent process (aka pid 0) can no longer fork because the pid namespace
> is flagged dead. This is what does this patch.

OK, thanks. I seem to understand. May be ;)

I'd suggest you to add this explanation to the changelog.

>>> --- a/include/linux/pid_namespace.h
>>> +++ b/include/linux/pid_namespace.h
>>> @@ -20,6 +20,7 @@ struct pid_namespace {
>>>   	struct kref kref;
>>>   	struct pidmap pidmap[PIDMAP_ENTRIES];
>>>   	int last_pid;
>>> +	atomic_t dead;
>> Why atomic_t? It is used as a plain boolean.
>>
>> And I can't unde
>
> I think Eric used an atomic because it is lockless with alloc_pid vs
> zap_pid_ns_processes.

Can't understand...

But anyway, I strongly believe atomic_t buys nothing in this patch.
May be it is needed for the next changes, I dunno.

Oleg.

