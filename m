Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755506Ab1BDBoN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 20:44:13 -0500
Received: from qmta13.westchester.pa.mail.comcast.net ([76.96.59.243]:55606
	"EHLO qmta13.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753951Ab1BDBoM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 20:44:12 -0500
X-Greylist: delayed 361 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Feb 2011 20:44:12 EST
From: Kamal Mostafa <kamal@canonical.com>
To: x86@kernel.org
Cc: Kamal Mostafa <kamal@canonical.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Yinghai Lu <yinghai@kernel.org>, Len Brown <len.brown@intel.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] x86: fix panic when handling "mem={invalid}" param
Date: Thu,  3 Feb 2011 17:38:04 -0800
Message-Id: <1296783486-23033-1-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Avoid removing all of memory and panicing when "mem={invalid}" is
specified, e.g. mem=blahblah, mem=0, or mem=nopentium (on platforms
other than x86_32).

BugLink: http://bugs.launchpad.net/bugs/553464
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
Cc: <stable@kernel.org>
---
 arch/x86/kernel/e820.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/arch/x86/kernel/e820.c b/arch/x86/kernel/e820.c
index 294f26d..55a59d8 100644
--- a/arch/x86/kernel/e820.c
+++ b/arch/x86/kernel/e820.c
@@ -856,6 +856,9 @@ static int __init parse_memopt(char *p)
 
 	userdef = 1;
 	mem_size = memparse(p, &p);
+	/* don't remove all of memory when handling "mem={invalid}" param */
+	if (mem_size == 0)
+		return -EINVAL;
 	e820_remove_range(mem_size, ULLONG_MAX - mem_size, E820_RAM, 1);
 
 	return 0;
-- 
1.7.1

