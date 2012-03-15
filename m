Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161693Ab2COVxo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 17:53:44 -0400
Received: from terminus.zytor.com ([198.137.202.10]:60199 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965306Ab2COVxl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 17:53:41 -0400
Date: Thu, 15 Mar 2012 14:53:32 -0700
From: tip-bot for Sasha Levin <levinsasha928@gmail.com>
Message-ID: <tip-a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, levinsasha928@gmail.com, hpa@zytor.com,
        mingo@redhat.com, tglx@linutronix.de
Reply-To: mingo@redhat.com, hpa@zytor.com, levinsasha928@gmail.com,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1331829374-31543-2-git-send-email-levinsasha928@gmail.com>
References: <1331829374-31543-2-git-send-email-levinsasha928@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] ntp: Fix integer overflow when setting time
Git-Commit-ID: a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Thu, 15 Mar 2012 14:53:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33
Gitweb:     http://git.kernel.org/tip/a078c6d0e6288fad6d83fb6d5edd91ddb7b6ab33
Author:     Sasha Levin <levinsasha928@gmail.com>
AuthorDate: Thu, 15 Mar 2012 12:36:14 -0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 15 Mar 2012 21:41:34 +0100

ntp: Fix integer overflow when setting time

'long secs' is passed as divisor to div_s64, which accepts a 32bit
divisor. On 64bit machines that value is trimmed back from 8 bytes
back to 4, causing a divide by zero when the number is bigger than
(1 << 32) - 1 and all 32 lower bits are 0.

Use div64_long() instead.

Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
Cc: johnstul@us.ibm.com
Link: http://lkml.kernel.org/r/1331829374-31543-2-git-send-email-levinsasha928@gmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 kernel/time/ntp.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 17fb1b9..6e039b1 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -289,7 +289,7 @@ static inline s64 ntp_update_offset_fll(s64 offset64, long secs)
 
 	time_status |= STA_MODE;
 
-	return div_s64(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
+	return div64_long(offset64 << (NTP_SCALE_SHIFT - SHIFT_FLL), secs);
 }
 
 static void ntp_update_offset(long offset)
