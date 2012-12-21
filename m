Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751628Ab2LURvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 12:51:51 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:57071 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751130Ab2LURvp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 12:51:45 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, Serge Hallyn <serge@hallyn.com>,
        Gao feng <gaofeng@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>
References: <8739097bkk.fsf@xmission.com>
	<1353083750-3621-1-git-send-email-ebiederm@xmission.com>
	<1353083750-3621-11-git-send-email-ebiederm@xmission.com>
	<20121219181400.GA22991@redhat.com> <871uektc2f.fsf@xmission.com>
	<20121221154931.GA18730@redhat.com>
Date: Fri, 21 Dec 2012 09:51:03 -0800
In-Reply-To: <20121221154931.GA18730@redhat.com> (Oleg Nesterov's message of
	"Fri, 21 Dec 2012 16:49:31 +0100")
Message-ID: <87fw2zmgzc.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-AID: U2FsdGVkX1+Q7he6yDpUqpRrW7WQeEjtFZrbLrX0/y4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0009]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Oleg Nesterov <oleg@redhat.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 11/11] pidns: Support unsharing the pid namespace.
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Jan 2012 03:05:19 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> writes:

> Eric. I understand that it is too late to discuss this. And yes, I simply
> do not understand the problem space, I never used containers.
>
> But, stupid question. Let's ignore the pid_ns-specific oddities.
>
> 1. Ignoring setns(), why do we need /proc/pid/ns/ ?
>
> 2. Why setns() requires /proc/pid/ns/ ? IOW, why it can't be
>
> 	sys_setns(pid_t pid, int clone_flags)
> 	{
> 		truct task_struct *tsk = find_task_by_vpid(pid);
> 		struct nsproxy *target = get_nsproxy(tsk->nsproxy);
>
> 		new_nsproxy = create_new_namespaces(...);
>
> 		if (clone_flags & CLONE_NEWNS)
> 			mntns_install(...);
> 		if (clone_flags & CLONE_NEWIPC)
> 			ipcns_install(...);
> 		...
> 	}
>
> I feel I missed something trivial, but what?

It is a question of naming.

The problem I set out to solve when all of this was introduced was how
to name namespaces without introducing yet another namespace.

The solution to the naming problem that I finally found was to introduce
something I could mount.  Using a file in /proc I can bind mount it
anywhere in the mount namespace with any name.  That gives me names for
namespaces in the mount namespace.  Furthermore those names go away
when the mount namespace goes away making them very easy to manage.

Being able to open the file instead of passing a path to setns
allows a process for private per process naming (via file descriptors).

To get a practical feel of this it may be worth looking at iproute.

ip netns add
ip netns del
ip netns exec

Eric
