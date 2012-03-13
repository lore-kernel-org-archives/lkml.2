Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758624Ab2CMBBu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 21:01:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:47624 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758545Ab2CMAWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 20:22:21 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Bob Liu <lliubbo@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 062/196] ramfs: fix memleak on no-mmu arch
Date: Mon, 12 Mar 2012 20:19:35 -0400
Message-Id: <1331598109-31424-17-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.9.3
In-Reply-To: <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
References: <1331597724-31358-1-git-send-email-paul.gortmaker@windriver.com>
 <1331598109-31424-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Liu <lliubbo@gmail.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit b836aec53e2bce71de1d5415313380688c851477 upstream.

On no-mmu arch, there is a memleak during shmem test.  The cause of this
memleak is ramfs_nommu_expand_for_mapping() added page refcount to 2
which makes iput() can't free that pages.

The simple test file is like this:

  int main(void)
  {
	int i;
	key_t k = ftok("/etc", 42);

	for ( i=0; i<100; ++i) {
		int id = shmget(k, 10000, 0644|IPC_CREAT);
		if (id == -1) {
			printf("shmget error\n");
		}
		if(shmctl(id, IPC_RMID, NULL ) == -1) {
			printf("shm  rm error\n");
			return -1;
		}
	}
	printf("run ok...\n");
	return 0;
  }

And the result:

  root:/> free
               total         used         free       shared      buffers
  Mem:         60320        17912        42408            0            0
  -/+ buffers:              17912        42408
  root:/> shmem
  run ok...
  root:/> free
               total         used         free       shared      buffers
  Mem:         60320        19096        41224            0            0
  -/+ buffers:              19096        41224
  root:/> shmem
  run ok...
  root:/> free
               total         used         free       shared      buffers
  Mem:         60320        20296        40024            0            0
  -/+ buffers:              20296        40024
  ...

After this patch the test result is:(no memleak anymore)

  root:/> free
               total         used         free       shared      buffers
  Mem:         60320        16668        43652            0            0
  -/+ buffers:              16668        43652
  root:/> shmem
  run ok...
  root:/> free
               total         used         free       shared      buffers
  Mem:         60320        16668        43652            0            0
  -/+ buffers:              16668        43652

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 fs/ramfs/file-nommu.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 5ea4ad8..e9f6f9b 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -112,6 +112,7 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 		SetPageDirty(page);
 
 		unlock_page(page);
+		put_page(page);
 	}
 
 	return 0;
-- 
1.7.9.3

