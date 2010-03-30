Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757820Ab0CaAeT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:34:19 -0400
Received: from kroah.org ([198.145.64.141]:48769 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756252Ab0C3XLw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:11:52 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:13 2010
Message-Id: <20100330225813.099145953@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:10 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Thomas Renninger <trenn@suse.de>, Dave Jones <davej@redhat.com>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [08/89] CPUFREQ: Fix use after free of struct powernow_k8_data
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Thomas Renninger <trenn@suse.de>

commit 557a701c16553b0b691dbb64ef30361115a80f64 upstream.

Easy fix for a regression introduced in 2.6.31.

On managed CPUs the cpufreq.c core will call driver->exit(cpu) on the
managed cpus and powernow_k8 will free the core's data.

Later driver->get(cpu) function might get called trying to read out the
current freq of a managed cpu and the NULL pointer check does not work on
the freed object -> better set it to NULL.

->get() is unsigned and must return 0 as invalid frequency.

Reference:
http://bugzilla.kernel.org/show_bug.cgi?id=14391

Signed-off-by: Thomas Renninger <trenn@suse.de>
Tested-by: Michal Schmidt <mschmidt@redhat.com>
Signed-off-by: Dave Jones <davej@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 arch/x86/kernel/cpu/cpufreq/powernow-k8.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
+++ b/arch/x86/kernel/cpu/cpufreq/powernow-k8.c
@@ -1372,6 +1372,7 @@ static int __devexit powernowk8_cpu_exit
 
 	kfree(data->powernow_table);
 	kfree(data);
+	per_cpu(powernow_data, pol->cpu) = NULL;
 
 	return 0;
 }
@@ -1391,7 +1392,7 @@ static unsigned int powernowk8_get(unsig
 	int err;
 
 	if (!data)
-		return -EINVAL;
+		return 0;
 
 	smp_call_function_single(cpu, query_values_on_cpu, &err, true);
 	if (err)


