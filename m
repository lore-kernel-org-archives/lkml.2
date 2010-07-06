Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451Ab0GFEa5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 00:30:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47084 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab0GFEa4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 00:30:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=P/n3/s9s9/e/5C2xWrhfVzbcRQi2NAX7RotvFJsDcPQleEB9UI9KynHQweWBLqsPWj
         Y5RZrJO2Ji4zOsSK7WKG8nWdxp/3EFv9X5Af6DAKhA1QoIDm0JgWocpnlKWtUqcHZBKf
         2rxlJK93GxWYYzSzWaDQYC8snx5SPD+XGXlgE=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: minyard@acm.org
Cc: akpm@linux-foundation.org, openipmi-developer@lists.sourceforge.net,
       linux-kernel@vger.kernel.org,
       "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH]ipmi:ipmi_si_intf.c Fix warning: variable 'addr_space' set but not used
Date: Mon,  5 Jul 2010 21:31:02 -0700
Message-Id: <1278390662-9455-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.1.rc1.21.gf3bd6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove addr_space in exchange for two symbols that represent 
mm = IPMI_MEM_ADDR_SPACE;
io = IPMI_IO_ADDR_SPACE;
then add a dev_warn printing information so that GCC doesn't give a
warning when building the kernel.
the original warning from GCC is this:

  CC [M]  drivers/char/ipmi/ipmi_si_intf.o
drivers/char/ipmi/ipmi_si_intf.c: In function 'try_init_spmi':
drivers/char/ipmi/ipmi_si_intf.c:2016:8: warning: variable 'addr_space' set but not used

And also the web address pointing to a *.pdf is no where to be found(or atleast I couldn't
find it), so just use the web site itself(if somebody has the *.pdf
let me know I can change this).

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/char/ipmi/ipmi_si_intf.c |   14 +++++++++-----
 1 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/char/ipmi/ipmi_si_intf.c b/drivers/char/ipmi/ipmi_si_intf.c
index 094bdc3..969e69a 100644
--- a/drivers/char/ipmi/ipmi_si_intf.c
+++ b/drivers/char/ipmi/ipmi_si_intf.c
@@ -1965,8 +1965,7 @@ static int acpi_gpe_irq_setup(struct smi_info *info)
 
 /*
  * Defined at
- * http://h21007.www2.hp.com/dspp/files/unprotected/devresource/
- * Docs/TechPapers/IA64/hpspmi.pdf
+ * http://h21007.www2.hp.com/portal/site/dspp
  */
 struct SPMITable {
 	s8	Signature[4];
@@ -2013,7 +2012,7 @@ struct SPMITable {
 static __devinit int try_init_spmi(struct SPMITable *spmi)
 {
 	struct smi_info  *info;
-	u8 		 addr_space;
+	u8		mem, io;
 
 	if (spmi->IPMIlegacy != 1) {
 		printk(KERN_INFO PFX "Bad SPMI legacy %d\n", spmi->IPMIlegacy);
@@ -2021,9 +2020,14 @@ static __devinit int try_init_spmi(struct SPMITable *spmi)
 	}
 
 	if (spmi->addr.space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY)
-		addr_space = IPMI_MEM_ADDR_SPACE;
+		mem = IPMI_MEM_ADDR_SPACE;
 	else
-		addr_space = IPMI_IO_ADDR_SPACE;
+		io  = IPMI_IO_ADDR_SPACE;
+
+	if (mem || io) {
+		dev_warn(info->dev, "spmi address space %d\n", mem ?: io);
+		return 0;
+	}
 
 	info = kzalloc(sizeof(*info), GFP_KERNEL);
 	if (!info) {
-- 
1.7.1.rc1.21.gf3bd6

