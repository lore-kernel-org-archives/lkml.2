Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757135Ab1F1IQw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 04:16:52 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:57418 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756718Ab1F1IMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 04:12:50 -0400
From: Per Forlin <per.forlin@linaro.org>
To: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org,
        Nickolay Nickolaev <nicknickolaev@gmail.com>,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Per Forlin <per.forlin@linaro.org>
Subject: [PATCH v8 01/12] mmc: core: add non-blocking mmc request function
Date: Tue, 28 Jun 2011 10:11:46 +0200
Message-Id: <1309248717-14606-2-git-send-email-per.forlin@linaro.org>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
References: <1309248717-14606-1-git-send-email-per.forlin@linaro.org>
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
 drivers/mmc/core/core.c  |  113 +++++++++++++++++++++++++++++++++++++++++----
 include/linux/mmc/core.h |    6 ++-
 include/linux/mmc/host.h |   21 +++++++++
 3 files changed, 129 insertions(+), 11 deletions(-)

diff --git a/drivers/mmc/core/core.c b/drivers/mmc/core/core.c
index 7843efe..d2d7239 100644
--- a/drivers/mmc/core/core.c
+++ b/drivers/mmc/core/core.c
@@ -198,9 +198,109 @@ mmc_start_request(struct mmc_host *host, struct mmc_request *mrq)
 
 static void mmc_wait_done(struct mmc_request *mrq)
 {
-	complete(mrq->done_data);
+	complete(&mrq->completion);
 }
 
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
+}
+
+/**
+ *	mmc_post_req - Post process a completed request
+ *	@host: MMC host to post process command
+ *	@mrq: MMC request to post process for
+ *	@err: Error, if non zero, clean up any resources made in pre_req
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
+ *	mmc_start_req - start a non-blocking request
+ *	@host: MMC host to start command
+ *	@areq: async request to start
+ *	@error: out parameter returns 0 for success, otherwise non zero
+ *
+ *	Start a new MMC custom command request for a host.
+ *	If there is on ongoing async request wait for completion
+ *	of that request and start the new one and return.
+ *	Does not wait for the new request to complete.
+ *
+ *      Returns the completed request, NULL in case of none completed.
+ *	Wait for the an ongoing request (previoulsy started) to complete and
+ *	return the completed request. If there is no ongoing request, NULL
+ *	is returned without waiting. NULL is not an error condition.
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
+			goto out;
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
+ out:
+	if (error)
+		*error = err;
+	return data;
+}
+EXPORT_SYMBOL(mmc_start_req);
+
 /**
  *	mmc_wait_for_req - start a request and wait for completion
  *	@host: MMC host to start command
@@ -212,16 +312,9 @@ static void mmc_wait_done(struct mmc_request *mrq)
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
index 791f060..57ee19e 100644
--- a/include/linux/mmc/core.h
+++ b/include/linux/mmc/core.h
@@ -117,6 +117,7 @@ struct mmc_data {
 
 	unsigned int		sg_len;		/* size of scatter list */
 	struct scatterlist	*sg;		/* I/O scatter list */
+	s32			host_cookie;	/* host private data */
 };
 
 struct mmc_request {
@@ -125,13 +126,16 @@ struct mmc_request {
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
 extern int mmc_app_cmd(struct mmc_host *, struct mmc_card *);
diff --git a/include/linux/mmc/host.h b/include/linux/mmc/host.h
index ac3fbac..59db6f2 100644
--- a/include/linux/mmc/host.h
+++ b/include/linux/mmc/host.h
@@ -106,6 +106,15 @@ struct mmc_host_ops {
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
@@ -144,6 +153,16 @@ struct mmc_host_ops {
 struct mmc_card;
 struct device;
 
+struct mmc_async_req {
+	/* active mmc request */
+	struct mmc_request	*mrq;
+	/*
+	 * Check error status of completed mmc request.
+	 * Returns 0 if success otherwise non zero.
+	 */
+	int (*err_check) (struct mmc_card *, struct mmc_async_req *);
+};
+
 struct mmc_host {
 	struct device		*parent;
 	struct device		class_dev;
@@ -280,6 +299,8 @@ struct mmc_host {
 
 	struct dentry		*debugfs_root;
 
+	struct mmc_async_req	*areq;		/* active async req */
+
 	unsigned long		private[0] ____cacheline_aligned;
 };
 
-- 
1.7.4.1

