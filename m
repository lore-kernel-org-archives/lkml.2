Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754242Ab2LEW0r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 17:26:47 -0500
Received: from hosting.adsl24.co.uk ([84.234.17.171]:60627 "EHLO
	hosting.adsl24.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751980Ab2LEW0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 17:26:45 -0500
X-Greylist: delayed 4205 seconds by postgrey-1.27 at vger.kernel.org; Wed, 05 Dec 2012 17:26:45 EST
Date: Wed, 5 Dec 2012 21:17:07 +0000
From: Alun <alun.linux@ty-penguin.org.uk>
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: PATCH reduce impact of FIFREEZE on userland processes
Message-ID: <20121205211707.7ca3b94b@aspire.ty-penguin.org.uk>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.12; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Whitelisted: from local domain
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hosting.adsl24.co.uk
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - ty-penguin.org.uk
X-Get-Message-Sender-Via: hosting.adsl24.co.uk: authenticated_id: mail@typenguin.adsl24.co.uk
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch is against kernel version 3.7-rc7.

The FIFREEZE ioctl blocks userland writes, then calls sync_filesystem.
If there is a large amount of dirty data, this sync can take a
substantial time to complete, with corresponding loss of responsiveness
to any userland processes wishing to write.

This patch simply adds an extra call to sync_filesystem prior to
blocking writes, so that (hopefully) the majority of outstanding dirty
data has been flushed before we impact on userland.

I'm a complete kernel newbie and have only done some pretty minimal
testing on my own machine, but with the patch in place the impact of
running "fsfreeze -f" immediately followed by "fsfreeze -u" on a
moderately loaded filesystem (as measured by time taken for a write()
to complete) was reduced from 2.5 to 0.2 seconds. Hopefully there's no
subtlety in how all this works, and that adding the extra call has no
scary implications...

Signed-off-by: Alun Jones <alun.linux@ty-penguin.org.uk>

--- linux-3.7-rc7/fs/super.c.orig       2012-11-29 17:35:37.000000000
+0000 +++ linux-3.7-rc7/fs/super.c    2012-12-05 20:56:38.730631855
+0000 @@ -1314,6 +1314,11 @@ int freeze_super(struct super_block *sb)
                return 0;
        }
 
+       /* Sync before we block writes to reduce the amount of
+        * work that has to be done afterwards.
+        */
+       sync_filesystem(sb);
+
        /* From now on, no new normal writers can start */
        sb->s_writers.frozen = SB_FREEZE_WRITE;
        smp_wmb();
