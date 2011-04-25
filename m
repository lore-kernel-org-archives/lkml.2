Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932552Ab1DYUa7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Apr 2011 16:30:59 -0400
Received: from 1wt.eu ([62.212.114.60]:34604 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932463Ab1DYUZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Apr 2011 16:25:28 -0400
Message-Id: <20110425200240.164070671@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 25 Apr 2011 22:05:17 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Bob Liu <lliubbo@gmail.com>, Hugh Dickins <hughd@google.com>,
        David Howells <dhowells@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 165/173] ramfs: fix memleak on no-mmu arch
In-Reply-To: <46075c3a3ef08be6d70339617d6afc98@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.59-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Bob Liu <lliubbo@gmail.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 fs/ramfs/file-nommu.c |    1 +
 1 file changed, 1 insertion(+)

--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -111,6 +111,7 @@ int ramfs_nommu_expand_for_mapping(struc
 		SetPageDirty(page);
 
 		unlock_page(page);
+		put_page(page);
 	}
 
 	return 0;


