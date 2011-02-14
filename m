Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755122Ab1BNNPM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 08:15:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:3942 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab1BNNPJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 08:15:09 -0500
Message-ID: <4D592AD1.6020500@redhat.com>
Date: Mon, 14 Feb 2011 14:14:57 +0100
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        device-mapper development <dm-devel@redhat.com>
Subject: [PATCH][RFC] dm: Do not open log and cow device read-write for read-only
 mappings
References: <4D573BBB.6090200@redhat.com> <1297594735-5593-1-git-send-email-tm@tao.ma> <4D57E67E.1030707@redhat.com> <4D57F357.6060708@tao.ma> <4D580A8B.5050508@redhat.com> <20110214103026.GA18742@htj.dyndns.org> <4D591664.6090203@redhat.com>
In-Reply-To: <4D591664.6090203@redhat.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> But it doesn't fix the read-only snapshot issue and I guess there will be
> the same problem with read-only MD code too.
> (so the 2) issue here https://lkml.org/lkml/2011/2/12/209).
I am not sure if this is complete fix... note that:
- what happens during mirror resync and read-only log?
- for COW, it there situation we need to update header in read-oly mode? (invalidated snap?)
Milan
--

[RFC] Do not open log and cow device read-write for read-only mappings

Signed-off-by: Milan Broz <mbroz@redhat.com> 

diff --git a/drivers/md/dm-log.c b/drivers/md/dm-log.c
index 6951536..8e8a868 100644
--- a/drivers/md/dm-log.c
+++ b/drivers/md/dm-log.c
@@ -543,7 +543,7 @@ static int disk_ctr(struct dm_dirty_log *log, struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	r = dm_get_device(ti, argv[0], FMODE_READ | FMODE_WRITE, &dev);
+	r = dm_get_device(ti, argv[0], dm_table_get_mode(ti->table), &dev);
 	if (r)
 		return r;
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index fdde53c..a2d3309 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1080,7 +1080,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	argv++;
 	argc--;
 
-	r = dm_get_device(ti, cow_path, FMODE_READ | FMODE_WRITE, &s->cow);
+	r = dm_get_device(ti, cow_path, dm_table_get_mode(ti->table), &s->cow);
 	if (r) {
 		ti->error = "Cannot get COW device";
 		goto bad_cow;


