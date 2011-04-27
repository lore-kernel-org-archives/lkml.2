Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756344Ab1D0Kg0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 06:36:26 -0400
Received: from rere.qmqm.pl ([89.167.52.164]:36500 "EHLO rere.qmqm.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752809Ab1D0KgY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:36:24 -0400
Date: Wed, 27 Apr 2011 12:36:22 +0200
From: =?iso-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        Santiago Leon <santil@linux.vnet.ibm.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: ibmveth runtime errors
Message-ID: <20110427103622.GA22781@rere.qmqm.pl>
References: <20110427144901.4c3f79b3.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110427144901.4c3f79b3.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 27, 2011 at 02:49:01PM +1000, Stephen Rothwell wrote:
> For the last couple of days, linux-next booting on a few of our Power
> partitions (but not all) have produced this error (over and over):
> 
> ibmveth 3000000b: eth0: tx: h_send_logical_lan failed with rc=-4
> 
> Linus' tree seems to boot fine on these partitions.  The only commit
> directly affecting ibmveth in linux-next is b9367bf3ee6d ("net: ibmveth:
> convert to hw_features") which first appeared in next-20110421 which is
> also the first one that failed.

Please test the following patch. It's just a blind guess, as this error
is not descriptive.

Best Regards,
Micha³ Miros³aw

---

net: ibmveth: force reconfiguring checksum settings on startup

Commit b9367bf3ee6d ("net: ibmveth: convert to hw_features") accidentally
removed call to ibmveth_set_csum_offload() in ibmveth_probe(). Put the
call back where it was, but with additional error checking provided
by ibmveth_set_features().

Signed-off-by: Micha³ Miros³aw <mirq-linux@rere.qmqm.pl>
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>

---
 drivers/net/ibmveth.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ibmveth.c b/drivers/net/ibmveth.c
index 4855f1f..0d1fea2 100644
--- a/drivers/net/ibmveth.c
+++ b/drivers/net/ibmveth.c
@@ -1397,6 +1397,8 @@ static int __devinit ibmveth_probe(struct vio_dev *dev,
 
 	netdev_dbg(netdev, "registering netdev...\n");
 
+	ibmveth_set_features(dev, dev->features);
+
 	rc = register_netdev(netdev);
 
 	if (rc) {
-- 
1.7.2.5

