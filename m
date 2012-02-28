Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757469Ab2B1W5O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 17:57:14 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:50495 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431Ab2B1W5M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 17:57:12 -0500
Date: Tue, 28 Feb 2012 17:56:59 -0500 (EST)
Message-Id: <20120228.175659.40937269571989661.davem@davemloft.net>
To: mroos@linux.ee
Cc: sam@ravnborg.org, tj@kernel.org, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: OF-related boot crash in 3.3.0-rc3-00188-g3ec1e88
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.SOC.1.00.1202282333580.3974@math.ut.ee>
References: <20120227.163044.2168482307021109001.davem@davemloft.net>
	<20120228.161023.117381282430807415.davem@davemloft.net>
	<alpine.SOC.1.00.1202282333580.3974@math.ut.ee>
X-Mailer: Mew version 6.4 on Emacs 23.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 28 Feb 2012 14:57:03 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Meelis Roos <mroos@linux.ee>
Date: Tue, 28 Feb 2012 23:36:07 +0200 (EET)

>> Meelis, can you get your tree back into a state where the crash happens
>> and then add the following debugging patch and see what happens?
> 
> Tried it, no obvious results in dmesg, except the crash is in a slightly 
> different location.

Interesting, the corruption is a little bit different this time, yet similar
to the ones we saw previously:

> [    0.000000] TPC: <strcmp+0x8/0x60>
 ...
> [    0.000000] i0: 000000007fcf3c80 i1: fffff8007fcec480 i2: 0000000001010101 i3: 0000000080808080
> [    0.000000] i4: fffff8007fcb8ccd i5: 0000000000028337 i6: 0000000000763231 i7: 0000000000606250

This is strcmp(0x000000007fcf3c80, 0xfffff8007fcec480), the first arg is
a bad pointer, somehow the top virtual address bits have been zero'd out.

It comes from dp->full_name, so something walked all over the beginning
of a device_node object.

Let's see if we can figure out anything else about the nature of the
corruption, please add this patch on top.

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 133908a..7c0f7f4 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -376,6 +376,18 @@ struct device_node *of_find_node_by_path(const char *path)
 
 	read_lock(&devtree_lock);
 	for (; np; np = np->allnext) {
+		if (!np->full_name)
+			continue;
+
+		if ((unsigned long)np->full_name < 0xfffff80000000000) {
+			pr_info("OF BUG: Bogus full_name pointer [%p]\n",
+				np->full_name);
+			pr_info("OF BUG: np[%p] np->name[%p] np->type[%p] np->phandle[0x%08x]\n",
+				np, np->name, np->type, (unsigned int) np->phandle);
+			pr_info("OF BUG: np->name(%s) np->type(%s)\n",
+				np->name, np->type);
+		}
+
 		if (np->full_name && (of_node_cmp(np->full_name, path) == 0)
 		    && of_node_get(np))
 			break;
