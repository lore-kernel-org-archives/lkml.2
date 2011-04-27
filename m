Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759630Ab1D0RAu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 13:00:50 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:57034 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759515Ab1D0RAr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 13:00:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=jib13mLBkpI+xxcdnWi1VmB4uye57g6dj829s5Twb+Ru9joy/trSJKGo1pgOSSGzpS
         BKbYLZzp1C8Z9ze0EP8CSMHoHk8RIY61Q9NdG01GaHDLnPXjt5IV4T81w9Cs4UqzW9Mb
         hZOFDMuD40dvQ32F7XGuI/EwQlRnxvlri5IJk=
Subject: [PATCH] kernel, profile: Remove some duplicate code from
 profile_hits()
From: Rakib Mullick <rakib.mullick@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 27 Apr 2011 23:00:35 +0600
Message-ID: <1303923635.5168.7.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 profile_hits() has a common check for prof_on and prof_buffer regardless of SMP or !SMP. So, remove some duplicate code by splitting profile_hits into two.

Signed-off-by: Rakib Mullick <rakib.mullick@gmail.com>
---

diff --git a/kernel/profile.c b/kernel/profile.c
index 14c9f87..185e648 100644
--- a/kernel/profile.c
+++ b/kernel/profile.c
@@ -303,14 +303,12 @@ static void profile_discard_flip_buffers(void)
 	mutex_unlock(&profile_flip_mutex);
 }
 
-void profile_hits(int type, void *__pc, unsigned int nr_hits)
+void do_profile_hits(int type, void *__pc, unsigned int nr_hits)
 {
 	unsigned long primary, secondary, flags, pc = (unsigned long)__pc;
 	int i, j, cpu;
 	struct profile_hit *hits;
 
-	if (prof_on != type || !prof_buffer)
-		return;
 	pc = min((pc - (unsigned long)_stext) >> prof_shift, prof_len - 1);
 	i = primary = (pc & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
 	secondary = (~(pc << 1) & (NR_PROFILE_GRP - 1)) << PROFILE_GRPSHIFT;
@@ -417,16 +415,20 @@ out_free:
 #define profile_discard_flip_buffers()	do { } while (0)
 #define profile_cpu_callback		NULL
 
-void profile_hits(int type, void *__pc, unsigned int nr_hits)
+void do_profile_hits(int type, void *__pc, unsigned int nr_hits)
 {
 	unsigned long pc;
-
-	if (prof_on != type || !prof_buffer)
-		return;
 	pc = ((unsigned long)__pc - (unsigned long)_stext) >> prof_shift;
 	atomic_add(nr_hits, &prof_buffer[min(pc, prof_len - 1)]);
 }
 #endif /* !CONFIG_SMP */
+
+void profile_hits(int type, void *__pc, unsigned int nr_hits)
+{
+	if (prof_on != type || !prof_buffer)
+		return;
+	do_profile_hits(type, __pc, nr_hits);
+}
 EXPORT_SYMBOL_GPL(profile_hits);
 
 void profile_tick(int type)


