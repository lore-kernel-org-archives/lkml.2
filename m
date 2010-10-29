Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759122Ab0J2TdK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 15:33:10 -0400
Received: from smtp108.prem.mail.ac4.yahoo.com ([76.13.13.47]:44734 "HELO
	smtp108.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752080Ab0J2TdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 15:33:07 -0400
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
X-YMail-OSG: AE2fPJgVM1kGuLVIp12kM0LMJDqlyUT5CETig_Hu6TsV8k2
 EccOuEey1azASvFE5UPSRLy4xYggNNgp9HfMKnsPshlt8bawRn8ztX.Zb5x2
 ZAF.XUiQUuZU_v1kvQ4wQxBNcifpemiN7m1.01teqwX3m5YOu7Qo8S6yIzuE
 lgz8HVOXYjb.uKGIB8Swr6nODg3JBi6pgJMLBOYiyQQcOoTeaVVqJeyqgOei
 5
X-Yahoo-Newman-Property: ymail-3
Date: Fri, 29 Oct 2010 14:33:02 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Andrew Morton <akpm@linux-foundation.org>
cc: Mel Gorman <mel@csn.ul.ie>, Shaohua Li <shaohua.li@intel.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>
Subject: Re: [PATCH 1/2] mm: page allocator: Adjust the per-cpu counter
 threshold when memory is low
In-Reply-To: <20101029112541.8ab906bb.akpm@linux-foundation.org>
Message-ID: <alpine.DEB.2.00.1010291425360.26312@router.home>
References: <1288278816-32667-1-git-send-email-mel@csn.ul.ie> <1288278816-32667-2-git-send-email-mel@csn.ul.ie> <20101028150433.fe4f2d77.akpm@linux-foundation.org> <alpine.DEB.2.00.1010290955510.20370@router.home>
 <20101029112541.8ab906bb.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010, Andrew Morton wrote:

> > Doing that caused cache misses in the past and reduced the performance of
> > the ZVCs. This way the threshold is in the same cacheline as the
> > differentials.
>
> This sounds wrong.  As long as that threshold isn't stored in a
> cacheline which other CPUs are modifying, all CPUs should be able to
> happily cache it.  Maybe it needed a bit of padding inside the zone
> struct.

High speed cpu caches are a very scarce resource. The differentials are
not in the zone struct. Tried to put it onto a single cacheline. Even that
did not do the trick for the large configurations.

The same optimizations are done in the slab allocators by the way.

Use of the percpu_counter() would at least quadruple the cache footprint
in use for the counters. percpu_counters() is using s32 and not s8.

