Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907Ab0C3XJL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 19:09:11 -0400
Received: from kroah.org ([198.145.64.141]:48515 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755842Ab0C3XJI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:09:08 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:49:56 2010
Message-Id: <20100330224956.153081018@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:48:44 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Alan Stern <stern@rowland.harvard.edu>,
       Marcus Meissner <meissner@suse.de>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [24/45] USB: usbfs: properly clean up the as structure on error paths
In-Reply-To: <20100330230410.GA28712@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit ddeee0b2eec2a51b0712b04de4b39e7bec892a53 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/core/devio.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/drivers/usb/core/devio.c
+++ b/drivers/usb/core/devio.c
@@ -1246,14 +1246,11 @@ static int processcompl(struct async *as
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
 
@@ -1283,8 +1280,11 @@ static struct async *reap_as(struct dev_
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
@@ -1292,11 +1292,16 @@ static int proc_reapurb(struct dev_state
 
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
@@ -1369,7 +1374,6 @@ static int processcompl_compat(struct as
 		}
 	}
 
-	free_async(as);
 	if (put_user(ptr_to_compat(addr), (u32 __user *)arg))
 		return -EFAULT;
 	return 0;
@@ -1378,8 +1382,11 @@ static int processcompl_compat(struct as
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
@@ -1387,11 +1394,16 @@ static int proc_reapurb_compat(struct de
 
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


