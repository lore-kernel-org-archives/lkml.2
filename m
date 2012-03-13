Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754969Ab2CMQM3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 12:12:29 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43638 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753544Ab2CMQM1 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 12:12:27 -0400
MIME-Version: 1.0
X-Originating-IP: [24.106.62.130]
In-Reply-To: <20120313141032.GD29169@redhat.com>
References: <20120221211938.GE12236@google.com> <20120312221050.GG23255@google.com>
 <1331590938.18960.57.camel@twins> <20120312222817.GI23255@google.com>
 <1331591568.18960.61.camel@twins> <20120312223944.GJ23255@google.com>
 <1331592241.18960.64.camel@twins> <20120312230416.GM23255@google.com> <20120313141032.GD29169@redhat.com>
From: C Anthony Risinger <anthony@xtfx.me>
Date: Tue, 13 Mar 2012 11:11:58 -0500
Message-ID: <CAGAVQTGus7LUWV3AdhAFy--gr=uJRWtSGjuP69-EckBiXy0qVg@mail.gmail.com>
Subject: Re: [RFD] cgroup: about multiple hierarchies
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Michal Schmidt <mschmidt@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        containers@lists.linux-foundation.org,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Lennart Poettering <lennart@poettering.net>, cgroups@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 13, 2012 at 9:10 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Mon, Mar 12, 2012 at 04:04:16PM -0700, Tejun Heo wrote:
>> On Mon, Mar 12, 2012 at 11:44:01PM +0100, Peter Zijlstra wrote:
>> > On Mon, 2012-03-12 at 15:39 -0700, Tejun Heo wrote:
>> > > If we can get to the point where nesting is fully
>> > > supported by every controller first, that would be awesome too.
>> >
>> > As long as that is the goal.. otherwise, I'd be overjoyed if I can rip
>> > nesting support out of the cpu-controller.. that stuff is such a pain.
>> > Then again, I don't think the container people like this proposal --
>> > they were the ones pushing for full hierarchy back when.
>>
>> Yeah, the great pain of full hierarchy support is one of the reasons
>> why I keep thinking about supporting mapping to flat hierarchy.  Full
>> hierarchy could be too painful and not useful enough for some
>> controllers.  Then again, cpu and memcg already have it and according
>> to Vivek blkcg also had a proposed implementation, so maybe it's okay.
>> Let's see.
>
> Implementing hierarchy is a pain and is expensive at run time. Supporting
> flat structure will provide path for smooth transition.
>
> We had some RFC patches for blkcg hierarchy and that made things even more
> complicated and we might not gain much. So why to complicate the code
> until and unless we have a good use case.

how about ditching the idea of an FS altogether?

the `mkdir` creates and nests has always felt awkward to me.  maybe
instead we flatten everything out, and bind to the process tree, but
enable a tag-like system to "mark" processes, and attach meaning to
them.  akin to marking+processing packets (netfilter), or maybe like
sysfs tags(?).

maybe a trivial example, but bear with me here ... other controllers
are bound to a `name` controller ...

# my pid?
$ echo $$
123

# what controllers are available for this process?
$ cat /proc/self/tags/TYPE

# create a new `name` base controller
$ touch /proc/self/tags/admin

# create a new `name` base controller
$ touch /proc/self/tags/users

# begin tracking cpu shares at some default level
$ touch /proc/self/tags/admin.cpuacct.cpu.shares

# explicit assign `admin` 150 shares
$ echo 150 > /proc/self/tags/admin.cpuacct.cpu.shares

# explicit assign `users` 50 shares
$ echo 50 > /proc/self/tags/admin.cpuacct.cpu.shares

# tag will propogate to children
$ echo 1 > /proc/self/tags/admin.cpuacct.cpu.PERSISTENT

# `name`'s priority relative to sibling `name` groups (like shares)
$ echo 100 > /proc/self/tags/admin.cpuacct.cpu.PRIORITY

# `name`'s priority relative to sibling `name` groups (like shares)
$ echo 100 > /proc/self/tags/admin.cpuacct.cpu.PRIORITY

[... system ...]

# what controllers are available system-wide?
$ cat /sys/fs/cgroup/TYPE
cpuacct = monitor resources
memory = monitor memory
blkio = io stuffs
[...]

# what knobs are available?
$ cat /sys/fs/cgroup/cpuacct.TYPE
shares = relative assignment of resources
stat = some stats
[...]

# how many total shares requested (system)
$ cat /sys/fs/cgroup/cpuacct.cpu.shares
200

# how many total shares requested (admin)
$ cat /sys/fs/cgroup/admin.cpuacct.cpu.shares
150

# how many total shares requested (users)
$ cat /sys/fs/cgroup/users.cpuacct.cpu.shares
50

# *all* processes
$ cat /sys/fs/cgroup/TASKS
1
123
[...]

# which processes have `admin` tag?
$ cat /sys/fs/cgroup/cpuacct/admin.TASKS
123

# which processes have `users` tag?
$ cat /sys/fs/cgroup/cpuacct/users.TASKS
123

# link to pid
$ readlink -f /sys/fs/cgroup/cpuacct/users.TASKS.123
/proc/123

# which user owns `users` tag?
$ cat /sys/fs/cgroup/cpuacct/users.UID
1000

# default mode for `user` controls?
$ cat /sys/fs/cgroup/users.MODE
0664

# default mode for `user` cpuacct controls?
$ cat /sys/fs/cgroup/users.cpuacct.MODE
0600

# mask some controllers to `users` tag?
$ echo -e "cpuacct\nmemory" > /sys/fs/cgroup/users.MASK

# ... did the above work? (look at last call to TYPE above)
$ cat /sys/fs/cgroup/users.TYPE
blkio
[...]

# assign a whitelist instead
$ echo -e "cpu\nmemory" > /sys/fs/cgroup/users.TYPE

# mask some knobs to `users` tag
$ echo -e "shares" > /sys/fs/cgroup/users.cpuacct.MASK

# ... did the above work?
$ cat /sys/fs/cgroup/users.cpuacct.TYPE
stat = some stats
[...]

... in this way there is still a sort of heirarchy, but each
controller is free to choose:

) if there is any meaning to multiple `names` per process
) ... or if one one should be allowed
) how to combine laterally
) how to combine descendents
) ... maybe even assignable strategies!
) controller semantics independent of other controllers

when a new pid namespace is created, the `tags` dir is "cleared out"
and that person can assign new values (or maybe a directory is created
in `tags`?).  the effective value is the union of both, and identical
to whatever the process would have had *without* a namespace (no
difference, on visibility).

thus, cgroupfs becomes a simple mount that has aggregate stats and
system-wide settings.

recap:

) bound to process heirarchy
) ... but control space is flat
) does not force every controller to use same paradigm (eg, "you must
behave like a directory tree")
) ... but orthogonal multiplexing of a controller is possible if the
controller allows it
) allows same permission-based ACL
) easy to see all controls affect a process or `name` group with a
simple `ls -l`
) additional possibilities that didn't exist with directory/arbitrary
mounts paradigm

does this make sense? makes much more to me at least, and i think
allow greater flexibility with less complexity (if my experience with
FUSE is any indication) ...

... or is this the same wolf in sheep's skin?

-- 

C Anthony
