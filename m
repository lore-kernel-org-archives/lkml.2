Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753621Ab1DNBKl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 21:10:41 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:53986 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752105Ab1DNBKk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 21:10:40 -0400
Date: Thu, 14 Apr 2011 03:10:37 +0200
From: Herbert Poetzl <herbert@13thfloor.at>
To: linux-kernel@vger.kernel.org
Subject: [PATCH] genhd: remove useless cast in diskstats_show()
Message-ID: <20110414011037.GI11970@MAIL.13thfloor.at>
Mail-Followup-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch removes the (unsigned long long) cast in
diskstats_show() and adjusts the seq_printf() format
string to 'unsigned long'

diskstats_show() uses part_stat_read() to get the
stats, which either accesses the specified field in
the struct disk_stats directly (non SMP) or sums
up the per CPU values in a variable of the same
type as the field, so in any case the result will
have the same type and range as the specified field
which for all disk_stats entries is unsigned long

also, for unsigned long ranges the output of %lu
should be identical to the one of %llu, so no cange
in teh actual proc entry contents

best,
Herbert

Signed-off-by: Herbert Poetzl <herbert@13thfloor.at>
---
--- linux/block/genhd.c	2011-03-07 16:53:26.000000000 +0100
+++ linux/block/genhd.c	2011-04-14 03:36:35.000000000 +0200
@@ -1154,17 +1154,17 @@ static int diskstats_show(struct seq_fil
 		cpu = part_stat_lock();
 		part_round_stats(cpu, hd);
 		part_stat_unlock();
-		seq_printf(seqf, "%4d %7d %s %lu %lu %llu "
-			   "%u %lu %lu %llu %u %u %u %u\n",
+		seq_printf(seqf, "%4d %7d %s %lu %lu %lu "
+			   "%u %lu %lu %lu %u %u %u %u\n",
 			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
 			   disk_name(gp, hd->partno, buf),
 			   part_stat_read(hd, ios[0]),
 			   part_stat_read(hd, merges[0]),
-			   (unsigned long long)part_stat_read(hd, sectors[0]),
+			   part_stat_read(hd, sectors[0]),
 			   jiffies_to_msecs(part_stat_read(hd, ticks[0])),
 			   part_stat_read(hd, ios[1]),
 			   part_stat_read(hd, merges[1]),
-			   (unsigned long long)part_stat_read(hd, sectors[1]),
+			   part_stat_read(hd, sectors[1]),
 			   jiffies_to_msecs(part_stat_read(hd, ticks[1])),
 			   part_in_flight(hd),
 			   jiffies_to_msecs(part_stat_read(hd, io_ticks)),
