Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498Ab1DDKGv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 06:06:51 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63917 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754280Ab1DDKGt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 06:06:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=lS0kawc6dj0eaK3vfuh1tQyU9N4gguABRLH7CcCRj4vXWDMTqsQ/b+y3L8St0x+S4a
         EeLox1YO2ucEYPgw2jIXmRnqtTQOs/ZF5rBXc15pv296IKqb8J2AX0p8nQzRfDERujFJ
         OQr50/a7H9Jfs5eQhiME+Gfgq6vB7qGoX4sAk=
Date: Mon, 4 Apr 2011 03:06:45 -0700
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Cyrill Gorcunov <gorcunov@gmail.com>,
        David Rientjes <rientjes@google.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: [PATCH tip:x86/urgent] x86-32, NUMA: Fix ACPI NUMA init broken by
 recent x86-64 change
Message-ID: <20110404100645.GE1420@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit d8fc3afc49 (x86, NUMA: Move *_numa_init() invocations into
initmem_init()) moved acpi_numa_init() call into NUMA initmem_init()
but forgot to update 32bit NUMA init breking ACPI NUMA configuration
for 32bit.

acpi_numa_init() call was later moved again to srat_64.c.  Match it by
adding the call to get_memcfg_from_srat() in srat_32.c.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: H. Peter Anvin <hpa@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/x86/mm/srat_32.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

Index: work/arch/x86/mm/srat_32.c
===================================================================
--- work.orig/arch/x86/mm/srat_32.c
+++ work/arch/x86/mm/srat_32.c
@@ -211,10 +211,12 @@ int __init get_memcfg_from_srat(void)
 {
 	int i, j, nid;
 
-
 	if (srat_disabled())
 		goto out_fail;
 
+	if (acpi_numa_init() < 0)
+		goto out_fail;
+
 	if (num_memory_chunks == 0) {
 		printk(KERN_DEBUG
 			 "could not find any ACPI SRAT memory areas.\n");
