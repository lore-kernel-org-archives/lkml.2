Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757613Ab1FPM02 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 08:26:28 -0400
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:60993 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756211Ab1FPM0Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 08:26:24 -0400
Message-ID: <4DF9F657.7030605@fr.ibm.com>
Date: Thu, 16 Jun 2011 14:25:59 +0200
From: Cedric Le Goater <clg@fr.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg Kurz <gkurz@fr.ibm.com>
CC: Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, containers@lists.osdl.org,
        akpm@linux-foundation.org, xemul@openvz.org
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was Vpid:)
References: <20110615145527.4016.70157.stgit@bahia.local>	<20110615190302.GA16440@redhat.com> <1308223158.8230.66.camel@bahia.local>
In-Reply-To: <1308223158.8230.66.camel@bahia.local>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 01:19 PM, Greg Kurz wrote:
> On Wed, 2011-06-15 at 21:03 +0200, Oleg Nesterov wrote:
>> Forgot to ask,
>>
>> On 06/15, Greg Kurz wrote:
>>>
>>> The need arises in the LXC community when one wants to send a signal from
>>> the host (aka. init_pid_ns context) to a container process for which one
>>> only knows the pid inside the container.
>>
>> I am just curious, why do you need this?
>>
> 
> Because some LXC users run partially isolated containers (AKA.
> application containers started with the lxc-execute command). Some of
> the user code runs outside the container and some inside. Since
> lxc-execute uses CLONE_NEWPID, it's difficult for the external code to
> relate a pid generated inside the container with a task. There are
> regular requests on lxc-users@ about this.

It's simply not possible. There's no support for it.

We have a case where a task in a parent pid namespace needs to kill 
another task in a sub pid namespace only knowing its internal pid.
the latter has been communicated to the parent task through a file or 
a unix socket.

This 'ActivePid' information in /proc is not sufficient to identity 
the task, you also need the list of the tasks which are living in 
the pid namespace.


We could have used the setns syscall and attach a kill command to 
a pid namespace. But, this is borderline as you might ended up 
killing all the tasks in the namespace you've attached to. Anyhow, 
setns doesn't support pid namespaces yet and it feels safer to send 
the signal for outside.

a new kill syscall could be the solution:

    int pidns_kill(pid_t init_pid, pid_t some_pid);

where 'init_pid' identifies the namespace and 'some_pid' identifies
a task in this namespace. this is very specific but why not.

Finally, we thought that the 'ActivePid' information was interesting 
enough to be exposed in /proc and was solving the case we're facing 
rather easily with some framework (cgroups) in user space.

Best,

C.
