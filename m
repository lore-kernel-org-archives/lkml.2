Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757821Ab0JEHx5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 03:53:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:29628 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755360Ab0JEHx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 03:53:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=HgmZYTqR4u/fuavRtszE41ifWCuB/RRot0uEcBSfcqtfZM0eDZiAht472x5umzt+MN
         LBZjie98uHt569VK003A==
From: Michel Lespinasse <walken@google.com>
To: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Ying Han <yinghan@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 0/3] V2: Reduce mmap_sem hold times during file backed page faults
Date: Tue,  5 Oct 2010 00:53:32 -0700
Message-Id: <1286265215-9025-1-git-send-email-walken@google.com>
X-Mailer: git-send-email 1.7.1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the second iteration of our change dropping mmap_sem when a disk
access occurs during a page fault to a file backed VMA.

Changes since V1:
- Cleaned up 'Retry page fault when blocking on disk transfer' applying
  linus's suggestions
- Added 'access_error API cleanup'

Tests:

- microbenchmark: thread A mmaps a large file and does random read accesses
  to the mmaped area - achieves about 55 iterations/s. Thread B does
  mmap/munmap in a loop at a separate location - achieves 55 iterations/s
  before, 15000 iterations/s after.
- We are seeing related effects in some applications in house, which show
  significant performance regressions when running without this change.
- I am looking for a microbenchmark to expose the worst case overhead of
  the page fault retry. Would FIO be a good match for that use ?

Michel Lespinasse (3):
  filemap_fault: unique path for locking page
  Retry page fault when blocking on disk transfer.
  access_error API cleanup

 arch/x86/mm/fault.c |   44 +++++++++++++++++++++++++++++---------------
 include/linux/mm.h  |    2 ++
 mm/filemap.c        |   41 ++++++++++++++++++++++++++++++++---------
 mm/memory.c         |    3 ++-
 4 files changed, 65 insertions(+), 25 deletions(-)
