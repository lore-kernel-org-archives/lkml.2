Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab0DTMSV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 08:18:21 -0400
Received: from ozlabs.org ([203.10.76.45]:41056 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754418Ab0DTMST (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 08:18:19 -0400
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Christian Kujau <lists@nerdbynature.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linuxppc-dev@ozlabs.org, schwab@linux-m68k.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       adobriyan@gmail.com, Maciej Rutecki <maciej.rutecki@gmail.com>
In-Reply-To: <alpine.DEB.2.01.1004192339190.13016@bogon.housecafe.de>
References: <deuQKFRcc0B.A.3EG.BRSzLB@tosh> <YeFfFNFyTSF.A.vUB.fSSzLB@tosh>
	 <alpine.DEB.2.01.1004192339190.13016@bogon.housecafe.de>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 20 Apr 2010 22:18:18 +1000
Message-ID: <1271765898.4324.2.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-04-19 at 23:45 -0700, Christian Kujau wrote:
> On Tue, 20 Apr 2010 at 05:19, Rafael J. Wysocki wrote:
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=15589
> > Subject		: 2.6.34-rc1: Badness at fs/proc/generic.c:316
> > Submitter	: Christian Kujau <lists@nerdbynature.de>
> > Date		: 2010-03-13 23:53 (38 days old)
> > Message-ID	: <alpine.DEB.2.01.1003131544340.5493@bogon.housecafe.de>
> > References	: http://marc.info/?l=linux-kernel&m=126852442903680&w=2
> 
> Yes, unless something in this area has changed from -rc4 to -rc5, this is 
> still printed during boot:
> 
> 
> device-tree: Duplicate name in /cpus/PowerPC,G4@0, renamed to "l2-cache#1"
> name 'pulses/rev'
> ------------[ cut here ]------------

Don't cut here, sigh.

> Badness at fs/proc/generic.c:317

Try this 100% unbuilt, 100% untested patch.

cheers


diff --git a/fs/proc/proc_devtree.c b/fs/proc/proc_devtree.c
index f8650dc..9502b48 100644
--- a/fs/proc/proc_devtree.c
+++ b/fs/proc/proc_devtree.c
@@ -175,6 +175,24 @@ retry:
        return fixed_name;
 }
 
+static const char *unslash_name(const char *name)
+{
+       char *p, *fixed_name;
+
+       fixed_name = kstrdup(name);
+       if (!fixed_name) {
+               printk(KERN_ERR "device-tree: Out of memory trying to unslash "
+                               "name \"%s\"\n", name);
+               return name;
+       }
+
+       p = fixed_name;
+       while ((p = strstr(p, "/")))
+               *p++ = '_';
+
+       return fixed_name;
+}
+
 /*
  * Process a node, adding entries for its children and its properties.
  */
@@ -211,6 +229,9 @@ void proc_device_tree_add_node(struct device_node *np,
                if (duplicate_name(de, p))
                        p = fixup_name(np, de, p);
 
+               if (strstr(p, "/"))
+                       p = unslash_name(p);
+
                ent = __proc_device_tree_add_prop(de, pp, p);
                if (ent == NULL)
                        break;


