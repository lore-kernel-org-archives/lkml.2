Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab2HaSl2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 14:41:28 -0400
Received: from mx1.redhat.com ([209.132.183.28]:53881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753449Ab2HaSl0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 14:41:26 -0400
Date: Fri, 31 Aug 2012 14:41:15 -0400 (EDT)
From: Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file.rdu.redhat.com
To: Eric Dumazet <eric.dumazet@gmail.com>
cc: Jens Axboe <axboe@kernel.dk>, Andrea Arcangeli <aarcange@redhat.com>,
        Jan Kara <jack@suse.cz>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, Jeff Moyer <jmoyer@redhat.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        kosaki.motohiro@jp.fujitsu.com, linux-fsdevel@vger.kernel.org,
        lwoodman@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
Subject: [PATCH 1/4] Add a lock that will be needed by the next patch
In-Reply-To: <Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
Message-ID: <Pine.LNX.4.64.1208311440350.2212@file.rdu.redhat.com>
References: <Pine.LNX.4.64.1206272226050.22857@file.rdu.redhat.com> 
 <20120628111541.GB17515@quack.suse.cz>  <Pine.LNX.4.64.1207152051490.4240@file.rdu.redhat.com>
  <x49ipdmyz4q.fsf@segfault.boston.devel.redhat.com> 
 <Pine.LNX.4.64.1207181512530.10923@file.rdu.redhat.com> 
 <x49k3xzq3jc.fsf@segfault.boston.devel.redhat.com> 
 <Pine.LNX.4.64.1207281236230.30415@file.rdu.redhat.com> 
 <Pine.LNX.4.64.1207281240270.30415@file.rdu.redhat.com> 
 <1343508252.2626.13184.camel@edumazet-glaptop> 
 <Pine.LNX.4.64.1207290107460.29910@file.rdu.redhat.com> 
 <1343556630.2626.13257.camel@edumazet-glaptop> <1343586962.2626.13266.camel@edumazet-glaptop>
 <Pine.LNX.4.64.1208011601280.21832@file.rdu.redhat.com>
 <Pine.LNX.4.64.1208311433480.2212@file.rdu.redhat.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a lock that will be needed by the next patch.

I am submitting this as a separate patch, because the act of adding an
extra field to "struct block_device" affects performance significantly.

So that performance change from adding the lock field can be
differentiated from the performance change of locking.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/char/raw.c |    2 -
 fs/block_dev.c     |   60 +++++++++++++++++++++++++++++++++++++++++++++++++++--
 include/linux/fs.h |    4 +++
 3 files changed, 63 insertions(+), 3 deletions(-)

Index: linux-3.5-rc6-devel/include/linux/fs.h
===================================================================
--- linux-3.5-rc6-devel.orig/include/linux/fs.h	2012-07-16 20:20:12.000000000 +0200
+++ linux-3.5-rc6-devel/include/linux/fs.h	2012-07-16 01:29:21.000000000 +0200
@@ -713,6 +713,8 @@ struct block_device {
 	int			bd_fsfreeze_count;
 	/* Mutex for freeze */
 	struct mutex		bd_fsfreeze_mutex;
+	/* A semaphore that prevents I/O while block size is being changed */
+	struct rw_semaphore	bd_block_size_semaphore;
 };
 
 /*

