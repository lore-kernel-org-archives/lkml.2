Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753143Ab2GZVaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:30:08 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62132 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753015Ab2GZVaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:30:06 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        John Stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: [ 02/40] ntp: Fix STA_INS/DEL clearing bug
Date: Thu, 26 Jul 2012 14:29:20 -0700
Message-Id: <20120726211411.254314091@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120726211411.164006056@linuxfoundation.org>
References: <20120726211424.GA7709@kroah.com>
 <20120726211411.164006056@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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

---
 kernel/time/ntp.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/time/ntp.c
+++ b/kernel/time/ntp.c
@@ -375,7 +375,9 @@ int second_overflow(unsigned long secs)
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
@@ -384,7 +386,9 @@ int second_overflow(unsigned long secs)
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


