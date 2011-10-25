Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753370Ab1JYUG5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 16:06:57 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43050 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751671Ab1JYUG4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 16:06:56 -0400
MIME-Version: 1.0
In-Reply-To: <20111004150111.e9337268.akpm00@gmail.com>
References: <1317668832-10784-1-git-send-email-fweisbec@gmail.com> <20111004150111.e9337268.akpm00@gmail.com>
From: Tim Hockin <thockin@hockin.org>
Date: Tue, 25 Oct 2011 13:06:35 -0700
X-Google-Sender-Auth: p6zuKahrcR0wQUTLprLCmba0wsI
Message-ID: <CAAAKZwu67VMiZgdpp=i5p7zyGbOHGHXwF_iprufGPzTLkkUF2A@mail.gmail.com>
Subject: Re: [PATCH 00/10] cgroups: Task counter subsystem v6
To: Andrew Morton <akpm00@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Tejun Heo <tj@kernel.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Containers <containers@lists.linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 4, 2011 at 3:01 PM, Andrew Morton <akpm00@gmail.com> wrote:
> On Mon,  3 Oct 2011 21:07:02 +0200
> Frederic Weisbecker <fweisbec@gmail.com> wrote:
>
>> Hi Andrew,
>>
>> This contains minor changes, mostly documentation and changelog
>> updates, off-case build fix, and a code optimization in
>> res_counter_common_ancestor().
>
> I'd normally duck a patch series like this when we're at -rc8 and ask
> for it to be resent late in -rc1.  But I was feeling frisky so I
> grabbed this lot for a bit of testing and will sit on it until -rc1.
>
> I'm still not convinced that the kernel has a burning need for a "task
> counter subsystem".  Someone convince me that we should merge this!

We have real (accidental) DoS situations which happen because we don't
have this.  It usually takes the form of some library no re-joining
threads.  We end up deploying a few apps linked against this library,
and suddenly we're in trouble on a machine.  Except, this being
Google, we're in trouble on a lot of machines.

There may be other ways to cobble this sort of safety together, but
they are less appealing for various reasons.  cgroups are how we
control groups of related pids.

I'd really love to be able to use this.


>> It's hard to put some statistic numbers while testing this feature
>> given that the result is rather binary: we launch a forkbomb and
>> either we stop and kill it or the system become unresponsive.
>>
>> Meanwhile, one can find a testsuite at this address:
>> https://tglx.de/~fweisbec/task_counter_test.tar.gz
>
> I do think that we should merge tests like this into the main tree.  So
> I can do "cd tests ; make ; ./run-tests".  The first step is for some hero
> to propose the (simple!) framework and to drop a first test in there.
>
>> It performs several checks to ensure the interface and the behaviour
>> are reliable after common events like moving tasks around over cgroups
>> in a hierarchy, forking inside, etc.. It also launches a forkbomb,
>> tries to stop and kill it. So beware, don't run it on a system that
>> is doing serious things.
>
> Good stuff, that.  Then, when people propose additions or fix bugs, I can
> whine at them for not updating the test suite.
>
>> Ensure you have CGROUP_TASK_COUNTER set
>> before, or it may compress the Ten Plagues in your MBR and
>> inflate the whole after your next reboot.
>
> That problem would need to be fixed.  Either probe for the feature
> up-front, or don't build the test at all if CONFIG_CGROUP_TASK_COUNTER=n.
>
>
