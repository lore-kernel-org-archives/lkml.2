Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291Ab1DPK1Z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 06:27:25 -0400
Received: from mga09.intel.com ([134.134.136.24]:36967 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756692Ab1DPK1S convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 06:27:18 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,223,1301900400"; 
   d="scan'208";a="734267319"
From: "Shi, Alex" <alex.shi@intel.com>
To: Tim Chen <tim.c.chen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>
CC: Andi Kleen <ak@linux.intel.com>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
Date: Sat, 16 Apr 2011 18:27:12 +0800
Subject: RE: [PATCH] vfs: Fix RCU path walk failiures due to uninitialized
 nameidata seq number for root directory
Thread-Topic: [PATCH] vfs: Fix RCU path walk failiures due to uninitialized
 nameidata seq number for root directory
Thread-Index: Acv7nGkVpyxhr557RPS4kW2yoUe0AQAhBuQg
Message-ID: <6E3BC7F7C9A4BF4286DD4C043110F30B4E0B8CD75A@shsmsx502.ccr.corp.intel.com>
References: <1302892769.2577.24.camel@schen9-DESK>
In-Reply-To: <1302892769.2577.24.camel@schen9-DESK>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This can fix dbenchthreads/aim7 regressions from 39-rc1 kernel, that caused by path_init_rcu/path_init merge. 


Regards! 
Alex  
>-----Original Message-----
>From: Tim Chen [mailto:tim.c.chen@linux.intel.com]
>Sent: Saturday, April 16, 2011 2:39 AM
>To: Alexander Viro; Nick Piggin
>Cc: Andi Kleen; linux-fsdevel@vger.kernel.org; linux-kernel@vger.kernel.org; Li, Shaohua; Shi, Alex
>Subject: [PATCH] vfs: Fix RCU path walk failiures due to uninitialized nameidata seq number for root directory
>
>During RCU walk in path_lookupat and path_openat, the rcu lookup
>frequently failed because when root directory was looked up, seq number
>was not properly set in nameidata.  We dropped out of RCU walk in
>nameidata_drop_rcu due to mismatch in directory entry's seq number.  We
>reverted to slow path walk that need to take references.
>
>With the following patch, I saw a 50% increase in an exim mail server
>benchmark throughput on a 4-socket Nehalem-EX system.
>
>Thanks.
>
>Tim
>
>Signed-off-by: Tim Chen <tim.c.chen@linux.intel.com>
>diff --git a/fs/namei.c b/fs/namei.c
>index 3cb616d..e4b27a6 100644
>--- a/fs/namei.c
>+++ b/fs/namei.c
>@@ -697,6 +697,7 @@ static __always_inline void set_root_rcu(struct nameidata *nd)
> 		do {
> 			seq = read_seqcount_begin(&fs->seq);
> 			nd->root = fs->root;
>+			nd->seq = __read_seqcount_begin(&nd->root.dentry->d_seq);
> 		} while (read_seqcount_retry(&fs->seq, seq));
> 	}
> }
>

