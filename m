Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758961Ab2EDPb5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 11:31:57 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:57954 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758781Ab2EDPbz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 11:31:55 -0400
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
	<m1vckcdoey.fsf@fess.ebiederm.org>
	<1336142995.25479.49.camel@marge.simpson.net>
Date: Fri, 04 May 2012 08:36:08 -0700
In-Reply-To: <1336142995.25479.49.camel@marge.simpson.net> (Mike Galbraith's
	message of "Fri, 04 May 2012 16:49:55 +0200")
Message-ID: <m1zk9oc61j.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/QpSkF6jG/yLifofY6TDtPJvy0EW1fdb4=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: *  0.1 XMSubLong Long Subject
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.1697]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_08 obfuscated drug references
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Mike Galbraith <efault@gmx.de>
X-Spam-Relay-Country: **
Subject: Re: [PATCH]  Re: [RFC PATCH] namespaces: fix leak on fork() failure
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Galbraith <efault@gmx.de> writes:

> On Fri, 2012-05-04 at 07:13 -0700, Eric W. Biederman wrote: 
>> Mike Galbraith <efault@gmx.de> writes:

>> Did you have HZ=100 in that kernel?  400 tasks at 100Hz all serialized
>> somehow and then doing synchronize_rcu at a jiffy each would account
>> for 4 seconds.  And the nsproxy certainly has a synchronize_rcu call.
>
> HZ=250

Rats.  Then non of my theories even approaches holding water.

>> The network namespace is comparatively heavy weight, at least in the
>> amount of code and other things it has to go through, so that would be
>> my prime suspect for those 29 seconds.  There are 2-4 synchronize_rcu
>> calls needed to put the loopback device.  Still we use
>> synchronize_rcu_expedited and that work should be out of line and all of
>> those calls should batch.
>> 
>> Mike is this something you are looking at a pursuing farther?
>
> Not really, but I can put it on my good intentions list.

About what I expected.  I just wanted to make certain I understood the
situation.

I will remember this as something weird and when I have time perhaps
I will investigate and track it.

>> I want to guess the serialization comes from waiting on children to be
>> reaped but the namespaces are all cleaned up in exit_notify() called
>> from do_exit() so that theory doesn't hold water.  The worst case
>> I can see is detach_pid from exit_signal running under the task list lock.
>> but nothing sleeps under that lock.  :(
>
> I'm up to my ears in zombies with several instances of the testcase
> running in parallel, so I imagine it's the same with hackbench.

Oh interesting.

> marge:/usr/local/tmp/starvation # taskset -c 3 ./hackbench -namespace& for i in 1 2 3 4 5 6 7 ; do ps ax|grep defunct|wc -l;sleep 1; done
> [1] 29985
> Running with 10*40 (== 400) tasks.
> 1
> 397
> 327
> 261
> 199
> 135
> 72
> marge:/usr/local/tmp/starvation # Time: 7.675

So if I read your output right the first second is spent running the
code and the rest of the time is spent reaping zombies.

So if this is all in reaping zombies it should be possible to add go
faster stripes by setting exit_signal to -1 on these guys.  I know
you can do that for threads, and I seem to remember hackbench using
threads so that might be interesting.

I wonder if it might be userspace scheduling madness.

What changes the speed of a waitpid loop?  Weird.  Very Weird.

Eric
