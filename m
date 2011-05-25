Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932609Ab1EYV6V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 17:58:21 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:55562 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932313Ab1EYV6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 17:58:15 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org,
        David Vrabel <david.vrabel@csr.com>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v4 01/12] mmc: add none blocking mmc request function
Date: Wed, 25 May 2011 23:57:22 +0200
Message-Id: <1306360653-6196-2-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1306360653-6196-1-git-send-email-per.forlin@linaro.org>
References: <1306360653-6196-1-git-send-email-per.forlin@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Previously there has only been one function mmc_wait_for_req()
to start and wait for a request. This patch adds
 * mmc_start_req() - starts a request wihtout waiting
   If there is on ongoing request wait for completion
   of that request and start the new one and return.
   Does not wait for the new command to complete.

This patch also adds new function members in struct mmc_host_ops
only called from core.c
 * pre_req - asks the host driver to prepare for the next job
 * post_req - asks the host driver to clean up after a completed job

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
 drivers/mmc/core/core.c  |  111 +++++++++++++++++++++++++++++++++++++++++----
 include/linux/mmc/core.h |    6 ++-
 include/linux/mmc/host.h |   16 +++++++
 3 files changed, 122 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 1f453ac..66e1403 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -198,10 +198,108 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 
 static void mmc_wait_done(struct mmc_request *mrq)
 {
-	complete(mrq->done_data);
+	complete(&mrq->completion);
+}
+
+static void __mmc_start_req(struct mmc_host *host, struct mmc_request *mrq)
+{
+	init_completion(&mrq->completion);
+	mrq->done = mmc_wait_done;
+	mmc_start_request(host, mrq);
+}
+
+static void mmc_wait_for_req_done(struct mmc_host *host,
+				  struct mmc_request *mrq)
+{
+	wait_for_completion(&mrq->completion);
+}
+
+/**
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
+static void mmc_pre_req(struct mmc_host *host, struct mmc_request *mrq,
+		 bool is_first_req)
+{
+	if (host->ops->pre_req)
+		host->ops->pre_req(host, mrq, is_first_req);
 }
 
 /**
+ *	mmc_post_req - Post process a completed request
+ *	@host: MMC host to post process command
+ *	@mrq: MMC request to post process for
+ *	@err: Error, if none zero, clean up any resources made in pre_req
+ *
+ *	Let the host post process a completed request. Post processing of
+ *	a request may be performed while another reuqest is running.
+ */
+static void mmc_post_req(struct mmc_host *host, struct mmc_request *mrq,
+			 int err)
+{
+	if (host->ops->post_req)
+		host->ops->post_req(host, mrq, err);
+}
+
+/**
+ *	mmc_start_req - start a none blocking request
+ *	@host: MMC host to start command
+ *	@areq: async request to start
+ *	@error: none zero in case of error
+ *
+ *	Start a new MMC custom command request for a host.
+ *	If there is on ongoing async request wait for completion
+ *	of that request and start the new one and return.
+ *	Does not wait for the new request to complete.
+ *
+ *	Returns the completed async request, NULL in case of none completed.
+ */
+struct mmc_async_req *mmc_start_req(struct mmc_host *host,
+				    struct mmc_async_req *areq, int *error)
+{
+	int err = 0;
+	struct mmc_async_req *data = host->areq;
+
+	/* Prepare a new request */
+	if (areq)
+		mmc_pre_req(host, areq->mrq, !host->areq);
+
+	if (host->areq) {
+		mmc_wait_for_req_done(host, host->areq->mrq);
+		err = host->areq->err_check(host->card, host->areq);
+		if (err) {
+			mmc_post_req(host, host->areq->mrq, 0);
+			if (areq)
+				mmc_post_req(host, areq->mrq, -EINVAL);
+
+			host->areq = NULL;
+			if (error)
+				*error = err;
+			return data;
+		}
+	}
+
+	if (areq)
+		__mmc_start_req(host, areq->mrq);
+
+	if (host->areq)
+		mmc_post_req(host, host->areq->mrq, 0);
+
+	host->areq = areq;
+	if (error)
+		*error = err;
+	return data;
+}
+EXPORT_SYMBOL(mmc_start_req);
+
+/**
  *	mmc_wait_for_req - start a request and wait for completion
  *	@host: MMC host to start command
  *	@mrq: MMC request to start
@@ -212,16 +310,9 @@ static void mmc_wait_done(struct mmc_request *mrq)
  */
 void mmc_wait_for_req(struct mmc_host *host, struct mmc_request *mrq)
 {
-	DECLARE_COMPLETION_ONSTACK(complete);
-
-	mrq->done_data = &complete;
-	mrq->done = mmc_wait_done;
-
-	mmc_start_request(host, mrq);
-
-	wait_for_completion(&complete);
+	__mmc_start_req(host, mrq);
+	mmc_wait_for_req_done(host, mrq);
 }
-
 EXPORT_SYMBOL(mmc_wait_for_req);
 
 /**
diff --git a/include/linux/mmc/core.h b/include/linux/mmc/core.h
index 07f27af..28b5956 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -117,6 +117,7 @@ struct mmc_data {
 
 	unsigned int		sg_len;		/* size of scatter list */
 	struct scatterlist	*sg;		/* I/O scatter list */
+	s32			host_cookie;	/* host private data */
 };
 
 struct mmc_request {
@@ -124,13 +125,16 @@ struct mmc_request {
 	struct mmc_data		*data;
 	struct mmc_command	*stop;
 
-	void			*done_data;	/* completion data */
+	struct completion	completion;
 	void			(*done)(struct mmc_request *);/* completion function */
 };
 
 struct mmc_host;
 struct mmc_card;
+struct mmc_async_req;
 
+extern struct mmc_async_req *mmc_start_req(struct mmc_host *,
+					   struct mmc_async_req *, int *);
 extern void mmc_wait_for_req(struct mmc_host *, struct mmc_request *);
 extern int mmc_wait_for_cmd(struct mmc_host *, struct mmc_command *, int);
 extern int mmc_wait_for_app_cmd(struct mmc_host *, struct mmc_card *,
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index eb792cb..d2d948b 100644
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
@@ -122,6 +131,11 @@ struct mmc_host_ops {
 struct mmc_card;
 struct device;
 
+struct mmc_async_req {
+	struct mmc_request	*mrq;
+	int (*err_check) (struct mmc_card *, struct mmc_async_req *);
+};
+
 struct mmc_host {
 	struct device		*parent;
 	struct device		class_dev;
@@ -242,6 +256,8 @@ struct mmc_host {
 
 	struct dentry		*debugfs_root;
 
+	struct mmc_async_req	*areq;		/* active async req */
+
 	unsigned long		private[0] ____cacheline_aligned;
 };
 
-- 
1.7.4.1

