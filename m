Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932861Ab0CaAYs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:24:48 -0400
Received: from kroah.org ([198.145.64.141]:49005 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756528Ab0C3XMf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:12:35 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:58:38 2010
Message-Id: <20100330225838.009568263@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:57:50 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Marcus Meissner <meissner@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>,
       Jeff Mahoney <jeffm@suse.com>
Subject: [48/89] USB: usbfs: properly clean up the as structure on error paths
In-Reply-To: <20100330230520.GA28779@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.31-stable review patch.  If anyone has any objections, please let us know.

------------------

commit ddeee0b2eec2a51b0712b04de4b39e7bec892a53 upstream

USB: usbfs: properly clean up the as structure on error paths

I notice that the processcompl_compat() function seems to be leaking the
'struct async *as' in the error paths.

I think that the calling convention is fundamentally buggered. The
caller is the one that did the "reap_as()" to get the as thing, the
caller should be the one to free it too.

Freeing it in the caller also means that it very clearly always gets
freed, and avoids the need for any "free in the error case too".

From: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Marcus Meissner <meissner@suse.de>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Acked-by: Jeff Mahoney <jeffm@suse.com>
---

 drivers/usb/core/devio.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1262,14 +1262,11 @@ static int processcompl(struct async *as
 		}
 	}
 
-	free_async(as);
-
 	if (put_user(addr, (void __user * __user *)arg))
 		return -EFAULT;
 	return 0;
 
 err_out:
-	free_async(as);
 	return -EFAULT;
 }
 
@@ -1299,8 +1296,11 @@ static struct async *reap_as(struct dev_
 static int proc_reapurb(struct dev_state *ps, void __user *arg)
 {
 	struct async *as = reap_as(ps);
-	if (as)
-		return processcompl(as, (void __user * __user *)arg);
+	if (as) {
+		int retval = processcompl(as, (void __user * __user *)arg);
+		free_async(as);
+		return retval;
+	}
 	if (signal_pending(current))
 		return -EINTR;
 	return -EIO;
@@ -1308,11 +1308,16 @@ static int proc_reapurb(struct dev_state
 
 static int proc_reapurbnonblock(struct dev_state *ps, void __user *arg)
 {
+	int retval;
 	struct async *as;
 
-	if (!(as = async_getcompleted(ps)))
-		return -EAGAIN;
-	return processcompl(as, (void __user * __user *)arg);
+	as = async_getcompleted(ps);
+	retval = -EAGAIN;
+	if (as) {
+		retval = processcompl(as, (void __user * __user *)arg);
+		free_async(as);
+	}
+	return retval;
 }
 
 #ifdef CONFIG_COMPAT
@@ -1385,7 +1390,6 @@ static int processcompl_compat(struct as
 		}
 	}
 
-	free_async(as);
 	if (put_user(ptr_to_compat(addr), (u32 __user *)arg))
 		return -EFAULT;
 	return 0;
@@ -1394,8 +1398,11 @@ static int processcompl_compat(struct as
 static int proc_reapurb_compat(struct dev_state *ps, void __user *arg)
 {
 	struct async *as = reap_as(ps);
-	if (as)
-		return processcompl_compat(as, (void __user * __user *)arg);
+	if (as) {
+		int retval = processcompl_compat(as, (void __user * __user *)arg);
+		free_async(as);
+		return retval;
+	}
 	if (signal_pending(current))
 		return -EINTR;
 	return -EIO;
@@ -1403,11 +1410,16 @@ static int proc_reapurb_compat(struct de
 
 static int proc_reapurbnonblock_compat(struct dev_state *ps, void __user *arg)
 {
+	int retval;
 	struct async *as;
 
-	if (!(as = async_getcompleted(ps)))
-		return -EAGAIN;
-	return processcompl_compat(as, (void __user * __user *)arg);
+	retval = -EAGAIN;
+	as = async_getcompleted(ps);
+	if (as) {
+		retval = processcompl_compat(as, (void __user * __user *)arg);
+		free_async(as);
+	}
+	return retval;
 }
 
 #endif


