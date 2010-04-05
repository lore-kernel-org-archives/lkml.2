Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756660Ab0DEVTU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 17:19:20 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:50884 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756424Ab0DEVTO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 17:19:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=bICvroI1ONfrXXeTXGrYOUAwl6g9bo/GwUyRL9JnzWu2HQHlE5pZK0M7fm7LFtW97U
         7GjPFow3jlz6zYrbwz2Y4boXL7sNxE8iLQcT7DRqpz6QQvTQT5bBAFjVkYzAeez6FWAc
         CkMmuoxecnA4MG3iphc6+BrkkdVsMLNtczSSQ=
Subject: [PATCH] /dev/mem: Allow rewinding
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
       Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1270501448.9013.23.camel@edumazet-laptop>
References: <1270499041.9013.15.camel@edumazet-laptop>
	 <1270501448.9013.23.camel@edumazet-laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 05 Apr 2010 23:19:05 +0200
Message-ID: <1270502345.9013.31.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 05 avril 2010 à 23:04 +0200, Eric Dumazet a écrit :
> Andrew, commit dcefafb6ac90ece8d68a6c203105f3d313e52da4 seems to be the
> problem. 
> 
> It breaks rewinds (negative offsets to lseek (... SEEK_CUR))
> 

Here is a patch to make rewind working again on /dev/mem

[PATCH] /dev/mem: Allow rewinding

commit dcefafb6 (/dev/mem: dont allow seek to last page)
inadvertently disabled rewinding on /dev/mem.

This broke x86info for example.

Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
---
diff --git a/drivers/char/mem.c b/drivers/char/mem.c
index 1f3215a..3973a1d 100644
--- a/drivers/char/mem.c
+++ b/drivers/char/mem.c
@@ -710,11 +710,6 @@ static loff_t memory_lseek(struct file *file, loff_t offset, int orig)
 	switch (orig) {
 	case SEEK_CUR:
 		offset += file->f_pos;
-		if ((unsigned long long)offset <
-		    (unsigned long long)file->f_pos) {
-			ret = -EOVERFLOW;
-			break;
-		}
 	case SEEK_SET:
 		/* to avoid userland mistaking f_pos=-9 as -EBADF=-9 */
 		if ((unsigned long long)offset >= ~0xFFFULL) {


