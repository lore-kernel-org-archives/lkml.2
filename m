Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab2CTQec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 12:34:32 -0400
Received: from tx2ehsobe005.messaging.microsoft.com ([65.55.88.15]:25685 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760335Ab2CTQeb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 12:34:31 -0400
X-SpamScore: -7
X-BigFish: VPS-7(zf7Iz542M4015Izz1202hzz8275ch8275bh8275dhz2fh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F68B180.8030709@am.sony.com>
Date: Tue, 20 Mar 2012 09:34:08 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Fwd: [PATCH] kdb:  Avoid using dbg_io_ops until it is initialized
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jason,

This patch has apparently fallen through the cracks.  Can you please apply?
This fixes a kernel panic for a use case where I'm setting a breakpoint
from kdb_cmds on kernel startup.  In this case, without this patch
dbg_io_ops is used before it is initialized.

Thanks,
 -- Tim

-------- Original Message --------
Subject: [PATCH] kdb:  Avoid using dbg_io_ops until it is initialized
Date: Wed, 21 Sep 2011 13:19:12 -0700
From: Tim Bird <tim.bird@am.sony.com>
To: Jason Wessel <jason.wessel@windriver.com>
CC: kgdb-bugreport@lists.sourceforge.net	<kgdb-bugreport@lists.sourceforge.net>, linux kernel	<linux-kernel@vger.kernel.org>

This fixes a bug with setting a breakpoint during kdb initialization
(from kdb_cmds).  Any call to kdb_printf() before the initialization
of the kgdboc serial console driver (which happens much later in
bootup than kdb_init), results in kernel panic due to the use of
dbg_io_ops before it is initialized.

Signed-off-by: Tim Bird <tim.bird@am.sony.com>
---
 kernel/debug/kdb/kdb_io.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/kernel/debug/kdb/kdb_io.c b/kernel/debug/kdb/kdb_io.c
index c9b7f4f..3bc995f 100644
--- a/kernel/debug/kdb/kdb_io.c
+++ b/kernel/debug/kdb/kdb_io.c
@@ -675,7 +675,7 @@ kdb_printit:
 	if (!dbg_kdb_mode && kgdb_connected) {
 		gdbstub_msg_write(kdb_buffer, retlen);
 	} else {
-		if (!dbg_io_ops->is_console) {
+		if (dbg_io_ops && !dbg_io_ops->is_console) {
 			len = strlen(kdb_buffer);
 			cp = kdb_buffer;
 			while (len--) {
-- 
1.7.2.3



