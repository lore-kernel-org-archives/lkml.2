Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756266Ab1FPPH1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:07:27 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:60798 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755435Ab1FPPHY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:07:24 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Greg Kurz <gkurz@fr.ibm.com>, Oleg Nesterov <oleg@redhat.com>,
        linux-kernel@vger.kernel.org, containers@lists.osdl.org,
        akpm@linux-foundation.org, xemul@openvz.org
References: <20110615145527.4016.70157.stgit@bahia.local>
	<20110615190302.GA16440@redhat.com>
	<1308223158.8230.66.camel@bahia.local> <4DF9F657.7030605@fr.ibm.com>
Date: Thu, 16 Jun 2011 08:07:17 -0700
In-Reply-To: <4DF9F657.7030605@fr.ibm.com> (Cedric Le Goater's message of
	"Thu, 16 Jun 2011 14:25:59 +0200")
Message-ID: <m1y611bysa.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+7ehxDwS4sgjpws4kzPuYNyC66oWPSZIg=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cedric Le Goater <clg@fr.ibm.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was Vpid:)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater <clg@fr.ibm.com> writes:

> On 06/16/2011 01:19 PM, Greg Kurz wrote:
>> On Wed, 2011-06-15 at 21:03 +0200, Oleg Nesterov wrote:
>>> Forgot to ask,
>>>
>>> On 06/15, Greg Kurz wrote:
>>>>
>>>> The need arises in the LXC community when one wants to send a signal from
>>>> the host (aka. init_pid_ns context) to a container process for which one
>>>> only knows the pid inside the container.
>>>
>>> I am just curious, why do you need this?
>>>
>> 
>> Because some LXC users run partially isolated containers (AKA.
>> application containers started with the lxc-execute command). Some of
>> the user code runs outside the container and some inside. Since
>> lxc-execute uses CLONE_NEWPID, it's difficult for the external code to
>> relate a pid generated inside the container with a task. There are
>> regular requests on lxc-users@ about this.
>
> It's simply not possible. There's no support for it.
>
> We have a case where a task in a parent pid namespace needs to kill 
> another task in a sub pid namespace only knowing its internal pid.
> the latter has been communicated to the parent task through a file or 
> a unix socket.

If you are using a unix domain sockets you can get them to translate
the pid for you, with SCM_CREDS.  Unix domain sockets have to do that
or it is a security problem.

> This 'ActivePid' information in /proc is not sufficient to identity 
> the task, you also need the list of the tasks which are living in 
> the pid namespace.
>
>
> We could have used the setns syscall and attach a kill command to 
> a pid namespace. But, this is borderline as you might ended up 
> killing all the tasks in the namespace you've attached to. Anyhow, 
> setns doesn't support pid namespaces yet and it feels safer to send 
> the signal for outside.
>
> a new kill syscall could be the solution:
>
>     int pidns_kill(pid_t init_pid, pid_t some_pid);
>
> where 'init_pid' identifies the namespace and 'some_pid' identifies
> a task in this namespace. this is very specific but why not.

Ugh.  

So I took a quick look at things and while setns support is tricky
from a technical perspective for pid namespaces, supporting the
namespace files is not.

We can plan on having pid, mnt, and user namespace namespace proc files
in 3.1.  Along with the small changes needed to have inode numbers on
the namespace files that are useful for comparing namespaces for
equality.   I will see about getting those patches out for review
shortly.

> Finally, we thought that the 'ActivePid' information was interesting 
> enough to be exposed in /proc and was solving the case we're facing 
> rather easily with some framework (cgroups) in user space.

The pid number by which a process knows itself doesn't seem
unreasonable.  I'm not totally 

After having a second look at the code in proc we already have
a reference to the struct pid we want to print.  So simply
printing
pid->numbers[pid->level].nr
seems reasonable, and race free.

Alternatively that could be written.
pid_nr_ns(pid, ns_of_pid(pid));

Eric
