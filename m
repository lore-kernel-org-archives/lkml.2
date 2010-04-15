Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756481Ab0DOTzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 15:55:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:54943 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756326Ab0DOTzb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 15:55:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,214,1270450800"; 
   d="scan'208";a="509503000"
From: "Sean Hefty" <sean.hefty@intel.com>
To: "'Tetsuo Handa'" <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: <amwang@redhat.com>, <opurdila@ixiacom.com>, <eric.dumazet@gmail.com>,
       <netdev@vger.kernel.org>, <nhorman@tuxdriver.com>,
       <davem@davemloft.net>, <ebiederm@xmission.com>,
       <linux-kernel@vger.kernel.org>, <rolandd@cisco.com>,
       <linux-rdma@vger.kernel.org>
References: <20100412100744.5302.92442.sendpatchset@localhost.localdomain>	<20100412100816.5302.74919.sendpatchset@localhost.localdomain>	<201004130121.o3D1Lhh7099571@www262.sakura.ne.jp>	<4BC41994.7030707@redhat.com>	<4BC42FE0.4040601@redhat.com> <201004132207.GAJ52684.OJFtMQVFHOSFLO@I-love.SAKURA.ne.jp> <21DAC78125424ED291B5D6477CFF9657@amr.corp.intel.com> <201004140201.o3E21Aqn075978@www262.sakura.ne.jp> <195EB1AD388F455AA386EB214FCD09F4@amr.corp.intel.com> <201004150229.o3F2T4dZ054768@www262.sakura.ne.jp>
Subject: [PATCH] rdma/cm: Randomize local port allocation.
Date: Thu, 15 Apr 2010 12:55:29 -0700
Message-ID: <5CE6BC7B954643FAAFFD2AD66F673CBD@amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 11
Thread-Index: AcrcQ38KvNo+aevSRBm7uT3ZGNfyHwAkNqww
In-Reply-To: <201004150229.o3F2T4dZ054768@www262.sakura.ne.jp>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

>Randomize local port allocation in a way sctp_get_port_local() does.
>Update rover at the end of loop since we're likely to pick a valid port
>on the first try.
>
>Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Reviewed-by: Sean Hefty <sean.hefty@intel.com>

>---

I like this version, thanks!  I'm not sure which tree to merge it through.
Are you needing this for 2.6.34, or is 2.6.35 okay?

> drivers/infiniband/core/cma.c |   70 +++++++++++++++--------------------------
>-
> 1 file changed, 25 insertions(+), 45 deletions(-)
>
>--- linux-2.6.34-rc4.orig/drivers/infiniband/core/cma.c
>+++ linux-2.6.34-rc4/drivers/infiniband/core/cma.c
>@@ -79,7 +79,6 @@ static DEFINE_IDR(sdp_ps);
> static DEFINE_IDR(tcp_ps);
> static DEFINE_IDR(udp_ps);
> static DEFINE_IDR(ipoib_ps);
>-static int next_port;
>
> struct cma_device {
> 	struct list_head	list;
>@@ -1970,47 +1969,33 @@ err1:
>
> static int cma_alloc_any_port(struct idr *ps, struct rdma_id_private *id_priv)
> {
>-	struct rdma_bind_list *bind_list;
>-	int port, ret, low, high;
>-
>-	bind_list = kzalloc(sizeof *bind_list, GFP_KERNEL);
>-	if (!bind_list)
>-		return -ENOMEM;
>-
>-retry:
>-	/* FIXME: add proper port randomization per like inet_csk_get_port */
>-	do {
>-		ret = idr_get_new_above(ps, bind_list, next_port, &port);
>-	} while ((ret == -EAGAIN) && idr_pre_get(ps, GFP_KERNEL));
>-
>-	if (ret)
>-		goto err1;
>+	static unsigned int last_used_port;
>+	int low, high, remaining;
>+	unsigned int rover;
>
> 	inet_get_local_port_range(&low, &high);
>-	if (port > high) {
>-		if (next_port != low) {
>-			idr_remove(ps, port);
>-			next_port = low;
>-			goto retry;
>-		}
>-		ret = -EADDRNOTAVAIL;
>-		goto err2;
>+	remaining = (high - low) + 1;
>+	rover = net_random() % remaining + low;
>+retry:
>+	if (last_used_port != rover &&
>+	    !idr_find(ps, (unsigned short) rover)) {
>+		int ret = cma_alloc_port(ps, id_priv, rover);
>+		/*
>+		 * Remember previously used port number in order to avoid
>+		 * re-using same port immediately after it is closed.
>+		 */
>+		if (!ret)
>+			last_used_port = rover;
>+		if (ret != -EADDRNOTAVAIL)
>+			return ret;
> 	}
>-
>-	if (port == high)
>-		next_port = low;
>-	else
>-		next_port = port + 1;
>-
>-	bind_list->ps = ps;
>-	bind_list->port = (unsigned short) port;
>-	cma_bind_port(bind_list, id_priv);
>-	return 0;
>-err2:
>-	idr_remove(ps, port);
>-err1:
>-	kfree(bind_list);
>-	return ret;
>+	if (--remaining) {
>+		rover++;
>+		if ((rover < low) || (rover > high))
>+			rover = low;
>+		goto retry;
>+	}
>+	return -EADDRNOTAVAIL;
> }
>
> static int cma_use_port(struct idr *ps, struct rdma_id_private *id_priv)
>@@ -2995,12 +2980,7 @@ static void cma_remove_one(struct ib_dev
>
> static int __init cma_init(void)
> {
>-	int ret, low, high, remaining;
>-
>-	get_random_bytes(&next_port, sizeof next_port);
>-	inet_get_local_port_range(&low, &high);
>-	remaining = (high - low) + 1;
>-	next_port = ((unsigned int) next_port % remaining) + low;
>+	int ret;
>
> 	cma_wq = create_singlethread_workqueue("rdma_cm");
> 	if (!cma_wq)

