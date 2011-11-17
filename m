Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932507Ab1KQQBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:01:10 -0500
Received: from mailhub.sw.ru ([195.214.232.25]:10689 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331Ab1KQQBI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:01:08 -0500
Message-ID: <4EC52FBF.1010407@parallels.com>
Date: Thu, 17 Nov 2011 20:01:03 +0400
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
Subject: Re: [RFC][PATCH 0/3] fork: Add the ability to create tasks with	given
 pids
References: <4EC4F2FB.408@parallels.com> <20111117154936.GB12325@redhat.com>
In-Reply-To: <20111117154936.GB12325@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2011 07:49 PM, Oleg Nesterov wrote:
> On 11/17, Pavel Emelyanov wrote:
>>
>> Gentlemen, please, find some time for this, your ACK/NACK on the API proposal
>> is required badly.
> 
> Please.
> 
>> The proposal is to introduce the CLONE_CHILD_USEPIDS flag for clone() syscall
>> and pass the pids values in the child_tidptr. In order not to introduce the
>> hole for the pid-reuse attack, using this flag will result in EPERM in case
>> the pid namespace we're trying to create pid in has at least one pid (except
>> for the init's one) generated with regular fork()/clone().
>>
>> Currently Tejun and Oleg are worrying only about the intrusiveness of this
>> approach, although Oleg agrees, that it solves all the problems it should. The
>> previous attempts to implement the similar stuff stopped, but no objections
>> against this were expressed. So the decision of whether it's OK to go this
>> way or not is required.
> 
> Yes, personally I'd prefer /proc/set_last_pid (or something similar) which
> simply writes to pid_ns->last_pid. Perhaps it is less convenient from the
> user-space pov (serialization, security) but it is much simpler.

Yes, this is also possible. I have a working prototype of /proc/sys/kernel/ns_last_pid
with the security issue solved, but setting sysctl then cloning seems more obfuscating
to me than just passing an array of pids to clone.

> OTOH, I do not pretend I understand the user-space needs, so I won't argue.
> This series seems correct, the bugs we discussed are fixed.
> 
> But. Speaking of API, it differs a bit compared to the previous version...
> 
>> The API will be used like in the code below
>>
>> 	/* restore new pid namespace with an init in it */
>> 	pid = clone(CLONE_NEWPID);
> 
> Yes, CLONE_NEWPID | CLONE_CHILD_USEPIDS is not possible.

It should be. If we (in theory, but) restore two pid namespaces with one being
a child of another we will have to create an init of the child ns with predefined
pid in the parent ns.

> Then how the array of pids in child_tidptr[] can be useful? If CLONE_NEWPID
> can't restore the pid_nr's in the parent namespaces, then probably this
> doesn't makes sense at all?
> 
> IOW. I think we should either allow CLONE_NEWPID | CLONE_CHILD_USEPIDS
> (with additional check in set_pidmap() to ensure that CLONE_NEWPID
>  comes with child_tidptr[0] == 1), or we should treat the "overloaded"
> child_tidptr as a simple pid_t.

The child_tidptr[0] == 1 check will also work. Currently I check for the
ns->child_reaper being NULL instead.

> Again, I won't insist. Just I want to be sure we do not miss something
> adding the new API.
> 
> Oleg.
