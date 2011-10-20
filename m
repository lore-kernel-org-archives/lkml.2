Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab1JTKMQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 06:12:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:58954 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755206Ab1JTKMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 06:12:14 -0400
MIME-Version: 1.0
In-Reply-To: <1317382585-12172-1-git-send-email-wpk@culm.net>
References: <1317382585-12172-1-git-send-email-wpk@culm.net>
From: Paul Menage <paul@paulmenage.org>
Date: Thu, 20 Oct 2011 03:11:54 -0700
X-Google-Sender-Auth: 7TBu6IMOy8N_BUU42E_V4feOOig
Message-ID: <CALdu-PDCxS49_GBBUQUskotKb_46O31YM8Tx+cniGfBa5X169g@mail.gmail.com>
Subject: Re: [PATCH 0/6] cgroup: add isolation_root flag, poor man's
 namespaces for cgroups
To: Witold Krecicki <wpk@culm.net>
Cc: Li Zefan <lizf@cn.fujitsu.com>, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Matt Helsley <matthltc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 4:36 AM, Witold Krecicki <wpk@culm.net> wrote:
> This patchset adds namespace-like feature to the existing cgroup system.
> When used with a container system (eg. lxc) it allows containers to have
> its own cgroup hierarchy, enabling use of 'systemd' (using cgroups) inside
> a container.

The basic idea is, I think, a necessary one for containers to be fully
useful. This patch set looks well designed.

After talking with Eric Biederman at LPC about the virtualizability of
containers, I was wondering whether we could go even further, and say
that a hierarchy (in the sense of a tree of cgroups with a bound set
of subsystems) could be broken at the point of an isolation root. The
container could then construct its own hierarchies with potentially
different combinations of subsystems.

>From the point of view of any given subsystem, its cgroups would still
all form a single tree, but potentially threading through multiple
hierarchies. (So there would need to be an explicit tree of pointers
running through the cgroup_subsys_state structs, as well as the tree
running through the cgroups, and a subsystem would have to only read
its own tree.)

Probably the rule for allowing this would have to be something like:
if you try to mount a cgroup filesystem with a combination of
subsystems that would normally give an EBUSY (since one or more of the
subsystems are in use but the combination requested does not exactly
match the existing combination) allow it if the cgroups of the
requesting task for the requested subsystems are all isolation roots,
and if they all contain the exact same set of tasks. At that point a
new hierarchy would be created.

There are definitely some fiddly issues to deal with in this idea,
though, and I doubt if it'll be around any time soon, but it would be
nice if we could set up the API in your isolation patches so that it
fits in with possible future ideas.

If more isolation options are likely in the future, which I think they
are, then having a separate file show up in every single cgroup for
something that's going to be relevant to very few actual cgroups seems
a bit bloated. How about making the file be called just 'isolation' or
'virtualization' and have it be a series of flags, so that it's
forward expandable.

Bit 0 could be 'root' as you have now.
Bit 1 could be 'hidden' - if the hidden bit is set, then the
subsystems in this hierarchy don't even show up in /proc/cgroup or
/proc/self/cgroup for this cgroup.

>
> I'm really not sure if the 'mount' part (patch 5) is done correctly, please
> review carefully.

It looks simple, I agree, and as though it *ought* to work. My first
worry with this was that if the parent system unmount the hierarchy,
and all the tasks in the child container died (so its namespace was
cleaned up), what would keep the root or the parent-created hierarchy
alive? But I think that since the super-block also has a reference on
the root dentry itself, it should be OK.

Paul
