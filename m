Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756642Ab1DFTHv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 15:07:51 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:48270 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab1DFTHu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 15:07:50 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v2 01/12] mmc: add none blocking mmc request function
Date: Wed,  6 Apr 2011 21:07:02 +0200
Message-Id: <1302116833-24540-2-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
References: <1302116833-24540-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously there has only been one function mmc_wait_for_req
to start and wait for a request. This patch adds
 * mmc_start_req - starts a request wihtout waiting
 * mmc_wait_for_req_done - waits until request is done
 * mmc_pre_req - asks the host driver to prepare for the next job
 * mmc_post_req - asks the host driver to clean up after a completed job

The intention is to use pre_req() and post_req() to do cache maintenance
while a request is active. pre_req() can be called while a request is active
to minimize latency to start next job. post_req() can be used after the next
job is started to clean up the request. This will minimize the host driver
request end latency. post_req() is typically used before ending the block
request and handing over the buffer to the block layer.

Add a host-private member in mmc_data to be used by
pre_req to mark the data. The host driver will then
check this mark to see if the data is prepared or not.

Signed-off-by: Per Forlin <per.forlin@linaro.org>
---
 drivers/mmc/core/core.c  |   78 ++++++++++++++++++++++++++++++++++++++++------
 include/linux/mmc/core.h |    9 +++++-
 include/linux/mmc/host.h |    9 +++++
 3 files changed, 85 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 1f453ac..e88dd36 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -198,30 +198,88 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 
 static void mmc_wait_done(struct mmc_request *mrq)
 {
-	complete(mrq->done_data);
+	complete(&mrq->completion);
 }
 
 /**
- *	mmc_wait_for_req - start a request and wait for completion
+ *	mmc_pre_req - Prepare for a new request
+ *	@host: MMC host to prepare command
+ *	@mrq: MMC request to prepare for
+ *	@is_first_req: true if there is no previous started request
+ *                     that may run in parellel to this call, otherwise false
+ *
+ *	mmc_pre_req() is called in prior to mmc_start_req() to let
+ *	host prepare for the new request. Preparation of a request may be
+ *	performed while another request is running on the host.
+ */
+void mmc_pre_req(struct mmc_host *host, struct mmc_request *mrq,
+		 bool is_first_req)
+{
+	if (host->ops->pre_req)
+		host->ops->pre_req(host, mrq, is_first_req);
+}
+EXPORT_SYMBOL(mmc_pre_req);
+
+/**
+ *	mmc_post_req - Post process a completed request
+ *	@host: MMC host to post process command
+ *	@mrq: MMC request to post process for
+ *	@err: Error, if none zero, clean up any resources made in pre_req
+ *
+ *	Let the host post process a completed request. Post processing of
+ *	a request may be performed while another reuqest is running.
+ */
+void mmc_post_req(struct mmc_host *host, struct mmc_request *mrq, int err)
+{
+	if (host->ops->post_req)
+		host->ops->post_req(host, mrq, err);
+}
+EXPORT_SYMBOL(mmc_post_req);
+
+/**
+ *	mmc_start_req - start a request
  *	@host: MMC host to start command
  *	@mrq: MMC request to start
  *
- *	Start a new MMC custom command request for a host, and wait
- *	for the command to complete. Does not attempt to parse the
- *	response.
+ *	Start a new MMC custom command request for a host.
+ *	Does not wait for the command to complete.
  */
-void mmc_wait_for_req(struct mmc_host *host, struct mmc_request *mrq)
+void mmc_start_req(struct mmc_host *host, struct mmc_request *mrq)
 {
-	DECLARE_COMPLETION_ONSTACK(complete);
-
-	mrq->done_data = &complete;
+	init_completion(&mrq->completion);
 	mrq->done = mmc_wait_done;
 
 	mmc_start_request(host, mrq);
+}
+EXPORT_SYMBOL(mmc_start_req);
 
-	wait_for_completion(&complete);
+/**
+ *	mmc_wait_for_req_done - wait for completion of request
+ *	@mrq: MMC request to wait for
+ *
+ *	Wait for the command to complete. Does not attempt to parse the
+ *	response.
+ */
+void mmc_wait_for_req_done(struct mmc_request *mrq)
+{
+	wait_for_completion(&mrq->completion);
 }
+EXPORT_SYMBOL(mmc_wait_for_req_done);
 
+/**
+ *	mmc_wait_for_req - start a request and wait for completion
+ *	@host: MMC host to start command
+ *	@mrq: MMC request to start
+ *
+ *	Start a new MMC custom command request for a host, and wait
+ *	for the command to complete. Does not attempt to parse the
+ *	response.
+ */
+void mmc_wait_for_req(struct mmc_host *host, struct mmc_request *mrq)
+{
+	mmc_start_req(host, mrq);
+	mmc_wait_for_req_done(mrq);
+}
 EXPORT_SYMBOL(mmc_wait_for_req);
 
 /**
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 07f27af..5bbfb71 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -117,6 +117,7 @@ struct mmc_data {
 
 	unsigned int		sg_len;		/* size of scatter list */
 	struct scatterlist	*sg;		/* I/O scatter list */
+	s32			host_cookie;	/* host private data */
 };
 
 struct mmc_request {
@@ -124,13 +125,19 @@ struct mmc_request {
 	struct mmc_data		*data;
 	struct mmc_command	*stop;
 
-	void			*done_data;	/* completion data */
+	struct completion	completion;
 	void			(*done)(struct mmc_request *);/* completion function */
 };
 
 struct mmc_host;
 struct mmc_card;
 
+extern void mmc_pre_req(struct mmc_host *host, struct mmc_request *mrq,
+			bool is_first_req);
+extern void mmc_post_req(struct mmc_host *host, struct mmc_request *mrq,
+			 int err);
+extern void mmc_start_req(struct mmc_host *host, struct mmc_request *mrq);
+extern void mmc_wait_for_req_done(struct mmc_request *mrq);
 extern void mmc_wait_for_req(struct mmc_host *, struct mmc_request *);
 extern int mmc_wait_for_cmd(struct mmc_host *, struct mmc_command *, int);
 extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index bcb793e..c056a3d 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -88,6 +88,15 @@ struct mmc_host_ops {
 	 */
 	int (*enable)(struct mmc_host *host);
 	int (*disable)(struct mmc_host *host, int lazy);
+	/*
+	 * It is optional for the host to implement pre_req and post_req in
+	 * order to support double buffering of requests (prepare one
+	 * request while another request is active).
+	 */
+	void	(*post_req)(struct mmc_host *host, struct mmc_request *req,
+			    int err);
+	void	(*pre_req)(struct mmc_host *host, struct mmc_request *req,
+			   bool is_first_req);
 	void	(*request)(struct mmc_host *host, struct mmc_request *req);
 	/*
 	 * Avoid calling these three functions too often or in a "fast path",
-- 
1.7.4.1

