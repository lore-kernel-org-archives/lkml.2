Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756248Ab1ALUgR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 15:36:17 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:57498 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752167Ab1ALUgP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 15:36:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH -next] x86/e820: fix build when ACPI is disabled
Date: Wed, 12 Jan 2011 21:35:55 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37+; KDE/4.4.4; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jslaby@suse.cz>,
        lenb@kernel.org, linux-acpi@vger.kernel.org
References: <20110112141822.c29314c4.sfr@canb.auug.org.au> <20110112122014.2d8455d7.randy.dunlap@oracle.com>
In-Reply-To: <20110112122014.2d8455d7.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101122135.55567.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, January 12, 2011, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix build error when CONFIG_ACPI is not enabled:
> 
> arch/x86/kernel/e820.c:734: error:implicit declaration of function 'suspend_nvs_register'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> ---
>  include/linux/acpi.h |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> --- linux-next-20110112.orig/include/linux/acpi.h
> +++ linux-next-20110112/include/linux/acpi.h
> @@ -360,5 +360,10 @@ static inline int acpi_table_parse(char 
>  {
>  	return -1;
>  }
> +
> +static inline int suspend_nvs_register(unsigned long a, unsigned long b)
> +{
> +	return 0;
> +}
>  #endif	/* !CONFIG_ACPI */
>  #endif	/*_LINUX_ACPI_H*/

I'd prefer the appended patch (it also should fix the problem indicated by Jiri).

Does it work for you?

Rafael


---
 drivers/acpi/internal.h |    2 +-
 include/linux/acpi.h    |   19 ++++++++++---------
 2 files changed, 11 insertions(+), 10 deletions(-)

Index: linux-2.6/drivers/acpi/internal.h
===================================================================
--- linux-2.6.orig/drivers/acpi/internal.h
+++ linux-2.6/drivers/acpi/internal.h
@@ -91,7 +91,7 @@ void suspend_nvs_restore(void);
 static inline int acpi_sleep_proc_init(void) { return 0; }
 static inline int suspend_nvs_alloc(void) { return 0; }
 static inline void suspend_nvs_free(void) {}
-static inline int suspend_nvs_save(void) {}
+static inline int suspend_nvs_save(void) { return 0; }
 static inline void suspend_nvs_restore(void) {}
 #endif
 
Index: linux-2.6/include/linux/acpi.h
===================================================================
--- linux-2.6.orig/include/linux/acpi.h
+++ linux-2.6/include/linux/acpi.h
@@ -254,15 +254,6 @@ void __init acpi_old_suspend_ordering(vo
 void __init acpi_nvs_nosave(void);
 #endif /* CONFIG_PM_SLEEP */
 
-#ifdef CONFIG_ACPI_SLEEP
-int suspend_nvs_register(unsigned long start, unsigned long size);
-#else
-static inline int suspend_nvs_register(unsigned long a, unsigned long b)
-{
-	return 0;
-}
-#endif
-
 struct acpi_osc_context {
 	char *uuid_str; /* uuid string */
 	int rev;
@@ -361,4 +352,14 @@ static inline int acpi_table_parse(char
 	return -1;
 }
 #endif	/* !CONFIG_ACPI */
+
+#ifdef CONFIG_ACPI_SLEEP
+int suspend_nvs_register(unsigned long start, unsigned long size);
+#else
+static inline int suspend_nvs_register(unsigned long a, unsigned long b)
+{
+	return 0;
+}
+#endif
+
 #endif	/*_LINUX_ACPI_H*/
