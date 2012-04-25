Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab2DYIvl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:51:41 -0400
Received: from mga01.intel.com ([192.55.52.88]:11868 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753409Ab2DYIvk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:51:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="158076641"
Message-ID: <4F97BA98.6010001@intel.com>
Date: Wed, 25 Apr 2012 16:49:28 +0800
From: ShuoX Liu <shuox.liu@intel.com>
Reply-To: shuox.liu@intel.com
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120420 Thunderbird/12.0
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: tj@kernel.org, Yanmin Zhang <yanmin_zhang@linux.intel.com>
Subject: [PATCH] mm: percpu: Add PCPU_FC_FIXED to pcpu_fc for setting fixed
 pcpu_atom_size.
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: ShuoX Liu <shuox.liu@intel.com>

We are enabling Android on Medfield. On i386, if the board has more
physical memory, it means the vmalloc space is small. If the vmalloc
space is big, it means physical memory is small. Dynamic percpu
allocation is based on VM space. On i386, by default, the chunk size
is 4MB. As vmalloc space is <= 128M, percpu allocation often fails.
If using PERCPU_FC_PAGE, system can't go to deep sleep states.

The patch add one more chosen to percpu_alloc kernel parameter.
Besides page,embed,auto are available for percpu_alloc, memory size
suffixed with %K,%M are supported. It set pcpu_atom_size to fixed
wanted size.

Signed-off-by: Yanmin Zhang <yanmin.zhang@intel.com>
Signed-off-by: ShuoX Liu <shuox.liu@intel.com>
---
 Documentation/kernel-parameters.txt |    4 +++-
 arch/x86/kernel/setup_percpu.c      |    6 +++++-
 include/linux/percpu.h              |    2 ++
 mm/percpu.c                         |   11 +++++++++--
 4 files changed, 19 insertions(+), 4 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index c1601e5..befeb5f 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -2196,7 +2196,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			See arch/parisc/kernel/pdc_chassis.c
 
 	percpu_alloc=	Select which percpu first chunk allocator to use.
-			Currently supported values are "embed" and "page".
+			Currently supported values are "embed", "page" and size
+			suffixed with %K,%M. Fixed size will overwrite
+			pcpu_atom_size of chunk allocation parameter.
 			Archs may support subset or none of the	selections.
 			See comments in mm/percpu.c for details on each
 			allocator.  This parameter is primarily	for debugging
diff --git a/arch/x86/kernel/setup_percpu.c b/arch/x86/kernel/setup_percpu.c
index 71f4727..824bc41 100644
--- a/arch/x86/kernel/setup_percpu.c
+++ b/arch/x86/kernel/setup_percpu.c
@@ -185,9 +185,13 @@ void __init setup_per_cpu_areas(void)
 #endif
 	rc = -EINVAL;
 	if (pcpu_chosen_fc != PCPU_FC_PAGE) {
-		const size_t atom_size = cpu_has_pse ? PMD_SIZE : PAGE_SIZE;
+		size_t atom_size;
 		const size_t dyn_size = PERCPU_MODULE_RESERVE +
 			PERCPU_DYNAMIC_RESERVE - PERCPU_FIRST_CHUNK_RESERVE;
+		if (pcpu_chosen_fc == PCPU_FC_FIXED && pcpu_atom_size)
+			atom_size = pcpu_atom_size;
+		else
+			atom_size = cpu_has_pse ? PMD_SIZE : PAGE_SIZE;
 
 		rc = pcpu_embed_first_chunk(PERCPU_FIRST_CHUNK_RESERVE,
 					    dyn_size, atom_size,
diff --git a/include/linux/percpu.h b/include/linux/percpu.h
index 21638ae..3943088 100644
--- a/include/linux/percpu.h
+++ b/include/linux/percpu.h
@@ -104,12 +104,14 @@ enum pcpu_fc {
 	PCPU_FC_AUTO,
 	PCPU_FC_EMBED,
 	PCPU_FC_PAGE,
+	PCPU_FC_FIXED,
 
 	PCPU_FC_NR,
 };
 extern const char *pcpu_fc_names[PCPU_FC_NR];
 
 extern enum pcpu_fc pcpu_chosen_fc;
+extern size_t pcpu_atom_size;
 
 typedef void * (*pcpu_fc_alloc_fn_t)(unsigned int cpu, size_t size,
 				     size_t align);
diff --git a/mm/percpu.c b/mm/percpu.c
index f47af91..7770ad0 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -113,9 +113,9 @@ struct pcpu_chunk {
 static int pcpu_unit_pages __read_mostly;
 static int pcpu_unit_size __read_mostly;
 static int pcpu_nr_units __read_mostly;
-static int pcpu_atom_size __read_mostly;
 static int pcpu_nr_slots __read_mostly;
 static size_t pcpu_chunk_struct_size __read_mostly;
+size_t pcpu_atom_size __read_mostly;
 
 /* cpus with the lowest and highest unit addresses */
 static unsigned int pcpu_low_unit_cpu __read_mostly;
@@ -1374,12 +1374,14 @@ const char *pcpu_fc_names[PCPU_FC_NR] __initdata = {
 	[PCPU_FC_AUTO]	= "auto",
 	[PCPU_FC_EMBED]	= "embed",
 	[PCPU_FC_PAGE]	= "page",
+	[PCPU_FC_FIXED]	= "fixed",
 };
 
 enum pcpu_fc pcpu_chosen_fc __initdata = PCPU_FC_AUTO;
 
 static int __init percpu_alloc_setup(char *str)
 {
+	size_t size = memparse(str, NULL);
 	if (0)
 		/* nada */;
 #ifdef CONFIG_NEED_PER_CPU_EMBED_FIRST_CHUNK
@@ -1390,7 +1392,12 @@ static int __init percpu_alloc_setup(char *str)
 	else if (!strcmp(str, "page"))
 		pcpu_chosen_fc = PCPU_FC_PAGE;
 #endif
-	else
+	else if (!strcmp(str, "auto"))
+		pcpu_chosen_fc = PCPU_FC_AUTO;
+	else if (size > 0) {
+		pcpu_atom_size = size;
+		pcpu_chosen_fc = PCPU_FC_FIXED;
+	} else
 		pr_warning("PERCPU: unknown allocator %s specified\n", str);
 
 	return 0;
