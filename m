Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab2CEWAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:00:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28746 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754025Ab2CEWAs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:00:48 -0500
Message-ID: <4F553764.5070305@redhat.com>
Date: Mon, 05 Mar 2012 19:00:04 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        EDAC devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCHv5] EDAC core changes in order to properly report errors from
 all types of memory controllers
References: <1330698314-9863-1-git-send-email-bp@amd64.org> <1330698314-9863-5-git-send-email-bp@amd64.org> <4F50DECB.8030200@redhat.com> <20120305110441.GC1070@aftab> <4F54A6FF.50502@redhat.com> <20120305124411.GD1070@aftab> <4F54C133.6040709@redhat.com> <20120305141349.GF1070@aftab> <4F54D4AF.9060802@redhat.com>
In-Reply-To: <4F54D4AF.9060802@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is the 5th version of my patch series. It seemed too big to
send all those emails to LKML/edac mailing lists for the 5th
time, so, instead, I'll point to the git tree where they're hold.

I'm doing a massive test of the entire patchset with several different edac 
drivers, so the biggest changes on this series are the bug-fix patches.

Besides that, there are a few other differences:

	- the struct channel_info doesn't represent a channel. Its contents
represent a memory rank. So, call it as "rank_info";

	- Add a FIXME information to remind that, currently, the new "dimm_info"
structure represents a "rank", if the memory is addressed via csrows;

	- when the "dimm_info" is representing a rank, the sysfs nodes for it are
called as "rank" instead of "dimm";

	- an agreement was not reached yet for the the MCA-based tracepoint. So, I've
removed it from the patch series;

	- the out_of_range tracepoint got removed. Instead, a parse error will
generate only a printk message.

With those changes, there's just one tracepont defined there, on this patchset:
	http://git.kernel.org/?p=linux/kernel/git/mchehab/linux-edac.git;a=commit;h=fdfa64045e43c942e1250708365d9240cd0da9c3

The following changes since commit 805a6af8dba5dfdd35ec35dc52ec0122400b2610:

  Linux 3.2 (2012-01-04 15:55:44 -0800)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/mchehab/linux-edac.git hw_events_v5

Mauro Carvalho Chehab (43):
      edac/ppc4xx_edac: Fix compilation
      edac: Better describe the memory concepts
      drivers/edac: rename channel_info to rank_info
      edac: Create a dimm struct and move the labels into it
      edac: Add per dimm's sysfs nodes
      edac: Prepare to push down to drivers the filling of the memset_info
      i5400_edac: Convert it to report memory with the new location
      i7300_edac: Convert it to report memory with the new location
      edac: move dimm properties to struct memset_info
      edac: Don't initialize csrow's first_page & friends when not needed
      edac: move nr_pages to dimm struct
      edac: Add per-dimm sysfs show nodes
      edac: DIMM location cleanup
      edac-mc: Allow reporting errors on a non-csrow oriented way
      edac.h: Use kernel-doc-nano-HOWTO.txt notation for enums
      edac: rework memory layer hierarchy description
      edac: Export MC hierarchy counters for CE and UE
      edac: Cleanup the logs for i7core and sb edac drivers
      edac_mc: Some clenups at the log message
      edac: Add a sysfs node to test the EDAC error report facility
      edac_mc: Fix the enable label filter logic
      edac: Initialize the dimm label with the known information
      edac: don't OOPS if the csrow is not visible
      edac: Fix sysfs csrow?/*ce*count counters
      edac: Fix new error counts
      edac: Fix per layer error count counters
      edac: i5400: Fix DIMM memory filling
      edac_mc: Improve the labels parsing
      edac: Fix module removal logic
      edac_mc_sysfs: don't create inactive errcount sysfs nodes
      edac_mc: Fixes the logic that fills the dimms
      i5400_edac: Avoid calling pci_put_device() twice
      i5400_edac: Better represent the memory controller hierarchy
      edac: fill the location with something useful if the DIMM is not found
      edac: be sure to use the GET_POS macro to get memset_info struct
      amd64_edac: remove a duplicated call to edac_mc_handle_error()
      i5000_edac: Fix the logic that retrieves memory information
      i5100_edac: Fix the logic
      edac: add a sysfs node that stores the max possible memory location
      edac: Call the minimum grain node as "rank" if chip select is used
      i7300_edac: fixup
      Fix memory error count
      events/hw_event: Create a Hardware Events Report Mecanism (HERM)

 drivers/edac/amd64_edac.c       |  210 +++++++------
 drivers/edac/amd64_edac_dbg.c   |    6 +-
 drivers/edac/amd64_edac_inj.c   |   24 +-
 drivers/edac/amd76x_edac.c      |   44 ++-
 drivers/edac/cell_edac.c        |   42 ++-
 drivers/edac/cpc925_edac.c      |   93 +++--
 drivers/edac/e752x_edac.c       |   94 ++++--
 drivers/edac/e7xxx_edac.c       |   88 ++++--
 drivers/edac/edac_core.h        |   48 +--
 drivers/edac/edac_device.c      |   27 +-
 drivers/edac/edac_mc.c          |  700 ++++++++++++++++++++++++---------------
 drivers/edac/edac_mc_sysfs.c    |  625 ++++++++++++++++++++++++++++++++---
 drivers/edac/edac_module.h      |    2 +-
 drivers/edac/edac_pci.c         |    7 +-
 drivers/edac/i3000_edac.c       |   51 ++-
 drivers/edac/i3200_edac.c       |   57 ++--
 drivers/edac/i5000_edac.c       |  225 +++++++------
 drivers/edac/i5100_edac.c       |  105 +++---
 drivers/edac/i5400_edac.c       |  318 ++++++++++--------
 drivers/edac/i7300_edac.c       |  117 +++----
 drivers/edac/i7core_edac.c      |  267 +++++-----------
 drivers/edac/i82443bxgx_edac.c  |   43 ++-
 drivers/edac/i82860_edac.c      |   57 +++-
 drivers/edac/i82875p_edac.c     |   53 ++-
 drivers/edac/i82975x_edac.c     |   58 +++-
 drivers/edac/mpc85xx_edac.c     |   45 ++-
 drivers/edac/mv64x60_edac.c     |   47 ++-
 drivers/edac/pasemi_edac.c      |   51 ++--
 drivers/edac/ppc4xx_edac.c      |   62 ++--
 drivers/edac/r82600_edac.c      |   42 ++-
 drivers/edac/sb_edac.c          |  203 +++++-------
 drivers/edac/tile_edac.c        |   33 ++-
 drivers/edac/x38_edac.c         |   54 ++--
 include/linux/edac.h            |  454 ++++++++++++++++++++-----
 include/trace/events/hw_event.h |  107 ++++++
 35 files changed, 2856 insertions(+), 1603 deletions(-)
 create mode 100644 include/trace/events/hw_event.h


-

Whan an agreement with regards to the MCA-based tracepont is reached, a simple
patch like the one below would be enough to use a separate tracepoint for the
x86 architecture, when MCA is enabled and the error comes from it.

diff --git a/drivers/edac/amd64_edac.c b/drivers/edac/amd64_edac.c
index ea7eb9a..348a396 100644
--- a/drivers/edac/amd64_edac.c
+++ b/drivers/edac/amd64_edac.c
@@ -1898,7 +1898,7 @@ static void amd64_handle_ce(struct mem_ctl_info *mci, struct mce *m)
 				     -1, -1, -1,
 				     EDAC_MOD_STR,
 				     "HW has no ERROR_ADDRESS available",
-				     NULL);
+				     m);
 		return;
 	}
 
@@ -1927,7 +1927,7 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 				     -1, -1, -1,
 				     EDAC_MOD_STR,
 				     "HW has no ERROR_ADDRESS available",
-				     NULL);
+				     m);
 		return;
 	}
 
@@ -1946,7 +1946,7 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 				     page, offset, 0,
 				     -1, -1, -1,
 				     EDAC_MOD_STR,
-				     "ERROR ADDRESS NOT mapped to a MC", NULL);
+				     "ERROR ADDRESS NOT mapped to a MC", m);
 		return;
 	}
 
@@ -1961,12 +1961,12 @@ static void amd64_handle_ue(struct mem_ctl_info *mci, struct mce *m)
 				     -1, -1, -1,
 				     EDAC_MOD_STR,
 				     "ERROR ADDRESS NOT mapped to CS",
-				     NULL);
+				     m);
 	} else {
 		edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
 				     page, offset, 0,
 				     csrow, -1, -1,
-				     EDAC_MOD_STR, "", NULL);
+				     EDAC_MOD_STR, "", m);
 	}
 }
 
diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index eb73ddc..dfd24d3 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -1055,8 +1055,17 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			"page 0x%lx offset 0x%lx grain %d",
 			page_frame_number, offset_in_page, grain);
 
+#ifdef CONFIG_X86
+	if (arch_log)
+		trace_mc_error_mce(type, mci->mc_idx, msg, label, location,
+				   detail, other_detail, arch_log);
+	else
+		trace_mc_error(type, mci->mc_idx, msg, label, location,
+			       detail, other_detail);
+#else
 	trace_mc_error(type, mci->mc_idx, msg, label, location,
 		       detail, other_detail);
+#endif
 
 	if (type == HW_EVENT_ERR_CORRECTED) {
 		if (edac_mc_get_log_ce())
diff --git a/include/trace/events/hw_event.h b/include/trace/events/hw_event.h
index 9209c6b..76f4dd5 100644
--- a/include/trace/events/hw_event.h
+++ b/include/trace/events/hw_event.h
@@ -101,6 +101,110 @@ TRACE_EVENT(mc_error,
 		  __get_str(driver_detail))
 );
 
+/*
+ * X86 arch-specific events
+ */
+
+#ifdef CONFIG_X86
+#include <asm/mce.h>
+
+/*
+ * MCE event for memory-controller errors
+ */
+
+/*
+ * NOTE: due to trace contraints, we can't have the mce_record at the
+ * same file as mce_record, as they're used by different files. Including
+ * trace headers twice cause duplicated symbols. So, care is needed to
+ * sync changes here with changes at include/trace/events/mce.h.
+ */
+
+TRACE_EVENT(mc_error_mce,
+
+	TP_PROTO(const unsigned int err_type,
+		 const unsigned int mc_index,
+		 const char *msg,
+		 const char *label,
+		 const char *location,
+		 const char *detail,
+		 const char *driver_detail,
+		 const struct mce *m),
+
+	TP_ARGS(err_type, mc_index, msg, label, location,
+		detail, driver_detail, m),
+
+	TP_STRUCT__entry(
+		__field(	unsigned int,	err_type	)
+		__field(	unsigned int,	mc_index	)
+		__string(	msg,		msg		)
+		__string(	label,		label		)
+		__string(	detail,		detail		)
+		__string(	location,	location	)
+		__string(	driver_detail,	driver_detail	)
+		__field(	u64,		mcgcap		)
+		__field(	u64,		mcgstatus	)
+		__field(	u64,		status		)
+		__field(	u64,		addr		)
+		__field(	u64,		misc		)
+		__field(	u64,		ip		)
+		__field(	u64,		tsc		)
+		__field(	u64,		walltime	)
+		__field(	u32,		cpu		)
+		__field(	u32,		cpuid		)
+		__field(	u32,		apicid		)
+		__field(	u32,		socketid	)
+		__field(	u8,		cs		)
+		__field(	u8,		bank		)
+		__field(	u8,		cpuvendor	)
+	),
+
+	TP_fast_assign(
+		__entry->err_type	= err_type;
+		__entry->mc_index	= mc_index;
+		__assign_str(msg, msg);
+		__assign_str(label, label);
+		__assign_str(location, location);
+		__assign_str(detail, detail);
+		__assign_str(driver_detail, driver_detail);
+		__entry->mcgcap		= m->mcgcap;
+		__entry->mcgstatus	= m->mcgstatus;
+		__entry->status		= m->status;
+		__entry->addr		= m->addr;
+		__entry->misc		= m->misc;
+		__entry->ip		= m->ip;
+		__entry->tsc		= m->tsc;
+		__entry->walltime	= m->time;
+		__entry->cpu		= m->extcpu;
+		__entry->cpuid		= m->cpuid;
+		__entry->apicid		= m->apicid;
+		__entry->socketid	= m->socketid;
+		__entry->cs		= m->cs;
+		__entry->bank		= m->bank;
+		__entry->cpuvendor	= m->cpuvendor;
+	),
+
+	TP_printk("mce#%d: %s error %s on label \"%s\" (%s %s CPU: %d, MCGc/s: %llx/%llx, MC%d: %016Lx, ADDR/MISC: %016Lx/%016Lx, RIP: %02x:<%016Lx>, TSC: %llx, PROCESSOR: %u:%x, TIME: %llu, SOCKET: %u, APIC: %x %s)",
+		  __entry->mc_index,
+		  (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
+			((__entry->err_type == HW_EVENT_ERR_FATAL) ?
+			"Fatal" : "Uncorrected"),
+		  __get_str(msg),
+		  __get_str(label),
+		  __get_str(location),
+		  __get_str(detail),
+		  __entry->cpu,
+		  __entry->mcgcap, __entry->mcgstatus,
+		  __entry->bank, __entry->status,
+		  __entry->addr, __entry->misc,
+		  __entry->cs, __entry->ip,
+		  __entry->tsc,
+		  __entry->cpuvendor, __entry->cpuid,
+		  __entry->walltime,
+		  __entry->socketid,
+		  __entry->apicid,
+		  __get_str(driver_detail))
+);
+
 #endif /* _TRACE_HW_EVENT_MC_H */
 
 /* This part must be outside protection */
