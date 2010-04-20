Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754929Ab0DTSPo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 14:15:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:64538 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754081Ab0DTSPm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 14:15:42 -0400
Date: Tue, 20 Apr 2010 11:15:05 -0700 (PDT)
From: Christian Kujau <lists@nerdbynature.de>
To: Michael Ellerman <michael@ellerman.id.au>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, schwab@linux-m68k.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       adobriyan@gmail.com, Maciej Rutecki <maciej.rutecki@gmail.com>
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
In-Reply-To: <1271765898.4324.2.camel@concordia>
Message-ID: <alpine.DEB.2.01.1004201104170.13016@bogon.housecafe.de>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.vUB.fSSzLB@tosh>  <alpine.DEB.2.01.1004192339190.13016@bogon.housecafe.de> <1271765898.4324.2.camel@concordia>
User-Agent: Alpine 2.01 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
X-Provags-ID: V01U2FsdGVkX1/NgjPsYqPnzF6IfCq5ljrmLfl7jN6YXUD+OUm
 G1p99J4olcWZXWOqk3K7rzCrbNzVkVUwhU69m9Tt4zq0dsqxYI
 RbJKxLR2Z4Uaqv4DX6dXQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 20 Apr 2010 at 22:18, Michael Ellerman wrote:
> Try this 100% unbuilt, 100% untested patch.

I added GFP_KERNEL to kstrdup to make the compile error go away:

fs/proc/proc_devtree.c: In function ‘unslash_name’:
fs/proc/proc_devtree.c:183: error: too few arguments to function ‘kstrdup’
make[2]: *** [fs/proc/proc_devtree.o] Error 1
make[1]: *** [fs/proc] Error 2
make: *** [fs] Error 2

And now 2.6.34-rc5 compiles and boots without the warning. Thanks! 
New dmesg and /proc/device-tree on:

  http://nerdbynature.de/bits/2.6.34-rc1/xlate_proc_name/

Alexey mentioned that this is "wasteful" - does it make the kernel slower? 
I have not done any performance tests, but I'd rather stick with the 
warning than make this Powerbook G4 any more slower :-\


Thanks again,
Christian.

diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index ce94801..019581d 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -176,6 +176,24 @@ retry:
 	return fixed_name;
 }
 
+static const char *unslash_name(const char *name)
+{
+	char *p, *fixed_name;
+
+	fixed_name = kstrdup(name, GFP_KERNEL);
+	if (!fixed_name) {
+		printk(KERN_ERR "device-tree: Out of memory trying to unslash "
+				"name \"%s\"\n", name);
+	return name;
+	}
+
+	p = fixed_name;
+	while ((p = strstr(p, "/")))
+		*p++ = '_';
+
+	return fixed_name;
+}
+
 /*
  * Process a node, adding entries for its children and its properties.
  */
@@ -212,6 +230,9 @@ void proc_device_tree_add_node(struct device_node *np,
 		if (duplicate_name(de, p))
 			p = fixup_name(np, de, p);
 
+		if (strstr(p, "/"))
+			p = unslash_name(p);
+
 		ent = __proc_device_tree_add_prop(de, pp, p);
 		if (ent == NULL)
 			break;
-- 
BOFH excuse #369:

Virus transmitted from computer to sysadmins.
