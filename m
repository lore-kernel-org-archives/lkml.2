Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754943Ab2HMWF2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:05:28 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:60176 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754790Ab2HMWFY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:05:24 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Borislav Petkov <borislav.petkov@amd.com>,
        Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: [ 36/44] x86, microcode: Sanitize per-cpu microcode reloading interface
Date: Mon, 13 Aug 2012 15:02:43 -0700
Message-Id: <20120813220145.337264645@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120813220142.113186818@linuxfoundation.org>
References: <20120813220142.113186818@linuxfoundation.org>
User-Agent: quilt/0.60-20.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Borislav Petkov <borislav.petkov@amd.com>

commit c9fc3f778a6a215ace14ee556067c73982b6d40f upstream.

Microcode reloading in a per-core manner is a very bad idea for both
major x86 vendors. And the thing is, we have such interface with which
we can end up with different microcode versions applied on different
cores of an otherwise homogeneous wrt (family,model,stepping) system.

So turn off the possibility of doing that per core and allow it only
system-wide.

This is a minimal fix which we'd like to see in stable too thus the
more-or-less arbitrary decision to allow system-wide reloading only on
the BSP:

$ echo 1 > /sys/devices/system/cpu/cpu0/microcode/reload
...

and disable the interface on the other cores:

$ echo 1 > /sys/devices/system/cpu/cpu23/microcode/reload
-bash: echo: write error: Invalid argument

Also, allowing the reload only from one CPU (the BSP in
that case) doesn't allow the reload procedure to degenerate
into an O(n^2) deal when triggering reloads from all
/sys/devices/system/cpu/cpuX/microcode/reload sysfs nodes
simultaneously.

A more generic fix will follow.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1340280437-7718-2-git-send-email-bp@amd64.org
Signed-off-by: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/x86/kernel/microcode_core.c |   26 +++++++++++++++++++-------
 1 file changed, 19 insertions(+), 7 deletions(-)

--- a/arch/x86/kernel/microcode_core.c
+++ b/arch/x86/kernel/microcode_core.c
@@ -297,19 +297,31 @@ static ssize_t reload_store(struct sys_d
 			    const char *buf, size_t size)
 {
 	unsigned long val;
-	int cpu = dev->id;
-	ssize_t ret = 0;
+	int cpu;
+	ssize_t ret = 0, tmp_ret;
+
+	/* allow reload only from the BSP */
+	if (boot_cpu_data.cpu_index != dev->id)
+		return -EINVAL;
 
 	ret = kstrtoul(buf, 0, &val);
 	if (ret)
 		return ret;
 
-	if (val == 1) {
-		get_online_cpus();
-		if (cpu_online(cpu))
-			ret = reload_for_cpu(cpu);
-		put_online_cpus();
+	if (val != 1)
+		return size;
+
+	get_online_cpus();
+	for_each_online_cpu(cpu) {
+		tmp_ret = reload_for_cpu(cpu);
+		if (tmp_ret != 0)
+			pr_warn("Error reloading microcode on CPU %d\n", cpu);
+
+		/* save retval of the first encountered reload error */
+		if (!ret)
+			ret = tmp_ret;
 	}
+	put_online_cpus();
 
 	if (!ret)
 		ret = size;


