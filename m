Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756839Ab0ELRmM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 13:42:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29063 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776Ab0ELRmH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 13:42:07 -0400
Date: Wed, 12 May 2010 13:38:15 -0400
From: Rik van Riel <riel@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Mel Gorman <mel@csn.ul.ie>, Andrea Arcangeli <aarcange@redhat.com>,
       Minchan Kim <minchan.kim@gmail.com>, Linux-MM <linux-mm@kvack.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 0/5] always lock the root anon_vma
Message-ID: <20100512133815.0d048a86@annuminas.surriel.com>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch series implements Linus's suggestion of always locking the
root anon_vma.  Because the lock in other anon_vmas no longer protects
anything at all, we cannot do the "lock dance" that Mel's earlier
patches implements and instead need a root pointer in the anon_vma.

The only subtlety these patches rely on is that the same_vma list
is ordered from new to old, with the root anon_vma at the very end.

This, together with the forward list walking in unlink_anon_vmas,
ensures that the root anon_vma is the last one freed.

The KSM refcount adds some additional complexity, because an anon_vma
can stick around after the processes it was attached to have already
exited.  Patch 5/5 deals with that issue.
