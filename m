Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754255Ab0GTRfV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jul 2010 13:35:21 -0400
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:38110 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab0GTRfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jul 2010 13:35:16 -0400
Date: Tue, 20 Jul 2010 11:35:12 -0600
From: dann frazier <dannf@debian.org>
To: linux-ia64@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@suse.de>, Mel Gorman <mel@csn.ul.ie>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>
Subject: ia64 hang/mca running gdb 'make check'
Message-ID: <20100720173512.GF26783@ldl.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Debian's ia64 autobuilders have been experiencing system crashes while
trying to run the gdb test suite:
  http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=588574

I was able to reproduce this w/ the latest git tree, and bisected it
down to this commit, introduced in 2.6.32:

  commit 62eede62dafb4a6633eae7ffbeb34c60dba5e7b1
  Author: Hugh Dickins <hugh.dickins@tiscali.co.uk>
  Date:   Mon Sep 21 17:03:34 2009 -0700

    mm: ZERO_PAGE without PTE_SPECIAL

    Reinstate anonymous use of ZERO_PAGE to all architectures, not just to
    those which __HAVE_ARCH_PTE_SPECIAL: as suggested by Nick Piggin.

    Contrary to how I'd imagined it, there's nothing ugly about this, just a
    zero_pfn test built into one or another block of vm_normal_page().

    But the MIPS ZERO_PAGE-of-many-colours case demands is_zero_pfn() and
    my_zero_pfn() inlines.  Reinstate its mremap move_pte() shuffling of
    ZERO_PAGEs we did from 2.6.17 to 2.6.19?  Not unless someone shouts for
    that: it would have to take vm_flags to weed out some cases.

fyi, I found this to not be reproducible on SLES11 SP1 (which is
2.6.32-based). I compared the .configs and found that the relevant
difference is the PAGE_SIZE. It does not fail w/ 64KB pages, but
reliably fails w/ 16KB pages.
