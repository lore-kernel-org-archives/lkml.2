Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752953Ab3ABQBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jan 2013 11:01:21 -0500
Received: from mx2.fusionio.com ([66.114.96.31]:45175 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab3ABQBS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jan 2013 11:01:18 -0500
X-ASG-Debug-ID: 1357142476-0421b52b7dcbee0001-xx1T2L
X-Barracuda-Envelope-From: clmason@fusionio.com
Date: Wed, 2 Jan 2013 11:01:15 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Dave Jones <davej@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Mason <clmason@fusionio.com>
Subject: Re: memory corruption, possibly caused by i915
Message-ID: <20130102160115.GB12838@shiny>
X-ASG-Orig-Subj: Re: memory corruption, possibly caused by i915
Mail-Followup-To: Chris Mason <chris.mason@fusionio.com>,
	Dave Jones <davej@redhat.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Daniel Vetter <daniel.vetter@ffwll.ch>,
	Chris Mason <clmason@fusionio.com>
References: <20130102155233.GA12479@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20130102155233.GA12479@redhat.com>
User-Agent: Mutt/1.5.21 (2011-07-01)
X-Barracuda-Connect: mail1.int.fusionio.com[10.101.1.21]
X-Barracuda-Start-Time: 1357142476
X-Barracuda-Encrypted: AES128-SHA
X-Barracuda-URL: http://10.101.1.181:8000/cgi-mod/mark.cgi
X-Barracuda-Spam-Score: 0.00
X-Barracuda-Spam-Status: No, SCORE=0.00 using global scores of TAG_LEVEL=1000.0 QUARANTINE_LEVEL=1000.0 KILL_LEVEL=9.0 tests=
X-Barracuda-Spam-Report: Code version 3.2, rules version 3.2.2.118739
	Rule breakdown below
	 pts rule name              description
	---- ---------------------- --------------------------------------------------
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 02, 2013 at 08:52:33AM -0700, Dave Jones wrote:
> We've had a increased number of reports in the last six months or so
> from Fedora users getting corrupted page tables.
> At first I wrote it off to bad hardware, but they started happening frequently
> enough that I began to wonder if it was a real problem.
> 
> The only common thing I could think of was that now that gnome-shell is
> our default desktop, we're making a lot more use of DRI than we used to.
> 
> To test a hypothesis, I played a whole lot of quake3 over the holidays,
> and was finally able to make it happen too.
> 
> After playing the game for a few hours, I exited it, and all was well.
> But when I then went to shut down the laptop, I saw this..
> 
> [52460.280346] BUG: Bad page map in process panel-6-systray  pte:ffff8800b665a0e8 pmd:b6659067
> [52460.280848] addr:00000038bf3fd000 vm_flags:00000070 anon_vma:          (null) mapping:ffff88011052fd98 index:1fd
> [52460.281547] vma->vm_ops->fault: filemap_fault+0x0/0x470
> [52460.281878] vma->vm_file->f_op->mmap: btrfs_file_mmap+0x0/0x60 [btrfs]
> [52460.286556] Pid: 1317, comm: panel-6-systray Not tainted 3.7.0+ #15
> [52460.286926] Call Trace:
> [52460.287086]  [<ffffffff8114c662>] print_bad_pte+0x1e2/0x250
> [52460.287445]  [<ffffffff8114ea1d>] unmap_single_vma+0x5dd/0x8a0
> [52460.287804]  [<ffffffff8114f541>] unmap_vmas+0x51/0xa0
> [52460.288087]  [<ffffffff81158628>] exit_mmap+0x98/0x170
> [52460.288388]  [<ffffffff81047808>] mmput+0x78/0xe0
> [52460.288651]  [<ffffffff8104ffae>] do_exit+0x24e/0xa30
> [52460.288944]  [<ffffffff8119394e>] ? ____fput+0xe/0x10
> [52460.289268]  [<ffffffff8106af3c>] ? task_work_run+0xac/0xe0
> [52460.289608]  [<ffffffff8105081f>] do_group_exit+0x3f/0xa0
> [52460.289937]  [<ffffffff81050897>] sys_exit_group+0x17/0x20
> [52460.290288]  [<ffffffff815f5699>] system_call_fastpath+0x16/0x1b
> 
> It's falling over in btrfs's mmap op, but I think it's just the victim here,
> of something else corrupting what had been mmaped in the panel process.

Hi Dave,

It's a btrfs file, but this isn't in our mmap op.  The traces are
finding bad pages at unmap time. 

> 
> Daniel, can you think of additional sanity checks that could be added to
> the i915 driver ? (Even if at the expense of speed: a CONFIG_DEBUG option
> to prove correctness would be very worthwhile imo)

If the bad pages are getting all the way to btrfs,
CONFIG_DEBUG_PAGE_ALOC may help?  You've got lockdep on so maybe you
already enabled it.

-chris

