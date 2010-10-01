Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648Ab0JAFE7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 01:04:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:60743 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab0JAFE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 01:04:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=pZ/iVY2aSJyipRuxh7ye4JctBIAvho3yqt6TahYdUyI6ZOJo5BiiauwY6nfUT9pTnK
         8FBM9ZgtDnG9cdY1iphg==
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Ying Han <yinghan@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, Hugh Dickins <hughd@google.com>
Subject: [PATCH 0/2] Reduce mmap_sem hold times during file backed page faults
Date: Thu, 30 Sep 2010 22:04:42 -0700
Message-Id: <1285909484-30958-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, I would appreciate your comments on this since you shot down the
previous proposal. I hope you'll find this approach is sane, but I would
be interested to hear if you have specific objections.

mmap_sem is very coarse grained (per process) and has long read-hold times
(disk latencies); this breaks down rapidly for workloads that use both
read and write mmap_sem acquires. This short patch series tries to reduce
mmap_sem hold times when faulting in file backed VMAs.

First patch creates a single place to lock the page in filemap_fault().
There should be no behavior differences.

Second patch modifies that lock_page() so that, if trylock_page() fails,
we consider releasing the mmap_sem while waiting for page to be unlocked.
This is controlled by a new FAULT_FLAG_RELEASE flag. If the mmap_sem gets
released, we return the VM_FAULT_RELEASED status; the caller is then expected
to re-acquire mmap_sem and retry the page fault. Chances are that the same
page will be accessed and will now be unlocked, so the mmap_sem hold time
will be short.

Michel Lespinasse (2):
  Unique path for locking page in filemap_fault()
  Release mmap_sem when page fault blocks on disk transfer.

 arch/x86/mm/fault.c |   35 ++++++++++++++++++++++++++---------
 include/linux/mm.h  |    2 ++
 mm/filemap.c        |   38 +++++++++++++++++++++++++++++---------
 mm/memory.c         |    3 ++-
 4 files changed, 59 insertions(+), 19 deletions(-)
