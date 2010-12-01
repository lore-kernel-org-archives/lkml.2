Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756002Ab0LASEX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 13:04:23 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45362 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755820Ab0LASEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 13:04:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=G5kUutI4zLWjNNqJgrDsMnJvPGRFjtNcafObsmPKD+XIuaaTzuIVCZ4qbKoOW04G24
         iQYsBWYPCAFOzUj3yLaSP/RgFJdh9n9/I0l9wzH78ql8XdI9Az0WSi0JXcn7DBWxTXAM
         +kkrchWyo/njTvdXi/dXQmbiZP097CdoVoAG0=
Date: Wed, 1 Dec 2010 20:04:20 +0200 (EET)
From: Tero Roponen <tero.roponen@gmail.com>
X-X-Sender: terrop@localhost6.localdomain6
To: linux-kernel@vger.kernel.org
cc: David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: [PATCH] slub: Fix a crash during slabinfo -v
Message-ID: <alpine.LFD.2.02.1012012002440.1633@localhost6.localdomain6>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Commit f7cb1933621bce66a77f690776a16fe3ebbc4d58 ("SLUB: Pass active
and inactive redzone flags instead of boolean to debug functions")
missed two instances of check_object(). This caused a lot of warnings
during 'slabinfo -v' finally leading to a crash:

  BUG ext4_xattr: Freepointer corrupt
  ...
  BUG buffer_head: Freepointer corrupt
  ...
  BUG ext4_alloc_context: Freepointer corrupt
  ...
  ...
  BUG: unable to handle kernel NULL pointer dereference at 0000000000000008
  IP: [<ffffffff810a291f>] file_sb_list_del+0x1c/0x35
  PGD 79d78067 PUD 79e67067 PMD 0
  Oops: 0002 [#1] SMP
  last sysfs file: /sys/kernel/slab/:t-0000192/validate

This patch fixes the problem by converting the two missed instances.

Signed-off-by: Tero Roponen <tero.roponen@gmail.com>

diff --git a/mm/slub.c b/mm/slub.c
index 981fb73..bec0e35 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -3401,13 +3401,13 @@ static int validate_slab(struct kmem_cache *s, struct page *page,
 
 	for_each_free_object(p, s, page->freelist) {
 		set_bit(slab_index(p, s, addr), map);
-		if (!check_object(s, page, p, 0))
+		if (!check_object(s, page, p, SLUB_RED_INACTIVE))
			return 0;
 	}
 
 	for_each_object(p, s, addr, page->objects)
 		if (!test_bit(slab_index(p, s, addr), map))
-			if (!check_object(s, page, p, 1))
+			if (!check_object(s, page, p, SLUB_RED_ACTIVE))
 				return 0;
 	return 1;
 }
