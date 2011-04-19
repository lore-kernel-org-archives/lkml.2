Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab1DSUmr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 16:42:47 -0400
Received: from kroah.org ([198.145.64.141]:58931 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754289Ab1DSUmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 16:42:37 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Apr 19 13:41:17 2011
Message-Id: <20110419204117.568954682@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Tue, 19 Apr 2011 13:30:46 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Bob Liu <lliubbo@gmail.com>, Hugh Dickins <hughd@google.com>,
        David Howells <dhowells@redhat.com>
Subject: [08/28] ramfs: fix memleak on no-mmu arch
In-Reply-To: <20110419204122.GA13268@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let us know.

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


