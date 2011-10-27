Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab1J0PMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 11:12:43 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61519 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158Ab1J0PMm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 11:12:42 -0400
Date: Thu, 27 Oct 2011 17:12:35 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Ben Blum <bblum@andrew.cmu.edu>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@redhat.com>,
        Paul Menage <paul@paulmenage.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] cgroups: don't cache common ancestor in task counter
 subsys
Message-ID: <20111027151230.GE7974@somewhere.redhat.com>
References: <4E9BDA43.6060406@cn.fujitsu.com>
 <20111017172537.GH2829@somewhere>
 <20111017172753.GA23241@ghc17.ghc.andrew.cmu.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111017172753.GA23241@ghc17.ghc.andrew.cmu.edu>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 17, 2011 at 01:27:53PM -0400, Ben Blum wrote:
> On Mon, Oct 17, 2011 at 07:25:41PM +0200, Frederic Weisbecker wrote:
> > When we rollback there, we are dealing with oldcgrp of the last thread
> > we have treated. All threads in the rollback list don't necessary belonged
> > to that old_cgroup.
> > 
> > And we can't try to retrieve these old_cgroup through task_cgroup_from_root() because
> > the threads might have exited and thus could be assigned to the init cgroup.
> > 
> > I believe we need to cache these old cgroups in the flex array.
> > 
> 
> Doing this would fulfill the "TODO" in cgroup_attach_proc for being able
> to pass the oldcgrp for each task in the loop around the ss->attach
> call, so if you do that, remove the corresponding comment. :)
> 
> -- Ben

I don't know, looking at the code, there is a separate issue to solve there.
The old cgroup passed in ->attach() is the one of a random task from the thread
group. The migrations that happen right before leave oldcgrp with the
old cgroup of the last thread in the group.

This doesn't seem to make any sense. As far as I checked this is only used
by the cpuset subsystem that does a migration in cpuset_attach() from
the old cgroup to the new.

I'm not sure about the details but that looks buggy.
