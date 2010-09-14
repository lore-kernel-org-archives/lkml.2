Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753874Ab0INNWB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 09:22:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30407 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab0INNWA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 09:22:00 -0400
Date: Tue, 14 Sep 2010 15:15:52 +0200
From: "Michael S. Tsirkin" <mst@redhat.com>
To: "Michael S. Tsirkin" <mst@redhat.com>, kvm@vger.kernel.org,
        virtualization@lists.osdl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] vhost-net: fix range checking in mrg bufs case
Message-ID: <20100914131552.GA1937@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In mergeable buffer case, we use headcount, log_num
and seg as indexes in same-size arrays, and
we know that headcount <= seg and
log_num equals either 0 or seg.

Therefore, the right thing to do is range-check seg,
not headcount as we do now: these will be different
if guest chains s/g descriptors (this does not
happen now, but we can not trust the guest).

Long term, we should add BUG_ON checks to verify
two other indexes are what we think they should be.

Reported-by: Jason Wang <jasowang@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
---

Dave, I'll queue this on my tree, no need to bother.

 drivers/vhost/net.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/vhost/net.c b/drivers/vhost/net.c
index 6400cd5..f095de6 100644
--- a/drivers/vhost/net.c
+++ b/drivers/vhost/net.c
@@ -245,7 +245,7 @@ static int get_rx_bufs(struct vhost_virtqueue *vq,
 	int r, nlogs = 0;
 
 	while (datalen > 0) {
-		if (unlikely(headcount >= VHOST_NET_MAX_SG)) {
+		if (unlikely(seg >= VHOST_NET_MAX_SG)) {
 			r = -ENOBUFS;
 			goto err;
 		}
-- 
1.7.3.rc1.5.ge5969
