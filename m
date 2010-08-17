Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755293Ab0HQC57 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:57:59 -0400
Received: from smtp-out.google.com ([216.239.44.51]:10752 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755021Ab0HQC54 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:57:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=UrrAnOimQefuCdNoNNcMaFwewJAcfNK/Km8MZsk11d6fQGiQhk9PLZDIENOu8Qsib
	1LGH0xVmGymgadqf5BzmA==
Date: Mon, 16 Aug 2010 19:57:51 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Neil Brown <neilb@suse.de>, Alasdair G Kergon <agk@redhat.com>
cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [patch 1/6] md: remove dependency on __GFP_NOFAIL
In-Reply-To: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
Message-ID: <alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes the dependency on __GFP_NOFAIL by looping indefinitely in the
caller.

Signed-off-by: David Rientjes <rientjes@google.com>
---
 drivers/md/dm-region-hash.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-region-hash.c b/drivers/md/dm-region-hash.c
--- a/drivers/md/dm-region-hash.c
+++ b/drivers/md/dm-region-hash.c
@@ -289,8 +289,12 @@ static struct dm_region *__rh_alloc(struct dm_region_hash *rh, region_t region)
 	struct dm_region *reg, *nreg;
 
 	nreg = mempool_alloc(rh->region_pool, GFP_ATOMIC);
-	if (unlikely(!nreg))
-		nreg = kmalloc(sizeof(*nreg), GFP_NOIO | __GFP_NOFAIL);
+	if (unlikely(!nreg)) {
+		/* FIXME: this may potentially loop forever */
+		do {
+			nreg = kmalloc(sizeof(*nreg), GFP_NOIO);
+		} while (!nreg);
+	}
 
 	nreg->state = rh->log->type->in_sync(rh->log, region, 1) ?
 		      DM_RH_CLEAN : DM_RH_NOSYNC;
