Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab1JLAqp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 20:46:45 -0400
Received: from mga09.intel.com ([134.134.136.24]:6351 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751017Ab1JLAqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 20:46:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="62327183"
Subject: Re: [patch]ext4: add block plug for .writepages
From: Shaohua Li <shaohua.li@intel.com>
To: Kyungmin Park <kmpark@infradead.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "linux-ext4@vger.kernel.org" <linux-ext4@vger.kernel.org>
In-Reply-To: <CAH9JG2X9Hik6Qs8BHKS1WqJmiB9=Ve-W0XiZ+-dfHFnN1GmXKg@mail.gmail.com>
References: <1317004226.29510.172.camel@sli10-conroe>
	 <20110926073025.GB21079@infradead.org>
	 <1317022727.29510.175.camel@sli10-conroe>
	 <20110926094554.GA30827@infradead.org>
	 <1317179380.22361.8.camel@sli10-conroe>	<20111010165116.GX7948@thunk.org>
	 <CAH9JG2X9Hik6Qs8BHKS1WqJmiB9=Ve-W0XiZ+-dfHFnN1GmXKg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 12 Oct 2011 08:53:01 +0800
Message-ID: <1318380781.22361.98.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-11 at 18:40 +0800, Kyungmin Park wrote:
> On Tue, Oct 11, 2011 at 1:51 AM, Ted Ts'o <tytso@mit.edu> wrote:
> > On Wed, Sep 28, 2011 at 11:09:40AM +0800, Shaohua Li wrote:
> >> I searched a little bit, looks only ext4 need it. here is the patch.
> >>
> >>
> >> Add block plug for ext4 .writepages. Though ext4 .writepages
> >> already handles request merge very well, block plug is still
> >> helpful to reduce block lock contention.
> >>
> >> Signed-off-by: Shaohua Li <shaohua.li@intel.com>
> 
> Does it require to add blk_finish_plug(&plug) when error case?
oops, we need.

Subject: ext4: calling blk_finish_plug in error path

Forgot calling blk_finish_plug in error code path. Thanks Kyungmin Park pointed
it out.

Signed-off-by: Shaohua Li <shaohua.li@intel.com>
---
 fs/ext4/inode.c |    1 +
 1 file changed, 1 insertion(+)

Index: linux/fs/ext4/inode.c
===================================================================
--- linux.orig/fs/ext4/inode.c	2011-10-12 08:46:32.000000000 +0800
+++ linux/fs/ext4/inode.c	2011-10-12 08:48:10.000000000 +0800
@@ -2144,6 +2144,7 @@ retry:
 			ext4_msg(inode->i_sb, KERN_CRIT, "%s: jbd2_start: "
 			       "%ld pages, ino %lu; err %d", __func__,
 				wbc->nr_to_write, inode->i_ino, ret);
+			blk_finish_plug(&plug);
 			goto out_writepages;
 		}
 


