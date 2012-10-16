Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753108Ab2JPIpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 04:45:30 -0400
Received: from mga03.intel.com ([143.182.124.21]:22356 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752550Ab2JPIp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 04:45:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,593,1344236400"; 
   d="scan'208";a="204964497"
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Vinod Koul <vinod.koul@intel.com>, Viresh Kumar <viresh.linux@gmail.com>,
        linux-kernel@vger.kernel.org, spear-devel <spear-devel@list.st.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH] dmatest: terminate all ongoing transfers before submitting new one
Date: Tue, 16 Oct 2012 11:45:20 +0300
Message-Id: <1350377120-27657-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following error messages come if we have software LLP emulation enabled and
enough threads running.

modprobe dmatest iterations=40
[  168.048601] dmatest: Started 1 threads using dma0chan0
[  168.054546] dmatest: Started 1 threads using dma0chan1
[  168.060441] dmatest: Started 1 threads using dma0chan2
[  168.066333] dmatest: Started 1 threads using dma0chan3
[  168.072250] dmatest: Started 1 threads using dma0chan4
[  168.078144] dmatest: Started 1 threads using dma0chan5
[  168.084057] dmatest: Started 1 threads using dma0chan6
[  168.089948] dmatest: Started 1 threads using dma0chan7
[  170.032962] dma0chan1-copy0: terminating after 40 tests, 0 failures (status 0)
[  170.041274] dma0chan0-copy0: terminating after 40 tests, 0 failures (status 0)
[  170.597559] dma0chan2-copy0: terminating after 40 tests, 0 failures (status 0)
[  171.085059] dma0chan7-copy0: #0: test timed out
[  171.839710] dma0chan3-copy0: terminating after 40 tests, 0 failures (status 0)
[  172.146071] dma0chan4-copy0: terminating after 40 tests, 0 failures (status 0)
[  172.220802] dma0chan7-copy0: #1: got completion callback, but status is 'in progress'
[  172.242049] dma0chan7-copy0: #2: got completion callback, but status is 'in progress'
[  172.281063] dma0chan7-copy0: #3: got completion callback, but status is 'in progress'
[  172.400866] dma0chan7-copy0: #4: got completion callback, but status is 'in progress'
[  172.471799] dma0chan7-copy0: #5: got completion callback, but status is 'in progress'
[  172.613996] dma0chan7-copy0: #6: got completion callback, but status is 'in progress'
[  172.670286] dma0chan7-copy0: #7: got completion callback, but status is 'in progress'
[  172.750763] dma0chan7-copy0: #8: got completion callback, but status is 'in progress'
[  172.777452] dma0chan5-copy0: terminating after 40 tests, 0 failures (status 0)
[  172.788740] dma0chan7-copy0: #9: got completion callback, but status is 'in progress'
[  172.845156] dma0chan7-copy0: #10: got completion callback, but status is 'in progress'
[  172.906593] dma0chan7-copy0: #11: got completion callback, but status is 'in progress'
[  173.181515] dma0chan6-copy0: terminating after 40 tests, 0 failures (status 0)
[  173.512838] dma0chan7-copy0: terminating after 40 tests, 12 failures (status 0)

The patch fixes dmatest module to stop any ongoing transfer before submitting
new one. Perhaps there is a better solution and driver logic needs to be fixed
as well.

After patch we will have

modprobe dmatest iterations=50
[   84.027375] dmatest: Started 1 threads using dma0chan0
[   84.033282] dmatest: Started 1 threads using dma0chan1
[   84.039182] dmatest: Started 1 threads using dma0chan2
[   84.045089] dmatest: Started 1 threads using dma0chan3
[   84.051003] dmatest: Started 1 threads using dma0chan4
[   84.056916] dmatest: Started 1 threads using dma0chan5
[   84.062828] dmatest: Started 1 threads using dma0chan6
[   84.068714] dmatest: Started 1 threads using dma0chan7
[   86.538284] dma0chan0-copy0: terminating after 50 tests, 0 failures (status 0)
[   86.842221] dma0chan1-copy0: terminating after 50 tests, 0 failures (status 0)
[   87.060460] dma0chan6-copy0: #0: test timed out
[   87.065614] dma0chan7-copy0: #0: test timed out
[   87.220321] dma0chan2-copy0: terminating after 50 tests, 0 failures (status 0)
[   88.595061] dma0chan3-copy0: terminating after 50 tests, 0 failures (status 0)
[   89.152170] dma0chan4-copy0: terminating after 50 tests, 0 failures (status 0)
[   89.955059] dma0chan5-copy0: terminating after 50 tests, 0 failures (status 0)
[   90.697073] dma0chan6-copy0: terminating after 50 tests, 1 failures (status 0)
[   90.893422] dma0chan7-copy0: terminating after 50 tests, 1 failures (status 0)

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
---
 drivers/dma/dmatest.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/dma/dmatest.c b/drivers/dma/dmatest.c
index 24225f0..583f882 100644
--- a/drivers/dma/dmatest.c
+++ b/drivers/dma/dmatest.c
@@ -399,6 +399,9 @@ static int dmatest_func(void *data)
 			continue;
 		}
 
+		/* Stop any ongoing transfers here */
+		chan->device->device_control(chan, DMA_TERMINATE_ALL, 0);
+
 		done.done = false;
 		tx->callback = dmatest_callback;
 		tx->callback_param = &done;
-- 
1.7.10.4

