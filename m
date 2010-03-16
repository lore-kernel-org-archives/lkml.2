Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937158Ab0CPC7B (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 22:59:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:11519 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932389Ab0CPC67 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 22:58:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,647,1262592000"; 
   d="scan'208";a="500920233"
Date: Tue, 16 Mar 2010 10:56:56 +0800
From: Shaohua Li <shaohua.li@intel.com>
To: linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, czoccolo@gmail.com, vgoyal@redhat.com,
       jmoyer@redhat.com, guijianfeng@cn.fujitsu.com, alex.shi@intel.com,
       shaohua.li@intel.com
Subject: [RFC]cfq-iosched: fix a kbuild regression
Message-ID: <20100316025656.GA15390@sli10-desk.sh.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alex Shi reported a kbuild regression which is about 10% performance lost.
He bisected to this commit: 3dde36ddea3e07dd025c4c1ba47edec91606fec0.
The reason is cfqq_close() can't find close cooperator. If we store the seek
distance to the value before the commit like below, the regression fully goes
away. If this is too invasive, just changing the cfq_rq_close() for the
!for_preempt is ok too.

Reported-by: Alex Shi <alex.shi@intel.com>
Signed-off-by: Shaohua Li <shaohua.li@intel.com>

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index dee9d93..fcae456 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -46,7 +46,7 @@ static const int cfq_hist_divisor = 4;
 #define CFQ_HW_QUEUE_MIN	(5)
 #define CFQ_SERVICE_SHIFT       12
 
-#define CFQQ_SEEK_THR		(sector_t)(8 * 100)
+#define CFQQ_SEEK_THR		(sector_t)(8 * 1024)
 #define CFQQ_SECT_THR_NONROT	(sector_t)(2 * 32)
 #define CFQQ_SEEKY(cfqq)	(hweight32(cfqq->seek_history) > 32/8)
 
