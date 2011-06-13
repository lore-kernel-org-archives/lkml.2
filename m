Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752008Ab1FMLjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 07:39:36 -0400
Received: from MAIL.13thfloor.at ([213.145.232.33]:60885 "EHLO
	MAIL.13thfloor.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750967Ab1FMLjf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 07:39:35 -0400
X-Greylist: delayed 1424 seconds by postgrey-1.27 at vger.kernel.org; Mon, 13 Jun 2011 07:39:35 EDT
Date: Mon, 13 Jun 2011 13:15:50 +0200
From: Herbert Poetzl <herbert@13thfloor.at>
To: Linux Kernel ML <linux-kernel@vger.kernel.org>
Subject: [PATCH] genhd: remove useless cast in diskstats_show()
Message-ID: <20110613111550.GD30072@MAIL.13thfloor.at>
Mail-Followup-To: Linux Kernel ML <linux-kernel@vger.kernel.org>
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
should be identical to the one of %llu, so no change
in the actual proc entry contents

best,
Herbert

Signed-off-by: Herbert Poetzl <herbert@13thfloor.at>
--- linux/block/genhd.c	2011-06-09 15:16:17.000000000 +0200
+++ linux/block/genhd.c	2011-06-13 13:05:56.000000000 +0200
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
 			   part_stat_read(hd, ios[READ]),
 			   part_stat_read(hd, merges[READ]),
-			   (unsigned long long)part_stat_read(hd, sectors[READ]),
+			   part_stat_read(hd, sectors[READ]),
 			   jiffies_to_msecs(part_stat_read(hd, ticks[READ])),
 			   part_stat_read(hd, ios[WRITE]),
 			   part_stat_read(hd, merges[WRITE]),
-			   (unsigned long long)part_stat_read(hd, sectors[WRITE]),
+			   part_stat_read(hd, sectors[WRITE]),
 			   jiffies_to_msecs(part_stat_read(hd, ticks[WRITE])),
 			   part_in_flight(hd),
 			   jiffies_to_msecs(part_stat_read(hd, io_ticks)),

