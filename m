Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932138Ab1LWRjy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Dec 2011 12:39:54 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:43296 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932102Ab1LWRjp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Dec 2011 12:39:45 -0500
From: Julia Lawall <julia@diku.dk>
To: Tony Lindgren <tony@atomide.com>
Cc: kernel-janitors@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 6/9] arch/arm/mach-omap2/devices.c: introduce missing kfree
Date: Fri, 23 Dec 2011 18:39:31 +0100
Message-Id: <1324661974-17281-6-git-send-email-julia@diku.dk>
X-Mailer: git-send-email 1.7.3.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

pdata needs to be freed before leaving the function in an error case.

A simplified version of the semantic match that finds the problem is as
follows: (http://coccinelle.lip6.fr)

// <smpl>
@r exists@
local idexpression x;
statement S;
identifier f1;
position p1,p2;
expression *ptr != NULL;
@@

x@p1 = \(kmalloc\|kzalloc\|kcalloc\)(...);
...
if (x == NULL) S
<... when != x
     when != if (...) { <+...x...+> }
x->f1
...>
(
 return \(0\|<+...x...+>\|ptr\);
|
 return@p2 ...;
)

@script:python@
p1 << r.p1;
p2 << r.p2;
@@

print "* file: %s kmalloc %s return %s" % (p1[0].file,p1[0].line,p2[0].line)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 arch/arm/mach-omap2/devices.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm/mach-omap2/devices.c b/arch/arm/mach-omap2/devices.c
index 46dfd1a..3334a47 100644
--- a/arch/arm/mach-omap2/devices.c
+++ b/arch/arm/mach-omap2/devices.c
@@ -393,6 +393,7 @@ static int omap_mcspi_init(struct omap_hwmod *oh, void *unused)
 			break;
 	default:
 			pr_err("Invalid McSPI Revision value\n");
+			kfree(pdata);
 			return -EINVAL;
 	}
 

