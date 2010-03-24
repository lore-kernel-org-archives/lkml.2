Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932949Ab0CXUwd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 16:52:33 -0400
Received: from smtp-out.google.com ([74.125.121.35]:44059 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab0CXUwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 16:52:30 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:subject:to:cc:date:message-id:user-agent:
	mime-version:content-type:content-transfer-encoding:x-system-of-record;
	b=konp9Ea7Nr/K4MCId+I+DfSaPjyhYlqMPePUdEWJUz4z5c4k1wiE89kPq8CeYOzec
	3qPId7FDBSc7bhCLTzmKg==
From: Divyesh Shah <dpshah@google.com>
Subject: [PATCH] cfq-iosched: Do not merge queues of BE and IDLE classes
To: jens.axboe@oracle.com
Cc: linux-kernel@vger.kernel.org, nauman@google.com, vgoyal@redhat.com
Date: Wed, 24 Mar 2010 13:52:03 -0700
Message-ID: <20100324205127.7477.97997.stgit@austin.mtv.corp.google.com>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

even if they are found to be co-operating.

The prio_trees do not have any IDLE cfqqs on them. cfq_close_cooperator()
is called from cfq_select_queue() and cfq_completed_request(). The latter
ensures that the close cooperator code does not get invoked if the current
cfqq is of class IDLE but the former doesn't seem to have any such checks.
So an IDLE cfqq may get merged with a BE cfqq from the same group which
should be avoided.

Signed-off-by: Divyesh Shah<dpshah@google.com>
---

 block/cfq-iosched.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index dee9d93..e6910dc 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1721,6 +1721,8 @@ static struct cfq_queue *cfq_close_cooperator(struct cfq_data *cfqd,
 {
 	struct cfq_queue *cfqq;
 
+	if (cfq_class_idle(cur_cfqq))
+		return NULL;
 	if (!cfq_cfqq_sync(cur_cfqq))
 		return NULL;
 	if (CFQQ_SEEKY(cur_cfqq))

