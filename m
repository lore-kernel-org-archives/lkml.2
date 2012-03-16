Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946481Ab2CPXnK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 19:43:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48094 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1946460Ab2CPXlc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 19:41:32 -0400
Message-Id: <20120316233814.005828186@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Fri, 16 Mar 2012 16:38:48 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Ville Syrjala <syrjala@sci.fi>,
        Jean Delvare <khali@linux-fr.org>
Subject: [ 38/41] i2c-algo-bit: Fix spurious SCL timeouts under heavy load
In-Reply-To: <20120316233829.GA14022@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ville Syrjala <syrjala@sci.fi>

commit 8ee161ce5e0cfc689eb677f227a6248191165fac upstream.

When the system is under heavy load, there can be a significant delay
between the getscl() and time_after() calls inside sclhi(). That delay
may cause the time_after() check to trigger after SCL has gone high,
causing sclhi() to return -ETIMEDOUT.

To fix the problem, double check that SCL is still low after the
timeout has been reached, before deciding to return -ETIMEDOUT.

Signed-off-by: Ville Syrjala <syrjala@sci.fi>
Signed-off-by: Jean Delvare <khali@linux-fr.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/i2c/algos/i2c-algo-bit.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/i2c/algos/i2c-algo-bit.c
+++ b/drivers/i2c/algos/i2c-algo-bit.c
@@ -103,8 +103,14 @@ static int sclhi(struct i2c_algo_bit_dat
 		 * chips may hold it low ("clock stretching") while they
 		 * are processing data internally.
 		 */
-		if (time_after(jiffies, start + adap->timeout))
+		if (time_after(jiffies, start + adap->timeout)) {
+			/* Test one last time, as we may have been preempted
+			 * between last check and timeout test.
+			 */
+			if (getscl(adap))
+				break;
 			return -ETIMEDOUT;
+		}
 		cond_resched();
 	}
 #ifdef DEBUG


