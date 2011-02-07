Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab1BGV7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:59:38 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:54751 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754971Ab1BGV7h convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:59:37 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=XAMRoTiOjPCDCPXA2QdA/V00C6qqbPboRu4vLwuZ3/jka+r2CEhbbvA/bKn1pWJN3+
         EzI8rXpqTpFP2YYE4+RDMWi8CDa0fp9W1EpUf/EYW/VbBda8ygXq2gR0wDdbx8sxgqA8
         D4filzhpJyc0UaNeBLjk5Br4Y/Bwzw6GhZOKk=
MIME-Version: 1.0
Date: Mon, 7 Feb 2011 15:59:32 -0600
Message-ID: <AANLkTinknGa1WZ-kxFNG6pZOaJHgF_tkdz6aAjsLf6bM@mail.gmail.com>
Subject: [RESEND PATCH] dcdbas: force SMI to happen when expected
From: Stuart Hayes <stuart.w.hayes@gmail.com>
To: linux-kernel@vger.kernel.org, douglas_warzecha@dell.com,
        shyam_iyer@dell.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending from a different email address so I don't have to attach the
patch as a file.


The dcdbas driver can do an I/O write to cause a SMI to occur.  On some sys=
tems I/O writes are posted in the chipset and don't complete immediately.  =
This can result in the SMI happening at a later time.  This can result in r=
andom failures since the SMI handler expects the EBX register to contain a =
pointer, and the handler can write to memory.

Performing an I/O read to the same address as the I/O write will force the =
I/O write to complete.  The patch is against the 2.6.37 kernel and has been=
 tested.

Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
Acked-by: Doug Warzecha <douglas_warzecha@dell.com>
---
diff -purN linux-2.6.37/drivers/firmware/dcdbas.c
linux-2.6.37_test/drivers/firmware/dcdbas.c
--- linux-2.6.37/drivers/firmware/dcdbas.c    2011-01-18
10:44:44.869882461 -0500
+++ linux-2.6.37_test/drivers/firmware/dcdbas.c    2011-01-18
10:41:15.404612154 -0500
@@ -278,6 +278,9 @@ int dcdbas_smi_request(struct smi_cmd *s
         : "memory"
     );

+    /* read to force posted write through and make SMI happen now */
+    inb(smi_cmd->command_address);
+
 out:
     set_cpus_allowed_ptr(current, old_mask);
     free_cpumask_var(old_mask);
