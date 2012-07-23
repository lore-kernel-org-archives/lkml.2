Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755052Ab2GWVQX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 17:16:23 -0400
Received: from longford.logfs.org ([213.229.74.203]:44594 "EHLO
	longford.logfs.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754986Ab2GWVQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 17:16:17 -0400
Date: Mon, 23 Jul 2012 16:02:30 -0400
From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
To: Tvrtko Ursulin <tvrtko.ursulin@onelan.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Jeff Moyer <jmoyer@redhat.com>, Steve Hodgson <steve@purestorage.com>
Subject: Re: [PATCH] add blockconsole version 1.1
Message-ID: <20120723200230.GC17767@logfs.org>
References: <20120424205946.GH20610@logfs.org>
 <x49vcknkdvn.fsf@segfault.boston.devel.redhat.com>
 <20120712174633.GA7248@logfs.org>
 <201207231533.16350.tvrtko.ursulin@onelan.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201207231533.16350.tvrtko.ursulin@onelan.co.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 July 2012 15:33:16 +0100, Tvrtko Ursulin wrote:
> On Thursday 12 Jul 2012 18:46:34 Jörn Engel wrote:
> > Console driver similar to netconsole, except it writes to a block
> > device.  Can be useful in a setup where netconsole, for whatever
> > reasons, is impractical.
> 
> Perhaps you need to add a word or two about limitations compared to netconsole 
> in documentation because it is quite significant difference in reliability? I 
> mean so it is not assumed it is analogous to netconsole but just a different 
> underlying media. I don't know if someone would expect it, but better said 
> than not. 

Given that I don't even know the limitations, that's a bit tough.  As
a general rule, I would always prefer netconsole.  It appears to be
more reliable than blockconsole and beats serial console by half a
lightyear.  But as a fallback when netconsole is not realistic,
blockconsole has proven useful.

> I second the notion that logging to partitions would be useful.

Below is a compile-tested patch to do that.  Feel free to give it a
spin and fix any bugs.

> Also, and I haven't checked what the swap format is, if it could somehow be 
> integrated together that could be useful.

That appears to be slightly less likely than crossbreeding a rabbit
with a chicken.  Is there something obvious I have missed?

Jörn

--
The story so far:
In the beginning the Universe was created.  This has made a lot
of people very angry and been widely regarded as a bad move.
-- Douglas Adams

[PATCH 2/2] bcon: Add a module parameter to support partitions

The usual methods of hooking into the partition scanner does not work
for partitions.  Allow those who care to pass in a module parameter.

Signed-off-by: Joern Engel <joern@logfs.org>
---
 drivers/block/blockconsole.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/block/blockconsole.c b/drivers/block/blockconsole.c
index 09f239c..91c27ce 100644
--- a/drivers/block/blockconsole.c
+++ b/drivers/block/blockconsole.c
@@ -10,6 +10,7 @@
 #include <linux/kref.h>
 #include <linux/kthread.h>
 #include <linux/mm.h>
+#include <linux/moduleparam.h>
 #include <linux/mount.h>
 #include <linux/random.h>
 #include <linux/slab.h>
@@ -543,6 +544,14 @@ static void bcon_create_fuzzy(const char *name)
 	}
 }
 
+static int bcon_setup(const char *val, struct kernel_param *kp)
+{
+	bcon_create_fuzzy(val);
+	return 0;
+}
+
+module_param_call(device, bcon_setup, NULL, NULL, 0200);
+
 static DEFINE_SPINLOCK(device_lock);
 static char scanned_devices[80];
 
-- 
1.7.10.4

