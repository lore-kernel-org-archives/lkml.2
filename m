Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965204Ab1KJETR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 23:19:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44281 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965322Ab1KJDlY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:41:24 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:31:51 2011
Message-Id: <20111109213151.525999008@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:32:21 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [094/264] kmod: prevent kmod_loop_msg overflow in __request_module()
In-Reply-To: <20111109213508.GA3476@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiri Kosina <jkosina@suse.cz>

commit 37252db6aa576c34fd794a5a54fb32d7a8b3a07a upstream.

Due to post-increment in condition of kmod_loop_msg in __request_module(),
the system log can be spammed by much more than 5 instances of the 'runaway
loop' message if the number of events triggering it makes the kmod_loop_msg
to overflow.

Fix that by making sure we never increment it past the threshold.

Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Rusty Russell <rusty@rustcorp.com.au>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 kernel/kmod.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/kernel/kmod.c
+++ b/kernel/kmod.c
@@ -114,10 +114,12 @@ int __request_module(bool wait, const ch
 	atomic_inc(&kmod_concurrent);
 	if (atomic_read(&kmod_concurrent) > max_modprobes) {
 		/* We may be blaming an innocent here, but unlikely */
-		if (kmod_loop_msg++ < 5)
+		if (kmod_loop_msg < 5) {
 			printk(KERN_ERR
 			       "request_module: runaway loop modprobe %s\n",
 			       module_name);
+			kmod_loop_msg++;
+		}
 		atomic_dec(&kmod_concurrent);
 		return -ENOMEM;
 	}


