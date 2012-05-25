Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab2EYV4u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 17:56:50 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:22867 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab2EYV4t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 17:56:49 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: jbeulich@suse.com, linux-kernel@vger.kernel.org,
        xen-devel@lists.xensource.com, axboe@kernel.dk
Subject: [PATCH] fixes to xen-blk[back|front] to deal with 32/64 host/guest combination with BLKIF_DISCARD (v1).
Date: Fri, 25 May 2012 17:50:01 -0400
Message-Id: <1337982603-15692-1-git-send-email-konrad.wilk@oracle.com>
X-Mailer: git-send-email 1.7.7.6
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches came out of hitting https://bugzilla.redhat.com/show_bug.cgi?id=824641
where a 32-bit guest would send a BLKIF_DISCARD request to a 64-bit
host. The xen-blkback did not copy the 'id' field into the response (it ended
up with a random value), which the frontend uses to lookup in its array to
find the 'struct request' that corresponded to this BLKIF_DISCARD.

The result was the __blk_end_request_all ended being called with a NULL
pointer and crashed the guest.

The fix is easy enough - make xen-blkback copy the 'id' field when
dealing with 32/64 or 64/32 host/guest combinations. The problem
does not exist if we are using a 64/64 combination.

I also added two BUG_ON to xen-blkfront to detect this misuse of 'id'
field in case there are other backends that do this.

If there are no problems with these patches I was thinking to put them
in my stable/for-jens-3.5 tree and ask Jens to pull them.

 drivers/block/xen-blkback/common.h |    2 ++
 drivers/block/xen-blkfront.c       |    7 +++++++
 2 files changed, 9 insertions(+), 0 deletions(-)

