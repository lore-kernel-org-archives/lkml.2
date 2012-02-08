Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab2BHCab (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 21:30:31 -0500
Received: from va3ehsobe002.messaging.microsoft.com ([216.32.180.12]:53753
	"EHLO VA3EHSOBE008.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755249Ab2BHCaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 21:30:30 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F31DE31.3040001@am.sony.com>
Date: Tue, 7 Feb 2012 18:30:09 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Andrew Morton <akpm@osdl.org>
Subject: [PATCH 3/5] logger: reorder prepare_to_wait and mutex_lock
References: <4F31DC31.6040303@am.sony.com>
In-Reply-To: <4F31DC31.6040303@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If mutex_lock waits, it will return in state TASK_RUNNING,
rubbing out the effect of prepare_to_wait().

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 drivers/staging/android/logger.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 92cfd94..54b7cdf 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -172,9 +172,10 @@ static ssize_t logger_read(struct file *file, char __user *buf,

 start:
 	while (1) {
+		mutex_lock(&log->mutex);
+
 		prepare_to_wait(&log->wq, &wait, TASK_INTERRUPTIBLE);

-		mutex_lock(&log->mutex);
 		ret = (log->w_off == reader->r_off);
 		mutex_unlock(&log->mutex);
 		if (!ret)
-- 
1.7.2.3

