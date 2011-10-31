Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1JaHvK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 03:51:10 -0400
Received: from ozlabs.org ([203.10.76.45]:35365 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754318Ab1JaHvJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 03:51:09 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>, miche@google.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org
Cc: xen-devel@lists.xensource.com
Subject: Re: Regression: patch " hvc_console: display printk messages on console." causing infinite loop with 3.2-rc0 + Xen.
In-Reply-To: <20111027053007.GA32765@phenom.dumpdata.com>
References: <20111027053007.GA32765@phenom.dumpdata.com>
User-Agent: Notmuch/0.6.1-1 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Mon, 31 Oct 2011 18:18:26 +1030
Message-ID: <87d3ddppo5.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Oct 2011 01:30:08 -0400, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
Non-text part: multipart/mixed
> Hey Miche.
> 
> The git commit 361162459f62dc0826b82c9690a741a940f457f0:
> 
>     hvc_console: display printk messages on console.
> 
> is causing an infinite loop when booting Linux under Xen, as so:

lguest too.

This is not a concurrency problem: the issue seems to be that calling
register_console() twice on the same struct console is a bad idea.

Simple fix which works here (might be completely wrong):

diff --git a/drivers/tty/hvc/hvc_console.c b/drivers/tty/hvc/hvc_console.c
--- a/drivers/tty/hvc/hvc_console.c
+++ b/drivers/tty/hvc/hvc_console.c
@@ -197,6 +197,8 @@ static int __init hvc_console_setup(stru
 	return 0;
 }
 
+static bool console_registered = false;
+
 static struct console hvc_console = {
 	.name		= "hvc",
 	.write		= hvc_console_print,
@@ -224,6 +226,7 @@ static struct console hvc_console = {
 static int __init hvc_console_init(void)
 {
 	register_console(&hvc_console);
+	console_registered = true;
 	return 0;
 }
 console_initcall(hvc_console_init);
@@ -279,8 +282,10 @@ int hvc_instantiate(uint32_t vtermno, in
 	 * now (setup won't fail at this point).  It's ok to just
 	 * call register again if previously .setup failed.
 	 */
-	if (index == hvc_console.index)
+	if (index == hvc_console.index && !console_registered) {
 		register_console(&hvc_console);
+		console_registered = true;
+	}
 
 	return 0;
 }
@@ -868,7 +873,10 @@ struct hvc_struct *hvc_alloc(uint32_t vt
 
 	list_add_tail(&(hp->next), &hvc_structs);
 	spin_unlock(&hvc_structs_lock);
-	register_console(&hvc_console);
+	if (!console_registered) {
+		register_console(&hvc_console);
+		console_registered = true;
+	}
 
 	return hp;
 }
@@ -880,6 +888,7 @@ int hvc_remove(struct hvc_struct *hp)
 	struct tty_struct *tty;
 
 	unregister_console(&hvc_console);
+	console_registered = false;
 	spin_lock_irqsave(&hp->lock, flags);
 	tty = tty_kref_get(hp->tty);
 
