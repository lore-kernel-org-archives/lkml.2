Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754643Ab1A1DKe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 22:10:34 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:24855 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754609Ab1A1DKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 22:10:32 -0500
Message-ID: <4D423360.6080408@kernel.org>
Date: Thu, 27 Jan 2011 19:09:20 -0800
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>
CC: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: [PATCH -v2] x86, acpi: Handle xapic/x2apic entries in MADT at same
 time
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


One system have mixing xapic and x2apic entries in MADT and SRAT.
BIOS guys insist that ACPI 4.0 SPEC said so, if apic id < 255, even
the cpus are with x2apic mode pre-enabled, still need to use xapic entries
instead of x2apic entries.

on 8 socket system with x2apic pre-enabled, will get out of order sequence:
CPU0: socket0, core0, thread0.
CPU1 - CPU 40: socket 4 - socket 7, thread 0
CPU41 - CPU 80: socket 4 - socket 7, thread 1
CPU81 - CPU 119: socket 0 - socket 3, thread 0
CPU120 - CPU 159: socket 0 - socket 3, thread 1

so max_cpus=80 will not get all thread0 now.

Need to handle every entry in MADT at same time with xapic and x2apic.
so we can honor sequence in MADT.

We can use max_cpus= command line to use thread0 in every core,
because recent MADT always have all thread0 at first.
Also it could make the cpu to node mapping more sane.

after patch will get
CPU0 - CPU 79: socket 0 - socket 7, thread 0
CPU80 - CPU 159: socket 0 - socket 7, thread 1

-v2: update some comments, and change to pass array pointer.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/acpi/boot.c |   30 ++++++++++++++++-------
 drivers/acpi/numa.c         |   16 +++++++++---
 drivers/acpi/tables.c       |   57 +++++++++++++++++++++++++++++++++-----------
 include/linux/acpi.h        |    9 ++++++
 4 files changed, 86 insertions(+), 26 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -883,6 +883,7 @@ static int __init acpi_parse_madt_lapic_
 {
 	int count;
 	int x2count = 0;
+	struct acpi_subtable_proc madt_proc[2];
 
 	if (!cpu_has_apic)
 		return -ENODEV;
@@ -907,10 +908,16 @@ static int __init acpi_parse_madt_lapic_
 				      acpi_parse_sapic, MAX_LOCAL_APIC);
 
 	if (!count) {
-		x2count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC,
-					acpi_parse_x2apic, MAX_LOCAL_APIC);
-		count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC,
-					acpi_parse_lapic, MAX_LOCAL_APIC);
+		memset(madt_proc, 0, sizeof(madt_proc));
+		madt_proc[0].id = ACPI_MADT_TYPE_LOCAL_APIC;
+		madt_proc[0].handler = acpi_parse_lapic;
+		madt_proc[1].id = ACPI_MADT_TYPE_LOCAL_X2APIC;
+		madt_proc[1].handler = acpi_parse_x2apic;
+		acpi_table_parse_entries_array(ACPI_SIG_MADT,
+					    sizeof(struct acpi_table_madt),
+					    madt_proc, 2, MAX_LOCAL_APIC);
+		count = madt_proc[0].count;
+		x2count = madt_proc[1].count;
 	}
 	if (!count && !x2count) {
 		printk(KERN_ERR PREFIX "No LAPIC entries present\n");
@@ -922,11 +929,16 @@ static int __init acpi_parse_madt_lapic_
 		return count;
 	}
 
-	x2count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC_NMI,
-				  acpi_parse_x2apic_nmi, 0);
-	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_NMI, acpi_parse_lapic_nmi, 0);
+	memset(madt_proc, 0, sizeof(madt_proc));
+	madt_proc[0].id = ACPI_MADT_TYPE_LOCAL_APIC_NMI;
+	madt_proc[0].handler = acpi_parse_lapic_nmi;
+	madt_proc[1].id = ACPI_MADT_TYPE_LOCAL_X2APIC_NMI;
+	madt_proc[1].handler = acpi_parse_x2apic_nmi;
+	acpi_table_parse_entries_array(ACPI_SIG_MADT,
+				    sizeof(struct acpi_table_madt),
+				    madt_proc, 2, 0);
+	count = madt_proc[0].count;
+	x2count = madt_proc[1].count;
 	if (count < 0 || x2count < 0) {
 		printk(KERN_ERR PREFIX "Error parsing LAPIC NMI entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
Index: linux-2.6/drivers/acpi/numa.c
===================================================================
--- linux-2.6.orig/drivers/acpi/numa.c
+++ linux-2.6/drivers/acpi/numa.c
@@ -284,10 +284,18 @@ int __init acpi_numa_init(void)
 
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
-		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
-				     acpi_parse_x2apic_affinity, 0);
-		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
-				     acpi_parse_processor_affinity, 0);
+		struct acpi_subtable_proc srat_proc[2];
+
+		memset(srat_proc, 0, sizeof(srat_proc));
+		srat_proc[0].id = ACPI_SRAT_TYPE_CPU_AFFINITY;
+		srat_proc[0].handler = acpi_parse_processor_affinity;
+		srat_proc[1].id = ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY;
+		srat_proc[1].handler = acpi_parse_x2apic_affinity;
+
+		acpi_table_parse_entries_array(ACPI_SIG_SRAT,
+					    sizeof(struct acpi_table_srat),
+					    srat_proc, 2, 0);
+
 		ret = acpi_table_parse_srat(ACPI_SRAT_TYPE_MEMORY_AFFINITY,
 					    acpi_parse_memory_affinity,
 					    NR_NODE_MEMBLKS);
Index: linux-2.6/drivers/acpi/tables.c
===================================================================
--- linux-2.6.orig/drivers/acpi/tables.c
+++ linux-2.6/drivers/acpi/tables.c
@@ -201,10 +201,9 @@ void acpi_table_print_madt_entry(struct
 
 
 int __init
-acpi_table_parse_entries(char *id,
+acpi_table_parse_entries_array(char *id,
 			     unsigned long table_size,
-			     int entry_id,
-			     acpi_table_entry_handler handler,
+			     struct acpi_subtable_proc *proc, int proc_num,
 			     unsigned int max_entries)
 {
 	struct acpi_table_header *table_header = NULL;
@@ -212,12 +211,12 @@ acpi_table_parse_entries(char *id,
 	unsigned int count = 0;
 	unsigned long table_end;
 	acpi_size tbl_size;
+	int i;
 
-	if (acpi_disabled)
+	if (acpi_disabled) {
+		proc[0].count = -ENODEV;
 		return -ENODEV;
-
-	if (!handler)
-		return -EINVAL;
+	}
 
 	if (strncmp(id, ACPI_SIG_MADT, 4) == 0)
 		acpi_get_table_with_size(id, acpi_apic_instance, &table_header, &tbl_size);
@@ -226,6 +225,7 @@ acpi_table_parse_entries(char *id,
 
 	if (!table_header) {
 		printk(KERN_WARNING PREFIX "%4.4s not present\n", id);
+		proc[0].count = -ENODEV;
 		return -ENODEV;
 	}
 
@@ -238,19 +238,30 @@ acpi_table_parse_entries(char *id,
 
 	while (((unsigned long)entry) + sizeof(struct acpi_subtable_header) <
 	       table_end) {
-		if (entry->type == entry_id
-		    && (!max_entries || count++ < max_entries))
-			if (handler(entry, table_end)) {
-				early_acpi_os_unmap_memory((char *)table_header, tbl_size);
+		for (i = 0; i < proc_num; i++) {
+			if (entry->type != proc[i].id)
+				continue;
+			if (max_entries && count++ >= max_entries)
+				continue;
+			if (proc[i].handler(entry, table_end)) {
+				early_acpi_os_unmap_memory((char *)table_header,
+								 tbl_size);
+				proc[i].count = -EINVAL;
 				return -EINVAL;
 			}
+			proc[i].count++;
+			break;
+		}
 
 		entry = (struct acpi_subtable_header *)
 		    ((unsigned long)entry + entry->length);
 	}
 	if (max_entries && count > max_entries) {
-		printk(KERN_WARNING PREFIX "[%4.4s:0x%02x] ignored %i entries of "
-		       "%i found\n", id, entry_id, count - max_entries, count);
+		printk(KERN_WARNING PREFIX "[%4.4s:0x%02x ", id, proc[0].id);
+		for (i = 1; i < proc_num; i++)
+			printk(KERN_CONT " 0x%02x", proc[i].id);
+		printk(KERN_CONT "] ignored %i entries of %i found\n",
+		       count-max_entries, count);
 	}
 
 	early_acpi_os_unmap_memory((char *)table_header, tbl_size);
@@ -258,6 +269,26 @@ acpi_table_parse_entries(char *id,
 }
 
 int __init
+acpi_table_parse_entries(char *id,
+			     unsigned long table_size,
+			     int entry_id,
+			     acpi_table_entry_handler handler,
+			     unsigned int max_entries)
+{
+	struct acpi_subtable_proc proc[1];
+
+	if (!handler)
+		return -EINVAL;
+
+	memset(proc, 0, sizeof(proc));
+	proc[0].id = entry_id;
+	proc[0].handler = handler;
+
+	return acpi_table_parse_entries_array(id, table_size, proc, 1,
+						 max_entries);
+}
+
+int __init
 acpi_table_parse_madt(enum acpi_madt_type id,
 		      acpi_table_entry_handler handler, unsigned int max_entries)
 {
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -76,6 +76,12 @@ typedef int (*acpi_table_handler) (struc
 
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
+struct acpi_subtable_proc {
+	int id;
+	acpi_table_entry_handler handler;
+	int count;
+};
+
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
 void __acpi_unmap_table(char *map, unsigned long size);
 int early_acpi_boot_init(void);
@@ -86,6 +92,9 @@ int acpi_numa_init (void);
 
 int acpi_table_init (void);
 int acpi_table_parse (char *id, acpi_table_handler handler);
+int acpi_table_parse_entries_array(char *id, unsigned long table_size,
+	struct acpi_subtable_proc *proc, int proc_num,
+	unsigned int max_entries);
 int __init acpi_table_parse_entries(char *id, unsigned long table_size,
 	int entry_id, acpi_table_entry_handler handler, unsigned int max_entries);
 int acpi_table_parse_madt (enum acpi_madt_type id, acpi_table_entry_handler handler, unsigned int max_entries);
