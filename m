Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0DEQPU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 12:15:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:56466 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755223Ab0DEQPO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 12:15:14 -0400
Date: Mon, 5 Apr 2010 12:13:33 -0400
From: Rik van Riel <riel@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Minchan Kim <minchan.kim@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Nick Piggin <npiggin@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, sgunderson@bigfoot.com
Subject: [PATCH -v2] rmap: fix anon_vma_fork() memory leak
Message-ID: <20100405121333.21d343ff@annuminas.surriel.com>
In-Reply-To: <alpine.LFD.2.00.1004050824400.21313@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
	<20100402175937.GA19690@liondog.tnic>
	<alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org>
	<20100402112428.f46ddc44.akpm@linux-foundation.org>
	<alpine.LFD.2.00.1004021135530.3634@i5.linux-foundation.org>
	<4BB66941.1060809@redhat.com>
	<1270397575.1814.106.camel@barrios-desktop>
	<20100404190925.5daac2f3@annuminas.surriel.com>
	<alpine.LFD.2.00.1004050824400.21313@i5.linux-foundation.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a memory leak in anon_vma_fork(), where we fail to tear down the
anon_vmas attached to the new VMA in case setting up the new anon_vma
fails.

This bug also has the potential to leave behind anon_vma_chain structs
with pointers to invalid memory.

Reported-by: Minchan Kim <minchan.kim@gmail.com>
Signed-off-by: Rik van Riel <riel@redhat.com>

diff --git a/mm/rmap.c b/mm/rmap.c
index fcd593c..eaa7a09 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -232,6 +232,7 @@ int anon_vma_fork(struct vm_area_struct *vma, struct vm_area_struct *pvma)
  out_error_free_anon_vma:
 	anon_vma_free(anon_vma);
  out_error:
+	unlink_anon_vmas(vma);
 	return -ENOMEM;
 }
 
