Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab0JKULc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 16:11:32 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:34796 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940Ab0JKULb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 16:11:31 -0400
From: "Tim Pepper" <lnxninja@linux.vnet.ibm.com>
Date: Mon, 11 Oct 2010 13:11:21 -0700
To: linux-kernel@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Marcio Saito <marcio@cyclades.com>, Jiri Slaby <jirislaby@gmail.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        John Stultz <johnstul@us.ibm.com>,
        Avantika Mathur <mathur@linux.vnet.ibm.com>
Subject: [RFC] [PATCH] allow low HZ values?
Message-ID: <20101011201121.GA953@tpepper-t61p.dolavim.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm not necessarily wanting to open up the age old question of "what is
a good HZ", but we were doing some testing on timer tick overheads for
HPC applications and this came up...

Below is a minimal hack at enabling lower HZ values.  The kernel builds
and boots for me on x86_64 (simple laptop and kvm configs) and ppc64
(misc. IBM System p) with each of the added HZ options.

There's explicit code checking HZ down to 12, but HZ<100 wasn't a config
option.  We collected some data at 10, 12 and 25.  There'd been some
question of whether 10 would even work or not but it looks fine in the
relatively minimal testing we did.  We tried 12 since the code seemed
to allow for it.  And 25 as a "safe" lower value.  The only difference
observed under load (ie: no no idle HZ in play) was the expected timer
tick happening less often.  There was definitely surprise that nothing
else seemed to break anywhere, especially at 10.

Do people feel it is reasonable to have Kconfig bits to allow some lower
HZ values?

If so, then there's the question of what breaks.  It's reasonable to
think there are other going to be subtleties buried in code around
assumptions on the likely range of HZ:

- I'm not sure that what I did in inet_timewait_sock.h and jiffies.h is
  reasonable.
- arch/x86/kernel/i8253.c throws a warning at line 43 (v2.6.36-rc7):
      warning: large integer implicitly truncated to unsigned type
- drivers/char/cyclades.c's cy_ioctl() warns:
      drivers/char/cyclades.c:2761: warning: division by zero
- drivers, drivers, drivers across all the arch's could use sanity checking

-- 
Tim Pepper  <lnxninja@linux.vnet.ibm.com>
IBM Linux Technology Center



Not-Signed-off-by: Tim Pepper <lnxninja@us.ibm.com>

diff --git a/include/linux/jiffies.h b/include/linux/jiffies.h
index 6811f4b..8c225b2 100644
--- a/include/linux/jiffies.h
+++ b/include/linux/jiffies.h
@@ -15,7 +15,9 @@
  * OSF/1 kernel. The SHIFT_HZ define expresses the same value as the
  * nearest power of two in order to avoid hardware multiply operations.
  */
-#if HZ >= 12 && HZ < 24
+#if HZ < 12
+# define SHIFT_HZ	3
+#elif HZ >= 12 && HZ < 24
 # define SHIFT_HZ	4
 #elif HZ >= 24 && HZ < 48
 # define SHIFT_HZ	5
diff --git a/include/net/inet_timewait_sock.h b/include/net/inet_timewait_sock.h
index a066fdd..1aba305 100644
--- a/include/net/inet_timewait_sock.h
+++ b/include/net/inet_timewait_sock.h
@@ -39,8 +39,9 @@ struct inet_hashinfo;
  * If time > 4sec, it is "slow" path, no recycling is required,
  * so that we select tick to get range about 4 seconds.
  */
-#if HZ <= 16 || HZ > 4096
-# error Unsupported: HZ <= 16 or HZ > 4096
+/* HACK HACK */
+#if HZ > 4096
+# error Unsupported: HZ > 4096
 #elif HZ <= 32
 # define INET_TWDR_RECYCLE_TICK (5 + 2 - INET_TWDR_RECYCLE_SLOTS_LOG)
 #elif HZ <= 64
diff --git a/kernel/Kconfig.hz b/kernel/Kconfig.hz
index 94fabd5..37302bf 100644
--- a/kernel/Kconfig.hz
+++ b/kernel/Kconfig.hz
@@ -15,6 +15,22 @@ choice
 	 environment leading to NR_CPUS * HZ number of timer interrupts
 	 per second.
 
+	config HZ_10
+		bool "10 HZ"
+	help
+	  10 Hz is extremely aggressive and may break things.
+
+	config HZ_12
+		bool "12 HZ"
+	help
+	  12 Hz because it's less aggressive than 10?
+
+	config HZ_25
+		bool "25 HZ"
+	help
+	  25 Hz is useful for reducing HPC application jitter caused by
+	  timer interrupts happening during a "fixed time quantum of work
+	  then barrier" style workload.
 
 	config HZ_100
 		bool "100 HZ"
@@ -49,6 +65,9 @@ endchoice
 
 config HZ
 	int
+	default 10 if HZ_10
+	default 12 if HZ_12
+	default 25 if HZ_25
 	default 100 if HZ_100
 	default 250 if HZ_250
 	default 300 if HZ_300
