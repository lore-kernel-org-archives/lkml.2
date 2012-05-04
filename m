Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479Ab2EDOJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 10:09:55 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:40803 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2EDOJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 10:09:44 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Mike Galbraith <efault@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Pavel Emelyanov <xemul@parallels.com>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        Louis Rilling <louis.rilling@kerlabs.com>
References: <1335604790.5995.22.camel@marge.simpson.net>
	<20120428142605.GA20248@redhat.com> <m14ns355ru.fsf@fess.ebiederm.org>
	<20120429165846.GA19054@redhat.com>
	<1335754867.17899.4.camel@marge.simpson.net>
	<m1zk9rmyh4.fsf@fess.ebiederm.org>
	<20120501134214.f6b44f4a.akpm@linux-foundation.org>
	<1336014721.7370.32.camel@marge.simpson.net>
	<1336057018.8119.46.camel@marge.simpson.net>
	<1336105676.7356.42.camel@marge.simpson.net>
	<m1aa1oidmn.fsf@fess.ebiederm.org>
	<1336124716.25479.36.camel@marge.simpson.net>
Date: Fri, 04 May 2012 07:13:57 -0700
In-Reply-To: <1336124716.25479.36.camel@marge.simpson.net> (Mike Galbraith's
	message of "Fri, 04 May 2012 11:45:16 +0200")
Message-ID: <m1vckcdoey.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/J02jYN8YVXZm/caSCu0FVCY/T4Q0zH8A=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.5 BAYES_05 BODY: Bayes spam probability is 1 to 5%
	*      [score: 0.0366]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Galbraith <efault@gmx.de>
X-Spam-Relay-Country: **
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith <efault@gmx.de> writes:

> On Fri, 2012-05-04 at 00:55 -0700, Eric W. Biederman wrote:
>
>> CLONE_NEWUSER?  I presume you have applied my latest user namespace
>> patches?  Otherwise you are running completely half baked code.
>
> I Removed CLONE_NEWUSER flag.
>
>> hackbench?  Which kernel are you running.  Hackbench in some kernels is
>> really good at triggering cache ping-pong effects with pids, and creds.
>
> Not when pinned.  3.0 kernel without the debug stuff enabled in 3.4.git.
> 
> marge:/usr/local/tmp/starvation # taskset -c 3 ./hackbench
> Running with 10*40 (== 400) tasks.
> Time: 0.868
> marge:/usr/local/tmp/starvation # taskset -c 3 ./hackbench -namespace
> Running with 10*40 (== 400) tasks.
> Time: 7.582
> marge:/usr/local/tmp/starvation # taskset -c 3 ./hackbench -namespace -all
> Running with 10*40 (== 400) tasks.
> Time: 29.677

Interesting.  I guess what truly puzzles me is what serializes all of
the processes.  Even synchronize_rcu should sleep and thus let other
synchronize_rcu calls run in parallel.

Did you have HZ=100 in that kernel?  400 tasks at 100Hz all serialized
somehow and then doing synchronize_rcu at a jiffy each would account
for 4 seconds.  And the nsproxy certainly has a synchronize_rcu call.

The network namespace is comparatively heavy weight, at least in the
amount of code and other things it has to go through, so that would be
my prime suspect for those 29 seconds.  There are 2-4 synchronize_rcu
calls needed to put the loopback device.  Still we use
synchronize_rcu_expedited and that work should be out of line and all of
those calls should batch.

Mike is this something you are looking at a pursuing farther?

I want to guess the serialization comes from waiting on children to be
reaped but the namespaces are all cleaned up in exit_notify() called
from do_exit() so that theory doesn't hold water.  The worst case
I can see is detach_pid from exit_signal running under the task list lock.
but nothing sleeps under that lock.  :(

So I am very puzzled why the code serializes itself in a way that leads
to those long delays.  Shrug.

Eric
