Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755391Ab0HKHaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 03:30:15 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:3186 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755054Ab0HKHaO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 03:30:14 -0400
X-IronPort-AV: E=Sophos;i="4.55,352,1278280800"; 
   d="scan'208";a="55295677"
Message-ID: <4C625181.4060606@inria.fr>
Date: Wed, 11 Aug 2010 09:30:09 +0200
From: Tomasz Buchert <Tomasz.Buchert@inria.fr>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Matt Helsley <matthltc@us.ibm.com>
CC: Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
        containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] cgroup_freezer: Freezing and task move race fix
References: <1281470001-14320-1-git-send-email-tomasz.buchert@inria.fr> <20100811011033.GF2927@count0.beaverton.ibm.com>
In-Reply-To: <20100811011033.GF2927@count0.beaverton.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Helsley a écrit :
> On Tue, Aug 10, 2010 at 09:53:21PM +0200, Tomasz Buchert wrote:
>> Writing 'FROZEN' to freezer.state file does not
>> forbid the task to be moved away from its cgroup
>> (for a very short time). Nevertheless the moved task
>> can become frozen OUTSIDE its cgroup which puts
>> discussed task in a permanent 'D' state.
> 
> SUMMARY (for supporting info see the "DETAILS" heading below)
> 
> I can't reproduce this.
> 
> My preliminary conclusion is that your testcase doesn't really reproduce
> what you described. Instead, your testcase prints an incorrect message which
> could easily lead the person running it to the wrong conclusion.
> 
> DETAILS
> 
> I tried it with and without the cpuset portions of the testcase on a dual
> core bare metal system with a 2.6.31-derived distro kernel. Since it
> *should* be obeying the cpuset portions of the testcase I don't think the
> fact that it's dual-core should make a difference.
> 
> I also tried with a 2.6.34-rc5 kernel in a single-cpu kvm on a different
> distro (but on the same physical hardware). I also tried it with and without
> the sleep(1) in the child's for(;;) loop in case the cpu load somehow enabled
> me to trigger the race.
> 
> I used the following bash snippet to run the testcase variations and did not
> observe any tasks in the D state:
> 
> mount -t cgroup -o freezer,cpuset none /cg
> while /bin/true ; do
> 	./bug /cg
> 	ps -C bug -o state= | grep D && break
> done
> 
> If there is a race then I should be able to run that ps line anytime afterwards
> to see the stuck task.
> 
> Note that the test message:
> 
> 	printf("Succesfully moved frozen task!\n");
> 
> is bogus. In fact there is no guarantee the task or cgroup is frozen at that
> point in the testcase. This should be apparent from a careful reading of
> Documentation/cgroups/freezer-subsystem.txt, especially:
> 
> 	This is the basic mechanism which should do the right thing for user space task
> 	in a simple scenario.
> 
> 	It's important to note that freezing can be incomplete. In that case we return
> 	EBUSY. This means that some tasks in the cgroup are busy doing something that
> 	prevents us from completely freezing the cgroup at this time. After EBUSY,
> 	the cgroup will remain partially frozen -- reflected by freezer.state reporting
> 	"FREEZING" when read. The state will remain "FREEZING" until one of these
> 	things happens:
> 
> 		1) Userspace cancels the freezing operation by writing "THAWED" to
> 			the freezer.state file
> 		2) Userspace retries the freezing operation by writing "FROZEN" to
> 			the freezer.state file (writing "FREEZING" is not legal
> 			and returns EINVAL)
> 		3) The tasks that blocked the cgroup from entering the "FROZEN"
> 			state disappear from the cgroup's set of tasks.
> 
> So simply writing FROZEN to freezer.state is necessary to initiate freezing
> but insufficient to assert that the task and/or cgroup is frozen.
> That's why the FREEZING state exists. It's intentionally not specified when/why
> we can't immediately enter FROZEN. Thus userspace must read the freezer.state
> to determine if the current state matches the requested/expected state.
> 
> This is why I have the extra ps step in the script above -- to determine
> if the task is actually in D. I should also check that the cgroup it belongs
> to is THAWED. However while attempting to reproduce your report that hasn't
> been necessary -- none of the tasks have even entered the D state.
> 
> Which brings us to the final portion of this analysis: Why isn't anything
> entering the D state?
> 
> The behavior I have been able to reproduce and which is not a bug is
> moving the task immediately after writing FROZEN to freezer.state. We don't
> know the state of the task or cgroup at that time (in this testcase) so
> this is acceptable. I've even made a sequence of modifications to your
> testcase and run it after each modification to bring it successively more
> in line with correct use of the cgroup freezer. I still was unable to
> reproduce your report.
> 
> So I'm fairly confident there is no bug. I say "fairly" because there may
> be some aspect of your system that I am not reproducing. At this point it
> would be great if you could provide more details so I can more thoroughly
> attempt to recreate your conditions.
> 
> Cheers,
> 	-Matt Helsley
> 

Maybe this is a problem with different timings. I have a qemu minimal image
with two different kernels 2.6.35 - vanilla and patached. I don't use kvm
with qemu though. You can get it from here:
	http://pentium.hopto.org/~thinred/files/qemu.tar.bz2
in the package there is also minimal '.config' for current Linus's tree.
You run it with ./run-linux <bzImageOfTheKernel>. In /root you will have
'minimal' program which is my testcase. The small problem with this image is that
ps segfaults but it's not a big problem. :)

I am also aware that:
	printf("Succesfully moved frozen task!\n");
does not show that task was moved. Only the message is just wrong. What I wanted to observe
is that the kernel actually ALLOWED to start the process of freezing.
When you run the testcase with 'strace' you'll see that 'write' returns a positive number
instead of -EBUSY. And that's the bug.

Anyway, I deduce from your later mail that you actually reproduced the problem.

Cheers,
Tomasz

