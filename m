Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759419Ab0I0NyF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Sep 2010 09:54:05 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:20406 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759385Ab0I0NyD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Sep 2010 09:54:03 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: CqN5AWIVM1nRd4kT7Ina1V7eub7Y4bmNfJJf6ZV83lMTR9x
 rLVvmhallDNhajvTrroqEp51dFyrBVWxH4_dHItm8DY4ukSPaeu6flNjiKOt
 5qMavec6_S7KACXpbsSR7qkuFlxdt.tu4Ned8HRrhzKUvIdu.WOEp8EnP6ie
 z4ZMu7iLMm24mBXOoNbdlHf7CV.1lu0s.6aKrV4vhUMCiTolSAXAGmqZuso2
 h1Z61HCFWzV2lZ3.dRh3Ghf8p48qjtn3m6_v_HNBecpF9Xln52Q--
X-Yahoo-Newman-Property: ymail-3
Date: Mon, 27 Sep 2010 08:53:58 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
cc: Mel Gorman <mel@csn.ul.ie>, Rob Mueller <robm@fastmail.fm>,
        linux-kernel@vger.kernel.org, Bron Gondwana <brong@fastmail.fm>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: Default zone_reclaim_mode = 1 on NUMA kernel is bad forfile/email/web
 servers
In-Reply-To: <20100927110049.6B31.A69D9226@jp.fujitsu.com>
Message-ID: <alpine.DEB.2.00.1009270828510.7000@router.home>
References: <52C8765522A740A4A5C027E8FDFFDFE3@jem> <20100921090407.GA11439@csn.ul.ie> <20100927110049.6B31.A69D9226@jp.fujitsu.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Sep 2010, KOSAKI Motohiro wrote:

> > No doubt this is true. The only real difference is that there are more NUMA
> > machines running mail/web/file servers now than there might have been in the
> > past. The default made sense once upon a time. Personally I wouldn't mind
> > the default changing but my preference would be that distribution packages
> > installing on NUMA machines would prompt if the default should be changed if it
> > is likely to be of benefit for that package (e.g. the mail, file and web ones).
>
> At first impression, I thought this is cute idea. But, after while thinking, I've found some
> weak point. The problem is, too many package need to disable zone_reclaim_mode.
> zone_reclaim doesn't works fine if an application need large working set rather than
> local node size. It mean major desktop applications (e.g. OpenOffice.org, Firefox, GIMP)
> need to disable zone_reclaim. It mean even though basic package installation require
> zone_reclaim disabling. Then, this mechanism doesn't works practically. Even though
> the user hope to use the machine for hpc, disable zone_reclaim will be turn on anyway.
>
> Probably, opposite switch (default is zone_reclaim=0, and installation MPI library change
> to zone_reclaim=1) might works. but I can guess why you don't propose this one.

The fundamental problem that needs to be addressed is the balancing of a
memory load in a system with memory ranges that have different performance
characteristics when running conventional software that does not
properly balance allocations and that has not been written with these
new memory balancing issues in mind.

You can switch off zone reclaim of course which means that the
applications will not be getting memory thats optimal for them to access.
Given the current minimal NUMA differences in most single server systems
this is likely not going to matter. In fact the kernel has such a
mechanism to switch off zone reclaim for such systems (see the definition
of RECLAIM_DISTANCE). Which seems to have somehow been defeated by the
ACPI information of those machines which indicate a high latency
difference between the memory areas. The arch code could be adjusted to
set a higher RECLAIM_DISTANCE so that this motherboard also will default
to zone reclaim mode off.

However, the larger the NUMA effects become the more the performance loss
due to these effect. Its expected that the number of processors and
therefore also the NUMA effects in coming generations of machines will
increase. Various API exist to do finer grained memory access control so
that the performance loss can be isolated to processes or memory ranges.

F.e. running the application with numactl (using interleave) or a cpuset
with round robin on could address this issue without changing zone
reclaim and would allow other processes to allocate faster local memory.

The problem with zone reclaim mainly is created for large apps whose
working set is larger than the local node. The special settings are only
needing for those applications.

What can be done here is:

1. Fix the ACPI information to indicate lower memory access differences
   (was that info actually acurate?) so that zone reclaim defaults to off.

2. Change the RECLAIM_DISTANCE setting for the arch so that the ACPI
   information does not trigger zone reclaim to be enabled.

3. Run the application with numactl settings for interleaving of memory
   accesses (or corresponding cpuset settings).

4. Fix the application to be conscious of the effect of memory allocations
   on a NUMA systems. Use the numa memory allocations API to allocate
   anonymous memory locally for optimal access and set interleave for the
   file backed pages.

