Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757278Ab1FPPW2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 11:22:28 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:46680 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754933Ab1FPPW1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 11:22:27 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cedric Le Goater <clg@fr.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Greg Kurz <gkurz@fr.ibm.com>,
        linux-kernel@vger.kernel.org, containers@lists.osdl.org,
        akpm@linux-foundation.org, xemul@openvz.org
References: <20110615145527.4016.70157.stgit@bahia.local>
	<20110615190302.GA16440@redhat.com>
	<1308223158.8230.66.camel@bahia.local> <4DF9F657.7030605@fr.ibm.com>
	<20110616130613.GC19312@redhat.com> <4DFA126D.9060102@fr.ibm.com>
Date: Thu, 16 Jun 2011 08:22:13 -0700
In-Reply-To: <4DFA126D.9060102@fr.ibm.com> (Cedric Le Goater's message of
	"Thu, 16 Jun 2011 16:25:49 +0200")
Message-ID: <m1fwn9by3e.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/1942vsrtBp8NsfUihfF9nK7750Cw+eTM=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.0 T_TooManySym_03 6+ unique symbols in subject
	*  0.0 T_TooManySym_02 5+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cedric Le Goater <clg@fr.ibm.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] Introduce ActivePid: in /proc/self/status (v2, was	Vpid:)
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cedric Le Goater <clg@fr.ibm.com> writes:

> On 06/16/2011 03:06 PM, Oleg Nesterov wrote:
>> On 06/16, Cedric Le Goater wrote:
>>>
>>> We have a case where a task in a parent pid namespace needs to kill
>>> another task in a sub pid namespace only knowing its internal pid.
>>> the latter has been communicated to the parent task through a file or
>>> a unix socket.
>> 
>> OK, thanks, this partly answers my question... But if they communicate
>> anyway, it is not clear why the signal is needed.
>
> Well, user space always finds ways to challenge the kernel.
>
> Our case is related to HPC. The batch manager runs jobs inside lxc 
> containers (using namespaces) and signals are sent to the application 
> for different reasons. First, to cleanly exit but also for other more 
> specific actions related to the cluster interconnects. 

In that case I really recommend unix domain sockets.  You likely
won't need a kernel upgrade to make use of those and their pid
translation ability.

>>> a new kill syscall could be the solution:
>>>
>>>     int pidns_kill(pid_t init_pid, pid_t some_pid);
>>>
>>> where 'init_pid' identifies the namespace and 'some_pid' identifies
>>> a task in this namespace. this is very specific but why not.
>> 
>> Yes, I also thought about this. Should be trivial.
>> 
>> Or int sys_tell_me_its_pid(pid_t init_pid, pid_t some_pid).
>
> why not. it's even better because more general.

If we get as far as a new system call (and I don't think any of this
needs a new system call) we really should use a namespace file
descriptor to identify the pid namespace not a pid.

>> Just in case.... This is hack, yes, but in fact you do not need the
>> kernel changes to send a signal inside the namespace. You could
>> ptrace sub_init, and execute the necessary code "inside" the namespace.
>
> hmm, I look at that.

Looking at the ptrace interactions are definitely worthwhile.

I remember there were a few very weird things with pids when ptracing
a process in another pid namespace.  It may be that ActivePid is enough
to allow the tracer to figure out the confusing information it is
getting.

I would be surprised if using ptrace to send signals is how you
want to do things.  It works, and it is a great argument from
a security perspective on allowing things that we already allow.
Using ptrace to run system calls was cumbersome and not easily
portable across architectures last time I looked.

Eric
