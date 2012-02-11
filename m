Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754575Ab2BKWwf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 17:52:35 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:56403 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751211Ab2BKWwe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 17:52:34 -0500
Message-ID: <1329000754.325.52.camel@deadeye>
Subject: [PATCH 2/5] x86/cpu: Clean up modalias feature matching
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org, Thomas Renninger <trenn@suse.de>,
        Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org
Date: Sat, 11 Feb 2012 22:52:34 +0000
In-Reply-To: <1329000256.325.48.camel@deadeye>
References: <1329000256.325.48.camel@deadeye>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently include commas on both sides of the feature ID in a
modalias, but this prevents the lowest numbered feature of a CPU from
being matched.  Since all feature IDs have the same length, we do not
need to worry about substring matches, so omit commas from the
modalias entirely.

Avoid generating multiple adjacent wildcards when there is no
feature ID to match.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 arch/x86/kernel/cpu/match.c |    3 +--
 scripts/mod/file2alias.c    |    5 +++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/match.c b/arch/x86/kernel/cpu/match.c
index 2dfa52b..5502b28 100644
--- a/arch/x86/kernel/cpu/match.c
+++ b/arch/x86/kernel/cpu/match.c
@@ -63,7 +63,7 @@ ssize_t arch_print_cpu_modalias(struct device *dev,
 		boot_cpu_data.x86_model);
 	size -= n;
 	buf += n;
-	size -= 2;
+	size -= 1;
 	for (i = 0; i < NCAPINTS*32; i++) {
 		if (boot_cpu_has(i)) {
 			n = snprintf(buf, size, ",%04X", i);
@@ -75,7 +75,6 @@ ssize_t arch_print_cpu_modalias(struct device *dev,
 			buf += n;
 		}
 	}
-	*buf++ = ',';
 	*buf++ = '\n';
 	return buf - bufptr;
 }
diff --git a/scripts/mod/file2alias.c b/scripts/mod/file2alias.c
index a468af0..78fd81f 100644
--- a/scripts/mod/file2alias.c
+++ b/scripts/mod/file2alias.c
@@ -1021,8 +1021,9 @@ static int do_x86cpu_entry(const char *filename, struct x86_cpu_id *id,
 	ADD(alias, "vendor:",  id->vendor != X86_VENDOR_ANY, id->vendor);
 	ADD(alias, ":family:", id->family != X86_FAMILY_ANY, id->family);
 	ADD(alias, ":model:",  id->model  != X86_MODEL_ANY,  id->model);
-	ADD(alias, ":feature:*,", id->feature != X86_FEATURE_ANY, id->feature);
-	strcat(alias, ",*");
+	strcat(alias, ":feature:*");
+	if (id->feature != X86_FEATURE_ANY)
+		sprintf(alias + strlen(alias), "%04X*", id->feature);
 	return 1;
 }
 ADD_TO_DEVTABLE("x86cpu", struct x86_cpu_id, do_x86cpu_entry);
-- 
1.7.9



