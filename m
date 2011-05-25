Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756487Ab1EYLyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 07:54:52 -0400
Received: from www.linutronix.de ([62.245.132.108]:48806 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754163Ab1EYLyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 07:54:47 -0400
Date: Wed, 25 May 2011 13:54:42 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        John Stultz <johnstul@us.ibm.com>, David Miller <davem@davemloft.net>
Subject: [GIT pull] timers/ptp for 2.6.40^Wnext release
Message-ID: <alpine.LFD.2.02.1105251348550.3078@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-ptp-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/linux-2.6-tip.git timers-ptp-for-linus

The patches which touch code outside of drivers/ptp have been acked by
the relevant maintainers. Patches got applied late because all
involved folks expected someone else to pick them up :)

Thanks,

	tglx

------------------>
John Stultz (1):
      ptp: Fix dp83640 build warning when building statically

Richard Cochran (4):
      ptp: Added a brand new class driver for ptp clocks.
      ptp: Added a clock that uses the eTSEC found on the MPC85xx.
      ptp: Added a clock driver for the IXP46x.
      ptp: Added a clock driver for the National Semiconductor PHYTER.


 Documentation/ABI/testing/sysfs-ptp                |   98 ++
 .../devicetree/bindings/net/fsl-tsec-phy.txt       |   54 +
 Documentation/ptp/ptp.txt                          |   89 ++
 Documentation/ptp/testptp.c                        |  381 +++++++
 Documentation/ptp/testptp.mk                       |   33 +
 arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h      |   78 ++
 arch/powerpc/boot/dts/mpc8313erdb.dts              |   13 +
 arch/powerpc/boot/dts/mpc8572ds.dts                |   13 +
 arch/powerpc/boot/dts/p2020ds.dts                  |   13 +
 arch/powerpc/boot/dts/p2020rdb.dts                 |   13 +
 drivers/Kconfig                                    |    2 +
 drivers/Makefile                                   |    1 +
 drivers/net/Makefile                               |    1 +
 drivers/net/arm/ixp4xx_eth.c                       |  195 ++++-
 drivers/net/gianfar_ptp.c                          |  588 +++++++++++
 drivers/net/phy/Makefile                           |    1 +
 drivers/net/phy/dp83640.c                          | 1100 ++++++++++++++++++++
 drivers/net/phy/dp83640_reg.h                      |  267 +++++
 drivers/ptp/Kconfig                                |   75 ++
 drivers/ptp/Makefile                               |    7 +
 drivers/ptp/ptp_chardev.c                          |  159 +++
 drivers/ptp/ptp_clock.c                            |  343 ++++++
 drivers/ptp/ptp_ixp46x.c                           |  332 ++++++
 drivers/ptp/ptp_private.h                          |   92 ++
 drivers/ptp/ptp_sysfs.c                            |  230 ++++
 include/linux/Kbuild                               |    1 +
 include/linux/ptp_classify.h                       |    7 +
 include/linux/ptp_clock.h                          |   84 ++
 include/linux/ptp_clock_kernel.h                   |  139 +++
 29 files changed, 4406 insertions(+), 3 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-ptp
 create mode 100644 Documentation/ptp/ptp.txt
 create mode 100644 Documentation/ptp/testptp.c
 create mode 100644 Documentation/ptp/testptp.mk
 create mode 100644 arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h
 create mode 100644 drivers/net/gianfar_ptp.c
 create mode 100644 drivers/net/phy/dp83640.c
 create mode 100644 drivers/net/phy/dp83640_reg.h
 create mode 100644 drivers/ptp/Kconfig
 create mode 100644 drivers/ptp/Makefile
 create mode 100644 drivers/ptp/ptp_chardev.c
 create mode 100644 drivers/ptp/ptp_clock.c
 create mode 100644 drivers/ptp/ptp_ixp46x.c
 create mode 100644 drivers/ptp/ptp_private.h
 create mode 100644 drivers/ptp/ptp_sysfs.c
 create mode 100644 include/linux/ptp_clock.h
 create mode 100644 include/linux/ptp_clock_kernel.h

diff --git a/Documentation/ABI/testing/sysfs-ptp b/Documentation/ABI/testing/sysfs-ptp
new file mode 100644
index 0000000..d40d2b5
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-ptp
@@ -0,0 +1,98 @@
+What:		/sys/class/ptp/
+Date:		September 2010
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		This directory contains files and directories
+		providing a standardized interface to the ancillary
+		features of PTP hardware clocks.
+
+What:		/sys/class/ptp/ptpN/
+Date:		September 2010
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		This directory contains the attributes of the Nth PTP
+		hardware clock registered into the PTP class driver
+		subsystem.
+
+What:		/sys/class/ptp/ptpN/clock_name
+Date:		September 2010
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		This file contains the name of the PTP hardware clock
+		as a human readable string.
+
+What:		/sys/class/ptp/ptpN/max_adjustment
+Date:		September 2010
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		This file contains the PTP hardware clock's maximum
+		frequency adjustment value (a positive integer) in
+		parts per billion.
+
+What:		/sys/class/ptp/ptpN/n_alarms
+Date:		September 2010
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		This file contains the number of periodic or one shot
+		alarms offer by the PTP hardware clock.
+
+What:		/sys/class/ptp/ptpN/n_external_timestamps
+Date:		September 2010
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		This file contains the number of external timestamp
+		channels offered by the PTP hardware clock.
+
+What:		/sys/class/ptp/ptpN/n_periodic_outputs
+Date:		September 2010
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		This file contains the number of programmable periodic
+		output channels offered by the PTP hardware clock.
+
+What:		/sys/class/ptp/ptpN/pps_avaiable
+Date:		September 2010
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		This file indicates whether the PTP hardware clock
+		supports a Pulse Per Second to the host CPU. Reading
+		"1" means that the PPS is supported, while "0" means
+		not supported.
+
+What:		/sys/class/ptp/ptpN/extts_enable
+Date:		September 2010
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		This write-only file enables or disables external
+		timestamps. To enable external timestamps, write the
+		channel index followed by a "1" into the file.
+		To disable external timestamps, write the channel
+		index followed by a "0" into the file.
+
+What:		/sys/class/ptp/ptpN/fifo
+Date:		September 2010
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		This file provides timestamps on external events, in
+		the form of three integers: channel index, seconds,
+		and nanoseconds.
+
+What:		/sys/class/ptp/ptpN/period
+Date:		September 2010
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		This write-only file enables or disables periodic
+		outputs. To enable a periodic output, write five
+		integers into the file: channel index, start time
+		seconds, start time nanoseconds, period seconds, and
+		period nanoseconds. To disable a periodic output, set
+		all the seconds and nanoseconds values to zero.
+
+What:		/sys/class/ptp/ptpN/pps_enable
+Date:		September 2010
+Contact:	Richard Cochran <richardcochran@gmail.com>
+Description:
+		This write-only file enables or disables delivery of
+		PPS events to the Linux PPS subsystem. To enable PPS
+		events, write a "1" into the file. To disable events,
+		write a "0" into the file.
diff --git a/Documentation/devicetree/bindings/net/fsl-tsec-phy.txt b/Documentation/devicetree/bindings/net/fsl-tsec-phy.txt
index edb7ae1..2c6be03 100644
--- a/Documentation/devicetree/bindings/net/fsl-tsec-phy.txt
+++ b/Documentation/devicetree/bindings/net/fsl-tsec-phy.txt
@@ -74,3 +74,57 @@ Example:
 		interrupt-parent = <&mpic>;
 		phy-handle = <&phy0>
 	};
+
+* Gianfar PTP clock nodes
+
+General Properties:
+
+  - compatible   Should be "fsl,etsec-ptp"
+  - reg          Offset and length of the register set for the device
+  - interrupts   There should be at least two interrupts. Some devices
+                 have as many as four PTP related interrupts.
+
+Clock Properties:
+
+  - fsl,tclk-period  Timer reference clock period in nanoseconds.
+  - fsl,tmr-prsc     Prescaler, divides the output clock.
+  - fsl,tmr-add      Frequency compensation value.
+  - fsl,tmr-fiper1   Fixed interval period pulse generator.
+  - fsl,tmr-fiper2   Fixed interval period pulse generator.
+  - fsl,max-adj      Maximum frequency adjustment in parts per billion.
+
+  These properties set the operational parameters for the PTP
+  clock. You must choose these carefully for the clock to work right.
+  Here is how to figure good values:
+
+  TimerOsc     = system clock               MHz
+  tclk_period  = desired clock period       nanoseconds
+  NominalFreq  = 1000 / tclk_period         MHz
+  FreqDivRatio = TimerOsc / NominalFreq     (must be greater that 1.0)
+  tmr_add      = ceil(2^32 / FreqDivRatio)
+  OutputClock  = NominalFreq / tmr_prsc     MHz
+  PulseWidth   = 1 / OutputClock            microseconds
+  FiperFreq1   = desired frequency in Hz
+  FiperDiv1    = 1000000 * OutputClock / FiperFreq1
+  tmr_fiper1   = tmr_prsc * tclk_period * FiperDiv1 - tclk_period
+  max_adj      = 1000000000 * (FreqDivRatio - 1.0) - 1
+
+  The calculation for tmr_fiper2 is the same as for tmr_fiper1. The
+  driver expects that tmr_fiper1 will be correctly set to produce a 1
+  Pulse Per Second (PPS) signal, since this will be offered to the PPS
+  subsystem to synchronize the Linux clock.
+
+Example:
+
+	ptp_clock@24E00 {
+		compatible = "fsl,etsec-ptp";
+		reg = <0x24E00 0xB0>;
+		interrupts = <12 0x8 13 0x8>;
+		interrupt-parent = < &ipic >;
+		fsl,tclk-period = <10>;
+		fsl,tmr-prsc    = <100>;
+		fsl,tmr-add     = <0x999999A4>;
+		fsl,tmr-fiper1  = <0x3B9AC9F6>;
+		fsl,tmr-fiper2  = <0x00018696>;
+		fsl,max-adj     = <659999998>;
+	};
diff --git a/Documentation/ptp/ptp.txt b/Documentation/ptp/ptp.txt
new file mode 100644
index 0000000..ae8fef8
--- /dev/null
+++ b/Documentation/ptp/ptp.txt
@@ -0,0 +1,89 @@
+
+* PTP hardware clock infrastructure for Linux
+
+  This patch set introduces support for IEEE 1588 PTP clocks in
+  Linux. Together with the SO_TIMESTAMPING socket options, this
+  presents a standardized method for developing PTP user space
+  programs, synchronizing Linux with external clocks, and using the
+  ancillary features of PTP hardware clocks.
+
+  A new class driver exports a kernel interface for specific clock
+  drivers and a user space interface. The infrastructure supports a
+  complete set of PTP hardware clock functionality.
+
+  + Basic clock operations
+    - Set time
+    - Get time
+    - Shift the clock by a given offset atomically
+    - Adjust clock frequency
+
+  + Ancillary clock features
+    - One short or periodic alarms, with signal delivery to user program
+    - Time stamp external events
+    - Period output signals configurable from user space
+    - Synchronization of the Linux system time via the PPS subsystem
+
+** PTP hardware clock kernel API
+
+   A PTP clock driver registers itself with the class driver. The
+   class driver handles all of the dealings with user space. The
+   author of a clock driver need only implement the details of
+   programming the clock hardware. The clock driver notifies the class
+   driver of asynchronous events (alarms and external time stamps) via
+   a simple message passing interface.
+
+   The class driver supports multiple PTP clock drivers. In normal use
+   cases, only one PTP clock is needed. However, for testing and
+   development, it can be useful to have more than one clock in a
+   single system, in order to allow performance comparisons.
+
+** PTP hardware clock user space API
+
+   The class driver also creates a character device for each
+   registered clock. User space can use an open file descriptor from
+   the character device as a POSIX clock id and may call
+   clock_gettime, clock_settime, and clock_adjtime.  These calls
+   implement the basic clock operations.
+
+   User space programs may control the clock using standardized
+   ioctls. A program may query, enable, configure, and disable the
+   ancillary clock features. User space can receive time stamped
+   events via blocking read() and poll(). One shot and periodic
+   signals may be configured via the POSIX timer_settime() system
+   call.
+
+** Writing clock drivers
+
+   Clock drivers include include/linux/ptp_clock_kernel.h and register
+   themselves by presenting a 'struct ptp_clock_info' to the
+   registration method. Clock drivers must implement all of the
+   functions in the interface. If a clock does not offer a particular
+   ancillary feature, then the driver should just return -EOPNOTSUPP
+   from those functions.
+
+   Drivers must ensure that all of the methods in interface are
+   reentrant. Since most hardware implementations treat the time value
+   as a 64 bit integer accessed as two 32 bit registers, drivers
+   should use spin_lock_irqsave/spin_unlock_irqrestore to protect
+   against concurrent access. This locking cannot be accomplished in
+   class driver, since the lock may also be needed by the clock
+   driver's interrupt service routine.
+
+** Supported hardware
+
+   + Freescale eTSEC gianfar
+     - 2 Time stamp external triggers, programmable polarity (opt. interrupt)
+     - 2 Alarm registers (optional interrupt)
+     - 3 Periodic signals (optional interrupt)
+
+   + National DP83640
+     - 6 GPIOs programmable as inputs or outputs
+     - 6 GPIOs with dedicated functions (LED/JTAG/clock) can also be
+       used as general inputs or outputs
+     - GPIO inputs can time stamp external triggers
+     - GPIO outputs can produce periodic signals
+     - 1 interrupt pin
+
+   + Intel IXP465
+     - Auxiliary Slave/Master Mode Snapshot (optional interrupt)
+     - Target Time (optional interrupt)
diff --git a/Documentation/ptp/testptp.c b/Documentation/ptp/testptp.c
new file mode 100644
index 0000000..f59ded0
--- /dev/null
+++ b/Documentation/ptp/testptp.c
@@ -0,0 +1,381 @@
+/*
+ * PTP 1588 clock support - User space test program
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <errno.h>
+#include <fcntl.h>
+#include <math.h>
+#include <signal.h>
+#include <stdio.h>
+#include <stdlib.h>
+#include <string.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <sys/time.h>
+#include <sys/timex.h>
+#include <sys/types.h>
+#include <time.h>
+#include <unistd.h>
+
+#include <linux/ptp_clock.h>
+
+#define DEVICE "/dev/ptp0"
+
+#ifndef ADJ_SETOFFSET
+#define ADJ_SETOFFSET 0x0100
+#endif
+
+#ifndef CLOCK_INVALID
+#define CLOCK_INVALID -1
+#endif
+
+/* When glibc offers the syscall, this will go away. */
+#include <sys/syscall.h>
+static int clock_adjtime(clockid_t id, struct timex *tx)
+{
+	return syscall(__NR_clock_adjtime, id, tx);
+}
+
+static clockid_t get_clockid(int fd)
+{
+#define CLOCKFD 3
+#define FD_TO_CLOCKID(fd)	((~(clockid_t) (fd) << 3) | CLOCKFD)
+
+	return FD_TO_CLOCKID(fd);
+}
+
+static void handle_alarm(int s)
+{
+	printf("received signal %d\n", s);
+}
+
+static int install_handler(int signum, void (*handler)(int))
+{
+	struct sigaction action;
+	sigset_t mask;
+
+	/* Unblock the signal. */
+	sigemptyset(&mask);
+	sigaddset(&mask, signum);
+	sigprocmask(SIG_UNBLOCK, &mask, NULL);
+
+	/* Install the signal handler. */
+	action.sa_handler = handler;
+	action.sa_flags = 0;
+	sigemptyset(&action.sa_mask);
+	sigaction(signum, &action, NULL);
+
+	return 0;
+}
+
+static long ppb_to_scaled_ppm(int ppb)
+{
+	/*
+	 * The 'freq' field in the 'struct timex' is in parts per
+	 * million, but with a 16 bit binary fractional field.
+	 * Instead of calculating either one of
+	 *
+	 *    scaled_ppm = (ppb / 1000) << 16  [1]
+	 *    scaled_ppm = (ppb << 16) / 1000  [2]
+	 *
+	 * we simply use double precision math, in order to avoid the
+	 * truncation in [1] and the possible overflow in [2].
+	 */
+	return (long) (ppb * 65.536);
+}
+
+static void usage(char *progname)
+{
+	fprintf(stderr,
+		"usage: %s [options]\n"
+		" -a val     request a one-shot alarm after 'val' seconds\n"
+		" -A val     request a periodic alarm every 'val' seconds\n"
+		" -c         query the ptp clock's capabilities\n"
+		" -d name    device to open\n"
+		" -e val     read 'val' external time stamp events\n"
+		" -f val     adjust the ptp clock frequency by 'val' ppb\n"
+		" -g         get the ptp clock time\n"
+		" -h         prints this message\n"
+		" -p val     enable output with a period of 'val' nanoseconds\n"
+		" -P val     enable or disable (val=1|0) the system clock PPS\n"
+		" -s         set the ptp clock time from the system time\n"
+		" -S         set the system time from the ptp clock time\n"
+		" -t val     shift the ptp clock time by 'val' seconds\n",
+		progname);
+}
+
+int main(int argc, char *argv[])
+{
+	struct ptp_clock_caps caps;
+	struct ptp_extts_event event;
+	struct ptp_extts_request extts_request;
+	struct ptp_perout_request perout_request;
+	struct timespec ts;
+	struct timex tx;
+
+	static timer_t timerid;
+	struct itimerspec timeout;
+	struct sigevent sigevent;
+
+	char *progname;
+	int c, cnt, fd;
+
+	char *device = DEVICE;
+	clockid_t clkid;
+	int adjfreq = 0x7fffffff;
+	int adjtime = 0;
+	int capabilities = 0;
+	int extts = 0;
+	int gettime = 0;
+	int oneshot = 0;
+	int periodic = 0;
+	int perout = -1;
+	int pps = -1;
+	int settime = 0;
+
+	progname = strrchr(argv[0], '/');
+	progname = progname ? 1+progname : argv[0];
+	while (EOF != (c = getopt(argc, argv, "a:A:cd:e:f:ghp:P:sSt:v"))) {
+		switch (c) {
+		case 'a':
+			oneshot = atoi(optarg);
+			break;
+		case 'A':
+			periodic = atoi(optarg);
+			break;
+		case 'c':
+			capabilities = 1;
+			break;
+		case 'd':
+			device = optarg;
+			break;
+		case 'e':
+			extts = atoi(optarg);
+			break;
+		case 'f':
+			adjfreq = atoi(optarg);
+			break;
+		case 'g':
+			gettime = 1;
+			break;
+		case 'p':
+			perout = atoi(optarg);
+			break;
+		case 'P':
+			pps = atoi(optarg);
+			break;
+		case 's':
+			settime = 1;
+			break;
+		case 'S':
+			settime = 2;
+			break;
+		case 't':
+			adjtime = atoi(optarg);
+			break;
+		case 'h':
+			usage(progname);
+			return 0;
+		case '?':
+		default:
+			usage(progname);
+			return -1;
+		}
+	}
+
+	fd = open(device, O_RDWR);
+	if (fd < 0) {
+		fprintf(stderr, "opening %s: %s\n", device, strerror(errno));
+		return -1;
+	}
+
+	clkid = get_clockid(fd);
+	if (CLOCK_INVALID == clkid) {
+		fprintf(stderr, "failed to read clock id\n");
+		return -1;
+	}
+
+	if (capabilities) {
+		if (ioctl(fd, PTP_CLOCK_GETCAPS, &caps)) {
+			perror("PTP_CLOCK_GETCAPS");
+		} else {
+			printf("capabilities:\n"
+			       "  %d maximum frequency adjustment (ppb)\n"
+			       "  %d programmable alarms\n"
+			       "  %d external time stamp channels\n"
+			       "  %d programmable periodic signals\n"
+			       "  %d pulse per second\n",
+			       caps.max_adj,
+			       caps.n_alarm,
+			       caps.n_ext_ts,
+			       caps.n_per_out,
+			       caps.pps);
+		}
+	}
+
+	if (0x7fffffff != adjfreq) {
+		memset(&tx, 0, sizeof(tx));
+		tx.modes = ADJ_FREQUENCY;
+		tx.freq = ppb_to_scaled_ppm(adjfreq);
+		if (clock_adjtime(clkid, &tx)) {
+			perror("clock_adjtime");
+		} else {
+			puts("frequency adjustment okay");
+		}
+	}
+
+	if (adjtime) {
+		memset(&tx, 0, sizeof(tx));
+		tx.modes = ADJ_SETOFFSET;
+		tx.time.tv_sec = adjtime;
+		tx.time.tv_usec = 0;
+		if (clock_adjtime(clkid, &tx) < 0) {
+			perror("clock_adjtime");
+		} else {
+			puts("time shift okay");
+		}
+	}
+
+	if (gettime) {
+		if (clock_gettime(clkid, &ts)) {
+			perror("clock_gettime");
+		} else {
+			printf("clock time: %ld.%09ld or %s",
+			       ts.tv_sec, ts.tv_nsec, ctime(&ts.tv_sec));
+		}
+	}
+
+	if (settime == 1) {
+		clock_gettime(CLOCK_REALTIME, &ts);
+		if (clock_settime(clkid, &ts)) {
+			perror("clock_settime");
+		} else {
+			puts("set time okay");
+		}
+	}
+
+	if (settime == 2) {
+		clock_gettime(clkid, &ts);
+		if (clock_settime(CLOCK_REALTIME, &ts)) {
+			perror("clock_settime");
+		} else {
+			puts("set time okay");
+		}
+	}
+
+	if (extts) {
+		memset(&extts_request, 0, sizeof(extts_request));
+		extts_request.index = 0;
+		extts_request.flags = PTP_ENABLE_FEATURE;
+		if (ioctl(fd, PTP_EXTTS_REQUEST, &extts_request)) {
+			perror("PTP_EXTTS_REQUEST");
+			extts = 0;
+		} else {
+			puts("external time stamp request okay");
+		}
+		for (; extts; extts--) {
+			cnt = read(fd, &event, sizeof(event));
+			if (cnt != sizeof(event)) {
+				perror("read");
+				break;
+			}
+			printf("event index %u at %lld.%09u\n", event.index,
+			       event.t.sec, event.t.nsec);
+			fflush(stdout);
+		}
+		/* Disable the feature again. */
+		extts_request.flags = 0;
+		if (ioctl(fd, PTP_EXTTS_REQUEST, &extts_request)) {
+			perror("PTP_EXTTS_REQUEST");
+		}
+	}
+
+	if (oneshot) {
+		install_handler(SIGALRM, handle_alarm);
+		/* Create a timer. */
+		sigevent.sigev_notify = SIGEV_SIGNAL;
+		sigevent.sigev_signo = SIGALRM;
+		if (timer_create(clkid, &sigevent, &timerid)) {
+			perror("timer_create");
+			return -1;
+		}
+		/* Start the timer. */
+		memset(&timeout, 0, sizeof(timeout));
+		timeout.it_value.tv_sec = oneshot;
+		if (timer_settime(timerid, 0, &timeout, NULL)) {
+			perror("timer_settime");
+			return -1;
+		}
+		pause();
+		timer_delete(timerid);
+	}
+
+	if (periodic) {
+		install_handler(SIGALRM, handle_alarm);
+		/* Create a timer. */
+		sigevent.sigev_notify = SIGEV_SIGNAL;
+		sigevent.sigev_signo = SIGALRM;
+		if (timer_create(clkid, &sigevent, &timerid)) {
+			perror("timer_create");
+			return -1;
+		}
+		/* Start the timer. */
+		memset(&timeout, 0, sizeof(timeout));
+		timeout.it_interval.tv_sec = periodic;
+		timeout.it_value.tv_sec = periodic;
+		if (timer_settime(timerid, 0, &timeout, NULL)) {
+			perror("timer_settime");
+			return -1;
+		}
+		while (1) {
+			pause();
+		}
+		timer_delete(timerid);
+	}
+
+	if (perout >= 0) {
+		if (clock_gettime(clkid, &ts)) {
+			perror("clock_gettime");
+			return -1;
+		}
+		memset(&perout_request, 0, sizeof(perout_request));
+		perout_request.index = 0;
+		perout_request.start.sec = ts.tv_sec + 2;
+		perout_request.start.nsec = 0;
+		perout_request.period.sec = 0;
+		perout_request.period.nsec = perout;
+		if (ioctl(fd, PTP_PEROUT_REQUEST, &perout_request)) {
+			perror("PTP_PEROUT_REQUEST");
+		} else {
+			puts("periodic output request okay");
+		}
+	}
+
+	if (pps != -1) {
+		int enable = pps ? 1 : 0;
+		if (ioctl(fd, PTP_ENABLE_PPS, enable)) {
+			perror("PTP_ENABLE_PPS");
+		} else {
+			puts("pps for system time request okay");
+		}
+	}
+
+	close(fd);
+	return 0;
+}
diff --git a/Documentation/ptp/testptp.mk b/Documentation/ptp/testptp.mk
new file mode 100644
index 0000000..4ef2d97
--- /dev/null
+++ b/Documentation/ptp/testptp.mk
@@ -0,0 +1,33 @@
+# PTP 1588 clock support - User space test program
+#
+# Copyright (C) 2010 OMICRON electronics GmbH
+#
+#  This program is free software; you can redistribute it and/or modify
+#  it under the terms of the GNU General Public License as published by
+#  the Free Software Foundation; either version 2 of the License, or
+#  (at your option) any later version.
+#
+#  This program is distributed in the hope that it will be useful,
+#  but WITHOUT ANY WARRANTY; without even the implied warranty of
+#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+#  GNU General Public License for more details.
+#
+#  You should have received a copy of the GNU General Public License
+#  along with this program; if not, write to the Free Software
+#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+CC        = $(CROSS_COMPILE)gcc
+INC       = -I$(KBUILD_OUTPUT)/usr/include
+CFLAGS    = -Wall $(INC)
+LDLIBS    = -lrt
+PROGS     = testptp
+
+all: $(PROGS)
+
+testptp: testptp.o
+
+clean:
+	rm -f testptp.o
+
+distclean: clean
+	rm -f $(PROGS)
diff --git a/arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h b/arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h
new file mode 100644
index 0000000..292d55e
--- /dev/null
+++ b/arch/arm/mach-ixp4xx/include/mach/ixp46x_ts.h
@@ -0,0 +1,78 @@
+/*
+ * PTP 1588 clock using the IXP46X
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _IXP46X_TS_H_
+#define _IXP46X_TS_H_
+
+#define DEFAULT_ADDEND 0xF0000029
+#define TICKS_NS_SHIFT 4
+
+struct ixp46x_channel_ctl {
+	u32 ch_control;  /* 0x40 Time Synchronization Channel Control */
+	u32 ch_event;    /* 0x44 Time Synchronization Channel Event */
+	u32 tx_snap_lo;  /* 0x48 Transmit Snapshot Low Register */
+	u32 tx_snap_hi;  /* 0x4C Transmit Snapshot High Register */
+	u32 rx_snap_lo;  /* 0x50 Receive Snapshot Low Register */
+	u32 rx_snap_hi;  /* 0x54 Receive Snapshot High Register */
+	u32 src_uuid_lo; /* 0x58 Source UUID0 Low Register */
+	u32 src_uuid_hi; /* 0x5C Sequence Identifier/Source UUID0 High */
+};
+
+struct ixp46x_ts_regs {
+	u32 control;     /* 0x00 Time Sync Control Register */
+	u32 event;       /* 0x04 Time Sync Event Register */
+	u32 addend;      /* 0x08 Time Sync Addend Register */
+	u32 accum;       /* 0x0C Time Sync Accumulator Register */
+	u32 test;        /* 0x10 Time Sync Test Register */
+	u32 unused;      /* 0x14 */
+	u32 rsystime_lo; /* 0x18 RawSystemTime_Low Register */
+	u32 rsystime_hi; /* 0x1C RawSystemTime_High Register */
+	u32 systime_lo;  /* 0x20 SystemTime_Low Register */
+	u32 systime_hi;  /* 0x24 SystemTime_High Register */
+	u32 trgt_lo;     /* 0x28 TargetTime_Low Register */
+	u32 trgt_hi;     /* 0x2C TargetTime_High Register */
+	u32 asms_lo;     /* 0x30 Auxiliary Slave Mode Snapshot Low  */
+	u32 asms_hi;     /* 0x34 Auxiliary Slave Mode Snapshot High */
+	u32 amms_lo;     /* 0x38 Auxiliary Master Mode Snapshot Low */
+	u32 amms_hi;     /* 0x3C Auxiliary Master Mode Snapshot High */
+
+	struct ixp46x_channel_ctl channel[3];
+};
+
+/* 0x00 Time Sync Control Register Bits */
+#define TSCR_AMM (1<<3)
+#define TSCR_ASM (1<<2)
+#define TSCR_TTM (1<<1)
+#define TSCR_RST (1<<0)
+
+/* 0x04 Time Sync Event Register Bits */
+#define TSER_SNM (1<<3)
+#define TSER_SNS (1<<2)
+#define TTIPEND  (1<<1)
+
+/* 0x40 Time Synchronization Channel Control Register Bits */
+#define MASTER_MODE   (1<<0)
+#define TIMESTAMP_ALL (1<<1)
+
+/* 0x44 Time Synchronization Channel Event Register Bits */
+#define TX_SNAPSHOT_LOCKED (1<<0)
+#define RX_SNAPSHOT_LOCKED (1<<1)
+
+#endif
diff --git a/arch/powerpc/boot/dts/mpc8313erdb.dts b/arch/powerpc/boot/dts/mpc8313erdb.dts
index 761faa7..ac1eb32 100644
--- a/arch/powerpc/boot/dts/mpc8313erdb.dts
+++ b/arch/powerpc/boot/dts/mpc8313erdb.dts
@@ -176,6 +176,19 @@
 			sleep = <&pmc 0x00300000>;
 		};
 
+		ptp_clock@24E00 {
+			compatible = "fsl,etsec-ptp";
+			reg = <0x24E00 0xB0>;
+			interrupts = <12 0x8 13 0x8>;
+			interrupt-parent = < &ipic >;
+			fsl,tclk-period = <10>;
+			fsl,tmr-prsc    = <100>;
+			fsl,tmr-add     = <0x999999A4>;
+			fsl,tmr-fiper1  = <0x3B9AC9F6>;
+			fsl,tmr-fiper2  = <0x00018696>;
+			fsl,max-adj     = <659999998>;
+		};
+
 		enet0: ethernet@24000 {
 			#address-cells = <1>;
 			#size-cells = <1>;
diff --git a/arch/powerpc/boot/dts/mpc8572ds.dts b/arch/powerpc/boot/dts/mpc8572ds.dts
index cafc128..f6c04d2 100644
--- a/arch/powerpc/boot/dts/mpc8572ds.dts
+++ b/arch/powerpc/boot/dts/mpc8572ds.dts
@@ -324,6 +324,19 @@
 			};
 		};
 
+		ptp_clock@24E00 {
+			compatible = "fsl,etsec-ptp";
+			reg = <0x24E00 0xB0>;
+			interrupts = <68 2 69 2 70 2 71 2>;
+			interrupt-parent = < &mpic >;
+			fsl,tclk-period = <5>;
+			fsl,tmr-prsc = <200>;
+			fsl,tmr-add = <0xAAAAAAAB>;
+			fsl,tmr-fiper1 = <0x3B9AC9FB>;
+			fsl,tmr-fiper2 = <0x3B9AC9FB>;
+			fsl,max-adj = <499999999>;
+		};
+
 		enet0: ethernet@24000 {
 			#address-cells = <1>;
 			#size-cells = <1>;
diff --git a/arch/powerpc/boot/dts/p2020ds.dts b/arch/powerpc/boot/dts/p2020ds.dts
index 2bcf368..dae4031 100644
--- a/arch/powerpc/boot/dts/p2020ds.dts
+++ b/arch/powerpc/boot/dts/p2020ds.dts
@@ -178,6 +178,19 @@
 
 		};
 
+		ptp_clock@24E00 {
+			compatible = "fsl,etsec-ptp";
+			reg = <0x24E00 0xB0>;
+			interrupts = <68 2 69 2 70 2>;
+			interrupt-parent = < &mpic >;
+			fsl,tclk-period = <5>;
+			fsl,tmr-prsc = <200>;
+			fsl,tmr-add = <0xCCCCCCCD>;
+			fsl,tmr-fiper1 = <0x3B9AC9FB>;
+			fsl,tmr-fiper2 = <0x0001869B>;
+			fsl,max-adj = <249999999>;
+		};
+
 		enet0: ethernet@24000 {
 			tbi-handle = <&tbi0>;
 			phy-handle = <&phy0>;
diff --git a/arch/powerpc/boot/dts/p2020rdb.dts b/arch/powerpc/boot/dts/p2020rdb.dts
index 3782a58..1d7a05f 100644
--- a/arch/powerpc/boot/dts/p2020rdb.dts
+++ b/arch/powerpc/boot/dts/p2020rdb.dts
@@ -224,6 +224,19 @@
 			status = "disabled";
 		};
 
+		ptp_clock@24E00 {
+			compatible = "fsl,etsec-ptp";
+			reg = <0x24E00 0xB0>;
+			interrupts = <68 2 69 2 70 2>;
+			interrupt-parent = < &mpic >;
+			fsl,tclk-period = <5>;
+			fsl,tmr-prsc = <200>;
+			fsl,tmr-add = <0xCCCCCCCD>;
+			fsl,tmr-fiper1 = <0x3B9AC9FB>;
+			fsl,tmr-fiper2 = <0x0001869B>;
+			fsl,max-adj = <249999999>;
+		};
+
 		enet0: ethernet@24000 {
 			fixed-link = <1 1 1000 0 0>;
 			phy-connection-type = "rgmii-id";
diff --git a/drivers/Kconfig b/drivers/Kconfig
index 61631ed..3bb154d 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -54,6 +54,8 @@ source "drivers/spi/Kconfig"
 
 source "drivers/pps/Kconfig"
 
+source "drivers/ptp/Kconfig"
+
 source "drivers/gpio/Kconfig"
 
 source "drivers/w1/Kconfig"
diff --git a/drivers/Makefile b/drivers/Makefile
index a29527f..3c29601 100644
--- a/drivers/Makefile
+++ b/drivers/Makefile
@@ -76,6 +76,7 @@ obj-$(CONFIG_I2O)		+= message/
 obj-$(CONFIG_RTC_LIB)		+= rtc/
 obj-y				+= i2c/ media/
 obj-$(CONFIG_PPS)		+= pps/
+obj-$(CONFIG_PTP_1588_CLOCK)	+= ptp/
 obj-$(CONFIG_W1)		+= w1/
 obj-$(CONFIG_POWER_SUPPLY)	+= power/
 obj-$(CONFIG_HWMON)		+= hwmon/
diff --git a/drivers/net/Makefile b/drivers/net/Makefile
index 209fbb7..776a478 100644
--- a/drivers/net/Makefile
+++ b/drivers/net/Makefile
@@ -31,6 +31,7 @@ obj-$(CONFIG_ATL2) += atlx/
 obj-$(CONFIG_ATL1E) += atl1e/
 obj-$(CONFIG_ATL1C) += atl1c/
 obj-$(CONFIG_GIANFAR) += gianfar_driver.o
+obj-$(CONFIG_PTP_1588_CLOCK_GIANFAR) += gianfar_ptp.o
 obj-$(CONFIG_TEHUTI) += tehuti.o
 obj-$(CONFIG_ENIC) += enic/
 obj-$(CONFIG_JME) += jme.o
diff --git a/drivers/net/arm/ixp4xx_eth.c b/drivers/net/arm/ixp4xx_eth.c
index 9eb9b98..de51e84 100644
--- a/drivers/net/arm/ixp4xx_eth.c
+++ b/drivers/net/arm/ixp4xx_eth.c
@@ -30,9 +30,12 @@
 #include <linux/etherdevice.h>
 #include <linux/io.h>
 #include <linux/kernel.h>
+#include <linux/net_tstamp.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/ptp_classify.h>
 #include <linux/slab.h>
+#include <mach/ixp46x_ts.h>
 #include <mach/npe.h>
 #include <mach/qmgr.h>
 
@@ -67,6 +70,10 @@
 #define RXFREE_QUEUE(port_id)	(NPE_ID(port_id) + 26)
 #define TXDONE_QUEUE		31
 
+#define PTP_SLAVE_MODE		1
+#define PTP_MASTER_MODE		2
+#define PORT2CHANNEL(p)		NPE_ID(p->id)
+
 /* TX Control Registers */
 #define TX_CNTRL0_TX_EN		0x01
 #define TX_CNTRL0_HALFDUPLEX	0x02
@@ -171,6 +178,8 @@ struct port {
 	int id;			/* logical port ID */
 	int speed, duplex;
 	u8 firmware[4];
+	int hwts_tx_en;
+	int hwts_rx_en;
 };
 
 /* NPE message structure */
@@ -246,6 +255,172 @@ static int ports_open;
 static struct port *npe_port_tab[MAX_NPES];
 static struct dma_pool *dma_pool;
 
+static struct sock_filter ptp_filter[] = {
+	PTP_FILTER
+};
+
+static int ixp_ptp_match(struct sk_buff *skb, u16 uid_hi, u32 uid_lo, u16 seqid)
+{
+	u8 *data = skb->data;
+	unsigned int offset;
+	u16 *hi, *id;
+	u32 lo;
+
+	if (sk_run_filter(skb, ptp_filter) != PTP_CLASS_V1_IPV4)
+		return 0;
+
+	offset = ETH_HLEN + IPV4_HLEN(data) + UDP_HLEN;
+
+	if (skb->len < offset + OFF_PTP_SEQUENCE_ID + sizeof(seqid))
+		return 0;
+
+	hi = (u16 *)(data + offset + OFF_PTP_SOURCE_UUID);
+	id = (u16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
+
+	memcpy(&lo, &hi[1], sizeof(lo));
+
+	return (uid_hi == ntohs(*hi) &&
+		uid_lo == ntohl(lo) &&
+		seqid  == ntohs(*id));
+}
+
+static void ixp_rx_timestamp(struct port *port, struct sk_buff *skb)
+{
+	struct skb_shared_hwtstamps *shhwtstamps;
+	struct ixp46x_ts_regs *regs;
+	u64 ns;
+	u32 ch, hi, lo, val;
+	u16 uid, seq;
+
+	if (!port->hwts_rx_en)
+		return;
+
+	ch = PORT2CHANNEL(port);
+
+	regs = (struct ixp46x_ts_regs __iomem *) IXP4XX_TIMESYNC_BASE_VIRT;
+
+	val = __raw_readl(&regs->channel[ch].ch_event);
+
+	if (!(val & RX_SNAPSHOT_LOCKED))
+		return;
+
+	lo = __raw_readl(&regs->channel[ch].src_uuid_lo);
+	hi = __raw_readl(&regs->channel[ch].src_uuid_hi);
+
+	uid = hi & 0xffff;
+	seq = (hi >> 16) & 0xffff;
+
+	if (!ixp_ptp_match(skb, htons(uid), htonl(lo), htons(seq)))
+		goto out;
+
+	lo = __raw_readl(&regs->channel[ch].rx_snap_lo);
+	hi = __raw_readl(&regs->channel[ch].rx_snap_hi);
+	ns = ((u64) hi) << 32;
+	ns |= lo;
+	ns <<= TICKS_NS_SHIFT;
+
+	shhwtstamps = skb_hwtstamps(skb);
+	memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+	shhwtstamps->hwtstamp = ns_to_ktime(ns);
+out:
+	__raw_writel(RX_SNAPSHOT_LOCKED, &regs->channel[ch].ch_event);
+}
+
+static void ixp_tx_timestamp(struct port *port, struct sk_buff *skb)
+{
+	struct skb_shared_hwtstamps shhwtstamps;
+	struct ixp46x_ts_regs *regs;
+	struct skb_shared_info *shtx;
+	u64 ns;
+	u32 ch, cnt, hi, lo, val;
+
+	shtx = skb_shinfo(skb);
+	if (unlikely(shtx->tx_flags & SKBTX_HW_TSTAMP && port->hwts_tx_en))
+		shtx->tx_flags |= SKBTX_IN_PROGRESS;
+	else
+		return;
+
+	ch = PORT2CHANNEL(port);
+
+	regs = (struct ixp46x_ts_regs __iomem *) IXP4XX_TIMESYNC_BASE_VIRT;
+
+	/*
+	 * This really stinks, but we have to poll for the Tx time stamp.
+	 * Usually, the time stamp is ready after 4 to 6 microseconds.
+	 */
+	for (cnt = 0; cnt < 100; cnt++) {
+		val = __raw_readl(&regs->channel[ch].ch_event);
+		if (val & TX_SNAPSHOT_LOCKED)
+			break;
+		udelay(1);
+	}
+	if (!(val & TX_SNAPSHOT_LOCKED)) {
+		shtx->tx_flags &= ~SKBTX_IN_PROGRESS;
+		return;
+	}
+
+	lo = __raw_readl(&regs->channel[ch].tx_snap_lo);
+	hi = __raw_readl(&regs->channel[ch].tx_snap_hi);
+	ns = ((u64) hi) << 32;
+	ns |= lo;
+	ns <<= TICKS_NS_SHIFT;
+
+	memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+	shhwtstamps.hwtstamp = ns_to_ktime(ns);
+	skb_tstamp_tx(skb, &shhwtstamps);
+
+	__raw_writel(TX_SNAPSHOT_LOCKED, &regs->channel[ch].ch_event);
+}
+
+static int hwtstamp_ioctl(struct net_device *netdev, struct ifreq *ifr, int cmd)
+{
+	struct hwtstamp_config cfg;
+	struct ixp46x_ts_regs *regs;
+	struct port *port = netdev_priv(netdev);
+	int ch;
+
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	if (cfg.flags) /* reserved for future extensions */
+		return -EINVAL;
+
+	ch = PORT2CHANNEL(port);
+	regs = (struct ixp46x_ts_regs __iomem *) IXP4XX_TIMESYNC_BASE_VIRT;
+
+	switch (cfg.tx_type) {
+	case HWTSTAMP_TX_OFF:
+		port->hwts_tx_en = 0;
+		break;
+	case HWTSTAMP_TX_ON:
+		port->hwts_tx_en = 1;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (cfg.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		port->hwts_rx_en = 0;
+		break;
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+		port->hwts_rx_en = PTP_SLAVE_MODE;
+		__raw_writel(0, &regs->channel[ch].ch_control);
+		break;
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+		port->hwts_rx_en = PTP_MASTER_MODE;
+		__raw_writel(MASTER_MODE, &regs->channel[ch].ch_control);
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	/* Clear out any old time stamps. */
+	__raw_writel(TX_SNAPSHOT_LOCKED | RX_SNAPSHOT_LOCKED,
+		     &regs->channel[ch].ch_event);
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
 
 static int ixp4xx_mdio_cmd(struct mii_bus *bus, int phy_id, int location,
 			   int write, u16 cmd)
@@ -573,6 +748,7 @@ static int eth_poll(struct napi_struct *napi, int budget)
 
 		debug_pkt(dev, "eth_poll", skb->data, skb->len);
 
+		ixp_rx_timestamp(port, skb);
 		skb->protocol = eth_type_trans(skb, dev);
 		dev->stats.rx_packets++;
 		dev->stats.rx_bytes += skb->len;
@@ -679,14 +855,12 @@ static int eth_xmit(struct sk_buff *skb, struct net_device *dev)
 		return NETDEV_TX_OK;
 	}
 	memcpy_swab32(mem, (u32 *)((int)skb->data & ~3), bytes / 4);
-	dev_kfree_skb(skb);
 #endif
 
 	phys = dma_map_single(&dev->dev, mem, bytes, DMA_TO_DEVICE);
 	if (dma_mapping_error(&dev->dev, phys)) {
-#ifdef __ARMEB__
 		dev_kfree_skb(skb);
-#else
+#ifndef __ARMEB__
 		kfree(mem);
 #endif
 		dev->stats.tx_dropped++;
@@ -728,6 +902,13 @@ static int eth_xmit(struct sk_buff *skb, struct net_device *dev)
 #if DEBUG_TX
 	printk(KERN_DEBUG "%s: eth_xmit end\n", dev->name);
 #endif
+
+	ixp_tx_timestamp(port, skb);
+	skb_tx_timestamp(skb);
+
+#ifndef __ARMEB__
+	dev_kfree_skb(skb);
+#endif
 	return NETDEV_TX_OK;
 }
 
@@ -783,6 +964,9 @@ static int eth_ioctl(struct net_device *dev, struct ifreq *req, int cmd)
 	if (!netif_running(dev))
 		return -EINVAL;
 
+	if (cpu_is_ixp46x() && cmd == SIOCSHWTSTAMP)
+		return hwtstamp_ioctl(dev, req, cmd);
+
 	return phy_mii_ioctl(port->phydev, req, cmd);
 }
 
@@ -1171,6 +1355,11 @@ static int __devinit eth_init_one(struct platform_device *pdev)
 	char phy_id[MII_BUS_ID_SIZE + 3];
 	int err;
 
+	if (ptp_filter_init(ptp_filter, ARRAY_SIZE(ptp_filter))) {
+		pr_err("ixp4xx_eth: bad ptp filter\n");
+		return -EINVAL;
+	}
+
 	if (!(dev = alloc_etherdev(sizeof(struct port))))
 		return -ENOMEM;
 
diff --git a/drivers/net/gianfar_ptp.c b/drivers/net/gianfar_ptp.c
new file mode 100644
index 0000000..d8e1753
--- /dev/null
+++ b/drivers/net/gianfar_ptp.c
@@ -0,0 +1,588 @@
+/*
+ * PTP 1588 clock using the eTSEC
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/device.h>
+#include <linux/hrtimer.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/of.h>
+#include <linux/of_platform.h>
+#include <linux/timex.h>
+#include <linux/io.h>
+
+#include <linux/ptp_clock_kernel.h>
+
+#include "gianfar.h"
+
+/*
+ * gianfar ptp registers
+ * Generated by regen.tcl on Thu May 13 01:38:57 PM CEST 2010
+ */
+struct gianfar_ptp_registers {
+	u32 tmr_ctrl;     /* Timer control register */
+	u32 tmr_tevent;   /* Timestamp event register */
+	u32 tmr_temask;   /* Timer event mask register */
+	u32 tmr_pevent;   /* Timestamp event register */
+	u32 tmr_pemask;   /* Timer event mask register */
+	u32 tmr_stat;     /* Timestamp status register */
+	u32 tmr_cnt_h;    /* Timer counter high register */
+	u32 tmr_cnt_l;    /* Timer counter low register */
+	u32 tmr_add;      /* Timer drift compensation addend register */
+	u32 tmr_acc;      /* Timer accumulator register */
+	u32 tmr_prsc;     /* Timer prescale */
+	u8  res1[4];
+	u32 tmroff_h;     /* Timer offset high */
+	u32 tmroff_l;     /* Timer offset low */
+	u8  res2[8];
+	u32 tmr_alarm1_h; /* Timer alarm 1 high register */
+	u32 tmr_alarm1_l; /* Timer alarm 1 high register */
+	u32 tmr_alarm2_h; /* Timer alarm 2 high register */
+	u32 tmr_alarm2_l; /* Timer alarm 2 high register */
+	u8  res3[48];
+	u32 tmr_fiper1;   /* Timer fixed period interval */
+	u32 tmr_fiper2;   /* Timer fixed period interval */
+	u32 tmr_fiper3;   /* Timer fixed period interval */
+	u8  res4[20];
+	u32 tmr_etts1_h;  /* Timestamp of general purpose external trigger */
+	u32 tmr_etts1_l;  /* Timestamp of general purpose external trigger */
+	u32 tmr_etts2_h;  /* Timestamp of general purpose external trigger */
+	u32 tmr_etts2_l;  /* Timestamp of general purpose external trigger */
+};
+
+/* Bit definitions for the TMR_CTRL register */
+#define ALM1P                 (1<<31) /* Alarm1 output polarity */
+#define ALM2P                 (1<<30) /* Alarm2 output polarity */
+#define FS                    (1<<28) /* FIPER start indication */
+#define PP1L                  (1<<27) /* Fiper1 pulse loopback mode enabled. */
+#define PP2L                  (1<<26) /* Fiper2 pulse loopback mode enabled. */
+#define TCLK_PERIOD_SHIFT     (16) /* 1588 timer reference clock period. */
+#define TCLK_PERIOD_MASK      (0x3ff)
+#define RTPE                  (1<<15) /* Record Tx Timestamp to PAL Enable. */
+#define FRD                   (1<<14) /* FIPER Realignment Disable */
+#define ESFDP                 (1<<11) /* External Tx/Rx SFD Polarity. */
+#define ESFDE                 (1<<10) /* External Tx/Rx SFD Enable. */
+#define ETEP2                 (1<<9) /* External trigger 2 edge polarity */
+#define ETEP1                 (1<<8) /* External trigger 1 edge polarity */
+#define COPH                  (1<<7) /* Generated clock output phase. */
+#define CIPH                  (1<<6) /* External oscillator input clock phase */
+#define TMSR                  (1<<5) /* Timer soft reset. */
+#define BYP                   (1<<3) /* Bypass drift compensated clock */
+#define TE                    (1<<2) /* 1588 timer enable. */
+#define CKSEL_SHIFT           (0)    /* 1588 Timer reference clock source */
+#define CKSEL_MASK            (0x3)
+
+/* Bit definitions for the TMR_TEVENT register */
+#define ETS2                  (1<<25) /* External trigger 2 timestamp sampled */
+#define ETS1                  (1<<24) /* External trigger 1 timestamp sampled */
+#define ALM2                  (1<<17) /* Current time = alarm time register 2 */
+#define ALM1                  (1<<16) /* Current time = alarm time register 1 */
+#define PP1                   (1<<7)  /* periodic pulse generated on FIPER1 */
+#define PP2                   (1<<6)  /* periodic pulse generated on FIPER2 */
+#define PP3                   (1<<5)  /* periodic pulse generated on FIPER3 */
+
+/* Bit definitions for the TMR_TEMASK register */
+#define ETS2EN                (1<<25) /* External trigger 2 timestamp enable */
+#define ETS1EN                (1<<24) /* External trigger 1 timestamp enable */
+#define ALM2EN                (1<<17) /* Timer ALM2 event enable */
+#define ALM1EN                (1<<16) /* Timer ALM1 event enable */
+#define PP1EN                 (1<<7) /* Periodic pulse event 1 enable */
+#define PP2EN                 (1<<6) /* Periodic pulse event 2 enable */
+
+/* Bit definitions for the TMR_PEVENT register */
+#define TXP2                  (1<<9) /* PTP transmitted timestamp im TXTS2 */
+#define TXP1                  (1<<8) /* PTP transmitted timestamp in TXTS1 */
+#define RXP                   (1<<0) /* PTP frame has been received */
+
+/* Bit definitions for the TMR_PEMASK register */
+#define TXP2EN                (1<<9) /* Transmit PTP packet event 2 enable */
+#define TXP1EN                (1<<8) /* Transmit PTP packet event 1 enable */
+#define RXPEN                 (1<<0) /* Receive PTP packet event enable */
+
+/* Bit definitions for the TMR_STAT register */
+#define STAT_VEC_SHIFT        (0) /* Timer general purpose status vector */
+#define STAT_VEC_MASK         (0x3f)
+
+/* Bit definitions for the TMR_PRSC register */
+#define PRSC_OCK_SHIFT        (0) /* Output clock division/prescale factor. */
+#define PRSC_OCK_MASK         (0xffff)
+
+
+#define DRIVER		"gianfar_ptp"
+#define DEFAULT_CKSEL	1
+#define N_ALARM		1 /* first alarm is used internally to reset fipers */
+#define N_EXT_TS	2
+#define REG_SIZE	sizeof(struct gianfar_ptp_registers)
+
+struct etsects {
+	struct gianfar_ptp_registers *regs;
+	spinlock_t lock; /* protects regs */
+	struct ptp_clock *clock;
+	struct ptp_clock_info caps;
+	struct resource *rsrc;
+	int irq;
+	u64 alarm_interval; /* for periodic alarm */
+	u64 alarm_value;
+	u32 tclk_period;  /* nanoseconds */
+	u32 tmr_prsc;
+	u32 tmr_add;
+	u32 cksel;
+	u32 tmr_fiper1;
+	u32 tmr_fiper2;
+};
+
+/*
+ * Register access functions
+ */
+
+/* Caller must hold etsects->lock. */
+static u64 tmr_cnt_read(struct etsects *etsects)
+{
+	u64 ns;
+	u32 lo, hi;
+
+	lo = gfar_read(&etsects->regs->tmr_cnt_l);
+	hi = gfar_read(&etsects->regs->tmr_cnt_h);
+	ns = ((u64) hi) << 32;
+	ns |= lo;
+	return ns;
+}
+
+/* Caller must hold etsects->lock. */
+static void tmr_cnt_write(struct etsects *etsects, u64 ns)
+{
+	u32 hi = ns >> 32;
+	u32 lo = ns & 0xffffffff;
+
+	gfar_write(&etsects->regs->tmr_cnt_l, lo);
+	gfar_write(&etsects->regs->tmr_cnt_h, hi);
+}
+
+/* Caller must hold etsects->lock. */
+static void set_alarm(struct etsects *etsects)
+{
+	u64 ns;
+	u32 lo, hi;
+
+	ns = tmr_cnt_read(etsects) + 1500000000ULL;
+	ns = div_u64(ns, 1000000000UL) * 1000000000ULL;
+	ns -= etsects->tclk_period;
+	hi = ns >> 32;
+	lo = ns & 0xffffffff;
+	gfar_write(&etsects->regs->tmr_alarm1_l, lo);
+	gfar_write(&etsects->regs->tmr_alarm1_h, hi);
+}
+
+/* Caller must hold etsects->lock. */
+static void set_fipers(struct etsects *etsects)
+{
+	u32 tmr_ctrl = gfar_read(&etsects->regs->tmr_ctrl);
+
+	gfar_write(&etsects->regs->tmr_ctrl,   tmr_ctrl & (~TE));
+	gfar_write(&etsects->regs->tmr_prsc,   etsects->tmr_prsc);
+	gfar_write(&etsects->regs->tmr_fiper1, etsects->tmr_fiper1);
+	gfar_write(&etsects->regs->tmr_fiper2, etsects->tmr_fiper2);
+	set_alarm(etsects);
+	gfar_write(&etsects->regs->tmr_ctrl,   tmr_ctrl|TE);
+}
+
+/*
+ * Interrupt service routine
+ */
+
+static irqreturn_t isr(int irq, void *priv)
+{
+	struct etsects *etsects = priv;
+	struct ptp_clock_event event;
+	u64 ns;
+	u32 ack = 0, lo, hi, mask, val;
+
+	val = gfar_read(&etsects->regs->tmr_tevent);
+
+	if (val & ETS1) {
+		ack |= ETS1;
+		hi = gfar_read(&etsects->regs->tmr_etts1_h);
+		lo = gfar_read(&etsects->regs->tmr_etts1_l);
+		event.type = PTP_CLOCK_EXTTS;
+		event.index = 0;
+		event.timestamp = ((u64) hi) << 32;
+		event.timestamp |= lo;
+		ptp_clock_event(etsects->clock, &event);
+	}
+
+	if (val & ETS2) {
+		ack |= ETS2;
+		hi = gfar_read(&etsects->regs->tmr_etts2_h);
+		lo = gfar_read(&etsects->regs->tmr_etts2_l);
+		event.type = PTP_CLOCK_EXTTS;
+		event.index = 1;
+		event.timestamp = ((u64) hi) << 32;
+		event.timestamp |= lo;
+		ptp_clock_event(etsects->clock, &event);
+	}
+
+	if (val & ALM2) {
+		ack |= ALM2;
+		if (etsects->alarm_value) {
+			event.type = PTP_CLOCK_ALARM;
+			event.index = 0;
+			event.timestamp = etsects->alarm_value;
+			ptp_clock_event(etsects->clock, &event);
+		}
+		if (etsects->alarm_interval) {
+			ns = etsects->alarm_value + etsects->alarm_interval;
+			hi = ns >> 32;
+			lo = ns & 0xffffffff;
+			spin_lock(&etsects->lock);
+			gfar_write(&etsects->regs->tmr_alarm2_l, lo);
+			gfar_write(&etsects->regs->tmr_alarm2_h, hi);
+			spin_unlock(&etsects->lock);
+			etsects->alarm_value = ns;
+		} else {
+			gfar_write(&etsects->regs->tmr_tevent, ALM2);
+			spin_lock(&etsects->lock);
+			mask = gfar_read(&etsects->regs->tmr_temask);
+			mask &= ~ALM2EN;
+			gfar_write(&etsects->regs->tmr_temask, mask);
+			spin_unlock(&etsects->lock);
+			etsects->alarm_value = 0;
+			etsects->alarm_interval = 0;
+		}
+	}
+
+	if (val & PP1) {
+		ack |= PP1;
+		event.type = PTP_CLOCK_PPS;
+		ptp_clock_event(etsects->clock, &event);
+	}
+
+	if (ack) {
+		gfar_write(&etsects->regs->tmr_tevent, ack);
+		return IRQ_HANDLED;
+	} else
+		return IRQ_NONE;
+}
+
+/*
+ * PTP clock operations
+ */
+
+static int ptp_gianfar_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+{
+	u64 adj;
+	u32 diff, tmr_add;
+	int neg_adj = 0;
+	struct etsects *etsects = container_of(ptp, struct etsects, caps);
+
+	if (ppb < 0) {
+		neg_adj = 1;
+		ppb = -ppb;
+	}
+	tmr_add = etsects->tmr_add;
+	adj = tmr_add;
+	adj *= ppb;
+	diff = div_u64(adj, 1000000000ULL);
+
+	tmr_add = neg_adj ? tmr_add - diff : tmr_add + diff;
+
+	gfar_write(&etsects->regs->tmr_add, tmr_add);
+
+	return 0;
+}
+
+static int ptp_gianfar_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	s64 now;
+	unsigned long flags;
+	struct etsects *etsects = container_of(ptp, struct etsects, caps);
+
+	spin_lock_irqsave(&etsects->lock, flags);
+
+	now = tmr_cnt_read(etsects);
+	now += delta;
+	tmr_cnt_write(etsects, now);
+
+	spin_unlock_irqrestore(&etsects->lock, flags);
+
+	set_fipers(etsects);
+
+	return 0;
+}
+
+static int ptp_gianfar_gettime(struct ptp_clock_info *ptp, struct timespec *ts)
+{
+	u64 ns;
+	u32 remainder;
+	unsigned long flags;
+	struct etsects *etsects = container_of(ptp, struct etsects, caps);
+
+	spin_lock_irqsave(&etsects->lock, flags);
+
+	ns = tmr_cnt_read(etsects);
+
+	spin_unlock_irqrestore(&etsects->lock, flags);
+
+	ts->tv_sec = div_u64_rem(ns, 1000000000, &remainder);
+	ts->tv_nsec = remainder;
+	return 0;
+}
+
+static int ptp_gianfar_settime(struct ptp_clock_info *ptp,
+			       const struct timespec *ts)
+{
+	u64 ns;
+	unsigned long flags;
+	struct etsects *etsects = container_of(ptp, struct etsects, caps);
+
+	ns = ts->tv_sec * 1000000000ULL;
+	ns += ts->tv_nsec;
+
+	spin_lock_irqsave(&etsects->lock, flags);
+
+	tmr_cnt_write(etsects, ns);
+	set_fipers(etsects);
+
+	spin_unlock_irqrestore(&etsects->lock, flags);
+
+	return 0;
+}
+
+static int ptp_gianfar_enable(struct ptp_clock_info *ptp,
+			      struct ptp_clock_request *rq, int on)
+{
+	struct etsects *etsects = container_of(ptp, struct etsects, caps);
+	unsigned long flags;
+	u32 bit, mask;
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_EXTTS:
+		switch (rq->extts.index) {
+		case 0:
+			bit = ETS1EN;
+			break;
+		case 1:
+			bit = ETS2EN;
+			break;
+		default:
+			return -EINVAL;
+		}
+		spin_lock_irqsave(&etsects->lock, flags);
+		mask = gfar_read(&etsects->regs->tmr_temask);
+		if (on)
+			mask |= bit;
+		else
+			mask &= ~bit;
+		gfar_write(&etsects->regs->tmr_temask, mask);
+		spin_unlock_irqrestore(&etsects->lock, flags);
+		return 0;
+
+	case PTP_CLK_REQ_PPS:
+		spin_lock_irqsave(&etsects->lock, flags);
+		mask = gfar_read(&etsects->regs->tmr_temask);
+		if (on)
+			mask |= PP1EN;
+		else
+			mask &= ~PP1EN;
+		gfar_write(&etsects->regs->tmr_temask, mask);
+		spin_unlock_irqrestore(&etsects->lock, flags);
+		return 0;
+
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static struct ptp_clock_info ptp_gianfar_caps = {
+	.owner		= THIS_MODULE,
+	.name		= "gianfar clock",
+	.max_adj	= 512000,
+	.n_alarm	= N_ALARM,
+	.n_ext_ts	= N_EXT_TS,
+	.n_per_out	= 0,
+	.pps		= 1,
+	.adjfreq	= ptp_gianfar_adjfreq,
+	.adjtime	= ptp_gianfar_adjtime,
+	.gettime	= ptp_gianfar_gettime,
+	.settime	= ptp_gianfar_settime,
+	.enable		= ptp_gianfar_enable,
+};
+
+/* OF device tree */
+
+static int get_of_u32(struct device_node *node, char *str, u32 *val)
+{
+	int plen;
+	const u32 *prop = of_get_property(node, str, &plen);
+
+	if (!prop || plen != sizeof(*prop))
+		return -1;
+	*val = *prop;
+	return 0;
+}
+
+static int gianfar_ptp_probe(struct platform_device *dev)
+{
+	struct device_node *node = dev->dev.of_node;
+	struct etsects *etsects;
+	struct timespec now;
+	int err = -ENOMEM;
+	u32 tmr_ctrl;
+	unsigned long flags;
+
+	etsects = kzalloc(sizeof(*etsects), GFP_KERNEL);
+	if (!etsects)
+		goto no_memory;
+
+	err = -ENODEV;
+
+	etsects->caps = ptp_gianfar_caps;
+	etsects->cksel = DEFAULT_CKSEL;
+
+	if (get_of_u32(node, "fsl,tclk-period", &etsects->tclk_period) ||
+	    get_of_u32(node, "fsl,tmr-prsc", &etsects->tmr_prsc) ||
+	    get_of_u32(node, "fsl,tmr-add", &etsects->tmr_add) ||
+	    get_of_u32(node, "fsl,tmr-fiper1", &etsects->tmr_fiper1) ||
+	    get_of_u32(node, "fsl,tmr-fiper2", &etsects->tmr_fiper2) ||
+	    get_of_u32(node, "fsl,max-adj", &etsects->caps.max_adj)) {
+		pr_err("device tree node missing required elements\n");
+		goto no_node;
+	}
+
+	etsects->irq = platform_get_irq(dev, 0);
+
+	if (etsects->irq == NO_IRQ) {
+		pr_err("irq not in device tree\n");
+		goto no_node;
+	}
+	if (request_irq(etsects->irq, isr, 0, DRIVER, etsects)) {
+		pr_err("request_irq failed\n");
+		goto no_node;
+	}
+
+	etsects->rsrc = platform_get_resource(dev, IORESOURCE_MEM, 0);
+	if (!etsects->rsrc) {
+		pr_err("no resource\n");
+		goto no_resource;
+	}
+	if (request_resource(&ioport_resource, etsects->rsrc)) {
+		pr_err("resource busy\n");
+		goto no_resource;
+	}
+
+	spin_lock_init(&etsects->lock);
+
+	etsects->regs = ioremap(etsects->rsrc->start,
+				1 + etsects->rsrc->end - etsects->rsrc->start);
+	if (!etsects->regs) {
+		pr_err("ioremap ptp registers failed\n");
+		goto no_ioremap;
+	}
+	getnstimeofday(&now);
+	ptp_gianfar_settime(&etsects->caps, &now);
+
+	tmr_ctrl =
+	  (etsects->tclk_period & TCLK_PERIOD_MASK) << TCLK_PERIOD_SHIFT |
+	  (etsects->cksel & CKSEL_MASK) << CKSEL_SHIFT;
+
+	spin_lock_irqsave(&etsects->lock, flags);
+
+	gfar_write(&etsects->regs->tmr_ctrl,   tmr_ctrl);
+	gfar_write(&etsects->regs->tmr_add,    etsects->tmr_add);
+	gfar_write(&etsects->regs->tmr_prsc,   etsects->tmr_prsc);
+	gfar_write(&etsects->regs->tmr_fiper1, etsects->tmr_fiper1);
+	gfar_write(&etsects->regs->tmr_fiper2, etsects->tmr_fiper2);
+	set_alarm(etsects);
+	gfar_write(&etsects->regs->tmr_ctrl,   tmr_ctrl|FS|RTPE|TE);
+
+	spin_unlock_irqrestore(&etsects->lock, flags);
+
+	etsects->clock = ptp_clock_register(&etsects->caps);
+	if (IS_ERR(etsects->clock)) {
+		err = PTR_ERR(etsects->clock);
+		goto no_clock;
+	}
+
+	dev_set_drvdata(&dev->dev, etsects);
+
+	return 0;
+
+no_clock:
+no_ioremap:
+	release_resource(etsects->rsrc);
+no_resource:
+	free_irq(etsects->irq, etsects);
+no_node:
+	kfree(etsects);
+no_memory:
+	return err;
+}
+
+static int gianfar_ptp_remove(struct platform_device *dev)
+{
+	struct etsects *etsects = dev_get_drvdata(&dev->dev);
+
+	gfar_write(&etsects->regs->tmr_temask, 0);
+	gfar_write(&etsects->regs->tmr_ctrl,   0);
+
+	ptp_clock_unregister(etsects->clock);
+	iounmap(etsects->regs);
+	release_resource(etsects->rsrc);
+	free_irq(etsects->irq, etsects);
+	kfree(etsects);
+
+	return 0;
+}
+
+static struct of_device_id match_table[] = {
+	{ .compatible = "fsl,etsec-ptp" },
+	{},
+};
+
+static struct platform_driver gianfar_ptp_driver = {
+	.driver = {
+		.name		= "gianfar_ptp",
+		.of_match_table	= match_table,
+		.owner		= THIS_MODULE,
+	},
+	.probe       = gianfar_ptp_probe,
+	.remove      = gianfar_ptp_remove,
+};
+
+/* module operations */
+
+static int __init ptp_gianfar_init(void)
+{
+	return platform_driver_register(&gianfar_ptp_driver);
+}
+
+module_init(ptp_gianfar_init);
+
+static void __exit ptp_gianfar_exit(void)
+{
+	platform_driver_unregister(&gianfar_ptp_driver);
+}
+
+module_exit(ptp_gianfar_exit);
+
+MODULE_AUTHOR("Richard Cochran <richard.cochran@omicron.at>");
+MODULE_DESCRIPTION("PTP clock using the eTSEC");
+MODULE_LICENSE("GPL");
diff --git a/drivers/net/phy/Makefile b/drivers/net/phy/Makefile
index 13bebab..2333215 100644
--- a/drivers/net/phy/Makefile
+++ b/drivers/net/phy/Makefile
@@ -19,6 +19,7 @@ obj-$(CONFIG_FIXED_PHY)		+= fixed.o
 obj-$(CONFIG_MDIO_BITBANG)	+= mdio-bitbang.o
 obj-$(CONFIG_MDIO_GPIO)		+= mdio-gpio.o
 obj-$(CONFIG_NATIONAL_PHY)	+= national.o
+obj-$(CONFIG_DP83640_PHY)	+= dp83640.o
 obj-$(CONFIG_STE10XP)		+= ste10Xp.o
 obj-$(CONFIG_MICREL_PHY)	+= micrel.o
 obj-$(CONFIG_MDIO_OCTEON)	+= mdio-octeon.o
diff --git a/drivers/net/phy/dp83640.c b/drivers/net/phy/dp83640.c
new file mode 100644
index 0000000..b0c9522
--- /dev/null
+++ b/drivers/net/phy/dp83640.c
@@ -0,0 +1,1100 @@
+/*
+ * Driver for the National Semiconductor DP83640 PHYTER
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/ethtool.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
+#include <linux/mii.h>
+#include <linux/module.h>
+#include <linux/net_tstamp.h>
+#include <linux/netdevice.h>
+#include <linux/phy.h>
+#include <linux/ptp_classify.h>
+#include <linux/ptp_clock_kernel.h>
+
+#include "dp83640_reg.h"
+
+#define DP83640_PHY_ID	0x20005ce1
+#define PAGESEL		0x13
+#define LAYER4		0x02
+#define LAYER2		0x01
+#define MAX_RXTS	4
+#define MAX_TXTS	4
+#define N_EXT_TS	1
+#define PSF_PTPVER	2
+#define PSF_EVNT	0x4000
+#define PSF_RX		0x2000
+#define PSF_TX		0x1000
+#define EXT_EVENT	1
+#define EXT_GPIO	1
+#define CAL_EVENT	2
+#define CAL_GPIO	9
+#define CAL_TRIGGER	2
+
+/* phyter seems to miss the mark by 16 ns */
+#define ADJTIME_FIX	16
+
+#if defined(__BIG_ENDIAN)
+#define ENDIAN_FLAG	0
+#elif defined(__LITTLE_ENDIAN)
+#define ENDIAN_FLAG	PSF_ENDIAN
+#endif
+
+#define SKB_PTP_TYPE(__skb) (*(unsigned int *)((__skb)->cb))
+
+struct phy_rxts {
+	u16 ns_lo;   /* ns[15:0] */
+	u16 ns_hi;   /* overflow[1:0], ns[29:16] */
+	u16 sec_lo;  /* sec[15:0] */
+	u16 sec_hi;  /* sec[31:16] */
+	u16 seqid;   /* sequenceId[15:0] */
+	u16 msgtype; /* messageType[3:0], hash[11:0] */
+};
+
+struct phy_txts {
+	u16 ns_lo;   /* ns[15:0] */
+	u16 ns_hi;   /* overflow[1:0], ns[29:16] */
+	u16 sec_lo;  /* sec[15:0] */
+	u16 sec_hi;  /* sec[31:16] */
+};
+
+struct rxts {
+	struct list_head list;
+	unsigned long tmo;
+	u64 ns;
+	u16 seqid;
+	u8  msgtype;
+	u16 hash;
+};
+
+struct dp83640_clock;
+
+struct dp83640_private {
+	struct list_head list;
+	struct dp83640_clock *clock;
+	struct phy_device *phydev;
+	struct work_struct ts_work;
+	int hwts_tx_en;
+	int hwts_rx_en;
+	int layer;
+	int version;
+	/* remember state of cfg0 during calibration */
+	int cfg0;
+	/* remember the last event time stamp */
+	struct phy_txts edata;
+	/* list of rx timestamps */
+	struct list_head rxts;
+	struct list_head rxpool;
+	struct rxts rx_pool_data[MAX_RXTS];
+	/* protects above three fields from concurrent access */
+	spinlock_t rx_lock;
+	/* queues of incoming and outgoing packets */
+	struct sk_buff_head rx_queue;
+	struct sk_buff_head tx_queue;
+};
+
+struct dp83640_clock {
+	/* keeps the instance in the 'phyter_clocks' list */
+	struct list_head list;
+	/* we create one clock instance per MII bus */
+	struct mii_bus *bus;
+	/* protects extended registers from concurrent access */
+	struct mutex extreg_lock;
+	/* remembers which page was last selected */
+	int page;
+	/* our advertised capabilities */
+	struct ptp_clock_info caps;
+	/* protects the three fields below from concurrent access */
+	struct mutex clock_lock;
+	/* the one phyter from which we shall read */
+	struct dp83640_private *chosen;
+	/* list of the other attached phyters, not chosen */
+	struct list_head phylist;
+	/* reference to our PTP hardware clock */
+	struct ptp_clock *ptp_clock;
+};
+
+/* globals */
+
+static int chosen_phy = -1;
+static ushort cal_gpio = 4;
+
+module_param(chosen_phy, int, 0444);
+module_param(cal_gpio, ushort, 0444);
+
+MODULE_PARM_DESC(chosen_phy, \
+	"The address of the PHY to use for the ancillary clock features");
+MODULE_PARM_DESC(cal_gpio, \
+	"Which GPIO line to use for synchronizing multiple PHYs");
+
+/* a list of clocks and a mutex to protect it */
+static LIST_HEAD(phyter_clocks);
+static DEFINE_MUTEX(phyter_clocks_lock);
+
+static void rx_timestamp_work(struct work_struct *work);
+
+/* extended register access functions */
+
+#define BROADCAST_ADDR 31
+
+static inline int broadcast_write(struct mii_bus *bus, u32 regnum, u16 val)
+{
+	return mdiobus_write(bus, BROADCAST_ADDR, regnum, val);
+}
+
+/* Caller must hold extreg_lock. */
+static int ext_read(struct phy_device *phydev, int page, u32 regnum)
+{
+	struct dp83640_private *dp83640 = phydev->priv;
+	int val;
+
+	if (dp83640->clock->page != page) {
+		broadcast_write(phydev->bus, PAGESEL, page);
+		dp83640->clock->page = page;
+	}
+	val = phy_read(phydev, regnum);
+
+	return val;
+}
+
+/* Caller must hold extreg_lock. */
+static void ext_write(int broadcast, struct phy_device *phydev,
+		      int page, u32 regnum, u16 val)
+{
+	struct dp83640_private *dp83640 = phydev->priv;
+
+	if (dp83640->clock->page != page) {
+		broadcast_write(phydev->bus, PAGESEL, page);
+		dp83640->clock->page = page;
+	}
+	if (broadcast)
+		broadcast_write(phydev->bus, regnum, val);
+	else
+		phy_write(phydev, regnum, val);
+}
+
+/* Caller must hold extreg_lock. */
+static int tdr_write(int bc, struct phy_device *dev,
+		     const struct timespec *ts, u16 cmd)
+{
+	ext_write(bc, dev, PAGE4, PTP_TDR, ts->tv_nsec & 0xffff);/* ns[15:0]  */
+	ext_write(bc, dev, PAGE4, PTP_TDR, ts->tv_nsec >> 16);   /* ns[31:16] */
+	ext_write(bc, dev, PAGE4, PTP_TDR, ts->tv_sec & 0xffff); /* sec[15:0] */
+	ext_write(bc, dev, PAGE4, PTP_TDR, ts->tv_sec >> 16);    /* sec[31:16]*/
+
+	ext_write(bc, dev, PAGE4, PTP_CTL, cmd);
+
+	return 0;
+}
+
+/* convert phy timestamps into driver timestamps */
+
+static void phy2rxts(struct phy_rxts *p, struct rxts *rxts)
+{
+	u32 sec;
+
+	sec = p->sec_lo;
+	sec |= p->sec_hi << 16;
+
+	rxts->ns = p->ns_lo;
+	rxts->ns |= (p->ns_hi & 0x3fff) << 16;
+	rxts->ns += ((u64)sec) * 1000000000ULL;
+	rxts->seqid = p->seqid;
+	rxts->msgtype = (p->msgtype >> 12) & 0xf;
+	rxts->hash = p->msgtype & 0x0fff;
+	rxts->tmo = jiffies + HZ;
+}
+
+static u64 phy2txts(struct phy_txts *p)
+{
+	u64 ns;
+	u32 sec;
+
+	sec = p->sec_lo;
+	sec |= p->sec_hi << 16;
+
+	ns = p->ns_lo;
+	ns |= (p->ns_hi & 0x3fff) << 16;
+	ns += ((u64)sec) * 1000000000ULL;
+
+	return ns;
+}
+
+/* ptp clock methods */
+
+static int ptp_dp83640_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+{
+	struct dp83640_clock *clock =
+		container_of(ptp, struct dp83640_clock, caps);
+	struct phy_device *phydev = clock->chosen->phydev;
+	u64 rate;
+	int neg_adj = 0;
+	u16 hi, lo;
+
+	if (ppb < 0) {
+		neg_adj = 1;
+		ppb = -ppb;
+	}
+	rate = ppb;
+	rate <<= 26;
+	rate = div_u64(rate, 1953125);
+
+	hi = (rate >> 16) & PTP_RATE_HI_MASK;
+	if (neg_adj)
+		hi |= PTP_RATE_DIR;
+
+	lo = rate & 0xffff;
+
+	mutex_lock(&clock->extreg_lock);
+
+	ext_write(1, phydev, PAGE4, PTP_RATEH, hi);
+	ext_write(1, phydev, PAGE4, PTP_RATEL, lo);
+
+	mutex_unlock(&clock->extreg_lock);
+
+	return 0;
+}
+
+static int ptp_dp83640_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	struct dp83640_clock *clock =
+		container_of(ptp, struct dp83640_clock, caps);
+	struct phy_device *phydev = clock->chosen->phydev;
+	struct timespec ts;
+	int err;
+
+	delta += ADJTIME_FIX;
+
+	ts = ns_to_timespec(delta);
+
+	mutex_lock(&clock->extreg_lock);
+
+	err = tdr_write(1, phydev, &ts, PTP_STEP_CLK);
+
+	mutex_unlock(&clock->extreg_lock);
+
+	return err;
+}
+
+static int ptp_dp83640_gettime(struct ptp_clock_info *ptp, struct timespec *ts)
+{
+	struct dp83640_clock *clock =
+		container_of(ptp, struct dp83640_clock, caps);
+	struct phy_device *phydev = clock->chosen->phydev;
+	unsigned int val[4];
+
+	mutex_lock(&clock->extreg_lock);
+
+	ext_write(0, phydev, PAGE4, PTP_CTL, PTP_RD_CLK);
+
+	val[0] = ext_read(phydev, PAGE4, PTP_TDR); /* ns[15:0] */
+	val[1] = ext_read(phydev, PAGE4, PTP_TDR); /* ns[31:16] */
+	val[2] = ext_read(phydev, PAGE4, PTP_TDR); /* sec[15:0] */
+	val[3] = ext_read(phydev, PAGE4, PTP_TDR); /* sec[31:16] */
+
+	mutex_unlock(&clock->extreg_lock);
+
+	ts->tv_nsec = val[0] | (val[1] << 16);
+	ts->tv_sec  = val[2] | (val[3] << 16);
+
+	return 0;
+}
+
+static int ptp_dp83640_settime(struct ptp_clock_info *ptp,
+			       const struct timespec *ts)
+{
+	struct dp83640_clock *clock =
+		container_of(ptp, struct dp83640_clock, caps);
+	struct phy_device *phydev = clock->chosen->phydev;
+	int err;
+
+	mutex_lock(&clock->extreg_lock);
+
+	err = tdr_write(1, phydev, ts, PTP_LOAD_CLK);
+
+	mutex_unlock(&clock->extreg_lock);
+
+	return err;
+}
+
+static int ptp_dp83640_enable(struct ptp_clock_info *ptp,
+			      struct ptp_clock_request *rq, int on)
+{
+	struct dp83640_clock *clock =
+		container_of(ptp, struct dp83640_clock, caps);
+	struct phy_device *phydev = clock->chosen->phydev;
+	u16 evnt;
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_EXTTS:
+		if (rq->extts.index != 0)
+			return -EINVAL;
+		evnt = EVNT_WR | (EXT_EVENT & EVNT_SEL_MASK) << EVNT_SEL_SHIFT;
+		if (on) {
+			evnt |= (EXT_GPIO & EVNT_GPIO_MASK) << EVNT_GPIO_SHIFT;
+			evnt |= EVNT_RISE;
+		}
+		ext_write(0, phydev, PAGE5, PTP_EVNT, evnt);
+		return 0;
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static u8 status_frame_dst[6] = { 0x01, 0x1B, 0x19, 0x00, 0x00, 0x00 };
+static u8 status_frame_src[6] = { 0x08, 0x00, 0x17, 0x0B, 0x6B, 0x0F };
+
+static void enable_status_frames(struct phy_device *phydev, bool on)
+{
+	u16 cfg0 = 0, ver;
+
+	if (on)
+		cfg0 = PSF_EVNT_EN | PSF_RXTS_EN | PSF_TXTS_EN | ENDIAN_FLAG;
+
+	ver = (PSF_PTPVER & VERSIONPTP_MASK) << VERSIONPTP_SHIFT;
+
+	ext_write(0, phydev, PAGE5, PSF_CFG0, cfg0);
+	ext_write(0, phydev, PAGE6, PSF_CFG1, ver);
+
+	if (!phydev->attached_dev) {
+		pr_warning("dp83640: expected to find an attached netdevice\n");
+		return;
+	}
+
+	if (on) {
+		if (dev_mc_add(phydev->attached_dev, status_frame_dst))
+			pr_warning("dp83640: failed to add mc address\n");
+	} else {
+		if (dev_mc_del(phydev->attached_dev, status_frame_dst))
+			pr_warning("dp83640: failed to delete mc address\n");
+	}
+}
+
+static bool is_status_frame(struct sk_buff *skb, int type)
+{
+	struct ethhdr *h = eth_hdr(skb);
+
+	if (PTP_CLASS_V2_L2 == type &&
+	    !memcmp(h->h_source, status_frame_src, sizeof(status_frame_src)))
+		return true;
+	else
+		return false;
+}
+
+static int expired(struct rxts *rxts)
+{
+	return time_after(jiffies, rxts->tmo);
+}
+
+/* Caller must hold rx_lock. */
+static void prune_rx_ts(struct dp83640_private *dp83640)
+{
+	struct list_head *this, *next;
+	struct rxts *rxts;
+
+	list_for_each_safe(this, next, &dp83640->rxts) {
+		rxts = list_entry(this, struct rxts, list);
+		if (expired(rxts)) {
+			list_del_init(&rxts->list);
+			list_add(&rxts->list, &dp83640->rxpool);
+		}
+	}
+}
+
+/* synchronize the phyters so they act as one clock */
+
+static void enable_broadcast(struct phy_device *phydev, int init_page, int on)
+{
+	int val;
+	phy_write(phydev, PAGESEL, 0);
+	val = phy_read(phydev, PHYCR2);
+	if (on)
+		val |= BC_WRITE;
+	else
+		val &= ~BC_WRITE;
+	phy_write(phydev, PHYCR2, val);
+	phy_write(phydev, PAGESEL, init_page);
+}
+
+static void recalibrate(struct dp83640_clock *clock)
+{
+	s64 now, diff;
+	struct phy_txts event_ts;
+	struct timespec ts;
+	struct list_head *this;
+	struct dp83640_private *tmp;
+	struct phy_device *master = clock->chosen->phydev;
+	u16 cfg0, evnt, ptp_trig, trigger, val;
+
+	trigger = CAL_TRIGGER;
+
+	mutex_lock(&clock->extreg_lock);
+
+	/*
+	 * enable broadcast, disable status frames, enable ptp clock
+	 */
+	list_for_each(this, &clock->phylist) {
+		tmp = list_entry(this, struct dp83640_private, list);
+		enable_broadcast(tmp->phydev, clock->page, 1);
+		tmp->cfg0 = ext_read(tmp->phydev, PAGE5, PSF_CFG0);
+		ext_write(0, tmp->phydev, PAGE5, PSF_CFG0, 0);
+		ext_write(0, tmp->phydev, PAGE4, PTP_CTL, PTP_ENABLE);
+	}
+	enable_broadcast(master, clock->page, 1);
+	cfg0 = ext_read(master, PAGE5, PSF_CFG0);
+	ext_write(0, master, PAGE5, PSF_CFG0, 0);
+	ext_write(0, master, PAGE4, PTP_CTL, PTP_ENABLE);
+
+	/*
+	 * enable an event timestamp
+	 */
+	evnt = EVNT_WR | EVNT_RISE | EVNT_SINGLE;
+	evnt |= (CAL_EVENT & EVNT_SEL_MASK) << EVNT_SEL_SHIFT;
+	evnt |= (cal_gpio & EVNT_GPIO_MASK) << EVNT_GPIO_SHIFT;
+
+	list_for_each(this, &clock->phylist) {
+		tmp = list_entry(this, struct dp83640_private, list);
+		ext_write(0, tmp->phydev, PAGE5, PTP_EVNT, evnt);
+	}
+	ext_write(0, master, PAGE5, PTP_EVNT, evnt);
+
+	/*
+	 * configure a trigger
+	 */
+	ptp_trig = TRIG_WR | TRIG_IF_LATE | TRIG_PULSE;
+	ptp_trig |= (trigger  & TRIG_CSEL_MASK) << TRIG_CSEL_SHIFT;
+	ptp_trig |= (cal_gpio & TRIG_GPIO_MASK) << TRIG_GPIO_SHIFT;
+	ext_write(0, master, PAGE5, PTP_TRIG, ptp_trig);
+
+	/* load trigger */
+	val = (trigger & TRIG_SEL_MASK) << TRIG_SEL_SHIFT;
+	val |= TRIG_LOAD;
+	ext_write(0, master, PAGE4, PTP_CTL, val);
+
+	/* enable trigger */
+	val &= ~TRIG_LOAD;
+	val |= TRIG_EN;
+	ext_write(0, master, PAGE4, PTP_CTL, val);
+
+	/* disable trigger */
+	val = (trigger & TRIG_SEL_MASK) << TRIG_SEL_SHIFT;
+	val |= TRIG_DIS;
+	ext_write(0, master, PAGE4, PTP_CTL, val);
+
+	/*
+	 * read out and correct offsets
+	 */
+	val = ext_read(master, PAGE4, PTP_STS);
+	pr_info("master PTP_STS  0x%04hx", val);
+	val = ext_read(master, PAGE4, PTP_ESTS);
+	pr_info("master PTP_ESTS 0x%04hx", val);
+	event_ts.ns_lo  = ext_read(master, PAGE4, PTP_EDATA);
+	event_ts.ns_hi  = ext_read(master, PAGE4, PTP_EDATA);
+	event_ts.sec_lo = ext_read(master, PAGE4, PTP_EDATA);
+	event_ts.sec_hi = ext_read(master, PAGE4, PTP_EDATA);
+	now = phy2txts(&event_ts);
+
+	list_for_each(this, &clock->phylist) {
+		tmp = list_entry(this, struct dp83640_private, list);
+		val = ext_read(tmp->phydev, PAGE4, PTP_STS);
+		pr_info("slave  PTP_STS  0x%04hx", val);
+		val = ext_read(tmp->phydev, PAGE4, PTP_ESTS);
+		pr_info("slave  PTP_ESTS 0x%04hx", val);
+		event_ts.ns_lo  = ext_read(tmp->phydev, PAGE4, PTP_EDATA);
+		event_ts.ns_hi  = ext_read(tmp->phydev, PAGE4, PTP_EDATA);
+		event_ts.sec_lo = ext_read(tmp->phydev, PAGE4, PTP_EDATA);
+		event_ts.sec_hi = ext_read(tmp->phydev, PAGE4, PTP_EDATA);
+		diff = now - (s64) phy2txts(&event_ts);
+		pr_info("slave offset %lld nanoseconds\n", diff);
+		diff += ADJTIME_FIX;
+		ts = ns_to_timespec(diff);
+		tdr_write(0, tmp->phydev, &ts, PTP_STEP_CLK);
+	}
+
+	/*
+	 * restore status frames
+	 */
+	list_for_each(this, &clock->phylist) {
+		tmp = list_entry(this, struct dp83640_private, list);
+		ext_write(0, tmp->phydev, PAGE5, PSF_CFG0, tmp->cfg0);
+	}
+	ext_write(0, master, PAGE5, PSF_CFG0, cfg0);
+
+	mutex_unlock(&clock->extreg_lock);
+}
+
+/* time stamping methods */
+
+static void decode_evnt(struct dp83640_private *dp83640,
+			struct phy_txts *phy_txts, u16 ests)
+{
+	struct ptp_clock_event event;
+	int words = (ests >> EVNT_TS_LEN_SHIFT) & EVNT_TS_LEN_MASK;
+
+	switch (words) { /* fall through in every case */
+	case 3:
+		dp83640->edata.sec_hi = phy_txts->sec_hi;
+	case 2:
+		dp83640->edata.sec_lo = phy_txts->sec_lo;
+	case 1:
+		dp83640->edata.ns_hi = phy_txts->ns_hi;
+	case 0:
+		dp83640->edata.ns_lo = phy_txts->ns_lo;
+	}
+
+	event.type = PTP_CLOCK_EXTTS;
+	event.index = 0;
+	event.timestamp = phy2txts(&dp83640->edata);
+
+	ptp_clock_event(dp83640->clock->ptp_clock, &event);
+}
+
+static void decode_rxts(struct dp83640_private *dp83640,
+			struct phy_rxts *phy_rxts)
+{
+	struct rxts *rxts;
+	unsigned long flags;
+
+	spin_lock_irqsave(&dp83640->rx_lock, flags);
+
+	prune_rx_ts(dp83640);
+
+	if (list_empty(&dp83640->rxpool)) {
+		pr_warning("dp83640: rx timestamp pool is empty\n");
+		goto out;
+	}
+	rxts = list_first_entry(&dp83640->rxpool, struct rxts, list);
+	list_del_init(&rxts->list);
+	phy2rxts(phy_rxts, rxts);
+	list_add_tail(&rxts->list, &dp83640->rxts);
+out:
+	spin_unlock_irqrestore(&dp83640->rx_lock, flags);
+}
+
+static void decode_txts(struct dp83640_private *dp83640,
+			struct phy_txts *phy_txts)
+{
+	struct skb_shared_hwtstamps shhwtstamps;
+	struct sk_buff *skb;
+	u64 ns;
+
+	/* We must already have the skb that triggered this. */
+
+	skb = skb_dequeue(&dp83640->tx_queue);
+
+	if (!skb) {
+		pr_warning("dp83640: have timestamp but tx_queue empty\n");
+		return;
+	}
+	ns = phy2txts(phy_txts);
+	memset(&shhwtstamps, 0, sizeof(shhwtstamps));
+	shhwtstamps.hwtstamp = ns_to_ktime(ns);
+	skb_complete_tx_timestamp(skb, &shhwtstamps);
+}
+
+static void decode_status_frame(struct dp83640_private *dp83640,
+				struct sk_buff *skb)
+{
+	struct phy_rxts *phy_rxts;
+	struct phy_txts *phy_txts;
+	u8 *ptr;
+	int len, size;
+	u16 ests, type;
+
+	ptr = skb->data + 2;
+
+	for (len = skb_headlen(skb) - 2; len > sizeof(type); len -= size) {
+
+		type = *(u16 *)ptr;
+		ests = type & 0x0fff;
+		type = type & 0xf000;
+		len -= sizeof(type);
+		ptr += sizeof(type);
+
+		if (PSF_RX == type && len >= sizeof(*phy_rxts)) {
+
+			phy_rxts = (struct phy_rxts *) ptr;
+			decode_rxts(dp83640, phy_rxts);
+			size = sizeof(*phy_rxts);
+
+		} else if (PSF_TX == type && len >= sizeof(*phy_txts)) {
+
+			phy_txts = (struct phy_txts *) ptr;
+			decode_txts(dp83640, phy_txts);
+			size = sizeof(*phy_txts);
+
+		} else if (PSF_EVNT == type && len >= sizeof(*phy_txts)) {
+
+			phy_txts = (struct phy_txts *) ptr;
+			decode_evnt(dp83640, phy_txts, ests);
+			size = sizeof(*phy_txts);
+
+		} else {
+			size = 0;
+			break;
+		}
+		ptr += size;
+	}
+}
+
+static int match(struct sk_buff *skb, unsigned int type, struct rxts *rxts)
+{
+	u16 *seqid;
+	unsigned int offset;
+	u8 *msgtype, *data = skb_mac_header(skb);
+
+	/* check sequenceID, messageType, 12 bit hash of offset 20-29 */
+
+	switch (type) {
+	case PTP_CLASS_V1_IPV4:
+	case PTP_CLASS_V2_IPV4:
+		offset = ETH_HLEN + IPV4_HLEN(data) + UDP_HLEN;
+		break;
+	case PTP_CLASS_V1_IPV6:
+	case PTP_CLASS_V2_IPV6:
+		offset = OFF_PTP6;
+		break;
+	case PTP_CLASS_V2_L2:
+		offset = ETH_HLEN;
+		break;
+	case PTP_CLASS_V2_VLAN:
+		offset = ETH_HLEN + VLAN_HLEN;
+		break;
+	default:
+		return 0;
+	}
+
+	if (skb->len + ETH_HLEN < offset + OFF_PTP_SEQUENCE_ID + sizeof(*seqid))
+		return 0;
+
+	if (unlikely(type & PTP_CLASS_V1))
+		msgtype = data + offset + OFF_PTP_CONTROL;
+	else
+		msgtype = data + offset;
+
+	seqid = (u16 *)(data + offset + OFF_PTP_SEQUENCE_ID);
+
+	return (rxts->msgtype == (*msgtype & 0xf) &&
+		rxts->seqid   == ntohs(*seqid));
+}
+
+static void dp83640_free_clocks(void)
+{
+	struct dp83640_clock *clock;
+	struct list_head *this, *next;
+
+	mutex_lock(&phyter_clocks_lock);
+
+	list_for_each_safe(this, next, &phyter_clocks) {
+		clock = list_entry(this, struct dp83640_clock, list);
+		if (!list_empty(&clock->phylist)) {
+			pr_warning("phy list non-empty while unloading");
+			BUG();
+		}
+		list_del(&clock->list);
+		mutex_destroy(&clock->extreg_lock);
+		mutex_destroy(&clock->clock_lock);
+		put_device(&clock->bus->dev);
+		kfree(clock);
+	}
+
+	mutex_unlock(&phyter_clocks_lock);
+}
+
+static void dp83640_clock_init(struct dp83640_clock *clock, struct mii_bus *bus)
+{
+	INIT_LIST_HEAD(&clock->list);
+	clock->bus = bus;
+	mutex_init(&clock->extreg_lock);
+	mutex_init(&clock->clock_lock);
+	INIT_LIST_HEAD(&clock->phylist);
+	clock->caps.owner = THIS_MODULE;
+	sprintf(clock->caps.name, "dp83640 timer");
+	clock->caps.max_adj	= 1953124;
+	clock->caps.n_alarm	= 0;
+	clock->caps.n_ext_ts	= N_EXT_TS;
+	clock->caps.n_per_out	= 0;
+	clock->caps.pps		= 0;
+	clock->caps.adjfreq	= ptp_dp83640_adjfreq;
+	clock->caps.adjtime	= ptp_dp83640_adjtime;
+	clock->caps.gettime	= ptp_dp83640_gettime;
+	clock->caps.settime	= ptp_dp83640_settime;
+	clock->caps.enable	= ptp_dp83640_enable;
+	/*
+	 * Get a reference to this bus instance.
+	 */
+	get_device(&bus->dev);
+}
+
+static int choose_this_phy(struct dp83640_clock *clock,
+			   struct phy_device *phydev)
+{
+	if (chosen_phy == -1 && !clock->chosen)
+		return 1;
+
+	if (chosen_phy == phydev->addr)
+		return 1;
+
+	return 0;
+}
+
+static struct dp83640_clock *dp83640_clock_get(struct dp83640_clock *clock)
+{
+	if (clock)
+		mutex_lock(&clock->clock_lock);
+	return clock;
+}
+
+/*
+ * Look up and lock a clock by bus instance.
+ * If there is no clock for this bus, then create it first.
+ */
+static struct dp83640_clock *dp83640_clock_get_bus(struct mii_bus *bus)
+{
+	struct dp83640_clock *clock = NULL, *tmp;
+	struct list_head *this;
+
+	mutex_lock(&phyter_clocks_lock);
+
+	list_for_each(this, &phyter_clocks) {
+		tmp = list_entry(this, struct dp83640_clock, list);
+		if (tmp->bus == bus) {
+			clock = tmp;
+			break;
+		}
+	}
+	if (clock)
+		goto out;
+
+	clock = kzalloc(sizeof(struct dp83640_clock), GFP_KERNEL);
+	if (!clock)
+		goto out;
+
+	dp83640_clock_init(clock, bus);
+	list_add_tail(&phyter_clocks, &clock->list);
+out:
+	mutex_unlock(&phyter_clocks_lock);
+
+	return dp83640_clock_get(clock);
+}
+
+static void dp83640_clock_put(struct dp83640_clock *clock)
+{
+	mutex_unlock(&clock->clock_lock);
+}
+
+static int dp83640_probe(struct phy_device *phydev)
+{
+	struct dp83640_clock *clock;
+	struct dp83640_private *dp83640;
+	int err = -ENOMEM, i;
+
+	if (phydev->addr == BROADCAST_ADDR)
+		return 0;
+
+	clock = dp83640_clock_get_bus(phydev->bus);
+	if (!clock)
+		goto no_clock;
+
+	dp83640 = kzalloc(sizeof(struct dp83640_private), GFP_KERNEL);
+	if (!dp83640)
+		goto no_memory;
+
+	dp83640->phydev = phydev;
+	INIT_WORK(&dp83640->ts_work, rx_timestamp_work);
+
+	INIT_LIST_HEAD(&dp83640->rxts);
+	INIT_LIST_HEAD(&dp83640->rxpool);
+	for (i = 0; i < MAX_RXTS; i++)
+		list_add(&dp83640->rx_pool_data[i].list, &dp83640->rxpool);
+
+	phydev->priv = dp83640;
+
+	spin_lock_init(&dp83640->rx_lock);
+	skb_queue_head_init(&dp83640->rx_queue);
+	skb_queue_head_init(&dp83640->tx_queue);
+
+	dp83640->clock = clock;
+
+	if (choose_this_phy(clock, phydev)) {
+		clock->chosen = dp83640;
+		clock->ptp_clock = ptp_clock_register(&clock->caps);
+		if (IS_ERR(clock->ptp_clock)) {
+			err = PTR_ERR(clock->ptp_clock);
+			goto no_register;
+		}
+	} else
+		list_add_tail(&dp83640->list, &clock->phylist);
+
+	if (clock->chosen && !list_empty(&clock->phylist))
+		recalibrate(clock);
+	else
+		enable_broadcast(dp83640->phydev, clock->page, 1);
+
+	dp83640_clock_put(clock);
+	return 0;
+
+no_register:
+	clock->chosen = NULL;
+	kfree(dp83640);
+no_memory:
+	dp83640_clock_put(clock);
+no_clock:
+	return err;
+}
+
+static void dp83640_remove(struct phy_device *phydev)
+{
+	struct dp83640_clock *clock;
+	struct list_head *this, *next;
+	struct dp83640_private *tmp, *dp83640 = phydev->priv;
+
+	if (phydev->addr == BROADCAST_ADDR)
+		return;
+
+	enable_status_frames(phydev, false);
+	cancel_work_sync(&dp83640->ts_work);
+
+	clock = dp83640_clock_get(dp83640->clock);
+
+	if (dp83640 == clock->chosen) {
+		ptp_clock_unregister(clock->ptp_clock);
+		clock->chosen = NULL;
+	} else {
+		list_for_each_safe(this, next, &clock->phylist) {
+			tmp = list_entry(this, struct dp83640_private, list);
+			if (tmp == dp83640) {
+				list_del_init(&tmp->list);
+				break;
+			}
+		}
+	}
+
+	dp83640_clock_put(clock);
+	kfree(dp83640);
+}
+
+static int dp83640_hwtstamp(struct phy_device *phydev, struct ifreq *ifr)
+{
+	struct dp83640_private *dp83640 = phydev->priv;
+	struct hwtstamp_config cfg;
+	u16 txcfg0, rxcfg0;
+
+	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
+		return -EFAULT;
+
+	if (cfg.flags) /* reserved for future extensions */
+		return -EINVAL;
+
+	switch (cfg.tx_type) {
+	case HWTSTAMP_TX_OFF:
+		dp83640->hwts_tx_en = 0;
+		break;
+	case HWTSTAMP_TX_ON:
+		dp83640->hwts_tx_en = 1;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	switch (cfg.rx_filter) {
+	case HWTSTAMP_FILTER_NONE:
+		dp83640->hwts_rx_en = 0;
+		dp83640->layer = 0;
+		dp83640->version = 0;
+		break;
+	case HWTSTAMP_FILTER_PTP_V1_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V1_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V1_L4_DELAY_REQ:
+		dp83640->hwts_rx_en = 1;
+		dp83640->layer = LAYER4;
+		dp83640->version = 1;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L4_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L4_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L4_DELAY_REQ:
+		dp83640->hwts_rx_en = 1;
+		dp83640->layer = LAYER4;
+		dp83640->version = 2;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_L2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_L2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_L2_DELAY_REQ:
+		dp83640->hwts_rx_en = 1;
+		dp83640->layer = LAYER2;
+		dp83640->version = 2;
+		break;
+	case HWTSTAMP_FILTER_PTP_V2_EVENT:
+	case HWTSTAMP_FILTER_PTP_V2_SYNC:
+	case HWTSTAMP_FILTER_PTP_V2_DELAY_REQ:
+		dp83640->hwts_rx_en = 1;
+		dp83640->layer = LAYER4|LAYER2;
+		dp83640->version = 2;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	txcfg0 = (dp83640->version & TX_PTP_VER_MASK) << TX_PTP_VER_SHIFT;
+	rxcfg0 = (dp83640->version & TX_PTP_VER_MASK) << TX_PTP_VER_SHIFT;
+
+	if (dp83640->layer & LAYER2) {
+		txcfg0 |= TX_L2_EN;
+		rxcfg0 |= RX_L2_EN;
+	}
+	if (dp83640->layer & LAYER4) {
+		txcfg0 |= TX_IPV6_EN | TX_IPV4_EN;
+		rxcfg0 |= RX_IPV6_EN | RX_IPV4_EN;
+	}
+
+	if (dp83640->hwts_tx_en)
+		txcfg0 |= TX_TS_EN;
+
+	if (dp83640->hwts_rx_en)
+		rxcfg0 |= RX_TS_EN;
+
+	mutex_lock(&dp83640->clock->extreg_lock);
+
+	if (dp83640->hwts_tx_en || dp83640->hwts_rx_en) {
+		enable_status_frames(phydev, true);
+		ext_write(0, phydev, PAGE4, PTP_CTL, PTP_ENABLE);
+	}
+
+	ext_write(0, phydev, PAGE5, PTP_TXCFG0, txcfg0);
+	ext_write(0, phydev, PAGE5, PTP_RXCFG0, rxcfg0);
+
+	mutex_unlock(&dp83640->clock->extreg_lock);
+
+	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+}
+
+static void rx_timestamp_work(struct work_struct *work)
+{
+	struct dp83640_private *dp83640 =
+		container_of(work, struct dp83640_private, ts_work);
+	struct list_head *this, *next;
+	struct rxts *rxts;
+	struct skb_shared_hwtstamps *shhwtstamps;
+	struct sk_buff *skb;
+	unsigned int type;
+	unsigned long flags;
+
+	/* Deliver each deferred packet, with or without a time stamp. */
+
+	while ((skb = skb_dequeue(&dp83640->rx_queue)) != NULL) {
+		type = SKB_PTP_TYPE(skb);
+		spin_lock_irqsave(&dp83640->rx_lock, flags);
+		list_for_each_safe(this, next, &dp83640->rxts) {
+			rxts = list_entry(this, struct rxts, list);
+			if (match(skb, type, rxts)) {
+				shhwtstamps = skb_hwtstamps(skb);
+				memset(shhwtstamps, 0, sizeof(*shhwtstamps));
+				shhwtstamps->hwtstamp = ns_to_ktime(rxts->ns);
+				list_del_init(&rxts->list);
+				list_add(&rxts->list, &dp83640->rxpool);
+				break;
+			}
+		}
+		spin_unlock_irqrestore(&dp83640->rx_lock, flags);
+		netif_rx(skb);
+	}
+
+	/* Clear out expired time stamps. */
+
+	spin_lock_irqsave(&dp83640->rx_lock, flags);
+	prune_rx_ts(dp83640);
+	spin_unlock_irqrestore(&dp83640->rx_lock, flags);
+}
+
+static bool dp83640_rxtstamp(struct phy_device *phydev,
+			     struct sk_buff *skb, int type)
+{
+	struct dp83640_private *dp83640 = phydev->priv;
+
+	if (!dp83640->hwts_rx_en)
+		return false;
+
+	if (is_status_frame(skb, type)) {
+		decode_status_frame(dp83640, skb);
+		/* Let the stack drop this frame. */
+		return false;
+	}
+
+	SKB_PTP_TYPE(skb) = type;
+	skb_queue_tail(&dp83640->rx_queue, skb);
+	schedule_work(&dp83640->ts_work);
+
+	return true;
+}
+
+static void dp83640_txtstamp(struct phy_device *phydev,
+			     struct sk_buff *skb, int type)
+{
+	struct dp83640_private *dp83640 = phydev->priv;
+
+	if (!dp83640->hwts_tx_en) {
+		kfree_skb(skb);
+		return;
+	}
+	skb_queue_tail(&dp83640->tx_queue, skb);
+	schedule_work(&dp83640->ts_work);
+}
+
+static struct phy_driver dp83640_driver = {
+	.phy_id		= DP83640_PHY_ID,
+	.phy_id_mask	= 0xfffffff0,
+	.name		= "NatSemi DP83640",
+	.features	= PHY_BASIC_FEATURES,
+	.flags		= 0,
+	.probe		= dp83640_probe,
+	.remove		= dp83640_remove,
+	.config_aneg	= genphy_config_aneg,
+	.read_status	= genphy_read_status,
+	.hwtstamp	= dp83640_hwtstamp,
+	.rxtstamp	= dp83640_rxtstamp,
+	.txtstamp	= dp83640_txtstamp,
+	.driver		= {.owner = THIS_MODULE,}
+};
+
+static int __init dp83640_init(void)
+{
+	return phy_driver_register(&dp83640_driver);
+}
+
+static void __exit dp83640_exit(void)
+{
+	dp83640_free_clocks();
+	phy_driver_unregister(&dp83640_driver);
+}
+
+MODULE_DESCRIPTION("National Semiconductor DP83640 PHY driver");
+MODULE_AUTHOR("Richard Cochran <richard.cochran@omicron.at>");
+MODULE_LICENSE("GPL");
+
+module_init(dp83640_init);
+module_exit(dp83640_exit);
+
+static struct mdio_device_id __maybe_unused dp83640_tbl[] = {
+	{ DP83640_PHY_ID, 0xfffffff0 },
+	{ }
+};
+
+MODULE_DEVICE_TABLE(mdio, dp83640_tbl);
diff --git a/drivers/net/phy/dp83640_reg.h b/drivers/net/phy/dp83640_reg.h
new file mode 100644
index 0000000..e7fe411
--- /dev/null
+++ b/drivers/net/phy/dp83640_reg.h
@@ -0,0 +1,267 @@
+/* dp83640_reg.h
+ * Generated by regen.tcl on Thu Feb 17 10:02:48 AM CET 2011
+ */
+#ifndef HAVE_DP83640_REGISTERS
+#define HAVE_DP83640_REGISTERS
+
+#define PAGE0                     0x0000
+#define PHYCR2                    0x001c /* PHY Control Register 2 */
+
+#define PAGE4                     0x0004
+#define PTP_CTL                   0x0014 /* PTP Control Register */
+#define PTP_TDR                   0x0015 /* PTP Time Data Register */
+#define PTP_STS                   0x0016 /* PTP Status Register */
+#define PTP_TSTS                  0x0017 /* PTP Trigger Status Register */
+#define PTP_RATEL                 0x0018 /* PTP Rate Low Register */
+#define PTP_RATEH                 0x0019 /* PTP Rate High Register */
+#define PTP_RDCKSUM               0x001a /* PTP Read Checksum */
+#define PTP_WRCKSUM               0x001b /* PTP Write Checksum */
+#define PTP_TXTS                  0x001c /* PTP Transmit Timestamp Register, in four 16-bit reads */
+#define PTP_RXTS                  0x001d /* PTP Receive Timestamp Register, in six? 16-bit reads */
+#define PTP_ESTS                  0x001e /* PTP Event Status Register */
+#define PTP_EDATA                 0x001f /* PTP Event Data Register */
+
+#define PAGE5                     0x0005
+#define PTP_TRIG                  0x0014 /* PTP Trigger Configuration Register */
+#define PTP_EVNT                  0x0015 /* PTP Event Configuration Register */
+#define PTP_TXCFG0                0x0016 /* PTP Transmit Configuration Register 0 */
+#define PTP_TXCFG1                0x0017 /* PTP Transmit Configuration Register 1 */
+#define PSF_CFG0                  0x0018 /* PHY Status Frame Configuration Register 0 */
+#define PTP_RXCFG0                0x0019 /* PTP Receive Configuration Register 0 */
+#define PTP_RXCFG1                0x001a /* PTP Receive Configuration Register 1 */
+#define PTP_RXCFG2                0x001b /* PTP Receive Configuration Register 2 */
+#define PTP_RXCFG3                0x001c /* PTP Receive Configuration Register 3 */
+#define PTP_RXCFG4                0x001d /* PTP Receive Configuration Register 4 */
+#define PTP_TRDL                  0x001e /* PTP Temporary Rate Duration Low Register */
+#define PTP_TRDH                  0x001f /* PTP Temporary Rate Duration High Register */
+
+#define PAGE6                     0x0006
+#define PTP_COC                   0x0014 /* PTP Clock Output Control Register */
+#define PSF_CFG1                  0x0015 /* PHY Status Frame Configuration Register 1 */
+#define PSF_CFG2                  0x0016 /* PHY Status Frame Configuration Register 2 */
+#define PSF_CFG3                  0x0017 /* PHY Status Frame Configuration Register 3 */
+#define PSF_CFG4                  0x0018 /* PHY Status Frame Configuration Register 4 */
+#define PTP_SFDCFG                0x0019 /* PTP SFD Configuration Register */
+#define PTP_INTCTL                0x001a /* PTP Interrupt Control Register */
+#define PTP_CLKSRC                0x001b /* PTP Clock Source Register */
+#define PTP_ETR                   0x001c /* PTP Ethernet Type Register */
+#define PTP_OFF                   0x001d /* PTP Offset Register */
+#define PTP_GPIOMON               0x001e /* PTP GPIO Monitor Register */
+#define PTP_RXHASH                0x001f /* PTP Receive Hash Register */
+
+/* Bit definitions for the PHYCR2 register */
+#define BC_WRITE                  (1<<11) /* Broadcast Write Enable */
+
+/* Bit definitions for the PTP_CTL register */
+#define TRIG_SEL_SHIFT            (10)    /* PTP Trigger Select */
+#define TRIG_SEL_MASK             (0x7)
+#define TRIG_DIS                  (1<<9)  /* Disable PTP Trigger */
+#define TRIG_EN                   (1<<8)  /* Enable PTP Trigger */
+#define TRIG_READ                 (1<<7)  /* Read PTP Trigger */
+#define TRIG_LOAD                 (1<<6)  /* Load PTP Trigger */
+#define PTP_RD_CLK                (1<<5)  /* Read PTP Clock */
+#define PTP_LOAD_CLK              (1<<4)  /* Load PTP Clock */
+#define PTP_STEP_CLK              (1<<3)  /* Step PTP Clock */
+#define PTP_ENABLE                (1<<2)  /* Enable PTP Clock */
+#define PTP_DISABLE               (1<<1)  /* Disable PTP Clock */
+#define PTP_RESET                 (1<<0)  /* Reset PTP Clock */
+
+/* Bit definitions for the PTP_STS register */
+#define TXTS_RDY                  (1<<11) /* Transmit Timestamp Ready */
+#define RXTS_RDY                  (1<<10) /* Receive Timestamp Ready */
+#define TRIG_DONE                 (1<<9)  /* PTP Trigger Done */
+#define EVENT_RDY                 (1<<8)  /* PTP Event Timestamp Ready */
+#define TXTS_IE                   (1<<3)  /* Transmit Timestamp Interrupt Enable */
+#define RXTS_IE                   (1<<2)  /* Receive Timestamp Interrupt Enable */
+#define TRIG_IE                   (1<<1)  /* Trigger Interrupt Enable */
+#define EVENT_IE                  (1<<0)  /* Event Interrupt Enable */
+
+/* Bit definitions for the PTP_TSTS register */
+#define TRIG7_ERROR               (1<<15) /* Trigger 7 Error */
+#define TRIG7_ACTIVE              (1<<14) /* Trigger 7 Active */
+#define TRIG6_ERROR               (1<<13) /* Trigger 6 Error */
+#define TRIG6_ACTIVE              (1<<12) /* Trigger 6 Active */
+#define TRIG5_ERROR               (1<<11) /* Trigger 5 Error */
+#define TRIG5_ACTIVE              (1<<10) /* Trigger 5 Active */
+#define TRIG4_ERROR               (1<<9)  /* Trigger 4 Error */
+#define TRIG4_ACTIVE              (1<<8)  /* Trigger 4 Active */
+#define TRIG3_ERROR               (1<<7)  /* Trigger 3 Error */
+#define TRIG3_ACTIVE              (1<<6)  /* Trigger 3 Active */
+#define TRIG2_ERROR               (1<<5)  /* Trigger 2 Error */
+#define TRIG2_ACTIVE              (1<<4)  /* Trigger 2 Active */
+#define TRIG1_ERROR               (1<<3)  /* Trigger 1 Error */
+#define TRIG1_ACTIVE              (1<<2)  /* Trigger 1 Active */
+#define TRIG0_ERROR               (1<<1)  /* Trigger 0 Error */
+#define TRIG0_ACTIVE              (1<<0)  /* Trigger 0 Active */
+
+/* Bit definitions for the PTP_RATEH register */
+#define PTP_RATE_DIR              (1<<15) /* PTP Rate Direction */
+#define PTP_TMP_RATE              (1<<14) /* PTP Temporary Rate */
+#define PTP_RATE_HI_SHIFT         (0)     /* PTP Rate High 10-bits */
+#define PTP_RATE_HI_MASK          (0x3ff)
+
+/* Bit definitions for the PTP_ESTS register */
+#define EVNTS_MISSED_SHIFT        (8)     /* Indicates number of events missed */
+#define EVNTS_MISSED_MASK         (0x7)
+#define EVNT_TS_LEN_SHIFT         (6)     /* Indicates length of the Timestamp field in 16-bit words minus 1 */
+#define EVNT_TS_LEN_MASK          (0x3)
+#define EVNT_RF                   (1<<5)  /* Indicates whether the event is a rise or falling event */
+#define EVNT_NUM_SHIFT            (2)     /* Indicates Event Timestamp Unit which detected an event */
+#define EVNT_NUM_MASK             (0x7)
+#define MULT_EVNT                 (1<<1)  /* Indicates multiple events were detected at the same time */
+#define EVENT_DET                 (1<<0)  /* PTP Event Detected */
+
+/* Bit definitions for the PTP_EDATA register */
+#define E7_RISE                   (1<<15) /* Indicates direction of Event 7 */
+#define E7_DET                    (1<<14) /* Indicates Event 7 detected */
+#define E6_RISE                   (1<<13) /* Indicates direction of Event 6 */
+#define E6_DET                    (1<<12) /* Indicates Event 6 detected */
+#define E5_RISE                   (1<<11) /* Indicates direction of Event 5 */
+#define E5_DET                    (1<<10) /* Indicates Event 5 detected */
+#define E4_RISE                   (1<<9)  /* Indicates direction of Event 4 */
+#define E4_DET                    (1<<8)  /* Indicates Event 4 detected */
+#define E3_RISE                   (1<<7)  /* Indicates direction of Event 3 */
+#define E3_DET                    (1<<6)  /* Indicates Event 3 detected */
+#define E2_RISE                   (1<<5)  /* Indicates direction of Event 2 */
+#define E2_DET                    (1<<4)  /* Indicates Event 2 detected */
+#define E1_RISE                   (1<<3)  /* Indicates direction of Event 1 */
+#define E1_DET                    (1<<2)  /* Indicates Event 1 detected */
+#define E0_RISE                   (1<<1)  /* Indicates direction of Event 0 */
+#define E0_DET                    (1<<0)  /* Indicates Event 0 detected */
+
+/* Bit definitions for the PTP_TRIG register */
+#define TRIG_PULSE                (1<<15) /* generate a Pulse rather than a single edge */
+#define TRIG_PER                  (1<<14) /* generate a periodic signal */
+#define TRIG_IF_LATE              (1<<13) /* trigger immediately if already past */
+#define TRIG_NOTIFY               (1<<12) /* Trigger Notification Enable */
+#define TRIG_GPIO_SHIFT           (8)     /* Trigger GPIO Connection, value 1-12 */
+#define TRIG_GPIO_MASK            (0xf)
+#define TRIG_TOGGLE               (1<<7)  /* Trigger Toggle Mode Enable */
+#define TRIG_CSEL_SHIFT           (1)     /* Trigger Configuration Select */
+#define TRIG_CSEL_MASK            (0x7)
+#define TRIG_WR                   (1<<0)  /* Trigger Configuration Write */
+
+/* Bit definitions for the PTP_EVNT register */
+#define EVNT_RISE                 (1<<14) /* Event Rise Detect Enable */
+#define EVNT_FALL                 (1<<13) /* Event Fall Detect Enable */
+#define EVNT_SINGLE               (1<<12) /* enable single event capture operation */
+#define EVNT_GPIO_SHIFT           (8)     /* Event GPIO Connection, value 1-12 */
+#define EVNT_GPIO_MASK            (0xf)
+#define EVNT_SEL_SHIFT            (1)     /* Event Select */
+#define EVNT_SEL_MASK             (0x7)
+#define EVNT_WR                   (1<<0)  /* Event Configuration Write */
+
+/* Bit definitions for the PTP_TXCFG0 register */
+#define SYNC_1STEP                (1<<15) /* insert timestamp into transmit Sync Messages */
+#define DR_INSERT                 (1<<13) /* Insert Delay_Req Timestamp in Delay_Resp (dangerous) */
+#define NTP_TS_EN                 (1<<12) /* Enable Timestamping of NTP Packets */
+#define IGNORE_2STEP              (1<<11) /* Ignore Two_Step flag for One-Step operation */
+#define CRC_1STEP                 (1<<10) /* Disable checking of CRC for One-Step operation */
+#define CHK_1STEP                 (1<<9)  /* Enable UDP Checksum correction for One-Step Operation */
+#define IP1588_EN                 (1<<8)  /* Enable IEEE 1588 defined IP address filter */
+#define TX_L2_EN                  (1<<7)  /* Layer2 Timestamp Enable */
+#define TX_IPV6_EN                (1<<6)  /* IPv6 Timestamp Enable */
+#define TX_IPV4_EN                (1<<5)  /* IPv4 Timestamp Enable */
+#define TX_PTP_VER_SHIFT          (1)     /* Enable Timestamp capture for IEEE 1588 version X */
+#define TX_PTP_VER_MASK           (0xf)
+#define TX_TS_EN                  (1<<0)  /* Transmit Timestamp Enable */
+
+/* Bit definitions for the PTP_TXCFG1 register */
+#define BYTE0_MASK_SHIFT          (8)     /* Bit mask to be used for matching Byte0 of the PTP Message */
+#define BYTE0_MASK_MASK           (0xff)
+#define BYTE0_DATA_SHIFT          (0)     /* Data to be used for matching Byte0 of the PTP Message */
+#define BYTE0_DATA_MASK           (0xff)
+
+/* Bit definitions for the PSF_CFG0 register */
+#define MAC_SRC_ADD_SHIFT         (11)    /* Status Frame Mac Source Address */
+#define MAC_SRC_ADD_MASK          (0x3)
+#define MIN_PRE_SHIFT             (8)     /* Status Frame Minimum Preamble */
+#define MIN_PRE_MASK              (0x7)
+#define PSF_ENDIAN                (1<<7)  /* Status Frame Endian Control */
+#define PSF_IPV4                  (1<<6)  /* Status Frame IPv4 Enable */
+#define PSF_PCF_RD                (1<<5)  /* Control Frame Read PHY Status Frame Enable */
+#define PSF_ERR_EN                (1<<4)  /* Error PHY Status Frame Enable */
+#define PSF_TXTS_EN               (1<<3)  /* Transmit Timestamp PHY Status Frame Enable */
+#define PSF_RXTS_EN               (1<<2)  /* Receive Timestamp PHY Status Frame Enable */
+#define PSF_TRIG_EN               (1<<1)  /* Trigger PHY Status Frame Enable */
+#define PSF_EVNT_EN               (1<<0)  /* Event PHY Status Frame Enable */
+
+/* Bit definitions for the PTP_RXCFG0 register */
+#define DOMAIN_EN                 (1<<15) /* Domain Match Enable */
+#define ALT_MAST_DIS              (1<<14) /* Alternate Master Timestamp Disable */
+#define USER_IP_SEL               (1<<13) /* Selects portion of IP address accessible thru PTP_RXCFG2 */
+#define USER_IP_EN                (1<<12) /* Enable User-programmed IP address filter */
+#define RX_SLAVE                  (1<<11) /* Receive Slave Only */
+#define IP1588_EN_SHIFT           (8)     /* Enable IEEE 1588 defined IP address filters */
+#define IP1588_EN_MASK            (0xf)
+#define RX_L2_EN                  (1<<7)  /* Layer2 Timestamp Enable */
+#define RX_IPV6_EN                (1<<6)  /* IPv6 Timestamp Enable */
+#define RX_IPV4_EN                (1<<5)  /* IPv4 Timestamp Enable */
+#define RX_PTP_VER_SHIFT          (1)     /* Enable Timestamp capture for IEEE 1588 version X */
+#define RX_PTP_VER_MASK           (0xf)
+#define RX_TS_EN                  (1<<0)  /* Receive Timestamp Enable */
+
+/* Bit definitions for the PTP_RXCFG1 register */
+#define BYTE0_MASK_SHIFT          (8)     /* Bit mask to be used for matching Byte0 of the PTP Message */
+#define BYTE0_MASK_MASK           (0xff)
+#define BYTE0_DATA_SHIFT          (0)     /* Data to be used for matching Byte0 of the PTP Message */
+#define BYTE0_DATA_MASK           (0xff)
+
+/* Bit definitions for the PTP_RXCFG3 register */
+#define TS_MIN_IFG_SHIFT          (12)    /* Minimum Inter-frame Gap */
+#define TS_MIN_IFG_MASK           (0xf)
+#define ACC_UDP                   (1<<11) /* Record Timestamp if UDP Checksum Error */
+#define ACC_CRC                   (1<<10) /* Record Timestamp if CRC Error */
+#define TS_APPEND                 (1<<9)  /* Append Timestamp for L2 */
+#define TS_INSERT                 (1<<8)  /* Enable Timestamp Insertion */
+#define PTP_DOMAIN_SHIFT          (0)     /* PTP Message domainNumber field */
+#define PTP_DOMAIN_MASK           (0xff)
+
+/* Bit definitions for the PTP_RXCFG4 register */
+#define IPV4_UDP_MOD              (1<<15) /* Enable IPV4 UDP Modification */
+#define TS_SEC_EN                 (1<<14) /* Enable Timestamp Seconds */
+#define TS_SEC_LEN_SHIFT          (12)    /* Inserted Timestamp Seconds Length */
+#define TS_SEC_LEN_MASK           (0x3)
+#define RXTS_NS_OFF_SHIFT         (6)     /* Receive Timestamp Nanoseconds offset */
+#define RXTS_NS_OFF_MASK          (0x3f)
+#define RXTS_SEC_OFF_SHIFT        (0)     /* Receive Timestamp Seconds offset */
+#define RXTS_SEC_OFF_MASK         (0x3f)
+
+/* Bit definitions for the PTP_COC register */
+#define PTP_CLKOUT_EN             (1<<15) /* PTP Clock Output Enable */
+#define PTP_CLKOUT_SEL            (1<<14) /* PTP Clock Output Source Select */
+#define PTP_CLKOUT_SPEEDSEL       (1<<13) /* PTP Clock Output I/O Speed Select */
+#define PTP_CLKDIV_SHIFT          (0)     /* PTP Clock Divide-by Value */
+#define PTP_CLKDIV_MASK           (0xff)
+
+/* Bit definitions for the PSF_CFG1 register */
+#define PTPRESERVED_SHIFT         (12)    /* PTP v2 reserved field */
+#define PTPRESERVED_MASK          (0xf)
+#define VERSIONPTP_SHIFT          (8)     /* PTP v2 versionPTP field */
+#define VERSIONPTP_MASK           (0xf)
+#define TRANSPORT_SPECIFIC_SHIFT  (4)     /* PTP v2 Header transportSpecific field */
+#define TRANSPORT_SPECIFIC_MASK   (0xf)
+#define MESSAGETYPE_SHIFT         (0)     /* PTP v2 messageType field */
+#define MESSAGETYPE_MASK          (0xf)
+
+/* Bit definitions for the PTP_SFDCFG register */
+#define TX_SFD_GPIO_SHIFT         (4)     /* TX SFD GPIO Select, value 1-12 */
+#define TX_SFD_GPIO_MASK          (0xf)
+#define RX_SFD_GPIO_SHIFT         (0)     /* RX SFD GPIO Select, value 1-12 */
+#define RX_SFD_GPIO_MASK          (0xf)
+
+/* Bit definitions for the PTP_INTCTL register */
+#define PTP_INT_GPIO_SHIFT        (0)     /* PTP Interrupt GPIO Select */
+#define PTP_INT_GPIO_MASK         (0xf)
+
+/* Bit definitions for the PTP_CLKSRC register */
+#define CLK_SRC_SHIFT             (14)    /* PTP Clock Source Select */
+#define CLK_SRC_MASK              (0x3)
+#define CLK_SRC_PER_SHIFT         (0)     /* PTP Clock Source Period */
+#define CLK_SRC_PER_MASK          (0x7f)
+
+/* Bit definitions for the PTP_OFF register */
+#define PTP_OFFSET_SHIFT          (0)     /* PTP Message offset from preceding header */
+#define PTP_OFFSET_MASK           (0xff)
+
+#endif
diff --git a/drivers/ptp/Kconfig b/drivers/ptp/Kconfig
new file mode 100644
index 0000000..68d7201
--- /dev/null
+++ b/drivers/ptp/Kconfig
@@ -0,0 +1,75 @@
+#
+# PTP clock support configuration
+#
+
+menu "PTP clock support"
+
+comment "Enable Device Drivers -> PPS to see the PTP clock options."
+	depends on PPS=n
+
+config PTP_1588_CLOCK
+	tristate "PTP clock support"
+	depends on EXPERIMENTAL
+	depends on PPS
+	help
+	  The IEEE 1588 standard defines a method to precisely
+	  synchronize distributed clocks over Ethernet networks. The
+	  standard defines a Precision Time Protocol (PTP), which can
+	  be used to achieve synchronization within a few dozen
+	  microseconds. In addition, with the help of special hardware
+	  time stamping units, it can be possible to achieve
+	  synchronization to within a few hundred nanoseconds.
+
+	  This driver adds support for PTP clocks as character
+	  devices. If you want to use a PTP clock, then you should
+	  also enable at least one clock driver as well.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called ptp.
+
+config PTP_1588_CLOCK_GIANFAR
+	tristate "Freescale eTSEC as PTP clock"
+	depends on PTP_1588_CLOCK
+	depends on GIANFAR
+	help
+	  This driver adds support for using the eTSEC as a PTP
+	  clock. This clock is only useful if your PTP programs are
+	  getting hardware time stamps on the PTP Ethernet packets
+	  using the SO_TIMESTAMPING API.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called gianfar_ptp.
+
+config PTP_1588_CLOCK_IXP46X
+	tristate "Intel IXP46x as PTP clock"
+	depends on PTP_1588_CLOCK
+	depends on IXP4XX_ETH
+	help
+	  This driver adds support for using the IXP46X as a PTP
+	  clock. This clock is only useful if your PTP programs are
+	  getting hardware time stamps on the PTP Ethernet packets
+	  using the SO_TIMESTAMPING API.
+
+	  To compile this driver as a module, choose M here: the module
+	  will be called ptp_ixp46x.
+
+comment "Enable PHYLIB and NETWORK_PHY_TIMESTAMPING to see the additional clocks."
+	depends on PTP_1588_CLOCK && (PHYLIB=n || NETWORK_PHY_TIMESTAMPING=n)
+
+config DP83640_PHY
+	tristate "Driver for the National Semiconductor DP83640 PHYTER"
+	depends on PTP_1588_CLOCK
+	depends on NETWORK_PHY_TIMESTAMPING
+	depends on PHYLIB
+	---help---
+	  Supports the DP83640 PHYTER with IEEE 1588 features.
+
+	  This driver adds support for using the DP83640 as a PTP
+	  clock. This clock is only useful if your PTP programs are
+	  getting hardware time stamps on the PTP Ethernet packets
+	  using the SO_TIMESTAMPING API.
+
+	  In order for this to work, your MAC driver must also
+	  implement the skb_tx_timetamp() function.
+
+endmenu
diff --git a/drivers/ptp/Makefile b/drivers/ptp/Makefile
new file mode 100644
index 0000000..f6933e8
--- /dev/null
+++ b/drivers/ptp/Makefile
@@ -0,0 +1,7 @@
+#
+# Makefile for PTP 1588 clock support.
+#
+
+ptp-y					:= ptp_clock.o ptp_chardev.o ptp_sysfs.o
+obj-$(CONFIG_PTP_1588_CLOCK)		+= ptp.o
+obj-$(CONFIG_PTP_1588_CLOCK_IXP46X)	+= ptp_ixp46x.o
diff --git a/drivers/ptp/ptp_chardev.c b/drivers/ptp/ptp_chardev.c
new file mode 100644
index 0000000..a8d03ae
--- /dev/null
+++ b/drivers/ptp/ptp_chardev.c
@@ -0,0 +1,159 @@
+/*
+ * PTP 1588 clock support - character device implementation.
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/module.h>
+#include <linux/posix-clock.h>
+#include <linux/poll.h>
+#include <linux/sched.h>
+
+#include "ptp_private.h"
+
+int ptp_open(struct posix_clock *pc, fmode_t fmode)
+{
+	return 0;
+}
+
+long ptp_ioctl(struct posix_clock *pc, unsigned int cmd, unsigned long arg)
+{
+	struct ptp_clock_caps caps;
+	struct ptp_clock_request req;
+	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
+	struct ptp_clock_info *ops = ptp->info;
+	int enable, err = 0;
+
+	switch (cmd) {
+
+	case PTP_CLOCK_GETCAPS:
+		memset(&caps, 0, sizeof(caps));
+		caps.max_adj = ptp->info->max_adj;
+		caps.n_alarm = ptp->info->n_alarm;
+		caps.n_ext_ts = ptp->info->n_ext_ts;
+		caps.n_per_out = ptp->info->n_per_out;
+		caps.pps = ptp->info->pps;
+		err = copy_to_user((void __user *)arg, &caps, sizeof(caps));
+		break;
+
+	case PTP_EXTTS_REQUEST:
+		if (copy_from_user(&req.extts, (void __user *)arg,
+				   sizeof(req.extts))) {
+			err = -EFAULT;
+			break;
+		}
+		if (req.extts.index >= ops->n_ext_ts) {
+			err = -EINVAL;
+			break;
+		}
+		req.type = PTP_CLK_REQ_EXTTS;
+		enable = req.extts.flags & PTP_ENABLE_FEATURE ? 1 : 0;
+		err = ops->enable(ops, &req, enable);
+		break;
+
+	case PTP_PEROUT_REQUEST:
+		if (copy_from_user(&req.perout, (void __user *)arg,
+				   sizeof(req.perout))) {
+			err = -EFAULT;
+			break;
+		}
+		if (req.perout.index >= ops->n_per_out) {
+			err = -EINVAL;
+			break;
+		}
+		req.type = PTP_CLK_REQ_PEROUT;
+		enable = req.perout.period.sec || req.perout.period.nsec;
+		err = ops->enable(ops, &req, enable);
+		break;
+
+	case PTP_ENABLE_PPS:
+		if (!capable(CAP_SYS_TIME))
+			return -EPERM;
+		req.type = PTP_CLK_REQ_PPS;
+		enable = arg ? 1 : 0;
+		err = ops->enable(ops, &req, enable);
+		break;
+
+	default:
+		err = -ENOTTY;
+		break;
+	}
+	return err;
+}
+
+unsigned int ptp_poll(struct posix_clock *pc, struct file *fp, poll_table *wait)
+{
+	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
+
+	poll_wait(fp, &ptp->tsev_wq, wait);
+
+	return queue_cnt(&ptp->tsevq) ? POLLIN : 0;
+}
+
+ssize_t ptp_read(struct posix_clock *pc,
+		 uint rdflags, char __user *buf, size_t cnt)
+{
+	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
+	struct timestamp_event_queue *queue = &ptp->tsevq;
+	struct ptp_extts_event event[PTP_BUF_TIMESTAMPS];
+	unsigned long flags;
+	size_t qcnt, i;
+
+	if (cnt % sizeof(struct ptp_extts_event) != 0)
+		return -EINVAL;
+
+	if (cnt > sizeof(event))
+		cnt = sizeof(event);
+
+	cnt = cnt / sizeof(struct ptp_extts_event);
+
+	if (mutex_lock_interruptible(&ptp->tsevq_mux))
+		return -ERESTARTSYS;
+
+	if (wait_event_interruptible(ptp->tsev_wq,
+				     ptp->defunct || queue_cnt(queue))) {
+		mutex_unlock(&ptp->tsevq_mux);
+		return -ERESTARTSYS;
+	}
+
+	if (ptp->defunct)
+		return -ENODEV;
+
+	spin_lock_irqsave(&queue->lock, flags);
+
+	qcnt = queue_cnt(queue);
+
+	if (cnt > qcnt)
+		cnt = qcnt;
+
+	for (i = 0; i < cnt; i++) {
+		event[i] = queue->buf[queue->head];
+		queue->head = (queue->head + 1) % PTP_MAX_TIMESTAMPS;
+	}
+
+	spin_unlock_irqrestore(&queue->lock, flags);
+
+	cnt = cnt * sizeof(struct ptp_extts_event);
+
+	mutex_unlock(&ptp->tsevq_mux);
+
+	if (copy_to_user(buf, event, cnt)) {
+		mutex_unlock(&ptp->tsevq_mux);
+		return -EFAULT;
+	}
+
+	return cnt;
+}
diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
new file mode 100644
index 0000000..cf3f999
--- /dev/null
+++ b/drivers/ptp/ptp_clock.c
@@ -0,0 +1,343 @@
+/*
+ * PTP 1588 clock support
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/bitops.h>
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/posix-clock.h>
+#include <linux/pps_kernel.h>
+#include <linux/slab.h>
+#include <linux/syscalls.h>
+#include <linux/uaccess.h>
+
+#include "ptp_private.h"
+
+#define PTP_MAX_ALARMS 4
+#define PTP_MAX_CLOCKS 8
+#define PTP_PPS_DEFAULTS (PPS_CAPTUREASSERT | PPS_OFFSETASSERT)
+#define PTP_PPS_EVENT PPS_CAPTUREASSERT
+#define PTP_PPS_MODE (PTP_PPS_DEFAULTS | PPS_CANWAIT | PPS_TSFMT_TSPEC)
+
+/* private globals */
+
+static dev_t ptp_devt;
+static struct class *ptp_class;
+
+static DECLARE_BITMAP(ptp_clocks_map, PTP_MAX_CLOCKS);
+static DEFINE_MUTEX(ptp_clocks_mutex); /* protects 'ptp_clocks_map' */
+
+/* time stamp event queue operations */
+
+static inline int queue_free(struct timestamp_event_queue *q)
+{
+	return PTP_MAX_TIMESTAMPS - queue_cnt(q) - 1;
+}
+
+static void enqueue_external_timestamp(struct timestamp_event_queue *queue,
+				       struct ptp_clock_event *src)
+{
+	struct ptp_extts_event *dst;
+	unsigned long flags;
+	s64 seconds;
+	u32 remainder;
+
+	seconds = div_u64_rem(src->timestamp, 1000000000, &remainder);
+
+	spin_lock_irqsave(&queue->lock, flags);
+
+	dst = &queue->buf[queue->tail];
+	dst->index = src->index;
+	dst->t.sec = seconds;
+	dst->t.nsec = remainder;
+
+	if (!queue_free(queue))
+		queue->head = (queue->head + 1) % PTP_MAX_TIMESTAMPS;
+
+	queue->tail = (queue->tail + 1) % PTP_MAX_TIMESTAMPS;
+
+	spin_unlock_irqrestore(&queue->lock, flags);
+}
+
+static s32 scaled_ppm_to_ppb(long ppm)
+{
+	/*
+	 * The 'freq' field in the 'struct timex' is in parts per
+	 * million, but with a 16 bit binary fractional field.
+	 *
+	 * We want to calculate
+	 *
+	 *    ppb = scaled_ppm * 1000 / 2^16
+	 *
+	 * which simplifies to
+	 *
+	 *    ppb = scaled_ppm * 125 / 2^13
+	 */
+	s64 ppb = 1 + ppm;
+	ppb *= 125;
+	ppb >>= 13;
+	return (s32) ppb;
+}
+
+/* posix clock implementation */
+
+static int ptp_clock_getres(struct posix_clock *pc, struct timespec *tp)
+{
+	return 1; /* always round timer functions to one nanosecond */
+}
+
+static int ptp_clock_settime(struct posix_clock *pc, const struct timespec *tp)
+{
+	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
+	return ptp->info->settime(ptp->info, tp);
+}
+
+static int ptp_clock_gettime(struct posix_clock *pc, struct timespec *tp)
+{
+	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
+	return ptp->info->gettime(ptp->info, tp);
+}
+
+static int ptp_clock_adjtime(struct posix_clock *pc, struct timex *tx)
+{
+	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
+	struct ptp_clock_info *ops;
+	int err = -EOPNOTSUPP;
+
+	ops = ptp->info;
+
+	if (tx->modes & ADJ_SETOFFSET) {
+		struct timespec ts;
+		ktime_t kt;
+		s64 delta;
+
+		ts.tv_sec  = tx->time.tv_sec;
+		ts.tv_nsec = tx->time.tv_usec;
+
+		if (!(tx->modes & ADJ_NANO))
+			ts.tv_nsec *= 1000;
+
+		if ((unsigned long) ts.tv_nsec >= NSEC_PER_SEC)
+			return -EINVAL;
+
+		kt = timespec_to_ktime(ts);
+		delta = ktime_to_ns(kt);
+		err = ops->adjtime(ops, delta);
+
+	} else if (tx->modes & ADJ_FREQUENCY) {
+
+		err = ops->adjfreq(ops, scaled_ppm_to_ppb(tx->freq));
+	}
+
+	return err;
+}
+
+static struct posix_clock_operations ptp_clock_ops = {
+	.owner		= THIS_MODULE,
+	.clock_adjtime	= ptp_clock_adjtime,
+	.clock_gettime	= ptp_clock_gettime,
+	.clock_getres	= ptp_clock_getres,
+	.clock_settime	= ptp_clock_settime,
+	.ioctl		= ptp_ioctl,
+	.open		= ptp_open,
+	.poll		= ptp_poll,
+	.read		= ptp_read,
+};
+
+static void delete_ptp_clock(struct posix_clock *pc)
+{
+	struct ptp_clock *ptp = container_of(pc, struct ptp_clock, clock);
+
+	mutex_destroy(&ptp->tsevq_mux);
+
+	/* Remove the clock from the bit map. */
+	mutex_lock(&ptp_clocks_mutex);
+	clear_bit(ptp->index, ptp_clocks_map);
+	mutex_unlock(&ptp_clocks_mutex);
+
+	kfree(ptp);
+}
+
+/* public interface */
+
+struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info)
+{
+	struct ptp_clock *ptp;
+	int err = 0, index, major = MAJOR(ptp_devt);
+
+	if (info->n_alarm > PTP_MAX_ALARMS)
+		return ERR_PTR(-EINVAL);
+
+	/* Find a free clock slot and reserve it. */
+	err = -EBUSY;
+	mutex_lock(&ptp_clocks_mutex);
+	index = find_first_zero_bit(ptp_clocks_map, PTP_MAX_CLOCKS);
+	if (index < PTP_MAX_CLOCKS)
+		set_bit(index, ptp_clocks_map);
+	else
+		goto no_slot;
+
+	/* Initialize a clock structure. */
+	err = -ENOMEM;
+	ptp = kzalloc(sizeof(struct ptp_clock), GFP_KERNEL);
+	if (ptp == NULL)
+		goto no_memory;
+
+	ptp->clock.ops = ptp_clock_ops;
+	ptp->clock.release = delete_ptp_clock;
+	ptp->info = info;
+	ptp->devid = MKDEV(major, index);
+	ptp->index = index;
+	spin_lock_init(&ptp->tsevq.lock);
+	mutex_init(&ptp->tsevq_mux);
+	init_waitqueue_head(&ptp->tsev_wq);
+
+	/* Create a new device in our class. */
+	ptp->dev = device_create(ptp_class, NULL, ptp->devid, ptp,
+				 "ptp%d", ptp->index);
+	if (IS_ERR(ptp->dev))
+		goto no_device;
+
+	dev_set_drvdata(ptp->dev, ptp);
+
+	err = ptp_populate_sysfs(ptp);
+	if (err)
+		goto no_sysfs;
+
+	/* Register a new PPS source. */
+	if (info->pps) {
+		struct pps_source_info pps;
+		memset(&pps, 0, sizeof(pps));
+		snprintf(pps.name, PPS_MAX_NAME_LEN, "ptp%d", index);
+		pps.mode = PTP_PPS_MODE;
+		pps.owner = info->owner;
+		ptp->pps_source = pps_register_source(&pps, PTP_PPS_DEFAULTS);
+		if (!ptp->pps_source) {
+			pr_err("failed to register pps source\n");
+			goto no_pps;
+		}
+	}
+
+	/* Create a posix clock. */
+	err = posix_clock_register(&ptp->clock, ptp->devid);
+	if (err) {
+		pr_err("failed to create posix clock\n");
+		goto no_clock;
+	}
+
+	mutex_unlock(&ptp_clocks_mutex);
+	return ptp;
+
+no_clock:
+	if (ptp->pps_source)
+		pps_unregister_source(ptp->pps_source);
+no_pps:
+	ptp_cleanup_sysfs(ptp);
+no_sysfs:
+	device_destroy(ptp_class, ptp->devid);
+no_device:
+	mutex_destroy(&ptp->tsevq_mux);
+	kfree(ptp);
+no_memory:
+	clear_bit(index, ptp_clocks_map);
+no_slot:
+	mutex_unlock(&ptp_clocks_mutex);
+	return ERR_PTR(err);
+}
+EXPORT_SYMBOL(ptp_clock_register);
+
+int ptp_clock_unregister(struct ptp_clock *ptp)
+{
+	ptp->defunct = 1;
+	wake_up_interruptible(&ptp->tsev_wq);
+
+	/* Release the clock's resources. */
+	if (ptp->pps_source)
+		pps_unregister_source(ptp->pps_source);
+	ptp_cleanup_sysfs(ptp);
+	device_destroy(ptp_class, ptp->devid);
+
+	posix_clock_unregister(&ptp->clock);
+	return 0;
+}
+EXPORT_SYMBOL(ptp_clock_unregister);
+
+void ptp_clock_event(struct ptp_clock *ptp, struct ptp_clock_event *event)
+{
+	struct pps_event_time evt;
+
+	switch (event->type) {
+
+	case PTP_CLOCK_ALARM:
+		break;
+
+	case PTP_CLOCK_EXTTS:
+		enqueue_external_timestamp(&ptp->tsevq, event);
+		wake_up_interruptible(&ptp->tsev_wq);
+		break;
+
+	case PTP_CLOCK_PPS:
+		pps_get_ts(&evt);
+		pps_event(ptp->pps_source, &evt, PTP_PPS_EVENT, NULL);
+		break;
+	}
+}
+EXPORT_SYMBOL(ptp_clock_event);
+
+/* module operations */
+
+static void __exit ptp_exit(void)
+{
+	class_destroy(ptp_class);
+	unregister_chrdev_region(ptp_devt, PTP_MAX_CLOCKS);
+}
+
+static int __init ptp_init(void)
+{
+	int err;
+
+	ptp_class = class_create(THIS_MODULE, "ptp");
+	if (IS_ERR(ptp_class)) {
+		pr_err("ptp: failed to allocate class\n");
+		return PTR_ERR(ptp_class);
+	}
+
+	err = alloc_chrdev_region(&ptp_devt, 0, PTP_MAX_CLOCKS, "ptp");
+	if (err < 0) {
+		pr_err("ptp: failed to allocate device region\n");
+		goto no_region;
+	}
+
+	ptp_class->dev_attrs = ptp_dev_attrs;
+	pr_info("PTP clock support registered\n");
+	return 0;
+
+no_region:
+	class_destroy(ptp_class);
+	return err;
+}
+
+subsys_initcall(ptp_init);
+module_exit(ptp_exit);
+
+MODULE_AUTHOR("Richard Cochran <richard.cochran@omicron.at>");
+MODULE_DESCRIPTION("PTP clocks support");
+MODULE_LICENSE("GPL");
diff --git a/drivers/ptp/ptp_ixp46x.c b/drivers/ptp/ptp_ixp46x.c
new file mode 100644
index 0000000..803d665
--- /dev/null
+++ b/drivers/ptp/ptp_ixp46x.c
@@ -0,0 +1,332 @@
+/*
+ * PTP 1588 clock using the IXP46X
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/device.h>
+#include <linux/err.h>
+#include <linux/gpio.h>
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/io.h>
+#include <linux/irq.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+
+#include <linux/ptp_clock_kernel.h>
+#include <mach/ixp46x_ts.h>
+
+#define DRIVER		"ptp_ixp46x"
+#define N_EXT_TS	2
+#define MASTER_GPIO	8
+#define MASTER_IRQ	25
+#define SLAVE_GPIO	7
+#define SLAVE_IRQ	24
+
+struct ixp_clock {
+	struct ixp46x_ts_regs *regs;
+	struct ptp_clock *ptp_clock;
+	struct ptp_clock_info caps;
+	int exts0_enabled;
+	int exts1_enabled;
+};
+
+DEFINE_SPINLOCK(register_lock);
+
+/*
+ * Register access functions
+ */
+
+static u64 ixp_systime_read(struct ixp46x_ts_regs *regs)
+{
+	u64 ns;
+	u32 lo, hi;
+
+	lo = __raw_readl(&regs->systime_lo);
+	hi = __raw_readl(&regs->systime_hi);
+
+	ns = ((u64) hi) << 32;
+	ns |= lo;
+	ns <<= TICKS_NS_SHIFT;
+
+	return ns;
+}
+
+static void ixp_systime_write(struct ixp46x_ts_regs *regs, u64 ns)
+{
+	u32 hi, lo;
+
+	ns >>= TICKS_NS_SHIFT;
+	hi = ns >> 32;
+	lo = ns & 0xffffffff;
+
+	__raw_writel(lo, &regs->systime_lo);
+	__raw_writel(hi, &regs->systime_hi);
+}
+
+/*
+ * Interrupt service routine
+ */
+
+static irqreturn_t isr(int irq, void *priv)
+{
+	struct ixp_clock *ixp_clock = priv;
+	struct ixp46x_ts_regs *regs = ixp_clock->regs;
+	struct ptp_clock_event event;
+	u32 ack = 0, lo, hi, val;
+
+	val = __raw_readl(&regs->event);
+
+	if (val & TSER_SNS) {
+		ack |= TSER_SNS;
+		if (ixp_clock->exts0_enabled) {
+			hi = __raw_readl(&regs->asms_hi);
+			lo = __raw_readl(&regs->asms_lo);
+			event.type = PTP_CLOCK_EXTTS;
+			event.index = 0;
+			event.timestamp = ((u64) hi) << 32;
+			event.timestamp |= lo;
+			event.timestamp <<= TICKS_NS_SHIFT;
+			ptp_clock_event(ixp_clock->ptp_clock, &event);
+		}
+	}
+
+	if (val & TSER_SNM) {
+		ack |= TSER_SNM;
+		if (ixp_clock->exts1_enabled) {
+			hi = __raw_readl(&regs->amms_hi);
+			lo = __raw_readl(&regs->amms_lo);
+			event.type = PTP_CLOCK_EXTTS;
+			event.index = 1;
+			event.timestamp = ((u64) hi) << 32;
+			event.timestamp |= lo;
+			event.timestamp <<= TICKS_NS_SHIFT;
+			ptp_clock_event(ixp_clock->ptp_clock, &event);
+		}
+	}
+
+	if (val & TTIPEND)
+		ack |= TTIPEND; /* this bit seems to be always set */
+
+	if (ack) {
+		__raw_writel(ack, &regs->event);
+		return IRQ_HANDLED;
+	} else
+		return IRQ_NONE;
+}
+
+/*
+ * PTP clock operations
+ */
+
+static int ptp_ixp_adjfreq(struct ptp_clock_info *ptp, s32 ppb)
+{
+	u64 adj;
+	u32 diff, addend;
+	int neg_adj = 0;
+	struct ixp_clock *ixp_clock = container_of(ptp, struct ixp_clock, caps);
+	struct ixp46x_ts_regs *regs = ixp_clock->regs;
+
+	if (ppb < 0) {
+		neg_adj = 1;
+		ppb = -ppb;
+	}
+	addend = DEFAULT_ADDEND;
+	adj = addend;
+	adj *= ppb;
+	diff = div_u64(adj, 1000000000ULL);
+
+	addend = neg_adj ? addend - diff : addend + diff;
+
+	__raw_writel(addend, &regs->addend);
+
+	return 0;
+}
+
+static int ptp_ixp_adjtime(struct ptp_clock_info *ptp, s64 delta)
+{
+	s64 now;
+	unsigned long flags;
+	struct ixp_clock *ixp_clock = container_of(ptp, struct ixp_clock, caps);
+	struct ixp46x_ts_regs *regs = ixp_clock->regs;
+
+	spin_lock_irqsave(&register_lock, flags);
+
+	now = ixp_systime_read(regs);
+	now += delta;
+	ixp_systime_write(regs, now);
+
+	spin_unlock_irqrestore(&register_lock, flags);
+
+	return 0;
+}
+
+static int ptp_ixp_gettime(struct ptp_clock_info *ptp, struct timespec *ts)
+{
+	u64 ns;
+	u32 remainder;
+	unsigned long flags;
+	struct ixp_clock *ixp_clock = container_of(ptp, struct ixp_clock, caps);
+	struct ixp46x_ts_regs *regs = ixp_clock->regs;
+
+	spin_lock_irqsave(&register_lock, flags);
+
+	ns = ixp_systime_read(regs);
+
+	spin_unlock_irqrestore(&register_lock, flags);
+
+	ts->tv_sec = div_u64_rem(ns, 1000000000, &remainder);
+	ts->tv_nsec = remainder;
+	return 0;
+}
+
+static int ptp_ixp_settime(struct ptp_clock_info *ptp,
+			   const struct timespec *ts)
+{
+	u64 ns;
+	unsigned long flags;
+	struct ixp_clock *ixp_clock = container_of(ptp, struct ixp_clock, caps);
+	struct ixp46x_ts_regs *regs = ixp_clock->regs;
+
+	ns = ts->tv_sec * 1000000000ULL;
+	ns += ts->tv_nsec;
+
+	spin_lock_irqsave(&register_lock, flags);
+
+	ixp_systime_write(regs, ns);
+
+	spin_unlock_irqrestore(&register_lock, flags);
+
+	return 0;
+}
+
+static int ptp_ixp_enable(struct ptp_clock_info *ptp,
+			  struct ptp_clock_request *rq, int on)
+{
+	struct ixp_clock *ixp_clock = container_of(ptp, struct ixp_clock, caps);
+
+	switch (rq->type) {
+	case PTP_CLK_REQ_EXTTS:
+		switch (rq->extts.index) {
+		case 0:
+			ixp_clock->exts0_enabled = on ? 1 : 0;
+			break;
+		case 1:
+			ixp_clock->exts1_enabled = on ? 1 : 0;
+			break;
+		default:
+			return -EINVAL;
+		}
+		return 0;
+	default:
+		break;
+	}
+
+	return -EOPNOTSUPP;
+}
+
+static struct ptp_clock_info ptp_ixp_caps = {
+	.owner		= THIS_MODULE,
+	.name		= "IXP46X timer",
+	.max_adj	= 66666655,
+	.n_ext_ts	= N_EXT_TS,
+	.pps		= 0,
+	.adjfreq	= ptp_ixp_adjfreq,
+	.adjtime	= ptp_ixp_adjtime,
+	.gettime	= ptp_ixp_gettime,
+	.settime	= ptp_ixp_settime,
+	.enable		= ptp_ixp_enable,
+};
+
+/* module operations */
+
+static struct ixp_clock ixp_clock;
+
+static int setup_interrupt(int gpio)
+{
+	int irq;
+
+	gpio_line_config(gpio, IXP4XX_GPIO_IN);
+
+	irq = gpio_to_irq(gpio);
+
+	if (NO_IRQ == irq)
+		return NO_IRQ;
+
+	if (irq_set_irq_type(irq, IRQF_TRIGGER_FALLING)) {
+		pr_err("cannot set trigger type for irq %d\n", irq);
+		return NO_IRQ;
+	}
+
+	if (request_irq(irq, isr, 0, DRIVER, &ixp_clock)) {
+		pr_err("request_irq failed for irq %d\n", irq);
+		return NO_IRQ;
+	}
+
+	return irq;
+}
+
+static void __exit ptp_ixp_exit(void)
+{
+	free_irq(MASTER_IRQ, &ixp_clock);
+	free_irq(SLAVE_IRQ, &ixp_clock);
+	ptp_clock_unregister(ixp_clock.ptp_clock);
+}
+
+static int __init ptp_ixp_init(void)
+{
+	if (!cpu_is_ixp46x())
+		return -ENODEV;
+
+	ixp_clock.regs =
+		(struct ixp46x_ts_regs __iomem *) IXP4XX_TIMESYNC_BASE_VIRT;
+
+	ixp_clock.caps = ptp_ixp_caps;
+
+	ixp_clock.ptp_clock = ptp_clock_register(&ixp_clock.caps);
+
+	if (IS_ERR(ixp_clock.ptp_clock))
+		return PTR_ERR(ixp_clock.ptp_clock);
+
+	__raw_writel(DEFAULT_ADDEND, &ixp_clock.regs->addend);
+	__raw_writel(1, &ixp_clock.regs->trgt_lo);
+	__raw_writel(0, &ixp_clock.regs->trgt_hi);
+	__raw_writel(TTIPEND, &ixp_clock.regs->event);
+
+	if (MASTER_IRQ != setup_interrupt(MASTER_GPIO)) {
+		pr_err("failed to setup gpio %d as irq\n", MASTER_GPIO);
+		goto no_master;
+	}
+	if (SLAVE_IRQ != setup_interrupt(SLAVE_GPIO)) {
+		pr_err("failed to setup gpio %d as irq\n", SLAVE_GPIO);
+		goto no_slave;
+	}
+
+	return 0;
+no_slave:
+	free_irq(MASTER_IRQ, &ixp_clock);
+no_master:
+	ptp_clock_unregister(ixp_clock.ptp_clock);
+	return -ENODEV;
+}
+
+module_init(ptp_ixp_init);
+module_exit(ptp_ixp_exit);
+
+MODULE_AUTHOR("Richard Cochran <richard.cochran@omicron.at>");
+MODULE_DESCRIPTION("PTP clock using the IXP46X timer");
+MODULE_LICENSE("GPL");
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
new file mode 100644
index 0000000..4d5b508
--- /dev/null
+++ b/drivers/ptp/ptp_private.h
@@ -0,0 +1,92 @@
+/*
+ * PTP 1588 clock support - private declarations for the core module.
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#ifndef _PTP_PRIVATE_H_
+#define _PTP_PRIVATE_H_
+
+#include <linux/cdev.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/posix-clock.h>
+#include <linux/ptp_clock.h>
+#include <linux/ptp_clock_kernel.h>
+#include <linux/time.h>
+
+#define PTP_MAX_TIMESTAMPS 128
+#define PTP_BUF_TIMESTAMPS 30
+
+struct timestamp_event_queue {
+	struct ptp_extts_event buf[PTP_MAX_TIMESTAMPS];
+	int head;
+	int tail;
+	spinlock_t lock;
+};
+
+struct ptp_clock {
+	struct posix_clock clock;
+	struct device *dev;
+	struct ptp_clock_info *info;
+	dev_t devid;
+	int index; /* index into clocks.map */
+	struct pps_device *pps_source;
+	struct timestamp_event_queue tsevq; /* simple fifo for time stamps */
+	struct mutex tsevq_mux; /* one process at a time reading the fifo */
+	wait_queue_head_t tsev_wq;
+	int defunct; /* tells readers to go away when clock is being removed */
+};
+
+/*
+ * The function queue_cnt() is safe for readers to call without
+ * holding q->lock. Readers use this function to verify that the queue
+ * is nonempty before proceeding with a dequeue operation. The fact
+ * that a writer might concurrently increment the tail does not
+ * matter, since the queue remains nonempty nonetheless.
+ */
+static inline int queue_cnt(struct timestamp_event_queue *q)
+{
+	int cnt = q->tail - q->head;
+	return cnt < 0 ? PTP_MAX_TIMESTAMPS + cnt : cnt;
+}
+
+/*
+ * see ptp_chardev.c
+ */
+
+long ptp_ioctl(struct posix_clock *pc,
+	       unsigned int cmd, unsigned long arg);
+
+int ptp_open(struct posix_clock *pc, fmode_t fmode);
+
+ssize_t ptp_read(struct posix_clock *pc,
+		 uint flags, char __user *buf, size_t cnt);
+
+uint ptp_poll(struct posix_clock *pc,
+	      struct file *fp, poll_table *wait);
+
+/*
+ * see ptp_sysfs.c
+ */
+
+extern struct device_attribute ptp_dev_attrs[];
+
+int ptp_cleanup_sysfs(struct ptp_clock *ptp);
+
+int ptp_populate_sysfs(struct ptp_clock *ptp);
+
+#endif
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
new file mode 100644
index 0000000..2f93926
--- /dev/null
+++ b/drivers/ptp/ptp_sysfs.c
@@ -0,0 +1,230 @@
+/*
+ * PTP 1588 clock support - sysfs interface.
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+#include <linux/capability.h>
+
+#include "ptp_private.h"
+
+static ssize_t clock_name_show(struct device *dev,
+			       struct device_attribute *attr, char *page)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	return snprintf(page, PAGE_SIZE-1, "%s\n", ptp->info->name);
+}
+
+#define PTP_SHOW_INT(name)						\
+static ssize_t name##_show(struct device *dev,				\
+			   struct device_attribute *attr, char *page)	\
+{									\
+	struct ptp_clock *ptp = dev_get_drvdata(dev);			\
+	return snprintf(page, PAGE_SIZE-1, "%d\n", ptp->info->name);	\
+}
+
+PTP_SHOW_INT(max_adj);
+PTP_SHOW_INT(n_alarm);
+PTP_SHOW_INT(n_ext_ts);
+PTP_SHOW_INT(n_per_out);
+PTP_SHOW_INT(pps);
+
+#define PTP_RO_ATTR(_var, _name) {				\
+	.attr	= { .name = __stringify(_name), .mode = 0444 },	\
+	.show	= _var##_show,					\
+}
+
+struct device_attribute ptp_dev_attrs[] = {
+	PTP_RO_ATTR(clock_name,	clock_name),
+	PTP_RO_ATTR(max_adj,	max_adjustment),
+	PTP_RO_ATTR(n_alarm,	n_alarms),
+	PTP_RO_ATTR(n_ext_ts,	n_external_timestamps),
+	PTP_RO_ATTR(n_per_out,	n_periodic_outputs),
+	PTP_RO_ATTR(pps,	pps_available),
+	__ATTR_NULL,
+};
+
+static ssize_t extts_enable_store(struct device *dev,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_clock_info *ops = ptp->info;
+	struct ptp_clock_request req = { .type = PTP_CLK_REQ_EXTTS };
+	int cnt, enable;
+	int err = -EINVAL;
+
+	cnt = sscanf(buf, "%u %d", &req.extts.index, &enable);
+	if (cnt != 2)
+		goto out;
+	if (req.extts.index >= ops->n_ext_ts)
+		goto out;
+
+	err = ops->enable(ops, &req, enable ? 1 : 0);
+	if (err)
+		goto out;
+
+	return count;
+out:
+	return err;
+}
+
+static ssize_t extts_fifo_show(struct device *dev,
+			       struct device_attribute *attr, char *page)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct timestamp_event_queue *queue = &ptp->tsevq;
+	struct ptp_extts_event event;
+	unsigned long flags;
+	size_t qcnt;
+	int cnt = 0;
+
+	memset(&event, 0, sizeof(event));
+
+	if (mutex_lock_interruptible(&ptp->tsevq_mux))
+		return -ERESTARTSYS;
+
+	spin_lock_irqsave(&queue->lock, flags);
+	qcnt = queue_cnt(queue);
+	if (qcnt) {
+		event = queue->buf[queue->head];
+		queue->head = (queue->head + 1) % PTP_MAX_TIMESTAMPS;
+	}
+	spin_unlock_irqrestore(&queue->lock, flags);
+
+	if (!qcnt)
+		goto out;
+
+	cnt = snprintf(page, PAGE_SIZE, "%u %lld %u\n",
+		       event.index, event.t.sec, event.t.nsec);
+out:
+	mutex_unlock(&ptp->tsevq_mux);
+	return cnt;
+}
+
+static ssize_t period_store(struct device *dev,
+			    struct device_attribute *attr,
+			    const char *buf, size_t count)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_clock_info *ops = ptp->info;
+	struct ptp_clock_request req = { .type = PTP_CLK_REQ_PEROUT };
+	int cnt, enable, err = -EINVAL;
+
+	cnt = sscanf(buf, "%u %lld %u %lld %u", &req.perout.index,
+		     &req.perout.start.sec, &req.perout.start.nsec,
+		     &req.perout.period.sec, &req.perout.period.nsec);
+	if (cnt != 5)
+		goto out;
+	if (req.perout.index >= ops->n_per_out)
+		goto out;
+
+	enable = req.perout.period.sec || req.perout.period.nsec;
+	err = ops->enable(ops, &req, enable);
+	if (err)
+		goto out;
+
+	return count;
+out:
+	return err;
+}
+
+static ssize_t pps_enable_store(struct device *dev,
+				struct device_attribute *attr,
+				const char *buf, size_t count)
+{
+	struct ptp_clock *ptp = dev_get_drvdata(dev);
+	struct ptp_clock_info *ops = ptp->info;
+	struct ptp_clock_request req = { .type = PTP_CLK_REQ_PPS };
+	int cnt, enable;
+	int err = -EINVAL;
+
+	if (!capable(CAP_SYS_TIME))
+		return -EPERM;
+
+	cnt = sscanf(buf, "%d", &enable);
+	if (cnt != 1)
+		goto out;
+
+	err = ops->enable(ops, &req, enable ? 1 : 0);
+	if (err)
+		goto out;
+
+	return count;
+out:
+	return err;
+}
+
+static DEVICE_ATTR(extts_enable, 0220, NULL, extts_enable_store);
+static DEVICE_ATTR(fifo,         0444, extts_fifo_show, NULL);
+static DEVICE_ATTR(period,       0220, NULL, period_store);
+static DEVICE_ATTR(pps_enable,   0220, NULL, pps_enable_store);
+
+int ptp_cleanup_sysfs(struct ptp_clock *ptp)
+{
+	struct device *dev = ptp->dev;
+	struct ptp_clock_info *info = ptp->info;
+
+	if (info->n_ext_ts) {
+		device_remove_file(dev, &dev_attr_extts_enable);
+		device_remove_file(dev, &dev_attr_fifo);
+	}
+	if (info->n_per_out)
+		device_remove_file(dev, &dev_attr_period);
+
+	if (info->pps)
+		device_remove_file(dev, &dev_attr_pps_enable);
+
+	return 0;
+}
+
+int ptp_populate_sysfs(struct ptp_clock *ptp)
+{
+	struct device *dev = ptp->dev;
+	struct ptp_clock_info *info = ptp->info;
+	int err;
+
+	if (info->n_ext_ts) {
+		err = device_create_file(dev, &dev_attr_extts_enable);
+		if (err)
+			goto out1;
+		err = device_create_file(dev, &dev_attr_fifo);
+		if (err)
+			goto out2;
+	}
+	if (info->n_per_out) {
+		err = device_create_file(dev, &dev_attr_period);
+		if (err)
+			goto out3;
+	}
+	if (info->pps) {
+		err = device_create_file(dev, &dev_attr_pps_enable);
+		if (err)
+			goto out4;
+	}
+	return 0;
+out4:
+	if (info->n_per_out)
+		device_remove_file(dev, &dev_attr_period);
+out3:
+	if (info->n_ext_ts)
+		device_remove_file(dev, &dev_attr_fifo);
+out2:
+	if (info->n_ext_ts)
+		device_remove_file(dev, &dev_attr_extts_enable);
+out1:
+	return err;
+}
diff --git a/include/linux/Kbuild b/include/linux/Kbuild
index 75cf611..4585836 100644
--- a/include/linux/Kbuild
+++ b/include/linux/Kbuild
@@ -302,6 +302,7 @@ header-y += ppp-comp.h
 header-y += ppp_defs.h
 header-y += pps.h
 header-y += prctl.h
+header-y += ptp_clock.h
 header-y += ptrace.h
 header-y += qnx4_fs.h
 header-y += qnxtypes.h
diff --git a/include/linux/ptp_classify.h b/include/linux/ptp_classify.h
index 943a85a..e07e274 100644
--- a/include/linux/ptp_classify.h
+++ b/include/linux/ptp_classify.h
@@ -25,6 +25,7 @@
 
 #include <linux/if_ether.h>
 #include <linux/if_vlan.h>
+#include <linux/ip.h>
 #include <linux/filter.h>
 #ifdef __KERNEL__
 #include <linux/in.h>
@@ -58,6 +59,12 @@
 #define OFF_NEXT	6
 #define OFF_UDP_DST	2
 
+#define OFF_PTP_SOURCE_UUID	22 /* PTPv1 only */
+#define OFF_PTP_SEQUENCE_ID	30
+#define OFF_PTP_CONTROL		32 /* PTPv1 only */
+
+#define IPV4_HLEN(data) (((struct iphdr *)(data + OFF_IHL))->ihl << 2)
+
 #define IP6_HLEN	40
 #define UDP_HLEN	8
 
diff --git a/include/linux/ptp_clock.h b/include/linux/ptp_clock.h
new file mode 100644
index 0000000..94e981f
--- /dev/null
+++ b/include/linux/ptp_clock.h
@@ -0,0 +1,84 @@
+/*
+ * PTP 1588 clock support - user space interface
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _PTP_CLOCK_H_
+#define _PTP_CLOCK_H_
+
+#include <linux/ioctl.h>
+#include <linux/types.h>
+
+/* PTP_xxx bits, for the flags field within the request structures. */
+#define PTP_ENABLE_FEATURE (1<<0)
+#define PTP_RISING_EDGE    (1<<1)
+#define PTP_FALLING_EDGE   (1<<2)
+
+/*
+ * struct ptp_clock_time - represents a time value
+ *
+ * The sign of the seconds field applies to the whole value. The
+ * nanoseconds field is always unsigned. The reserved field is
+ * included for sub-nanosecond resolution, should the demand for
+ * this ever appear.
+ *
+ */
+struct ptp_clock_time {
+	__s64 sec;  /* seconds */
+	__u32 nsec; /* nanoseconds */
+	__u32 reserved;
+};
+
+struct ptp_clock_caps {
+	int max_adj;   /* Maximum frequency adjustment in parts per billon. */
+	int n_alarm;   /* Number of programmable alarms. */
+	int n_ext_ts;  /* Number of external time stamp channels. */
+	int n_per_out; /* Number of programmable periodic signals. */
+	int pps;       /* Whether the clock supports a PPS callback. */
+	int rsv[15];   /* Reserved for future use. */
+};
+
+struct ptp_extts_request {
+	unsigned int index;  /* Which channel to configure. */
+	unsigned int flags;  /* Bit field for PTP_xxx flags. */
+	unsigned int rsv[2]; /* Reserved for future use. */
+};
+
+struct ptp_perout_request {
+	struct ptp_clock_time start;  /* Absolute start time. */
+	struct ptp_clock_time period; /* Desired period, zero means disable. */
+	unsigned int index;           /* Which channel to configure. */
+	unsigned int flags;           /* Reserved for future use. */
+	unsigned int rsv[4];          /* Reserved for future use. */
+};
+
+#define PTP_CLK_MAGIC '='
+
+#define PTP_CLOCK_GETCAPS  _IOR(PTP_CLK_MAGIC, 1, struct ptp_clock_caps)
+#define PTP_EXTTS_REQUEST  _IOW(PTP_CLK_MAGIC, 2, struct ptp_extts_request)
+#define PTP_PEROUT_REQUEST _IOW(PTP_CLK_MAGIC, 3, struct ptp_perout_request)
+#define PTP_ENABLE_PPS     _IOW(PTP_CLK_MAGIC, 4, int)
+
+struct ptp_extts_event {
+	struct ptp_clock_time t; /* Time event occured. */
+	unsigned int index;      /* Which channel produced the event. */
+	unsigned int flags;      /* Reserved for future use. */
+	unsigned int rsv[2];     /* Reserved for future use. */
+};
+
+#endif
diff --git a/include/linux/ptp_clock_kernel.h b/include/linux/ptp_clock_kernel.h
new file mode 100644
index 0000000..dd2e44f
--- /dev/null
+++ b/include/linux/ptp_clock_kernel.h
@@ -0,0 +1,139 @@
+/*
+ * PTP 1588 clock support
+ *
+ * Copyright (C) 2010 OMICRON electronics GmbH
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; either version 2 of the License, or
+ *  (at your option) any later version.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ *  GNU General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License
+ *  along with this program; if not, write to the Free Software
+ *  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+ */
+
+#ifndef _PTP_CLOCK_KERNEL_H_
+#define _PTP_CLOCK_KERNEL_H_
+
+#include <linux/ptp_clock.h>
+
+
+struct ptp_clock_request {
+	enum {
+		PTP_CLK_REQ_EXTTS,
+		PTP_CLK_REQ_PEROUT,
+		PTP_CLK_REQ_PPS,
+	} type;
+	union {
+		struct ptp_extts_request extts;
+		struct ptp_perout_request perout;
+	};
+};
+
+/**
+ * struct ptp_clock_info - decribes a PTP hardware clock
+ *
+ * @owner:     The clock driver should set to THIS_MODULE.
+ * @name:      A short name to identify the clock.
+ * @max_adj:   The maximum possible frequency adjustment, in parts per billon.
+ * @n_alarm:   The number of programmable alarms.
+ * @n_ext_ts:  The number of external time stamp channels.
+ * @n_per_out: The number of programmable periodic signals.
+ * @pps:       Indicates whether the clock supports a PPS callback.
+ *
+ * clock operations
+ *
+ * @adjfreq:  Adjusts the frequency of the hardware clock.
+ *            parameter delta: Desired period change in parts per billion.
+ *
+ * @adjtime:  Shifts the time of the hardware clock.
+ *            parameter delta: Desired change in nanoseconds.
+ *
+ * @gettime:  Reads the current time from the hardware clock.
+ *            parameter ts: Holds the result.
+ *
+ * @settime:  Set the current time on the hardware clock.
+ *            parameter ts: Time value to set.
+ *
+ * @enable:   Request driver to enable or disable an ancillary feature.
+ *            parameter request: Desired resource to enable or disable.
+ *            parameter on: Caller passes one to enable or zero to disable.
+ *
+ * Drivers should embed their ptp_clock_info within a private
+ * structure, obtaining a reference to it using container_of().
+ *
+ * The callbacks must all return zero on success, non-zero otherwise.
+ */
+
+struct ptp_clock_info {
+	struct module *owner;
+	char name[16];
+	s32 max_adj;
+	int n_alarm;
+	int n_ext_ts;
+	int n_per_out;
+	int pps;
+	int (*adjfreq)(struct ptp_clock_info *ptp, s32 delta);
+	int (*adjtime)(struct ptp_clock_info *ptp, s64 delta);
+	int (*gettime)(struct ptp_clock_info *ptp, struct timespec *ts);
+	int (*settime)(struct ptp_clock_info *ptp, const struct timespec *ts);
+	int (*enable)(struct ptp_clock_info *ptp,
+		      struct ptp_clock_request *request, int on);
+};
+
+struct ptp_clock;
+
+/**
+ * ptp_clock_register() - register a PTP hardware clock driver
+ *
+ * @info:  Structure describing the new clock.
+ */
+
+extern struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info);
+
+/**
+ * ptp_clock_unregister() - unregister a PTP hardware clock driver
+ *
+ * @ptp:  The clock to remove from service.
+ */
+
+extern int ptp_clock_unregister(struct ptp_clock *ptp);
+
+
+enum ptp_clock_events {
+	PTP_CLOCK_ALARM,
+	PTP_CLOCK_EXTTS,
+	PTP_CLOCK_PPS,
+};
+
+/**
+ * struct ptp_clock_event - decribes a PTP hardware clock event
+ *
+ * @type:  One of the ptp_clock_events enumeration values.
+ * @index: Identifies the source of the event.
+ * @timestamp: When the event occured.
+ */
+
+struct ptp_clock_event {
+	int type;
+	int index;
+	u64 timestamp;
+};
+
+/**
+ * ptp_clock_event() - notify the PTP layer about an event
+ *
+ * @ptp:    The clock obtained from ptp_clock_register().
+ * @event:  Message structure describing the event.
+ */
+
+extern void ptp_clock_event(struct ptp_clock *ptp,
+			    struct ptp_clock_event *event);
+
+#endif
