Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754516Ab1C1N5V (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 09:57:21 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:46640 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab1C1N5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 09:57:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=v0vsgrwrkfrhDsYbP3ABBZFBTQCLnnS23DPDS8ezsgrif+TcpXRpD5oD57Rg2NdGtL
         AG+Sqqt2uTrDCf30LRHLY3irgF8ESbuwa+m8fXqBR3gl/Adrjyd9cNuuz/R4lOEw0NH8
         3WPJoDrSzkwGLgSY2GbD24RjW8a2z4SmqjUyk=
From: Namhyung Kim <namhyung@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>,
        Greg Ungerer <gerg@snapgear.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/6] nommu: fix a potential memory leak in do_mmap_private()
Date: Mon, 28 Mar 2011 22:56:46 +0900
Message-Id: <1301320607-7259-6-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1301320607-7259-1-git-send-email-namhyung@gmail.com>
References: <1301320607-7259-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If f_op->read() fails and sysctl_nr_trim_pages > 1, there could be a
memory leak between @region->vm_end and @region->vm_top.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 mm/nommu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/nommu.c b/mm/nommu.c
index 33f5d23c6d44..662fd46449a6 100644
--- a/mm/nommu.c
+++ b/mm/nommu.c
@@ -1241,7 +1241,7 @@ static int do_mmap_private(struct vm_area_struct *vma,
 	return 0;
 
 error_free:
-	free_page_series(region->vm_start, region->vm_end);
+	free_page_series(region->vm_start, region->vm_top);
 	region->vm_start = vma->vm_start = 0;
 	region->vm_end   = vma->vm_end = 0;
 	region->vm_top   = 0;
-- 
1.7.4

