Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753543Ab1IUUTc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 16:19:32 -0400
Received: from va3ehsobe010.messaging.microsoft.com ([216.32.180.30]:43268
	"EHLO VA3EHSOBE010.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753151Ab1IUUTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 16:19:30 -0400
X-SpamScore: 0
X-BigFish: VPS0(zzzz1202hzz8275bhz2fh668h839h62h)
X-Spam-TCS-SCL: 1:0
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPVD:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4E7A46C0.6010804@am.sony.com>
Date: Wed, 21 Sep 2011 13:19:12 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] kdb:  Avoid using dbg_io_ops until it is initialized
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a bug with setting a breakpoint during kdb initialization
(from kdb_cmds).  Any call to kdb_printf() before the initialization
of the kgdboc serial console driver (which happens much later during
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


