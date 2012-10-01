Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757978Ab2JAXFl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:05:41 -0400
Received: from 1wt.eu ([62.212.114.60]:35720 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753513Ab2JAXFi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:05:38 -0400
Message-Id: <20121001225201.714420724@1wt.eu>
User-Agent: quilt/0.48-1
Date: Tue, 02 Oct 2012 00:53:34 +0200
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Willy Tarreau <w@1wt.eu>
Subject: [ 097/180] ntp: Fix STA_INS/DEL clearing bug
In-Reply-To: <6a854f579a99b4fe2efaca1057e8ae22@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-longterm review patch.  If anyone has any objections, please let me know.

------------------

From: John Stultz <johnstul@us.ibm.com>

commit 6b1859dba01c7d512b72d77e3fd7da8354235189 upstream.

In commit 6b43ae8a619d17c4935c3320d2ef9e92bdeed05d, I
introduced a bug that kept the STA_INS or STA_DEL bit
from being cleared from time_status via adjtimex()
without forcing STA_PLL first.

Usually once the STA_INS is set, it isn't cleared
until the leap second is applied, so its unlikely this
affected anyone. However during testing I noticed it
took some effort to cancel a leap second once STA_INS
was set.

Signed-off-by: John Stultz <johnstul@us.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Richard Cochran <richardcochran@gmail.com>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1342156917-25092-2-git-send-email-john.stultz@linaro.org
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Willy Tarreau <w@1wt.eu>
---
 kernel/time/ntp.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
index 26472a7..264928c 100644
--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -205,7 +205,9 @@ int second_overflow(unsigned long secs)
 			time_state = TIME_DEL;
 		break;
 	case TIME_INS:
-		if (secs % 86400 == 0) {
+		if (!(time_status & STA_INS))
+			time_state = TIME_OK;
+		else if (secs % 86400 == 0) {
 			leap = -1;
 			time_state = TIME_OOP;
 			time_tai++;
@@ -214,7 +216,9 @@ int second_overflow(unsigned long secs)
 		}
 		break;
 	case TIME_DEL:
-		if ((secs + 1) % 86400 == 0) {
+		if (!(time_status & STA_DEL))
+			time_state = TIME_OK;
+		else if ((secs + 1) % 86400 == 0) {
 			leap = 1;
 			time_tai--;
 			time_state = TIME_WAIT;
-- 
1.7.2.1.45.g54fbc



