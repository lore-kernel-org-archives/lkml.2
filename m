Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab0ELTOm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 15:14:42 -0400
Received: from tango.0pointer.de ([85.214.72.216]:41631 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751852Ab0ELTOl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 15:14:41 -0400
X-Greylist: delayed 373 seconds by postgrey-1.27 at vger.kernel.org; Wed, 12 May 2010 15:14:40 EDT
Date: Wed, 12 May 2010 21:07:57 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dhaval Giani <dhaval.giani@gmail.com>, James Kosin <jkosin@intcomgrp.com>,
       linux-kernel@vger.kernel.org, menage@google.com,
       balbir@linux.vnet.ibm.com, jsafrane@redhat.com, tglx@linutronix.de
Subject: Re: [PATCH/RFC] Have sane default values for cpusets
Message-ID: <20100512190757.GA421@tango.0pointer.de>
References: <eJjRf-6YM-1@gated-at.bofh.it>
 <eJktY-7JG-7@gated-at.bofh.it>
 <eJktY-7JG-5@gated-at.bofh.it>
 <4BEAB6FC.8090105@intcomgrp.com>
 <AANLkTinwfvtALZhefqp_KbaUqH0EQFiokqvCQdMZC5M7@mail.gmail.com>
 <1273674048.1626.117.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1273674048.1626.117.camel@laptop>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12.05.10 16:20, Peter Zijlstra (peterz@infradead.org) wrote:

> 
> On Wed, 2010-05-12 at 16:13 +0200, Dhaval Giani wrote:
> > What you are saying is that an application
> > programmer who wants to just use memory cgroups should also care about
> > cpusets and just about countless other cgroup subsystems that can
> > exist. 
> 
> That's exactly what he says if he mounts them together.

Well, this is not realistic.

See Dhaval's patch on the background of systemd
(http://0pointer.de/blog/projects/systemd.html). When a service is
started in systemd, we create a cgroup for it, when it ends, we remove
it. While systemd does that to keep track of processes this has the nice
side effect that all services are properly (and without races) sorted
into different groups: if you start apache, then you get it into its own
group, if you started cups, you get your own group for that -- without
further configuration. Now, while the main reason to do that is for
keeping track of processes this is also useful to actually enforce
limits and suchlike on those groups and hence services. An admin can
choose to enforce limits on the groups systemd creates
for him, because most likely the grouping systemd does along service
lines is the one that matters the most.

I am not interested to make systemd aware of each and every controller
that exists and will exist in the future and encode specific inheritance
rules for them. That is simply not possible, we'd have to add a lot of
logic to systemd I simply don't want to maintain there, and I'd have to
constantly play catch-up with every controller that is added to the
kernel. However, if I don't have that in systemd, as it stands now and
an admin tells systemd to duplicate its groups tree in the cpuset
hierarchy, then systemd would fail to work. And that is not acceptable.

So, just for once, see this from the perspective of the people using
your code: if admins want to piggybick resource limiting onto the normal
systemd cgroup tree, then you make that impossible by having weird
inheritance rules that systemd would first have to learn. (And I am
sorry, but I refuse to teach those rules to systemd, anyway)

What I am arguing here is basically that it is really important to allow
userspace code to create groups in hierarchies where controllers are
active that the userspace code does not know.

Also, it's completely stupid anyway to ask userspace code to implement
inheritance rules for each cgroup controller, if that algorithm could
just as well with minimal work be implemented on the kernel side for free,
and then allows userspace to simply rely on "mkdir" to result in a
working subgroup.

Or let me say this with other words: if an "mkdir" is not enough to
create a working sub-cgroup then libcgroup would have to learn the
necessary inheritance rules and how to copy group params from the parent
to the child -- and that for each and every controller that exists and
will exist. If a new controller is added you'd have to patch libcgroup
and the kernel and make sure they always stay in sync. And that's just
crappy design, if you ask me, and doesn't scale.

Lennart
