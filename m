Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758551Ab2EKBtC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 21:49:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63092 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754331Ab2EKBs7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 21:48:59 -0400
Message-ID: <4FAC6FF8.3050608@redhat.com>
Date: Thu, 10 May 2012 22:48:40 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Doug Thompson <norsk5@yahoo.com>, Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH v22] edac, ras/hw_event.h: use events to handle hw issues
References: <1336679788-4982-1-git-send-email-mchehab@redhat.com> <20120510204042.GA4598@aftab.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F192EC1A2@ORSMSX104.amr.corp.intel.com> <4FAC3C35.70101@redhat.com> <3908561D78D1C84285E8C5FCA982C28F192EC247@ORSMSX104.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192EC247@ORSMSX104.amr.corp.intel.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 10-05-2012 19:37, Luck, Tony escreveu:
>      kworker/u:6-201   [007] .N..   186.197280: mc_error: [Hardware Error]: mem_ctl#0: Corrected error memory read error on memory stick "DIMM_A1" (channel:0 slot:1  page:0x2f1eb3 offset:0x446 grain:32 syndrome:0x0 1 error(s): Unknown: Err=0001:0090 socket=0 channel=0/mask=1 rank=5)
>      
> The word "error" appears *five* times on this line (once with a capital E).
> I feel beaten, bruised and ready to give up on this machine with just one
> actual error reported :-)

:)

Several of them come from the driver-provided details.

The edac-mc core contributes with "mc_error", "[Hardware Error]" and "Corrected error".
The sb-edac driver contributes with "memory read error" and "1 error(s)".

We can get easily get rid of "[Hardware Error]" by removing HW_ERR from:

	TP_printk(HW_ERR "mem_ctl#%d: %s error %s on memory stick \"%s\" (%s %s %s)",

replacing mc_error by something else is not hard, but this is the name of the trace call:

TRACE_EVENT(mc_error,
...

Maybe the better is to do s/mc_error/mc_event/g.

The error count msg ("1 error(s)") could be replaced by "count:1".

> 
> We could get rid of one by:
>  s/Corrected error memory read error/Corrected memory read error/

This is the hardest possible solution ;) Changing it will cause weird messages
all over EDAC drivers ;)

This is how sb_edac.c provides the "memory read error" string:

                switch (optypenum) {
               	case 0:
                       	optype = "generic undef request error";
                       	break;
                case 1:
                        optype = "memory read error";
                        break;
                case 2:
                        optype = "memory write error";
                        break;
                case 3:
                        optype = "addr/cmd error";
                        break;
               	case 4:
                        optype = "memory scrubbing error";
                        break;
               	default:
                        optype = "reserved";
                       	break;

In the last case of switch, for this driver, the error would be printed as "Corrected reserved".

On i7core_edac, there's also one error that would be weird:

        switch (optypenum) {
        case 0:
                optype = "generic undef request";
               	break;

Drivers like i5100_edac also provide error messages without the word "error" on it, like:

static const char *i5100_err_msg(unsigned err)
{
        static const char *merrs[] = {
                "unknown", /* 0 */
                "uncorrectable data ECC on replay", /* 1 */
                "unknown", /* 2 */
                "unknown", /* 3 */
                "aliased uncorrectable demand data ECC", /* 4 */
                "aliased uncorrectable spare-copy data ECC", /* 5 */
                "aliased uncorrectable patrol data ECC", /* 6 */
                "unknown", /* 7 */
                "unknown", /* 8 */
                "unknown", /* 9 */
                "non-aliased uncorrectable demand data ECC", /* 10 */
                "non-aliased uncorrectable spare-copy data ECC", /* 11 */
                "non-aliased uncorrectable patrol data ECC", /* 12 */
...

On _several_ drivers, the error type is simply the name of the driver, or blank:

amd76x_edac.c:
                       	edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
                                             mci->csrows[row]->first_page, 0, 0,
                                             row, 0, -1,
                                             mci->ctl_name, "", NULL);

i3200_edac:
                        edac_mc_handle_error(HW_EVENT_ERR_UNCORRECTED, mci,
                                             0, 0, 0,
                                             eccerrlog_row(channel, log),
                                             -1, -1,
                                             "i3000 UE", "", NULL);

Btw, you should not forget that, while simple usecases will be to just read the
/sys/kernel/debug/tracing/trace file, a monitoring tool will use the
binary data information, and store each trace field on a separate database
field.

So, the contents of the error message field should be consistent.

> 
> (though we'd need to see if things still read well for all other "msg" options.
> 
> Or perhaps it could say:
>    ... Corrected error: memory read on memory stick ...
> or even:
>    ... Corrected error: read on memory stick ...
> 
> This part could get shortened too:
>    mc_error: [Hardware Error]:
> will mc_error ever report something that isn't a "Hardware Error"?
> I don't think we have to preserve this legacy string when moving
> to a new reporting mechanism.
> 
> 
>> There are still some space to improve the fields provided by the drivers.
> Apart from reporting "channel" twice, that doesn't look too bad. Maybe
> the "1 error(s)" could say "count: 1"?

Agreed.

See the enclosed patch. The TP_printk() message after it is:

mc_event: Corrected error:memory read error on memory stick "DIMM_A1" (mc:0 channel:0 slot:0  page:0x1a3706 offset:0xff1 grain:32 syndrome:0x0 count:1 area:DRAM err_code:0001:0090 socket:0 channel_mask:8 rank:0)

If ok, I'll merge the edac core part together with this changeset, and the 
sb_edac part together with the patch that cleans the sb_edac logs.

Regards,
Mauro

--

edac: Improve error messages on sb-edac and edac-mc

From: Mauro Carvalho Chehab <mchehab@redhat.com>

After this patch, /sys/kernel/debug/tracing/trace displays:

     kworker/u:6-201   [007] .N..   161.136624: mc_event: Corrected error:memory read error on memory stick "DIMM_A1" (mc:0 channel:0 slot:0  page:0x586b6e offset:0xa66 grain:32 syndrome:0x0 count:1 area:DRAM err_code:0001:0090 socket:0 channel_mask:1 rank:1)
     kworker/u:6-201   [007] .N..   161.155708: mc_event: Corrected error:memory read error on memory stick "DIMM_E1" (mc:1 channel:0 slot:0  page:0x987f45 offset:0x14c grain:32 syndrome:0x0 count:1 area:DRAM err_code:0001:0090 socket:1 channel_mask:4 rank:0)
     kworker/u:6-201   [007] .N..   161.174817: mc_event: Corrected error:memory read error on memory stick "DIMM_C1" (mc:0 channel:0 slot:1  page:0x2bf618 offset:0xb2e grain:32 syndrome:0x0 count:1 area:DRAM err_code:0001:0090 socket:0 channel_mask:4 rank:4)

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>

diff --git a/drivers/edac/edac_mc.c b/drivers/edac/edac_mc.c
index 0550cb4..b7492e8 100644
--- a/drivers/edac/edac_mc.c
+++ b/drivers/edac/edac_mc.c
@@ -35,7 +35,7 @@
 
 #define CREATE_TRACE_POINTS
 #define TRACE_INCLUDE_PATH ../../include/ras
-#include <ras/ras.h>
+#include <ras/ras_event.h>
 
 /* lock to memory controller's control array */
 static DEFINE_MUTEX(mem_ctls_mutex);
@@ -1174,7 +1174,7 @@ void edac_mc_handle_error(const enum hw_event_mc_err_type type,
 			page_frame_number, offset_in_page, grain);
 
 	/* Report the error via the trace interface */
-	trace_mc_error(type, mci->mc_idx, msg, label, location,
+	trace_mc_event(type, mci->mc_idx, msg, label, location,
 		       detail, other_detail);
 
 	/* Report the error via the edac_mc_printk() interface */
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index 69c807c..60dbefe 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -786,7 +786,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 				 u8 *socket,
 				 long *channel_mask,
 				 u8 *rank,
-				 char *area_type, char *msg)
+				 char **area_type, char *msg)
 {
 	struct mem_ctl_info	*new_mci;
 	struct sbridge_pvt *pvt = mci->pvt_info;
@@ -841,7 +841,7 @@ static int get_memory_error_data(struct mem_ctl_info *mci,
 		sprintf(msg, "Can't discover the memory socket");
 		return -EINVAL;
 	}
-	area_type = get_dram_attr(reg);
+	*area_type = get_dram_attr(reg);
 	interleave_mode = INTERLEAVE_MODE(reg);
 
 	pci_read_config_dword(pvt->pci_sad0, interleave_list[n_sads],
@@ -1339,7 +1339,7 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	struct mem_ctl_info *new_mci;
 	struct sbridge_pvt *pvt = mci->pvt_info;
 	enum hw_event_mc_err_type tp_event;
-	char *type, *optype, msg[256], *recoverable_msg;
+	char *type, *optype, msg[256];
 	bool ripv = GET_BITFIELD(m->mcgstatus, 0, 0);
 	bool overflow = GET_BITFIELD(m->status, 62, 62);
 	bool uncorrected_error = GET_BITFIELD(m->status, 61, 61);
@@ -1352,7 +1352,7 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	long channel_mask, first_channel;
 	u8  rank, socket;
 	int rc, dimm;
-	char *area_type = "Unknown";
+	char *area_type = NULL;
 
 	if (uncorrected_error) {
 		if (ripv) {
@@ -1404,7 +1404,7 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	}
 
 	rc = get_memory_error_data(mci, m->addr, &socket,
-				   &channel_mask, &rank, area_type, msg);
+				   &channel_mask, &rank, &area_type, msg);
 	if (rc < 0)
 		goto err_parsing;
 	new_mci = get_mci_for_node_id(socket);
@@ -1424,10 +1424,6 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	else
 		dimm = 2;
 
-	if (uncorrected_error && recoverable)
-		recoverable_msg = " recoverable";
-	else
-		recoverable_msg = "";
 
 	/*
 	 * FIXME: On some memory configurations (mirror, lockstep), the
@@ -1436,14 +1432,13 @@ static void sbridge_mce_output_error(struct mem_ctl_info *mci,
 	 * to the group of dimm's where the error may be happening.
 	 */
 	snprintf(msg, sizeof(msg),
-		 "%d error(s)%s: %s%s: Err=%04x:%04x socket=%d channel=%ld/mask=%ld rank=%d",
+		 "count:%d%s%s area:%s err_code:%04x:%04x socket:%d channel_mask:%ld rank:%d",
 		 core_err_cnt,
 		 overflow ? " OVERFLOW" : "",
+		 (uncorrected_error && recoverable) ? " recoverable" : "",
 		 area_type,
-		 recoverable_msg,
 		 mscod, errcode,
 		 socket,
-		 first_channel,
 		 channel_mask,
 		 rank);
 
diff --git a/include/ras/ras.h b/include/ras/ras_event.h
similarity index 80%
rename from include/ras/ras.h
rename to include/ras/ras_event.h
index 13ea4ee..66f6a43 100644
--- a/include/ras/ras.h
+++ b/include/ras/ras_event.h
@@ -1,5 +1,6 @@
 #undef TRACE_SYSTEM
 #define TRACE_SYSTEM ras
+#define TRACE_INCLUDE_FILE ras_event
 
 #if !defined(_TRACE_HW_EVENT_MC_H) || defined(TRACE_HEADER_MULTI_READ)
 #define _TRACE_HW_EVENT_MC_H
@@ -26,25 +27,25 @@
 /*
  * Default error mechanisms for Memory Controller errors (CE and UE)
  */
-TRACE_EVENT(mc_error,
+TRACE_EVENT(mc_event,
 
 	TP_PROTO(const unsigned int err_type,
 		 const unsigned int mc_index,
-		 const char *msg,
+		 const char *error_msg,
 		 const char *label,
 		 const char *location,
-		 const char *detail,
+		 const char *core_detail,
 		 const char *driver_detail),
 
-	TP_ARGS(err_type, mc_index, msg, label, location,
-		detail, driver_detail),
+	TP_ARGS(err_type, mc_index, error_msg, label, location,
+		core_detail, driver_detail),
 
 	TP_STRUCT__entry(
 		__field(	unsigned int,	err_type		)
 		__field(	unsigned int,	mc_index		)
-		__string(	msg,		msg			)
+		__string(	msg,		error_msg		)
 		__string(	label,		label			)
-		__string(	detail,		detail			)
+		__string(	detail,		core_detail		)
 		__string(	location,	location		)
 		__string(	driver_detail,	driver_detail		)
 	),
@@ -52,20 +53,20 @@ TRACE_EVENT(mc_error,
 	TP_fast_assign(
 		__entry->err_type		= err_type;
 		__entry->mc_index		= mc_index;
-		__assign_str(msg, msg);
+		__assign_str(msg, error_msg);
 		__assign_str(label, label);
 		__assign_str(location, location);
-		__assign_str(detail, detail);
+		__assign_str(detail, core_detail);
 		__assign_str(driver_detail, driver_detail);
 	),
 
-	TP_printk(HW_ERR "mem_ctl#%d: %s error %s on memory stick \"%s\" (%s %s %s)",
-		  __entry->mc_index,
+	TP_printk("%s error:%s on memory stick \"%s\" (mc:%d %s %s %s)",
 		  (__entry->err_type == HW_EVENT_ERR_CORRECTED) ? "Corrected" :
 			((__entry->err_type == HW_EVENT_ERR_FATAL) ?
 			"Fatal" : "Uncorrected"),
 		  __get_str(msg),
 		  __get_str(label),
+		  __entry->mc_index,
 		  __get_str(location),
 		  __get_str(detail),
 		  __get_str(driver_detail))
