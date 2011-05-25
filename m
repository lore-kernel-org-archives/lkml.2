Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755458Ab1EYUUb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 16:20:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:52070 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab1EYUU3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 16:20:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: virtualization@lists.linux-foundation.org
Subject: Re: [PATCH] arch/tile: add /proc/tile, /proc/sys/tile, and a sysfs cpu attribute
Date: Wed, 25 May 2011 22:20:23 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Chris Metcalf <cmetcalf@tilera.com>, linux-kernel@vger.kernel.org
References: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com> <201105202159.50780.arnd@arndb.de> <4DDD55ED.2080607@tilera.com>
In-Reply-To: <4DDD55ED.2080607@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105252220.23948.arnd@arndb.de>
X-Provags-ID: V02:K0:ec1CwqiJcO9y+6c3NCK/IPRNiYtuKGzX6gxUtCBzur+
 i1mZHj1Q36Taos3gq4ovtbe6ZDbLjwEDDgHIkNpZyUPCz65Pxt
 6glVBVeTh5tEc2Dc7ONeSc3EIKejtgm7RKitkOOLaAk6RMNngp
 vFbeJbTULdFy7qk3B+NRWOqs3I8OuVi7FGxOTbqk/qIirIi7/A
 rDj2I80PBEXKEKw9Z4NvQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 25 May 2011 21:18:05 Chris Metcalf wrote:
> (Resending with no HTML for LKML.)
> 
> On 5/20/2011 3:59 PM, Arnd Bergmann wrote:
> > Any chance you can still restructure the information? I would recommend
> > making it a first-class procfs member, since the data is really per-task.
> >
> > You can add a conditional entry to tgid_base_stuff[] in fs/proc/base.c
> > to make it show up for each pid, and then just have the per-task information
> > in there to do the lookup the other way round:
> >
> > # cat /proc/484/hardwall
> > 2x2 1,1 @2,1
> >
> > # cat /proc/479/hardwall
> > 2x2 1,1 @1,1
> > Another problem with the existing interface is that it doesn't currently
> > support PID name spaces. That could of course be retrofitted, but having
> > the data split by pid directory would make it work implicitly.
> >
> > Another approach would be to have a /proc/hardwall/ directory with
> > one entry per hardwall instance, and symlinks from /proc/<pid>/hardwall
> > to the respective file.
> 
> I went ahead and implemented this, and will send out a v2 patch shortly.  I
> added the "hardwall" entry to both the tgid_base (since everything is
> reflected there) but also to the tid_base_stuff[], since it can be
> different (in principle) for different threads.

Ok, sounds good.

> I played around with using a symlink, but the bottom line seems to be that
> if I make it a symlink (via a SYM() macro in the table) it always has to
> exist -- so what does it point to when there's no hardwall activated?  I
> tried making it point to /dev/null, but that just seemed silly.  In the end
> I made /proc/PID/hardwall a file, either empty, or else containing the
> hardwall id.

ok. I suppose you could make a non-hardwall file that you can link to,
but an empty file also sounds ok.

> The actual hardwalls are then in /proc/tile/hardwall/NN, where NN is the
> hardwall id.  I wrote a very simple hardwall id allocate/free pair; the pid
> allocator seemed too tied to task_structs.  We only need at most NR_CPUS
> hardwall ids, so it's pretty simple to just use a cpumask to hold the set
> of allocated hardwall IDs.

ok.

> The contents of the hardwall ID file are then just a cpulist of the cpus
> covered by the hardwall, rather than introducing a new convention (as
> quoted above, e.g. "2x2 1,1").  Individual tasks that are in the hardwall
> can be found by reading the "hardwall" files, and we can learn where they
> are bound in the hardwall by reading the "stat" file as is normal for
> learning process affinity.

Be careful with listing PID values in the hardwall files, as the PIDs
may not be unique or visible if you combine this with PID name spaces.
I guess the right solution would be to only list the tasks that are
present in the name space of the thread reading the file.

> > When you do a /sys/hypervisor/ interface, put everything into a subdirectory
> > under /sys/hypervisor with the name of your hypervisor, to avoid naming
> > conflicts, e.g.
> >
> > /sys/hypervisor/tilera-hv/board/board_serial
> 
> I don't see an easy way to put a directory in /sys/hypervisor.  It seems
> complex to create a kobject and a suitable class, etc., just for a
> subdirectory.  Or is there something simple I'm missing?  I'll keep looking.
> 
> I also suspect just "tile" is an adequate subdirectory name here in the
> context of /sys/hypervisor, e.g. /sys/hypervisor/tile/version.

I just checked for other users. The only one I could find was
drivers/xen/sys-hypervisor.c, and it also doesn't use a subdirectory to
identify that hypervisor. It's probably more consistent if you also don't
do it then.

You can create a directory with multiple files using sysfs_create_group()
as the xen code does, but not nested directories.

	Arnd
