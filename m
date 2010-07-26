Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427Ab0GZV6s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 17:58:48 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64030 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752458Ab0GZV6q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 17:58:46 -0400
Message-ID: <4C4E047D.6030000@kernel.org>
Date: Mon, 26 Jul 2010 14:56:13 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>
CC: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        David Rientjes <rientjes@google.com>, Feng Tang <feng.tang@intel.com>,
        Shaohua Li <shaohua.li@intel.com>, Jean Delvare <khali@linux-fr.org>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH] x86, acpi: handle xapic/x2apic at same time
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090207.4C4E0487.0074,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



one system have mixing xapic and x2apic entries in MADT and SRAT.

try to handle every entry in MADT at same time with xapic and x2apic.
so we can honor sequence in MADT.

We can use max_cpus= command line to use thread0 in every core.
because recent MADT always have all thread0 at first.

also make the cpu to node mapping more sane.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>

---
 arch/x86/kernel/acpi/boot.c |   35 ++++++++++++++++++++-------
 drivers/acpi/numa.c         |   18 +++++++++++---
 drivers/acpi/tables.c       |   56 ++++++++++++++++++++++++++++++++------------
 include/linux/acpi.h        |    8 ++++++
 4 files changed, 89 insertions(+), 28 deletions(-)

Index: linux-2.6/arch/x86/kernel/acpi/boot.c
===================================================================
--- linux-2.6.orig/arch/x86/kernel/acpi/boot.c
+++ linux-2.6/arch/x86/kernel/acpi/boot.c
@@ -863,6 +863,7 @@ static int __init acpi_parse_madt_lapic_
 {
 	int count;
 	int x2count = 0;
+	struct acpi_subtable_proc madt_proc;
 
 	if (!cpu_has_apic)
 		return -ENODEV;
@@ -887,10 +888,19 @@ static int __init acpi_parse_madt_lapic_
 				      acpi_parse_sapic, MAX_APICS);
 
 	if (!count) {
-		x2count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC,
-						acpi_parse_x2apic, MAX_APICS);
-		count = acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC,
-					      acpi_parse_lapic, MAX_APICS);
+
+		memset(&madt_proc, 0, sizeof(madt_proc));
+		madt_proc.id[0] = ACPI_MADT_TYPE_LOCAL_APIC;
+		madt_proc.handler[0] = acpi_parse_lapic;
+		madt_proc.num++;
+		madt_proc.id[1] = ACPI_MADT_TYPE_LOCAL_X2APIC;
+		madt_proc.handler[1] = acpi_parse_x2apic;
+		madt_proc.num++;
+		acpi_table_parse_entries_x(ACPI_SIG_MADT,
+					    sizeof(struct acpi_table_madt),
+					    &madt_proc, MAX_APICS);
+		count = madt_proc.count[0];
+		x2count = madt_proc.count[1];
 	}
 	if (!count && !x2count) {
 		printk(KERN_ERR PREFIX "No LAPIC entries present\n");
@@ -902,11 +912,18 @@ static int __init acpi_parse_madt_lapic_
 		return count;
 	}
 
-	x2count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_X2APIC_NMI,
-				  acpi_parse_x2apic_nmi, 0);
-	count =
-	    acpi_table_parse_madt(ACPI_MADT_TYPE_LOCAL_APIC_NMI, acpi_parse_lapic_nmi, 0);
+	memset(&madt_proc, 0, sizeof(madt_proc));
+	madt_proc.id[0] = ACPI_MADT_TYPE_LOCAL_APIC_NMI;
+	madt_proc.handler[0] = acpi_parse_lapic_nmi;
+	madt_proc.num++;
+	madt_proc.id[1] = ACPI_MADT_TYPE_LOCAL_X2APIC_NMI;
+	madt_proc.handler[1] = acpi_parse_x2apic_nmi;
+	madt_proc.num++;
+	acpi_table_parse_entries_x(ACPI_SIG_MADT,
+				    sizeof(struct acpi_table_madt),
+				    &madt_proc, MAX_APICS);
+	count = madt_proc.count[0];
+	x2count = madt_proc.count[1];
 	if (count < 0 || x2count < 0) {
 		printk(KERN_ERR PREFIX "Error parsing LAPIC NMI entry\n");
 		/* TBD: Cleanup to allow fallback to MPS */
Index: linux-2.6/drivers/acpi/numa.c
===================================================================
--- linux-2.6.orig/drivers/acpi/numa.c
+++ linux-2.6/drivers/acpi/numa.c
@@ -292,10 +292,20 @@ int __init acpi_numa_init(void)
 
 	/* SRAT: Static Resource Affinity Table */
 	if (!acpi_table_parse(ACPI_SIG_SRAT, acpi_parse_srat)) {
-		acpi_table_parse_srat(ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY,
-				     acpi_parse_x2apic_affinity, nr_cpu_ids);
-		acpi_table_parse_srat(ACPI_SRAT_TYPE_CPU_AFFINITY,
-				     acpi_parse_processor_affinity, nr_cpu_ids);
+		struct acpi_subtable_proc srat_proc;
+
+		memset(&srat_proc, 0, sizeof(srat_proc));
+		srat_proc.id[0] = ACPI_SRAT_TYPE_CPU_AFFINITY;
+		srat_proc.handler[0] = acpi_parse_processor_affinity;
+		srat_proc.num++;
+		srat_proc.id[1] = ACPI_SRAT_TYPE_X2APIC_CPU_AFFINITY;
+		srat_proc.handler[1] = acpi_parse_x2apic_affinity;
+		srat_proc.num++;
+
+		acpi_table_parse_entries_x(ACPI_SIG_SRAT,
+					    sizeof(struct acpi_table_srat),
+					    &srat_proc, nr_cpu_ids);
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
+acpi_table_parse_entries_x(char *id,
 			     unsigned long table_size,
-			     int entry_id,
-			     acpi_table_entry_handler handler,
+			     struct acpi_subtable_proc *proc,
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
+		proc->count[0] = -ENODEV;
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
+		proc->count[0] = -ENODEV;
 		return -ENODEV;
 	}
 
@@ -238,19 +238,25 @@ acpi_table_parse_entries(char *id,
 
 	while (((unsigned long)entry) + sizeof(struct acpi_subtable_header) <
 	       table_end) {
-		if (entry->type == entry_id
-		    && (!max_entries || count++ < max_entries))
-			if (handler(entry, table_end)) {
-				early_acpi_os_unmap_memory((char *)table_header, tbl_size);
-				return -EINVAL;
-			}
+		for (i = 0; i < proc->num; i++) {
+			if (entry->type != proc->id[i])
+				continue;
+			if (!max_entries || count++ < max_entries)
+				if (proc->handler[i](entry, table_end)) {
+					early_acpi_os_unmap_memory((char *)table_header, tbl_size);
+					proc->count[i] = -EINVAL;
+					return -EINVAL;
+				}
+			proc->count[i]++;
+			break;
+		}
 
 		entry = (struct acpi_subtable_header *)
 		    ((unsigned long)entry + entry->length);
 	}
 	if (max_entries && count > max_entries) {
-		printk(KERN_WARNING PREFIX "[%4.4s:0x%02x] ignored %i entries of "
-		       "%i found\n", id, entry_id, count - max_entries, count);
+		printk(KERN_WARNING PREFIX "[%4.4s:0x%02x 0x%02x] ignored %i entries of "
+		       "%i found\n", id, proc->id[0], proc->id[1], count - max_entries, count);
 	}
 
 	early_acpi_os_unmap_memory((char *)table_header, tbl_size);
@@ -258,6 +264,26 @@ acpi_table_parse_entries(char *id,
 }
 
 int __init
+acpi_table_parse_entries(char *id,
+			     unsigned long table_size,
+			     int entry_id,
+			     acpi_table_entry_handler handler,
+			     unsigned int max_entries)
+{
+	struct acpi_subtable_proc proc;
+
+	if (!handler)
+		return -EINVAL;
+
+	memset(&proc, 0, sizeof(proc));
+	proc.id[0] = entry_id;
+	proc.handler[0] = handler;
+	proc.num++;
+
+	return acpi_table_parse_entries_x(id, table_size, &proc, max_entries);
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
@@ -76,6 +76,13 @@ typedef int (*acpi_table_handler) (struc
 
 typedef int (*acpi_table_entry_handler) (struct acpi_subtable_header *header, const unsigned long end);
 
+struct acpi_subtable_proc {
+	int id[2];
+	acpi_table_entry_handler handler[2];
+	int count[2];
+	int num;
+};
+
 char * __acpi_map_table (unsigned long phys_addr, unsigned long size);
 void __acpi_unmap_table(char *map, unsigned long size);
 int early_acpi_boot_init(void);
@@ -86,6 +93,7 @@ int acpi_numa_init (void);
 
 int acpi_table_init (void);
 int acpi_table_parse (char *id, acpi_table_handler handler);
+int acpi_table_parse_entries_x(char *id, unsigned long table_size, struct acpi_subtable_proc *proc, unsigned int max_entries);
 int __init acpi_table_parse_entries(char *id, unsigned long table_size,
 	int entry_id, acpi_table_entry_handler handler, unsigned int max_entries);
 int acpi_table_parse_madt (enum acpi_madt_type id, acpi_table_entry_handler handler, unsigned int max_entries);
