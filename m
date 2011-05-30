Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab1E3GaW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 02:30:22 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:34130 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995Ab1E3GaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 02:30:20 -0400
Message-ID: <4DE3396E.4090801@in.ibm.com>
Date: Mon, 30 May 2011 12:00:06 +0530
From: Suzuki Poulose <suzuki@in.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc14 Thunderbird/3.1.10
MIME-Version: 1.0
To: "kexec@lists.infradead.org" <kexec@lists.infradead.org>,
        Simon Horman <horms@verge.net.au>
CC: linux ppc dev <linuxppc-dev@lists.ozlabs.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: [RFC][PATCH] powerpc: Use the #address-cells information to parse
 memory/reg
References: <4DC923C4.6080707@in.ibm.com> <4DC92784.2040001@in.ibm.com> <20110510134152.GB18537@in.ibm.com> <4DCA285D.2080006@in.ibm.com>
In-Reply-To: <4DCA285D.2080006@in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the #address-cells, #size-cells information to parse the memory/reg info
from  device tree.

The format of memory/reg is based on the #address-cells,#size-cells. Currently,
the kexec-tools doesn't use the above values in parsing the memory/reg values.
Hence the kexec cannot handle cases where #address-cells, #size-cells are
different, (for e.g, PPC440X ).

This patch introduces a read_memory_region_limits(), which parses the
memory/reg contents based on the values of #address-cells and #size-cells.

Changed the add_usable_mem_property() to accept FILE* fp instead of int fd,
as most of the other users of read_memory_region_limits() deals with FILE*.

Signed-off-by: Suzuki K. Poulose <suzuki@in.ibm.com>

---
  kexec/arch/ppc/crashdump-powerpc.c |   23 ------
  kexec/arch/ppc/fs2dt.c             |   31 ++------
  kexec/arch/ppc/kexec-ppc.c         |  136 ++++++++++++++++++++++++++-----------
  kexec/arch/ppc/kexec-ppc.h         |    6 +
  4 files changed, 118 insertions(+), 78 deletions(-)

Index: kexec-tools-2.0.4/kexec/arch/ppc/kexec-ppc.c
===================================================================
--- kexec-tools-2.0.4.orig/kexec/arch/ppc/kexec-ppc.c
+++ kexec-tools-2.0.4/kexec/arch/ppc/kexec-ppc.c
@@ -26,6 +26,7 @@
  
  #include "config.h"
  
+unsigned long dt_address_cells = 0, dt_size_cells = 0;
  uint64_t rmo_top;
  unsigned long long crash_base = 0, crash_size = 0;
  unsigned long long initrd_base = 0, initrd_size = 0;
@@ -34,6 +35,92 @@ unsigned int rtas_base, rtas_size;
  int max_memory_ranges;
  const char *ramdisk;
  
+/*
+ * Reads the #address-cells and #size-cells on this platform.
+ * This is used to parse the memory/reg info from the device-tree
+ */
+int init_memory_region_info()
+{
+	size_t res = 0;
+	FILE *fp;
+	char *file;
+
+	file = "/proc/device-tree/#address-cells";
+	fp = fopen(file, "r");
+	if (!fp) {
+		fprintf(stderr,"Unable to open %s\n", file);
+		return -1;
+	}
+
+	res = fread(&dt_address_cells,sizeof(unsigned long),1,fp);
+	if (res != 1) {
+		fprintf(stderr,"Error reading %s\n", file);
+		return -1;
+	}
+	fclose(fp);
+	dt_address_cells *= sizeof(unsigned long);
+
+	file = "/proc/device-tree/#size-cells";
+	fp = fopen(file, "r");
+	if (!fp) {
+		fprintf(stderr,"Unable to open %s\n", file);
+		return -1;
+	}
+
+	res = fread(&dt_size_cells,sizeof(unsigned long),1,fp);
+	if (res != 1) {
+		fprintf(stderr,"Error reading %s\n", file);
+		return -1;
+	}
+	fclose(fp);
+	dt_size_cells *= sizeof(unsigned long);
+
+	return 0;
+}
+
+#define MAXBYTES 128
+/*
+ * Reads the memory region info from the device-tree node pointed
+ * by @fp and fills the *start, *end with the boundaries of the region
+ */
+int read_memory_region_limits(FILE* fp, unsigned long long *start,
+				unsigned long long *end)
+{
+	char buf[MAXBYTES];
+	unsigned long *p;
+	unsigned long nbytes = dt_address_cells + dt_size_cells;
+
+	if (fread(buf, 1, MAXBYTES, fp) != nbytes) {
+		fprintf(stderr, "Error reading the memory region info\n");
+		return -1;
+	}
+
+	p = (unsigned long*)buf;
+	if (dt_address_cells == sizeof(unsigned long)) {
+		*start = p[0];
+		p++;
+	} else if (dt_address_cells == sizeof(unsigned long long)) {
+		*start = ((unsigned long long *)p)[0];
+		p = (unsigned long long *)p + 1;
+	} else {
+		fprintf(stderr,"Unsupported value for #address-cells : %ld\n",
+					dt_address_cells);
+		return -1;
+	}
+
+	if (dt_size_cells == sizeof(unsigned long))
+		*end = *start + p[0];
+	else if (dt_size_cells == sizeof(unsigned long long))
+		*end = *start + ((unsigned long long *)p)[0];
+	else {
+		fprintf(stderr,"Unsupported value for #size-cells : %ld\n",
+					dt_size_cells);
+		return -1;
+	}
+
+	return 0;
+}
+
  void arch_reuse_initrd(void)
  {
  	reuse_initrd = 1;
@@ -182,9 +269,6 @@ static int sort_base_ranges(void)
  	return 0;
  }
  
-
-#define MAXBYTES 128
-
  static int realloc_memory_ranges(void)
  {
  	size_t memory_range_len;
@@ -248,6 +332,8 @@ static int get_base_ranges(void)
  			return -1;
  		}
  		while ((mentry = readdir(dmem)) != NULL) {
+			unsigned long long start, end;
+
  			if (strcmp(mentry->d_name, "reg"))
  				continue;
  			strcat(fname, "/reg");
@@ -257,8 +343,7 @@ static int get_base_ranges(void)
  				closedir(dir);
  				return -1;
  			}
-			if ((n = fread(buf, 1, MAXBYTES, file)) < 0) {
-				perror(fname);
+			if (read_memory_region_limits(file, &start, &end) != 0) {
  				fclose(file);
  				closedir(dmem);
  				closedir(dir);
@@ -271,24 +356,8 @@ static int get_base_ranges(void)
  				}
  			}
  
-			if (n == sizeof(uint32_t) * 2) {
-				base_memory_range[local_memory_ranges].start =
-					((uint32_t *)buf)[0];
-				base_memory_range[local_memory_ranges].end  =
-					base_memory_range[local_memory_ranges].start +
-					((uint32_t *)buf)[1];
-			}
-			else if (n == sizeof(uint64_t) * 2) {
-				base_memory_range[local_memory_ranges].start =
-                                        ((uint64_t *)buf)[0];
-                                base_memory_range[local_memory_ranges].end  =
-                                        base_memory_range[local_memory_ranges].start +
-                                        ((uint64_t *)buf)[1];
-			}
-			else {
-				fprintf(stderr, "Mem node has invalid size: %d\n", n);
-				return -1;
-			}
+			base_memory_range[local_memory_ranges].start = start;
+			base_memory_range[local_memory_ranges].end  = end;
  			base_memory_range[local_memory_ranges].type = RANGE_RAM;
  			local_memory_ranges++;
  			dbgprintf("%016llx-%016llx : %x\n",
@@ -577,20 +646,10 @@ static int get_devtree_details(unsigned
  				perror(fname);
  				goto error_opencdir;
  			}
-			if ((n = fread(buf, 1, MAXBYTES, file)) < 0) {
-				perror(fname);
-				goto error_openfile;
-			}
-			if (n == sizeof(uint64_t)) {
-				rmo_base = ((uint32_t *)buf)[0];
-				rmo_top = rmo_base + ((uint32_t *)buf)[1];
-			} else if (n == 16) {
-				rmo_base = ((uint64_t *)buf)[0];
-				rmo_top = rmo_base + ((uint64_t *)buf)[1];
-			} else {
-				fprintf(stderr, "Mem node has invalid size: %d\n", n);
+			if (read_memory_region_limits(file, &rmo_base, &rmo_top) != 0) {
  				goto error_openfile;
  			}
+
  			if (rmo_top > 0x30000000UL)
  				rmo_top = 0x30000000UL;
  
@@ -664,7 +723,6 @@ error_opendir:
  	return -1;
  }
  
-
  /* Setup a sorted list of memory ranges. */
  static int setup_memory_ranges(unsigned long kexec_flags)
  {
@@ -756,7 +814,6 @@ out:
  	return -1;
  }
  
-
  /* Return a list of valid memory ranges */
  int get_memory_ranges_dt(struct memory_range **range, int *ranges,
  		unsigned long kexec_flags)
@@ -778,6 +835,11 @@ int get_memory_ranges_dt(struct memory_r
  int get_memory_ranges(struct memory_range **range, int *ranges,
  					unsigned long kexec_flags)
  {
+	int res = 0;
+
+	res = init_memory_region_info();
+	if (res != 0)
+		return res;
  #ifdef WITH_GAMECUBE
  	return get_memory_ranges_gc(range, ranges, kexec_flags);
  #else
Index: kexec-tools-2.0.4/kexec/arch/ppc/kexec-ppc.h
===================================================================
--- kexec-tools-2.0.4.orig/kexec/arch/ppc/kexec-ppc.h
+++ kexec-tools-2.0.4/kexec/arch/ppc/kexec-ppc.h
@@ -69,6 +69,12 @@ extern unsigned long long initrd_base, i
  extern unsigned long long ramdisk_base, ramdisk_size;
  extern unsigned char reuse_initrd;
  extern const char *ramdisk;
+
+/* Method to parse the memory/reg nodes in device-tree */
+extern unsigned long dt_address_cells, dt_size_cells;
+extern int init_memory_region_info(void);
+extern int read_memory_region_limits(FILE *fp, unsigned long long *start,
+					unsigned long long *end);
  #define COMMAND_LINE_SIZE	512 /* from kernel */
  /*fs2dt*/
  void reserve(unsigned long long where, unsigned long long length);
Index: kexec-tools-2.0.4/kexec/arch/ppc/crashdump-powerpc.c
===================================================================
--- kexec-tools-2.0.4.orig/kexec/arch/ppc/crashdump-powerpc.c
+++ kexec-tools-2.0.4/kexec/arch/ppc/crashdump-powerpc.c
@@ -130,9 +130,8 @@ static int get_crash_memory_ranges(struc
  				closedir(dir);
  				goto err;
  			}
-			n = fread(buf, 1, MAXBYTES, file);
-			if (n < 0) {
-				perror(fname);
+			n = read_memory_region_limits(file, &start, &end);
+			if (n != 0) {
  				fclose(file);
  				closedir(dmem);
  				closedir(dir);
@@ -146,24 +145,6 @@ static int get_crash_memory_ranges(struc
  				goto err;
  			}
  
-			/*
-			 * FIXME: This code fails on platforms that
-			 * have more than one memory range specified
-			 * in the device-tree's /memory/reg property.
-			 * or where the #address-cells and #size-cells
-			 * are not identical.
-			 *
-			 * We should interpret the /memory/reg property
-			 * based on the values of the #address-cells and
-			 * #size-cells properites.
-			 */
-			if (n == (sizeof(unsigned long) * 2)) {
-				start = ((unsigned long *)buf)[0];
-				end = start + ((unsigned long *)buf)[1];
-			} else {
-				start = ((unsigned long long *)buf)[0];
-				end = start + ((unsigned long long *)buf)[1];
-			}
  			if (start == 0 && end >= (BACKUP_SRC_END + 1))
  				start = BACKUP_SRC_END + 1;
  
Index: kexec-tools-2.0.4/kexec/arch/ppc/fs2dt.c
===================================================================
--- kexec-tools-2.0.4.orig/kexec/arch/ppc/fs2dt.c
+++ kexec-tools-2.0.4/kexec/arch/ppc/fs2dt.c
@@ -122,7 +122,7 @@ static unsigned propnum(const char *name
  	return offset;
  }
  
-static void add_usable_mem_property(int fd, int len)
+static void add_usable_mem_property(FILE* fp, int len)
  {
  	char fname[MAXPATH], *bname;
  	unsigned long buf[2];
@@ -137,21 +137,11 @@ static void add_usable_mem_property(int
  	if (strncmp(bname, "/memory@", 8) && strcmp(bname, "/memory"))
  		return;
  
-	if (len < 2 * sizeof(unsigned long))
-		die("unrecoverable error: not enough data for mem property\n");
-	len = 2 * sizeof(unsigned long);
-
-	if (lseek(fd, 0, SEEK_SET) < 0)
+	if (fseek(fp, 0, SEEK_SET) < 0)
  		die("unrecoverable error: error seeking in \"%s\": %s\n",
  		    pathname, strerror(errno));
-	if (read(fd, buf, len) != len)
-		die("unrecoverable error: error reading \"%s\": %s\n",
-		    pathname, strerror(errno));
-
-	if (~0ULL - buf[0] < buf[1])
-		die("unrecoverable error: mem property overflow\n");
-	base = buf[0];
-	end = base + buf[1];
+	if (read_memory_region_limits(fp, &base, &end) != 0)
+		die("unrecoverable error: error parsing memory/reg limits\n");
  
  	for (range = 0; range < usablemem_rgns.size; range++) {
  		loc_base = usablemem_rgns.ranges[range].start;
@@ -194,8 +184,9 @@ static void add_usable_mem_property(int
  static void putprops(char *fn, struct dirent **nlist, int numlist)
  {
  	struct dirent *dp;
-	int i = 0, fd, len;
+	int i = 0, len;
  	struct stat statbuf;
+	FILE *fp;
  
  	for (i = 0; i < numlist; i++) {
  		dp = nlist[i];
@@ -243,12 +234,12 @@ static void putprops(char *fn, struct di
  		*dt++ = len;
  		*dt++ = propnum(fn);
  
-		fd = open(pathname, O_RDONLY);
-		if (fd == -1)
+		fp = fopen(pathname, "r");
+		if (fp == NULL)
  			die("unrecoverable error: could not open \"%s\": %s\n",
  			    pathname, strerror(errno));
  
-		if (read(fd, dt, len) != len)
+		if (fread(dt, 1, len, fp) != len)
  			die("unrecoverable error: could not read \"%s\": %s\n",
  			    pathname, strerror(errno));
  
@@ -290,8 +281,8 @@ static void putprops(char *fn, struct di
  
  		dt += (len + 3)/4;
  		if (!strcmp(dp->d_name, "reg") && usablemem_rgns.size)
-			add_usable_mem_property(fd, len);
-		close(fd);
+			add_usable_mem_property(fp, len);
+		fclose(fp);
  	}
  
  	fn[0] = '\0';
