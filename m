Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752126Ab1CYNC6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:02:58 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16792 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751051Ab1CYNC5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:02:57 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Dave Chinner <david@fromorbit.com>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jens Axboe <jaxboe@fusionio.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] Core block IO bits for 2.6.39 - early Oops
In-reply-to: <20110325044128.GJ26611@dastard>
References: <4D8B4A89.80608@fusionio.com> <20110324183019.GA1676@gentoo.trippels.de> <4D8B8F34.5000203@fusionio.com> <4D8B92AE.8090308@fusionio.com> <20110324185445.GB1696@gentoo.trippels.de> <4D8B9457.2020608@fusionio.com> <20110324193441.GA1723@gentoo.trippels.de> <20110325044128.GJ26611@dastard>
Date: Fri, 25 Mar 2011 09:01:40 -0400
Message-Id: <1301057952-sup-6679@think>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt358.oracle.com [141.146.40.158]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4D8C926B.01C1,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Dave Chinner's message of 2011-03-25 00:41:28 -0400:
> On Thu, Mar 24, 2011 at 08:34:41PM +0100, Markus Trippelsdorf wrote:

[ oopsen and fs corruptions in linus master ]

> 
> So the patchset is causing repeatable filesystem corruption? Sounds
> to me like this series is not yet ready for mainline merging. Last
> thing I want to spend the .39 cycle helping people recover busted
> filesystems as a result of undercooked block layer changes...
> 

I tried to reproduce this, but didn't get farther than make
modules_install.  My setup works like this:

build new kernel
start virtual machine off new kernel
make modules_install over NFS to get new modules (just the filesystems)

make modules_install instantly did this:
BUG: spinlock recursion on CPU#0, as/2014
 lock: ffff88006e939d08, .magic: dead4ead, .owner: as/2014, .owner_cpu: 0
Pid: 2014, comm: as Tainted: G        W   2.6.38-josef+ #228
Call Trace:
 [<ffffffff812712e5>] spin_bug+0x9c/0xa3
 [<ffffffff81271333>] do_raw_spin_lock+0x47/0x13c
 [<ffffffff81068329>] ? get_parent_ip+0x11/0x41
 [<ffffffff815dd796>] _raw_spin_lock+0x23/0x27
 [<ffffffff811258f9>] igrab+0x1b/0x48
 [<ffffffff811b2249>] nfs_updatepage+0x2ac/0x469
 [<ffffffff811a4eff>] nfs_write_end+0x26d/0x298
 [<ffffffff81068329>] ? get_parent_ip+0x11/0x41
 [<ffffffff810d43b7>] generic_file_buffered_write+0x189/0x26a
 [<ffffffff810db611>] ? __alloc_pages_nodemask+0x14d/0x7a8
 [<ffffffff810d5b2e>] __generic_file_aio_write+0x32b/0x35b
 [<ffffffff810d5bbf>] generic_file_aio_write+0x61/0xba
 [<ffffffff811a5ab7>] nfs_file_write+0xde/0x161
 [<ffffffff8110f3ba>] do_sync_write+0xcb/0x108
 [<ffffffff810f78d4>] ? do_mmap_pgoff+0x29a/0x2f4
 [<ffffffff8110f9f7>] vfs_write+0xb5/0x131
 [<ffffffff8110fc5c>] sys_write+0x4a/0x71
 [<ffffffff815e34ab>] system_call_fastpath+0x16/0x1b

-chris
