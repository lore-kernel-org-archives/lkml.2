Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756792Ab2B1VKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 16:10:35 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:49430 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752470Ab2B1VKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 16:10:33 -0500
Date: Tue, 28 Feb 2012 16:10:23 -0500 (EST)
Message-Id: <20120228.161023.117381282430807415.davem@davemloft.net>
To: mroos@linux.ee
Cc: sam@ravnborg.org, tj@kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
From: David Miller <davem@davemloft.net>
In-Reply-To: <20120227.163044.2168482307021109001.davem@davemloft.net>
References: <20120227194341.GA1448@merkur.ravnborg.org>
	<alpine.SOC.1.00.1202272316280.15067@math.ut.ee>
	<20120227.163044.2168482307021109001.davem@davemloft.net>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 28 Feb 2012 13:10:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Miller <davem@davemloft.net>
Date: Mon, 27 Feb 2012 16:30:44 -0500 (EST)

> I think the issue is that OF writes past the end of the buffer even
> though the length it reports is smaller than what it writes.

Meelis, can you get your tree back into a state where the crash happens
and then add the following debugging patch and see what happens?

Thanks!

diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
index 07cc1d6..367ef33 100644
--- a/drivers/of/pdt.c
+++ b/drivers/of/pdt.c
@@ -125,12 +125,31 @@ static struct property * __init of_pdt_build_one_prop(phandle node, char *prev,
 		} else {
 			int len;
 
+#if 1
+			int i;
+			p->value = prom_early_alloc(p->length + 1 + 64);
+			for (i = p->length + 1; i < p->length + 1 + 64; i++)
+				((unsigned char *)p->value)[i] = 0xff;
+#else
 			p->value = prom_early_alloc(p->length + 1);
+#endif
 			len = of_pdt_prom_ops->getproperty(node, p->name,
 					p->value, p->length);
-			if (len <= 0)
+			if (len <= 0) {
+				pr_info("OF BUG: getproperty(%s, %d) returns %d\n",
+					p->name, p->length, len);
 				p->length = 0;
+			}
 			((unsigned char *)p->value)[p->length] = '\0';
+#if 1
+			for (i = p->length + 1; i < p->length + 1 + 64; i++) {
+				if (((unsigned char *)p->value)[i] != 0xff) {
+					pr_info("OF BUG: Write past end of property buffer\n");
+					pr_info("OF BUG: Property name [%s] length [%d] getprop len [%d]\n",
+						p->name, p->length, len);
+				}
+			}
+#endif
 		}
 	}
 	return p;
@@ -161,7 +180,11 @@ static char * __init of_pdt_get_one_property(phandle node, const char *name)
 
 	len = of_pdt_prom_ops->getproplen(node, name);
 	if (len > 0) {
+#if 1
+		buf = prom_early_alloc(len + 64);
+#else
 		buf = prom_early_alloc(len);
+#endif
 		len = of_pdt_prom_ops->getproperty(node, name, buf, len);
 	}
 
