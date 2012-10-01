Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932745Ab2JAXAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:00:49 -0400
Received: from 1wt.eu ([62.212.114.60]:35215 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932707Ab2JAXAm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:00:42 -0400
Message-Id: <20121001225200.194544970@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:52:58 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Sasha Levin <levinsasha928@gmail.com>, johnstul@us.ibm.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 061/180] ntp: Fix integer overflow when setting time
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: Sasha Levin <levinsasha928@gmail.com>

commit a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33 upstream.

'long secs' is passed as divisor to div_s64, which accepts a 32bit
divisor. On 64bit machines that value is trimmed back from 8 bytes
back to 4, causing a divide by zero when the number is bigger than
(1 << 32) - 1 and all 32 lower bits are 0.

Use div64_long() instead.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: johnstul@us.ibm.com
Link: http://lkml.kernel.org/r/1331829374-31543-2-git-send-email-levinsasha928@gmail.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[WT: div64_long() does not exist on 2.6.32 and needs a deeper backport than
 desired. Instead, address the issue by controlling that the divisor is
 correct for use as an s32 divisor]
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/time/ntp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index c1c36a2..26472a7 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -106,7 +106,7 @@ static inline s64 ntp_update_offset_fll(s64 offset64, long secs)
 {
 	time_status &= ~STA_MODE;
 
-	if (secs < MINSEC)
+	if ((s32)secs < MINSEC)
 		return 0;
 
 	if (!(time_status & STA_FLL) && (secs <= MAXSEC))
-- 
1.7.2.1.45.g54fbc



