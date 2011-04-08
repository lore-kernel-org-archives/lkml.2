Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab1DHXyz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 19:54:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:35121 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab1DHXyx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 19:54:53 -0400
Date: Fri, 8 Apr 2011 16:54:51 -0700 (PDT)
From: Jiri Kosina <jkosina@suse.cz>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Ott <alan@signal11.us>
Subject: Re: linux-next: build failure after merge of the hid tree
In-Reply-To: <20110407110626.397202fb.sfr@canb.auug.org.au>
Message-ID: <alpine.LNX.2.00.1104081645480.6022@pobox.suse.cz>
References: <20110407110626.397202fb.sfr@canb.auug.org.au>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Apr 2011, Stephen Rothwell wrote:

> Hi Jiri,
> 
> After merging the hid tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> samples/hidraw/hid-example.c: In function 'main':
> samples/hidraw/hid-example.c:103: warning: implicit declaration of function 'HIDIOCSFEATURE'
> samples/hidraw/hid-example.c:111: warning: implicit declaration of function 'HIDIOCGFEATURE'
> tmp/ccK96SHd.o: In function `main':
> hid-example.c:(.text+0x205): undefined reference to `HIDIOCSFEATURE'
> hid-example.c:(.text+0x23e): undefined reference to `HIDIOCGFEATURE'
> 
> Caused by commit c54ea4918c2b ("HID: Documentation for hidraw").  I can
> only assume that linux/hidraw.h is being included from /usr/include and
> not the kernel tree being built?
> 
> I have used the hid tree from next-20110406 for today.

OK, I have introduced the patch below to the branch now. I am not proud of 
it, but I don't see other option currently. Will remove it after some 
time.



From: Jiri Kosina <jkosina@suse.cz>
Subject: [PATCH] HID: hidraw: fix samples miscompilation

On systems where userspace doesn't have new hidraw.h populated to
/usr/include, the hidraw sample won't compile as it's missing the new
ioctl defitions.

Introduce temporary ugly workaround to define the ioctls "manually"
in such cases, just to avoid miscompilation in allmodconfig cases.

Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
---
 samples/hidraw/hid-example.c |   11 +++++++++++
 1 files changed, 11 insertions(+), 0 deletions(-)

diff --git a/samples/hidraw/hid-example.c b/samples/hidraw/hid-example.c
index 40e3d62..816e2dc 100644
--- a/samples/hidraw/hid-example.c
+++ b/samples/hidraw/hid-example.c
@@ -14,6 +14,17 @@
 #include <linux/input.h>
 #include <linux/hidraw.h>
 
+/*
+ * Ugly hack to work around failing compilation on systems that don't
+ * yet populate new version of hidraw.h to userspace.
+ *
+ * If you need this, please have your distro update the kernel headers.
+ */
+#ifndef HIDIOCSFEATURE
+#define HIDIOCSFEATURE(len)    _IOC(_IOC_WRITE|_IOC_READ, 'H', 0x06, len)
+#define HIDIOCGFEATURE(len)    _IOC(_IOC_WRITE|_IOC_READ, 'H', 0x07, len)
+#endif
+
 /* Unix */
 #include <sys/ioctl.h>
 #include <sys/types.h>
-- 
1.7.3.1


