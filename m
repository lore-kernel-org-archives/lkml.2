Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1JLAxM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 20:53:12 -0400
Received: from mail-ww0-f42.google.com ([74.125.82.42]:52860 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab1JLAxK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 20:53:10 -0400
Date: Wed, 12 Oct 2011 02:53:05 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Kay Sievers <kay.sievers@vrfy.org>, TejunHeotj@kernel.org
Cc: linux-kernel@vger.kernel.org, lennart@poettering.net, harald@redhat.com,
        david@fubar.dk, greg@kroah.com,
        "Kirill A. Shutemov" <kirill@shutemov.name>
Subject: Re: A =?utf-8?Q?Plumber=E2=80=99?= =?utf-8?Q?s?= Wish List for Linux
Message-ID: <20111012005303.GC14968@somewhere>
References: <1317943022.1095.25.camel@mop>
 <20111011161600.6145aa6b.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111011161600.6145aa6b.akpm@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 11, 2011 at 04:16:00PM -0700, Andrew Morton wrote:
> On Fri, 07 Oct 2011 01:17:02 +0200
> Kay Sievers <kay.sievers@vrfy.org> wrote:
> > * fork throttling mechanism as basic cgroup functionality that is
> > available in all hierarchies independent of the controllers used:
> > This is important to implement race-free killing of all members of a
> > cgroup, so that cgroup member processes cannot fork faster then a cgroup
> > supervisor process could kill them. This needs to be recursive, so that
> > not only a cgroup but all its subgroups are covered as well.
> 
> Frederic Weisbecker's "cgroups: add a task counter subsystem" should
> address this.  Does it meet these requirments?  Have you tested it?

It should work for this yeah. We in fact explored and documented that
second usecase of the task counter subsystem for Kay's needs.

Now cgroup subsystems can only be binded in one hierarchy at a time.
So it couldn't be used by Lxc and some other user at the same time
and that defeats kay's goals. But there is an old patch from Paul
Menage that allows some specific subsystems (those that don't deal
with global resources) to be mounted on many hierarchies. The task
counter would fit in and hence be usable by Lxc and other users
simultaneously.

There is another solution that is to be considered. One could use
the cgroup freezer to freeze all the tasks in a cgroup and then kill
them all before thawing the whole. If the process of freezing doesn't
have races against fork then it should work as well. I only worry
about the window in copy_process() between the test on signal_pending(),
that cancels the fork if a signal is pending on the parent, and the
time the new task is eventually added to the cgroup with
cgroup_post_fork(). If the freezer misses the child while it is in that
window, then it's not going to be killed with the rest and it may even
launch some fork() soon to annoy you further. I don't know if that's
handled by the freezer. If it doesn't and that can't be fixed then that
won't work for you.

If the freezer is a possible solution then I don't know which one
is best for you. Perhaps freezing the tasks in the cgroup can make
it faster, or slower, than rejecting any fork and killing directly.
Perhaps it would be helpful to get more details about the practical
case you have.

Anyway, if you think the task counter subsystem approach suits you
better, I can rework Paul's patches that allow multi-bindable
subsystem so that it gets usable by several users simultaneously.

Thanks.
