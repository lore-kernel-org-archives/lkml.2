Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752341Ab1HPQCK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 12:02:10 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54142 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751472Ab1HPQCI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 12:02:08 -0400
MIME-Version: 1.0
In-Reply-To: <CAAAKZwupGmw_+EaApZFAqVcXWBF885Gsjx6tUWUdMuebXrt_Mg@mail.gmail.com>
References: <1311956010-32076-1-git-send-email-fweisbec@gmail.com>
 <20110801161900.1fe24b76.akpm@linux-foundation.org> <CAAAKZwupGmw_+EaApZFAqVcXWBF885Gsjx6tUWUdMuebXrt_Mg@mail.gmail.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 16 Aug 2011 18:01:48 +0200
Message-ID: <CAPXgP11aUfdkq-SdaHc8=tfjA4W7DYXjSXG-asoZMi6hK4iOPQ@mail.gmail.com>
Subject: Re: [PATCH 0/8 v3] cgroups: Task counter subsystem (was: New max
 number of tasks subsystem)
To: Tim Hockin <thockin@hockin.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <menage@google.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Aditya Kali <adityakali@google.com>, Oleg Nesterov <oleg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 12, 2011 at 23:11, Tim Hockin <thockin@hockin.org> wrote:
> On Mon, Aug 1, 2011 at 4:19 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
>> On Fri, 29 Jul 2011 18:13:22 +0200
>> Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>
>>> Reminder:
>>>
>>> This patchset is aimed at reducing the impact of a forkbomb to a
>>> cgroup boundaries, thus minimizing the consequences of such an attack
>>> against the rest of the system.
>>>
>>> This can be useful when cgroups are used to stage some processes or run
>>> untrustees.
>>
>> Really?  How useful?  Why is it useful enough to justify adding code
>> such as this to the kernel?
>>
>> Is forkbomb-prevention the only use?  Others have proposed different
>> ways of preventing forkbombs which were independent of cgroups - is
>> this way better and if so, why?
>
> I certainly want this for exactly the proposed use - putting a bounds
> on threads/tasks per container.  It's rlimits but more useful.
>
> IMHO, most every limit that can be set at a system level should be
> settable at a cgroup level.  This is just one more isolation leak.

Such functionality in general sounds useful. System management tools
want to be able to race-free stop a service. A 'service' in the sense
of 'a group of processes and all the future processes it creates'.

A common problem here are user sessions that a logins creates. For
some systems it is required, that after logout of the user, all
processes the user has started are properly cleaned up. Common example
for such enforcements are servers at schools universities that do not
want to allow users to leave things like file sharing programs running
in the background after they log out.

We currently do that in systemd by tracking these session in a cgroup
and kill all pids in that group. This currently requires some
cooperation of the services to be successful. If they would fork
faster than we kill them, we would never be able to finish the task.

Such user sessions are generally untrusted code and processes, and the
system management that cleans up after the end of the session runs
privileged. It would be nice, to be allow trusted code to race-free
kill all remaining processes of such an untrusted session. This is not
so much about fork-bombs, things might not even have bad things in
mind, this would be more like a rlimit for a 'group of pids', that
allows race-free resource management of the services.

For the actual implementation, I think it would be nicer to use to
have such functionality at the core of cgroups, and not require a
specific controller to be set up. We already track every single
service in its own cgroup in a custom hierarchy. These groups just act
as the container for all the pids belonging to the service, so we can
track the service properly.

Naively looking at it as a user of it, we would like to be able to
apply these limits for every cgroup right away, not needing to create
another controller/subsystem/hierarchy.

Thanks,
Kay
