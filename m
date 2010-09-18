Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757417Ab0IRT2n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:28:43 -0400
Received: from kroah.org ([198.145.64.141]:43551 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756839Ab0IRTP3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:15:29 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:13:03 2010
Message-Id: <20100918191303.089458245@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:45 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Robert Richter <robert.richter@amd.com>
Subject: [067/129] oprofile, x86: fix init_sysfs error handling
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Robert Richter <robert.richter@amd.com>

commit 10f0412f57f2a76a90eff4376f59cbb0a39e4e18 upstream.

On failure init_sysfs() might not properly free resources. The error
code of the function is not checked. And, when reinitializing the exit
function might be called twice. This patch fixes all this.

Signed-off-by: Robert Richter <robert.richter@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/oprofile/nmi_int.c |   16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

--- a/arch/x86/oprofile/nmi_int.c
+++ b/arch/x86/oprofile/nmi_int.c
@@ -568,8 +568,13 @@ static int __init init_sysfs(void)
 	int error;
 
 	error = sysdev_class_register(&oprofile_sysclass);
-	if (!error)
-		error = sysdev_register(&device_oprofile);
+	if (error)
+		return error;
+
+	error = sysdev_register(&device_oprofile);
+	if (error)
+		sysdev_class_unregister(&oprofile_sysclass);
+
 	return error;
 }
 
@@ -695,6 +700,8 @@ int __init op_nmi_init(struct oprofile_o
 	char *cpu_type = NULL;
 	int ret = 0;
 
+	using_nmi = 0;
+
 	if (!cpu_has_apic)
 		return -ENODEV;
 
@@ -774,7 +781,10 @@ int __init op_nmi_init(struct oprofile_o
 
 	mux_init(ops);
 
-	init_sysfs();
+	ret = init_sysfs();
+	if (ret)
+		return ret;
+
 	using_nmi = 1;
 	printk(KERN_INFO "oprofile: using NMI interrupt.\n");
 	return 0;


