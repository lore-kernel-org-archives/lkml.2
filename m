Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab1DZV3I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 17:29:08 -0400
Received: from mga09.intel.com ([134.134.136.24]:46509 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932239Ab1DZVO3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 17:14:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,270,1301900400"; 
   d="scan'208";a="738831849"
From: Andi Kleen <andi@firstfloor.org>
References: <20110426212.641772347@firstfloor.org>
In-Reply-To: <20110426212.641772347@firstfloor.org>
To: lliubbo@gmail.com, hughd@google.com, dhowells@redhat.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        gregkh@suse.de, ak@linux.intel.com, linux-kernel@vger.kernel.org,
        stable@kernel.org, tim.bird@am.sony.com
Subject: [PATCH] [60/106] ramfs: fix memleak on no-mmu arch
Message-Id: <20110426211340.DA43D3E1886@tassilo.jf.intel.com>
Date: Tue, 26 Apr 2011 14:13:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 fs/ramfs/file-nommu.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux-2.6.35.y/fs/ramfs/file-nommu.c
===================================================================
--- linux-2.6.35.y.orig/fs/ramfs/file-nommu.c
+++ linux-2.6.35.y/fs/ramfs/file-nommu.c
@@ -112,6 +112,7 @@ int ramfs_nommu_expand_for_mapping(struc
 		SetPageDirty(page);
 
 		unlock_page(page);
+		put_page(page);
 	}
 
 	return 0;
