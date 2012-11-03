Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754173Ab2KCO1E (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Nov 2012 10:27:04 -0400
Received: from mail4-relais-sop.national.inria.fr ([192.134.164.105]:23526
	"EHLO mail4-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752075Ab2KCO1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Nov 2012 10:27:02 -0400
X-IronPort-AV: E=Sophos;i="4.80,705,1344204000"; 
   d="scan'208";a="161253691"
Date: Sat, 3 Nov 2012 15:26:59 +0100 (CET)
From: Julia Lawall <Julia.Lawall@lip6.fr>
X-X-Sender: jll@localhost6.localdomain6
To: walter harms <wharms@bfs.de>
cc: Arnd Bergmann <arnd@arndb.de>, kernel-janitors@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        kgdb-bugreport@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: [PATCH] drivers/misc/kgdbts.c: remove eprintk
In-Reply-To: <509509F8.2010407@bfs.de>
Message-ID: <alpine.DEB.2.02.1211031525500.1955@localhost6.localdomain6>
References: <1351940317-14812-1-git-send-email-Julia.Lawall@lip6.fr> <1351940317-14812-12-git-send-email-Julia.Lawall@lip6.fr> <509509F8.2010407@bfs.de>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

eprintk is really just WARN(1, KERN_ERR ...).  Use WARN to be more
consistent with the rest of the code.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
  drivers/misc/kgdbts.c |   38 +++++++++++++++++---------------------
  1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/drivers/misc/kgdbts.c b/drivers/misc/kgdbts.c
index 3aa9a96..433993b 100644
--- a/drivers/misc/kgdbts.c
+++ b/drivers/misc/kgdbts.c
@@ -113,10 +113,6 @@
  		printk(KERN_INFO a); \
  		touch_nmi_watchdog();	\
  	} while (0)
-#define eprintk(a...) do { \
-		printk(KERN_ERR a); \
-		WARN_ON(1); \
-	} while (0)
  #define MAX_CONFIG_LEN		40

  static struct kgdb_io kgdbts_io_ops;
@@ -323,7 +319,7 @@ static int check_and_rewind_pc(char *put_str, char *arg)
  		v2printk("Emul: rewind hit single step bp\n");
  		restart_from_top_after_write = 1;
  	} else if (strcmp(arg, "silent") && ip + offset != addr) {
-		eprintk("kgdbts: BP mismatch %lx expected %lx\n",
+		WARN(1, KERN_ERR "kgdbts: BP mismatch %lx expected %lx\n",
  			   ip + offset, addr);
  		return 1;
  	}
@@ -374,7 +370,7 @@ static int check_single_step(char *put_str, char *arg)
  continue_test:
  	matched_id = 0;
  	if (instruction_pointer(&kgdbts_regs) == addr) {
-		eprintk("kgdbts: SingleStep failed at %lx\n",
+		WARN(1, KERN_ERR "kgdbts: SingleStep failed at %lx\n",
  			   instruction_pointer(&kgdbts_regs));
  		return 1;
  	}
@@ -469,7 +465,7 @@ static void emul_sstep_get(char *arg)
  		break_helper("z0", NULL, sstep_addr);
  		break;
  	default:
-		eprintk("kgdbts: ERROR failed sstep get emulation\n");
+		WARN(1, KERN_ERR "kgdbts: ERROR failed sstep get emulation\n");
  	}
  	sstep_state++;
  }
@@ -496,13 +492,13 @@ static int emul_sstep_put(char *put_str, char *arg)
  		break;
  	case 2:
  		if (strncmp(put_str, "$OK", 3)) {
-			eprintk("kgdbts: failed sstep break set\n");
+			WARN(1, KERN_ERR "kgdbts: failed sstep break set\n");
  			return 1;
  		}
  		break;
  	case 3:
  		if (strncmp(put_str, "$T0", 3)) {
-			eprintk("kgdbts: failed continue sstep\n");
+			WARN(1, KERN_ERR "kgdbts: failed continue sstep\n");
  			return 1;
  		} else {
  			char *ptr = &put_str[11];
@@ -511,14 +507,14 @@ static int emul_sstep_put(char *put_str, char *arg)
  		break;
  	case 4:
  		if (strncmp(put_str, "$OK", 3)) {
-			eprintk("kgdbts: failed sstep break unset\n");
+			WARN(1, KERN_ERR "kgdbts: failed sstep break unset\n");
  			return 1;
  		}
  		/* Single step is complete so continue on! */
  		sstep_state = 0;
  		return 0;
  	default:
-		eprintk("kgdbts: ERROR failed sstep put emulation\n");
+		WARN(1, KERN_ERR "kgdbts: ERROR failed sstep put emulation\n");
  	}

  	/* Continue on the same test line until emulation is complete */
@@ -763,7 +759,7 @@ static int run_simple_test(int is_get_char, int chr)
  		}

  		if (get_buf[get_buf_cnt] == '\0') {
-			eprintk("kgdbts: ERROR GET: EOB on '%s' at %i\n",
+			WARN(1, KERN_ERR "kgdbts: ERROR GET: EOB on '%s' at %i\n",
  			   ts.name, ts.idx);
  			get_buf_cnt = 0;
  			fill_get_buf("D");
@@ -778,13 +774,13 @@ static int run_simple_test(int is_get_char, int chr)
  	 */
  	if (ts.tst[ts.idx].get[0] == '\0' && ts.tst[ts.idx].put[0] == '\0' &&
  	    !ts.tst[ts.idx].get_handler) {
-		eprintk("kgdbts: ERROR: beyond end of test on"
+		WARN(1, KERN_ERR "kgdbts: ERROR: beyond end of test on"
  			   " '%s' line %i\n", ts.name, ts.idx);
  		return 0;
  	}

  	if (put_buf_cnt >= BUFMAX) {
-		eprintk("kgdbts: ERROR: put buffer overflow on"
+		WARN(1, KERN_ERR "kgdbts: ERROR: put buffer overflow on"
  			   " '%s' line %i\n", ts.name, ts.idx);
  		put_buf_cnt = 0;
  		return 0;
@@ -799,7 +795,7 @@ static int run_simple_test(int is_get_char, int chr)
  	/* End of packet == #XX so look for the '#' */
  	if (put_buf_cnt > 3 && put_buf[put_buf_cnt - 3] == '#') {
  		if (put_buf_cnt >= BUFMAX) {
-			eprintk("kgdbts: ERROR: put buffer overflow on"
+			WARN(1, KERN_ERR "kgdbts: ERROR: put buffer overflow on"
  				" '%s' line %i\n", ts.name, ts.idx);
  			put_buf_cnt = 0;
  			return 0;
@@ -808,7 +804,7 @@ static int run_simple_test(int is_get_char, int chr)
  		v2printk("put%i: %s\n", ts.idx, put_buf);
  		/* Trigger check here */
  		if (ts.validate_put && ts.validate_put(put_buf)) {
-			eprintk("kgdbts: ERROR PUT: end of test "
+			WARN(1, KERN_ERR "kgdbts: ERROR PUT: end of test "
  			   "buffer on '%s' line %i expected %s got %s\n",
  			   ts.name, ts.idx, ts.tst[ts.idx].put, put_buf);
  		}
@@ -872,7 +868,7 @@ static void run_breakpoint_test(int is_hw_breakpoint)
  	if (test_complete)
  		return;

-	eprintk("kgdbts: ERROR %s test failed\n", ts.name);
+	WARN(1, KERN_ERR "kgdbts: ERROR %s test failed\n", ts.name);
  	if (is_hw_breakpoint)
  		hwbreaks_ok = 0;
  }
@@ -893,7 +889,7 @@ static void run_hw_break_test(int is_write_test)
  	hw_break_val_access();
  	if (is_write_test) {
  		if (test_complete == 2) {
-			eprintk("kgdbts: ERROR %s broke on access\n",
+			WARN(1, KERN_ERR "kgdbts: ERROR %s broke on access\n",
  				ts.name);
  			hwbreaks_ok = 0;
  		}
@@ -904,7 +900,7 @@ static void run_hw_break_test(int is_write_test)
  	if (test_complete == 1)
  		return;

-	eprintk("kgdbts: ERROR %s test failed\n", ts.name);
+	WARN(1, KERN_ERR "kgdbts: ERROR %s test failed\n", ts.name);
  	hwbreaks_ok = 0;
  }

@@ -922,12 +918,12 @@ static void run_nmi_sleep_test(int nmi_sleep)
  	touch_nmi_watchdog();
  	local_irq_restore(flags);
  	if (test_complete != 2)
-		eprintk("kgdbts: ERROR nmi_test did not hit nmi\n");
+		WARN(1, KERN_ERR "kgdbts: ERROR nmi_test did not hit nmi\n");
  	kgdb_breakpoint();
  	if (test_complete == 1)
  		return;

-	eprintk("kgdbts: ERROR %s test failed\n", ts.name);
+	WARN(1, KERN_ERR "kgdbts: ERROR %s test failed\n", ts.name);
  }

  static void run_bad_read_test(void)
