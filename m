Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab1JYHd6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 03:33:58 -0400
Received: from krak.alatek.krakow.pl ([46.170.108.42]:8621 "EHLO
	krak.alatek.krakow.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752656Ab1JYHd5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 03:33:57 -0400
From: Pawel Sikora <pluto@agmk.net>
To: Nai Xia <nai.xia@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        aarcange@redhat.com, mgorman@suse.de, hughd@google.com,
        torvalds@linux-foundation.org
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
Date: Tue, 25 Oct 2011 09:33:50 +0200
Message-ID: <3389010.3KTHnsaGe8@pawels>
User-Agent: KMail/4.7.2 (Linux/3.0.6-2; KDE/4.7.2; x86_64; ; )
In-Reply-To: <CAPQyPG5HJKTo8AEy_khdJeciTgtNQepK6XLcpzvPF8PYS0V-Lw@mail.gmail.com>
References: <201110122012.33767.pluto@agmk.net> <201110221842.26940.pluto@agmk.net> <CAPQyPG5HJKTo8AEy_khdJeciTgtNQepK6XLcpzvPF8PYS0V-Lw@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 of October 2011 12:21:30 Nai Xia wrote:
> 2011/10/23 Paweł Sikora <pluto@agmk.net>:
> > On Saturday 22 of October 2011 08:21:23 Nai Xia wrote:
> >> On Saturday 22 October 2011 05:36:46 Paweł Sikora wrote:
> >> > On Friday 21 of October 2011 11:07:56 Nai Xia wrote:
> >> > > On Fri, Oct 21, 2011 at 4:07 PM, Pawel Sikora <pluto@agmk.net> wrote:
> >> > > > On Friday 21 of October 2011 14:22:37 Nai Xia wrote:
> >> > > >
> >> > > >> And as a side note. Since I notice that Pawel's workload may include OOM,
> >> > > >
> >> > > > my last tests on patched (3.0.4 + migrate.c fix + vserver) kernel produce full cpu load
> >> > > > on dual 8-cores opterons like on this htop screenshot -> http://pluto.agmk.net/kernel/screen1.png
> >> > > > afaics all userspace applications usualy don't use more than half of physical memory
> >> > > > and so called "cache" on htop bar doesn't reach the 100%.
> >> > >
> >> > > OK，did you logged any OOM killing if there was some memory usage burst?
> >> > > But, well my above OOM reasoning is a direct short cut to imagined
> >> > > root cause of "adjacent VMAs which
> >> > > should have been merged but in fact not merged" case.
> >> > > Maybe there are other cases that can lead to this or maybe it's
> >> > > totally another bug....
> >> >
> >> > i don't see any OOM killing with my conservative settings
> >> > (vm.overcommit_memory=2, vm.overcommit_ratio=100).
> >>
> >> OK, that does not matter now. Andrea showed us a simpler way to goto
> >> this bug.
> >>
> >> >
> >> > > But still I think if my reasoning is good, similar bad things will
> >> > > happen again some time in the future,
> >> > > even if it was not your case here...
> >> > >
> >> > > >
> >> > > > the patched kernel with disabled CONFIG_TRANSPARENT_HUGEPAGE (new thing in 2.6.38)
> >> > > > died at night, so now i'm going to disable also CONFIG_COMPACTION/MIGRATION in next
> >> > > > steps and stress this machine again...
> >> > >
> >> > > OK, it's smart to narrow down the range first....
> >> >
> >> > disabling hugepage/compacting didn't help but disabling hugepage/compacting/migration keeps
> >> > opterons stable for ~9h so far. userspace uses ~40GB (from 64) ram, caches reach 100% on htop bar,
> >> > average load ~16. i wonder if it survive weekend...
> >> >
> >>
> >> Maybe you should give another shot of Andrea's latest anon_vma_order_tail() patch. :)
> >>
> >
> > all my attempts to disabling thp/compaction/migration failed (machine locked).
> > now, i'm testing 3.0.7+vserver+Hugh's+Andrea's patches+enabled few kernel debug options.
> 
> Have you got the result of this patch combination by now?

yes, this combination is working *stable* for ~2 days so far (with heavy stressing).

moreover, i've isolated/reported a faulty code in vserver patch that causes cryptic
deadlocks for 2.6.38+ kernels: http://list.linux-vserver.org/archive?msp:5420:mdaibmimlbgoligkjdma

> I have no clues about the locking below, indeed, it seems like another bug......

this might be fixed by 3.0.8  https://lkml.org/lkml/2011/10/23/26, i'll test it soon...

> >
> > so far it has logged only something unrelated to memory managment subsystem:
> >
> > [  258.397014] =======================================================
> > [  258.397209] [ INFO: possible circular locking dependency detected ]
> > [  258.397311] 3.0.7-vs2.3.1-dirty #1
> > [  258.397402] -------------------------------------------------------
> > [  258.397503] slave_odra_g_00/19432 is trying to acquire lock:
> > [  258.397603]  (&(&sig->cputimer.lock)->rlock){-.....}, at: [<ffffffff8103adfc>] update_curr+0xfc/0x190
