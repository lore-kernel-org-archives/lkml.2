Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab2G2Ss1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jul 2012 14:48:27 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:40606 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753359Ab2G2Ss0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jul 2012 14:48:26 -0400
X-Authenticated: #787645
X-Provags-ID: V01U2FsdGVkX1/Xq0Mqt6XXP4B+UElfcKzTXli/qF99Yv/YDGToL4
	FOYcJyU0/2L7zv
Message-ID: <50158577.7060908@gmx.net>
Date: Sun, 29 Jul 2012 20:48:23 +0200
From: Witold Szczeponik <Witold.Szczeponik@gmx.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: bhelgaas@google.com, lenb@kernel.org
CC: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [PATCH V3 2/3] PNP: Allow resources to be set as disabled
References: <50158321.4030007@gmx.net>
In-Reply-To: <50158321.4030007@gmx.net>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch allows to set PNP resources as "disabled".  As such, the patch is
a follow-up to commit 18fd470a48396c8795ba7256c5973e92ffa25cb3 where parsing
of ACPI PNP resources that can be disabled was made possible.  

The patch achieves this by allowing the strings "disabled" and "<none>" to be 
used as a valid PNP resource value.  The value "disabled" is used because it
also appears when reporting PNP resources, whereas the string "<none>" is
used when reporting PNP options.

The patch is required in order to support the setting of "disabled" IRQs like 
described in the commit 29df8d8f8702f0f53c1375015f09f04bc8d023c1, i.e., with
this patch applied, some vintage IBM ThinkPads like the 600E can allocate the
resources such that all devices can be used simultaneously.  

The patch is applied against Linux 3.5.x.


Signed-off-by: Witold Szczeponik <Witold.Szczeponik@gmx.net>
Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>


Index: linux/drivers/pnp/interface.c
===================================================================
--- linux.orig/drivers/pnp/interface.c
+++ linux/drivers/pnp/interface.c
@@ -311,10 +311,14 @@ static char *pnp_get_resource_value(char
 	if (flags)
 		*flags = 0;
 
-	/* TBD: allow for disabled resources */
-
 	buf = skip_spaces(buf);
-	if (start) {
+	if (flags && !strnicmp(buf, "disabled", 8)) {
+		buf += 8;
+		*flags |= IORESOURCE_DISABLED;
+	} else if (flags && !strnicmp(buf, "<none>", 6)) {
+		buf += 6;
+		*flags |= IORESOURCE_DISABLED;
+	} else if (start) {
 		*start = simple_strtoull(buf, &buf, 0);
 		if (end) {
 			buf = skip_spaces(buf);
