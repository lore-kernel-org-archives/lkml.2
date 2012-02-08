Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279Ab2BHCev (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 21:34:51 -0500
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:3489
	"EHLO AM1EHSOBE005.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756607Ab2BHCeu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 21:34:50 -0500
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh668h839h93fh)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F31DF34.8000205@am.sony.com>
Date: Tue, 7 Feb 2012 18:34:28 -0800
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        linux kernel <linux-kernel@vger.kernel.org>,
        Brian Swetland <swetland@google.com>, Dima Zavin <dima@android.com>,
        Andrew Morton <akpm@osdl.org>
Subject: [PATCH 5/5] logger: clarify non-update of w_off in do_write_log_from_user
References: <4F31DC31.6040303@am.sony.com>
In-Reply-To: <4F31DC31.6040303@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add comment to explain when w_off is not updated in case of failed second
fragment copy to buffer.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 drivers/staging/android/logger.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/android/logger.c b/drivers/staging/android/logger.c
index 8d9d4f1..115d8ed 100644
--- a/drivers/staging/android/logger.c
+++ b/drivers/staging/android/logger.c
@@ -330,6 +330,12 @@ static ssize_t do_write_log_from_user(struct logger_log *log,

 	if (count != len)
 		if (copy_from_user(log->buffer, buf + len, count - len))
+			/*
+			 * Note that by not updating w_off, this abandons the
+			 * portion of the new entry that *was* successfully
+			 * copied, just above.  This is intentional to avoid
+			 * message corruption from missing fragments.
+			 */
 			return -EFAULT;

 	log->w_off = logger_offset(log, log->w_off + count);
-- 
1.7.2.3

