Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752552Ab1AIXhR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Jan 2011 18:37:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54772
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849Ab1AIXhP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Jan 2011 18:37:15 -0500
Date: Sun, 09 Jan 2011 15:37:45 -0800 (PST)
Message-Id: <20110109.153745.35032992.davem@davemloft.net>
To: sam@ravnborg.org
Cc: peterz@infradead.org, linux-kernel@vger.kernel.org,
        sparclinux@vger.kernel.org
Subject: Re: sparc boot failure due to perf init
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110107203119.GA30408@merkur.ravnborg.org>
References: <1294431832.2016.457.camel@laptop>
	<1294432055.2016.458.camel@laptop>
	<20110107203119.GA30408@merkur.ravnborg.org>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sam Ravnborg <sam@ravnborg.org>
Date: Fri, 7 Jan 2011 21:31:19 +0100

> Then you guys can sort it out and I can test any patches
> you come up with.

Here is the fix I will be pushing to Linus to fix this:

--------------------
sparc64: Fix bootup regression due to perf init ordering.

Commit 004417a6d468e24399e383645c068b498eed84ad
("perf, arch: Cleanup perf-pmu init vs lockup-detector")
move the perf events init to be an early_initcall.

But this won't work properly unless the dependencies for
this code initialize beforehand.

Fix it by making cpu_type_probe and pcr_arch_init be
an early_initcall as well.

Reported-by: Sam Ravnborg <sam@ravnborg.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
---
 arch/sparc/kernel/cpu.c |    2 +-
 arch/sparc/kernel/pcr.c |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/sparc/kernel/cpu.c b/arch/sparc/kernel/cpu.c
index e447938..0dc714f 100644
--- a/arch/sparc/kernel/cpu.c
+++ b/arch/sparc/kernel/cpu.c
@@ -375,5 +375,5 @@ static int __init cpu_type_probe(void)
 	return 0;
 }
 
-arch_initcall(cpu_type_probe);
+early_initcall(cpu_type_probe);
 #endif
diff --git a/arch/sparc/kernel/pcr.c b/arch/sparc/kernel/pcr.c
index b87873c..ae96cf5 100644
--- a/arch/sparc/kernel/pcr.c
+++ b/arch/sparc/kernel/pcr.c
@@ -168,4 +168,4 @@ out_unregister:
 	return err;
 }
 
-arch_initcall(pcr_arch_init);
+early_initcall(pcr_arch_init);
-- 
1.7.3.4

