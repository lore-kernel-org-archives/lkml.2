Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934895Ab1KCBnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:43:04 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51499 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934858Ab1KCBm5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:42:57 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  2 15:27:46 2011
Message-Id: <20111102222746.254246779@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 02 Nov 2011 15:26:55 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Kosina <jkosina@suse.cz>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: [071/101] kmod: prevent kmod_loop_msg overflow in __request_module()
In-Reply-To: <20111102222755.GA10893@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.33-longterm review patch.  If anyone has any objections, please let us know.

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
@@ -106,10 +106,12 @@ int __request_module(bool wait, const ch
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


