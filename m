Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755652Ab1EYTSK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 15:18:10 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:35205 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755617Ab1EYTSI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 15:18:08 -0400
Message-ID: <4DDD55ED.2080607@tilera.com>
Date: Wed, 25 May 2011 15:18:05 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <virtualization@lists.linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arch/tile: add /proc/tile, /proc/sys/tile, and a sysfs
 cpu attribute
References: <201105181807.p4II7C5g015224@farm-0002.internal.tilera.com> <4DD6821F.6060707@tilera.com> <201105201713.25364.arnd@arndb.de> <201105202159.50780.arnd@arndb.de>
In-Reply-To: <201105202159.50780.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Resending with no HTML for LKML.)

On 5/20/2011 3:59 PM, Arnd Bergmann wrote:
> Any chance you can still restructure the information? I would recommend
> making it a first-class procfs member, since the data is really per-task.
>
> You can add a conditional entry to tgid_base_stuff[] in fs/proc/base.c
> to make it show up for each pid, and then just have the per-task information
> in there to do the lookup the other way round:
>
> # cat /proc/484/hardwall
> 2x2 1,1 @2,1
>
> # cat /proc/479/hardwall
> 2x2 1,1 @1,1
> Another problem with the existing interface is that it doesn't currently
> support PID name spaces. That could of course be retrofitted, but having
> the data split by pid directory would make it work implicitly.
>
> Another approach would be to have a /proc/hardwall/ directory with
> one entry per hardwall instance, and symlinks from /proc/<pid>/hardwall
> to the respective file.

I went ahead and implemented this, and will send out a v2 patch shortly.  I
added the "hardwall" entry to both the tgid_base (since everything is
reflected there) but also to the tid_base_stuff[], since it can be
different (in principle) for different threads.

I played around with using a symlink, but the bottom line seems to be that
if I make it a symlink (via a SYM() macro in the table) it always has to
exist -- so what does it point to when there's no hardwall activated?  I
tried making it point to /dev/null, but that just seemed silly.  In the end
I made /proc/PID/hardwall a file, either empty, or else containing the
hardwall id.

The actual hardwalls are then in /proc/tile/hardwall/NN, where NN is the
hardwall id.  I wrote a very simple hardwall id allocate/free pair; the pid
allocator seemed too tied to task_structs.  We only need at most NR_CPUS
hardwall ids, so it's pretty simple to just use a cpumask to hold the set
of allocated hardwall IDs.

The contents of the hardwall ID file are then just a cpulist of the cpus
covered by the hardwall, rather than introducing a new convention (as
quoted above, e.g. "2x2 1,1").  Individual tasks that are in the hardwall
can be found by reading the "hardwall" files, and we can learn where they
are bound in the hardwall by reading the "stat" file as is normal for
learning process affinity.

> When you do a /sys/hypervisor/ interface, put everything into a subdirectory
> under /sys/hypervisor with the name of your hypervisor, to avoid naming
> conflicts, e.g.
>
> /sys/hypervisor/tilera-hv/board/board_serial

I don't see an easy way to put a directory in /sys/hypervisor.  It seems
complex to create a kobject and a suitable class, etc., just for a
subdirectory.  Or is there something simple I'm missing?  I'll keep looking.

I also suspect just "tile" is an adequate subdirectory name here in the
context of /sys/hypervisor, e.g. /sys/hypervisor/tile/version.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


