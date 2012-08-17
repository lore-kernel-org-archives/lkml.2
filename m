Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755588Ab2HQVCq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 17:02:46 -0400
Received: from 1wt.eu ([62.212.114.60]:5772 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753626Ab2HQVCg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 17:02:36 -0400
Date: Fri, 17 Aug 2012 23:02:06 +0200
From: Willy Tarreau <w@1wt.eu>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        Namhyung Kim <namhyung@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Luciano Chavez <lnx1138@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>
Subject: Re: [v2.6.34-stable 134/165] mm: avoid null pointer access in vm_struct via /proc/vmallocinfo
Message-ID: <20120817210206.GA495@1wt.eu>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com> <1345060109-9187-135-git-send-email-paul.gortmaker@windriver.com> <20120817152233.GB4039@herton-Z68MA-D2H-B3> <502E8CC7.4070401@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <502E8CC7.4070401@windriver.com>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 02:26:15PM -0400, Paul Gortmaker wrote:
> On 12-08-17 11:22 AM, Herton Ronaldo Krzesinski wrote:
> > On Wed, Aug 15, 2012 at 03:47:58PM -0400, Paul Gortmaker wrote:
> >> From: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> >>
> >>                    -------------------
> >>     This is a commit scheduled for the next v2.6.34 longterm release.
> >>     http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
> >>     If you see a problem with using this for longterm, please comment.
> >>                    -------------------
> >>
> >> commit f5252e009d5b87071a919221e4f6624184005368 upstream.
> >>
> >> The /proc/vmallocinfo shows information about vmalloc allocations in
> >> vmlist that is a linklist of vm_struct.  It, however, may access pages
> >> field of vm_struct where a page was not allocated.  This results in a null
> >> pointer access and leads to a kernel panic.
> >>
> >> Why this happens: In __vmalloc_node_range() called from vmalloc(), newly
> >> allocated vm_struct is added to vmlist at __get_vm_area_node() and then,
> >> some fields of vm_struct such as nr_pages and pages are set at
> >> __vmalloc_area_node().  In other words, it is added to vmlist before it is
> >> fully initialized.  At the same time, when the /proc/vmallocinfo is read,
> >> it accesses the pages field of vm_struct according to the nr_pages field
> >> at show_numa_info().  Thus, a null pointer access happens.
> >>
> >> The patch adds the newly allocated vm_struct to the vmlist *after* it is
> >> fully initialized.  So, it can avoid accessing the pages field with
> >> unallocated page when show_numa_info() is called.
> >>
> >> Signed-off-by: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
> >> Cc: Andrew Morton <akpm@linux-foundation.org>
> >> Cc: David Rientjes <rientjes@google.com>
> >> Cc: Namhyung Kim <namhyung@gmail.com>
> >> Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> >> Cc: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> >> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> >> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> >> [PG: .34 has VMALLOC_START/END vs. start/end in f5252e009d5]
> >> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> > [...]
> > 
> > commit 1368edf0647ac112d8cfa6ce47257dc950c50f5c ("mm: vmalloc: check for
> > page allocation failure before vmlist insertion") addresses a regression
> > on this change, something to consider for inclusion in this stable
> > update as well.
> 
> Thanks Herton.
> 
> I've added Willy to CC, since v2.6.32.49 added f5252e but does
> not have 1368edf0 yet in any 2.6.32.x

Thank you Paul, much appreciated.

Queued for .60.

Willy

