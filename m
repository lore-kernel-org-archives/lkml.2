Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933187Ab1DMQqJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:46:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42579 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932582Ab1DMQqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:46:06 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
 Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
 Kingdom.
 Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
Subject: [PATCH] ramfs: fix memleak on no-mmu arch
To: torvalds@osdl.org, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, uclinux-dev@uclinux.org, linux-kernel@vger.kernel.org,
        Bob Liu <lliubbo@gmail.com>, Hugh Dickins <hughd@google.com>,
        stable@kernel.org, David Howells <dhowells@redhat.com>
Date: Wed, 13 Apr 2011 17:45:21 +0100
Message-ID: <20110413164521.3112.31642.stgit@warthog.procyon.org.uk>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Bob Liu <lliubbo@gmail.com>

On no-mmu arch, there is a memleak duirng shmem test.
The cause of this memleak is ramfs_nommu_expand_for_mapping() added page
refcount to 2 which makes iput() can't free that pages.

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
Mem:         60320        16644        43676            0            0
-/+ buffers:              16644        43676
root:/> shmem
run ok...
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
root:/> shmem
run ok...
root:/> free
             total         used         free       shared      buffers
Mem:         60320        21496        38824            0            0
-/+ buffers:              21496        38824
root:/> shmem
run ok...
root:/> free
             total         used         free       shared      buffers
Mem:         60320        22692        37628            0            0
-/+ buffers:              22692        37628
root:/>

After this patch the test result is:(no memleak anymore)
root:/>
root:/> free
             total         used         free       shared      buffers
Mem:         60320        16580        43740            0            0
-/+ buffers:              16580        43740
root:/> shmem
run ok...
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
root:/> shmem
run ok...
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
root:/> shmem
run ok...
root:/> free
             total         used         free       shared      buffers
Mem:         60320        16668        43652            0            0
-/+ buffers:              16668        43652
root:/>

Signed-off-by: Bob Liu <lliubbo@gmail.com>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: stable@kernel.org
Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/ramfs/file-nommu.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)


diff --git a/fs/ramfs/file-nommu.c b/fs/ramfs/file-nommu.c
index 9eead2c..fbb0b47 100644
--- a/fs/ramfs/file-nommu.c
+++ b/fs/ramfs/file-nommu.c
@@ -112,6 +112,7 @@ int ramfs_nommu_expand_for_mapping(struct inode *inode, size_t newsize)
 		SetPageDirty(page);
 
 		unlock_page(page);
+		put_page(page);
 	}
 
 	return 0;

