Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753582Ab0KWWsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 17:48:11 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:39227 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970Ab0KWWsG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 17:48:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:user-agent:date:from:to:cc:subject:references
         :content-disposition;
        b=aLVzG4gXa76yAXroMb+/qYAyYiDbGGK1r61uy2MZz7QTEBEt7tan6V5/eXUjpauF77
         +B/i/RUoW8PCmII7605Inm+gWARpL2+k7RkJx1eD5jJAvsAhNbLgryD/v9M++UpZUpjG
         lfg3Iuw5CBG30MGV9LqzXy6Nbx/lp5vmvgAKs=
Message-Id: <20101123224800.294919307@openvz.org>
User-Agent: quilt/0.47-1
Date: Wed, 24 Nov 2010 01:46:02 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>
Cc: ming.m.lin@intel.com, eranian@google.com, peterz@infradead.org,
        Cyrill Gorcunov <gorcunov@openvz.org>
Subject: [rfc 1/3] perf, x86: P4 PMU - describe config format
References: <20101123224601.766827604@openvz.org>
Content-Disposition: inline; filename=perf-x86-export-p4-bits
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add description of .config in a sake of RAW events.
At least this should bring some light to those who
will be reading this code.

Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
CC: Lin Ming <ming.m.lin@intel.com>
CC: Stephane Eranian <eranian@google.com>
CC: Peter Zijlstra <peterz@infradead.org>
---
 arch/x86/include/asm/perf_event_p4.h |   62 ++++++++++++++++++++++++++++++-----
 1 file changed, 54 insertions(+), 8 deletions(-)

Index: linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
=====================================================================
--- linux-2.6.git.orig/arch/x86/include/asm/perf_event_p4.h
+++ linux-2.6.git/arch/x86/include/asm/perf_event_p4.h
@@ -744,14 +744,6 @@ enum P4_ESCR_EMASKS {
 };
 
 /*
- * P4 PEBS specifics (Replay Event only)
- *
- * Format (bits):
- *   0-6: metric from P4_PEBS_METRIC enum
- *    7 : reserved
- *    8 : reserved
- * 9-11 : reserved
- *
  * Note we have UOP and PEBS bits reserved for now
  * just in case if we will need them once
  */
@@ -788,5 +780,59 @@ enum P4_PEBS_METRIC {
 	P4_PEBS_METRIC__max
 };
 
+/*
+ * Notes on internal configuration of ESCR+CCCR tuples
+ *
+ * Since P4 has quite the different architecture of
+ * performance registers in compare with "architectural"
+ * once and we have on 64 bits to keep configuration
+ * of performance event, the following trick is used.
+ *
+ * 1) Since both ESCR and CCCR registers have only low
+ *    32 bits valuable, we pack them into a single 64 bit
+ *    configuration. Low 32 bits of such config correspond
+ *    to low 32 bits of CCCR register and high 32 bits
+ *    correspond to low 32 bits of ESCR register.
+ *
+ * 2) The meaning of every bit of such config field can
+ *    be found in Intel SDM but it should be noted that
+ *    we "borrow" some reserved bits for own usage and
+ *    clean them or set to a proper value when we do
+ *    a real write to hardware registers.
+ *
+ * 3) The format of bits of config is the following
+ *    and should be either 0 or set to some predefined
+ *    values:
+ *
+ *    Low 32 bits
+ *    -----------
+ *      0-6: P4_PEBS_METRIC enum
+ *     7-11:                    reserved
+ *       12: Active thread
+ *    13-15:                    reserved (ESCR select)
+ *    16-17: Compare
+ *       18: Complement
+ *    20-23: Threshold
+ *       24: Edge
+ *       25:                    reserved (FORCE_OVF)
+ *       26:                    reserved (OVF_PMI_T0)
+ *       27:                    reserved (OVF_PMI_T1)
+ *    28-29:                    reserved
+ *       30:                    reserved (Cascade)
+ *       31:                    reserved (OVF)
+ *
+ *    High 32 bits
+ *    ------------
+ *        0:                    reserved (T1_USR)
+ *        1:                    reserved (T1_OS)
+ *        2:                    reserved (T0_USR)
+ *        3:                    reserved (T0_OS)
+ *        4: Tag Enable
+ *      5-8: Tag Value
+ *     9-24: Event Mask (may use P4_ESCR_EMASK_BIT helper)
+ *    25-30: enum P4_EVENTS
+ *       31:                    reserved (HT thread)
+ */
+
 #endif /* PERF_EVENT_P4_H */
 

