Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1HUOEc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Aug 2011 10:04:32 -0400
Received: from router-fw.net-space.pl ([89.174.63.77]:51373 "EHLO
	router-fw.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603Ab1HUOEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Aug 2011 10:04:25 -0400
X-Greylist: delayed 733 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Aug 2011 10:04:21 EDT
Date: Sun, 21 Aug 2011 15:54:59 +0200
From: Daniel Kiper <dkiper@net-space.pl>
To: konrad.wilk@oracle.com, ian.campbell@citrix.com, vgoyal@redhat.com,
        horms@verge.net.au, olaf@aepfle.de, kexec@lists.infradead.org,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] kexec/arch/i386: Add get_memory_ranges_xen() function
Message-ID: <20110821135459.GE17323@router-fw-old.local.net-space.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.3.28i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

get_memory_ranges_sysfs() and get_memory_ranges_proc_iomem()
are unreliable under Xen. Proper machine memory map could be
obtained under Xen by calling __HYPERVISOR_memory_op hypercall
with XENMEM_machine_memory_map argument. get_memory_ranges_xen()
does that. It is implemented using ioctl() or libxenctrl interface.
This solution is compatible with 3.x and 4.x Xen versions.

Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
---
 configure.ac                       |    3 +
 kexec/arch/i386/kexec-x86-common.c |  203 ++++++++++++++++++++++++++++++++++--
 2 files changed, 197 insertions(+), 9 deletions(-)

diff --git a/configure.ac b/configure.ac
index 172a52a..0d09bba 100644
--- a/configure.ac
+++ b/configure.ac
@@ -157,6 +157,9 @@ if test "$with_xen" = yes ; then
 	AC_CHECK_HEADER(xenctrl.h,
 		AC_CHECK_LIB(xenctrl, xc_version, ,
 		AC_MSG_NOTICE([Xen support disabled])))
+	if test "$ac_cv_lib_xenctrl_xc_version" = yes ; then
+		AC_CHECK_FUNCS(xc_get_machine_memory_map)
+	fi
 fi
 
 dnl ---Sanity checks
diff --git a/kexec/arch/i386/kexec-x86-common.c b/kexec/arch/i386/kexec-x86-common.c
index 8f59c6c..609d35d 100644
--- a/kexec/arch/i386/kexec-x86-common.c
+++ b/kexec/arch/i386/kexec-x86-common.c
@@ -17,6 +17,10 @@
  * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
  */
 
+#define _XOPEN_SOURCE	600
+#define _BSD_SOURCE
+
+#include <fcntl.h>
 #include <stddef.h>
 #include <stdio.h>
 #include <errno.h>
@@ -24,12 +28,29 @@
 #include <string.h>
 #include <limits.h>
 #include <stdlib.h>
+#include <stdio.h>
+#include <sys/ioctl.h>
+#include <sys/mman.h>
+#include <sys/stat.h>
+#include <unistd.h>
 #include "../../kexec.h"
 #include "../../kexec-syscall.h"
 #include "../../firmware_memmap.h"
 #include "../../crashdump.h"
 #include "kexec-x86.h"
 
+#ifdef HAVE_LIBXENCTRL
+#ifdef HAVE_XC_GET_MACHINE_MEMORY_MAP
+#include <xenctrl.h>
+#else
+#define __XEN_TOOLS__	1
+#include <x86/x86-linux.h>
+#include <xen/xen.h>
+#include <xen/memory.h>
+#include <xen/sys/privcmd.h>
+#endif /* HAVE_XC_GET_MACHINE_MEMORY_MAP */
+#endif /* HAVE_LIBXENCTRL */
+
 static struct memory_range memory_range[MAX_MEMORY_RANGES];
 
 /**
@@ -129,6 +150,172 @@ static int get_memory_ranges_sysfs(struct memory_range **range, int *ranges)
 	return 0;
 }
 
+#ifdef HAVE_LIBXENCTRL
+static unsigned e820_to_kexec_type(uint32_t type)
+{
+	switch (type) {
+		case E820_RAM:
+			return RANGE_RAM;
+		case E820_ACPI:
+			return RANGE_ACPI;
+		case E820_NVS:
+			return RANGE_ACPI_NVS;
+		case E820_RESERVED:
+		default:
+			return RANGE_RESERVED;
+	}
+}
+
+/**
+ * Memory map detection for Xen.
+ *
+ * @param[out] range pointer that will be set to an array that holds the
+ *             memory ranges
+ * @param[out] ranges number of ranges valid in @p range
+ *
+ * @return 0 on success, any other value on failure.
+ */
+#ifdef HAVE_XC_GET_MACHINE_MEMORY_MAP
+static int get_memory_ranges_xen(struct memory_range **range, int *ranges)
+{
+	int rc, ret = -1;
+	struct e820entry e820entries[MAX_MEMORY_RANGES];
+	unsigned int i;
+#ifdef XENCTRL_HAS_XC_INTERFACE
+	xc_interface *xc;
+#else
+	int xc;
+#endif
+
+#ifdef XENCTRL_HAS_XC_INTERFACE
+	xc = xc_interface_open(NULL, NULL, 0);
+
+	if (!xc) {
+		fprintf(stderr, "%s: Failed to open Xen control interface\n", __func__);
+		goto err;
+	}
+#else
+	xc = xc_interface_open();
+
+	if (xc == -1) {
+		fprintf(stderr, "%s: Failed to open Xen control interface\n", __func__);
+		goto err;
+	}
+#endif
+
+	rc = xc_get_machine_memory_map(xc, e820entries, MAX_MEMORY_RANGES);
+
+	if (rc < 0) {
+		fprintf(stderr, "%s: xc_get_machine_memory_map: %s\n", __func__, strerror(rc));
+		goto err;
+	}
+
+	for (i = 0; i < rc; ++i) {
+		memory_range[i].start = e820entries[i].addr;
+		memory_range[i].end = e820entries[i].addr + e820entries[i].size;
+		memory_range[i].type = e820_to_kexec_type(e820entries[i].type);
+	}
+
+	qsort(memory_range, rc, sizeof(struct memory_range), compare_ranges);
+
+	*range = memory_range;
+	*ranges = rc;
+
+	ret = 0;
+
+err:
+	xc_interface_close(xc);
+
+	return ret;
+}
+#else
+static int get_memory_ranges_xen(struct memory_range **range, int *ranges)
+{
+	int fd, rc, ret = -1;
+	privcmd_hypercall_t hypercall;
+	struct e820entry *e820entries = NULL;
+	struct xen_memory_map *xen_memory_map = NULL;
+	unsigned int i;
+
+	fd = open("/proc/xen/privcmd", O_RDWR);
+
+	if (fd == -1) {
+		fprintf(stderr, "%s: open(/proc/xen/privcmd): %m\n", __func__);
+		goto err;
+	}
+
+	rc = posix_memalign((void **)&e820entries, sysconf(_SC_PAGESIZE),
+			    sizeof(struct e820entry) * MAX_MEMORY_RANGES);
+
+	if (rc) {
+		fprintf(stderr, "%s: posix_memalign(e820entries): %s\n", __func__, strerror(rc));
+		e820entries = NULL;
+		goto err;
+	}
+
+	rc = posix_memalign((void **)&xen_memory_map, sysconf(_SC_PAGESIZE),
+			    sizeof(struct xen_memory_map));
+
+	if (rc) {
+		fprintf(stderr, "%s: posix_memalign(xen_memory_map): %s\n", __func__, strerror(rc));
+		xen_memory_map = NULL;
+		goto err;
+	}
+
+	if (mlock(e820entries, sizeof(struct e820entry) * MAX_MEMORY_RANGES) == -1) {
+		fprintf(stderr, "%s: mlock(e820entries): %m\n", __func__);
+		goto err;
+	}
+
+	if (mlock(xen_memory_map, sizeof(struct xen_memory_map)) == -1) {
+		fprintf(stderr, "%s: mlock(xen_memory_map): %m\n", __func__);
+		goto err;
+	}
+
+	xen_memory_map->nr_entries = MAX_MEMORY_RANGES;
+	set_xen_guest_handle(xen_memory_map->buffer, e820entries);
+
+	hypercall.op = __HYPERVISOR_memory_op;
+	hypercall.arg[0] = XENMEM_machine_memory_map;
+	hypercall.arg[1] = (__u64)xen_memory_map;
+
+	rc = ioctl(fd, IOCTL_PRIVCMD_HYPERCALL, &hypercall);
+
+	if (rc == -1) {
+		fprintf(stderr, "%s: ioctl(IOCTL_PRIVCMD_HYPERCALL): %m\n", __func__);
+		goto err;
+	}
+
+	for (i = 0; i < xen_memory_map->nr_entries; ++i) {
+		memory_range[i].start = e820entries[i].addr;
+		memory_range[i].end = e820entries[i].addr + e820entries[i].size;
+		memory_range[i].type = e820_to_kexec_type(e820entries[i].type);
+	}
+
+	qsort(memory_range, xen_memory_map->nr_entries, sizeof(struct memory_range), compare_ranges);
+
+	*range = memory_range;
+	*ranges = xen_memory_map->nr_entries;
+
+	ret = 0;
+
+err:
+	munlock(xen_memory_map, sizeof(struct xen_memory_map));
+	munlock(e820entries, sizeof(struct e820entry) * MAX_MEMORY_RANGES);
+	free(xen_memory_map);
+	free(e820entries);
+	close(fd);
+
+	return ret;
+}
+#endif /* HAVE_XC_GET_MACHINE_MEMORY_MAP */
+#else
+static int get_memory_ranges_xen(struct memory_range **range, int *ranges)
+{
+	return 0;
+}
+#endif /* HAVE_LIBXENCTRL */
+
 static void remove_range(struct memory_range *range, int nr_ranges, int index)
 {
 	int i, j;
@@ -242,23 +429,21 @@ int get_memory_ranges(struct memory_range **range, int *ranges,
 {
 	int ret, i;
 
-	/*
-	 * When using Xen, /sys/firmware/memmap (i.e., the E820 map) is
-	 * wrong, it just provides one large memory are and that cannot
-	 * be used for Kdump. Use always the /proc/iomem interface there
-	 * even if we have /sys/firmware/memmap. Without that, /proc/vmcore
-	 * is empty in the kdump kernel.
-	 */
 	if (!efi_map_added() && !xen_present() && have_sys_firmware_memmap()) {
 		ret = get_memory_ranges_sysfs(range, ranges);
 		if (!ret)
 			ret = fixup_memory_ranges(range, ranges);
+	} else if (xen_present()) {
+		ret = get_memory_ranges_xen(range, ranges);
+		if (!ret)
+			ret = fixup_memory_ranges(range, ranges);
 	} else
 		ret = get_memory_ranges_proc_iomem(range, ranges);
 
 	/*
-	 * both get_memory_ranges_sysfs() and get_memory_ranges_proc_iomem()
-	 * have already printed an error message, so fail silently here
+	 * get_memory_ranges_sysfs(), get_memory_ranges_proc_iomem() and
+	 * get_memory_ranges_xen() have already printed an error message,
+	 * so fail silently here.
 	 */
 	if (ret != 0)
 		return ret;
-- 
1.5.6.5
