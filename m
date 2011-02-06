Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753375Ab1BFRcQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 12:32:16 -0500
Received: from smtp-out.google.com ([74.125.121.67]:3099 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752744Ab1BFRcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 12:32:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-operating-system
         :user-agent;
        b=fzwBYuQJK4GgGWh3tHS0cDi8H7COwtbRyW8mjEZ9oNb72Rp/TupfbHG6pei/Wopt9X
         yjG/4ZaCU+4guyYnShVQ==
Date: Sun, 6 Feb 2011 09:31:53 -0800
From: Mandeep Singh Baines <msb@chromium.org>
To: Greg KH <greg@kroah.com>
Cc: gregkh@suse.de, rjw@sisk.pl, mingo@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v2] TTY: use appropriate printk priority level
Message-ID: <20110206173153.GT19745@google.com>
References: <20110125235700.GR8008@google.com>
 <1296084570-31453-5-git-send-email-msb@chromium.org>
 <20110203221346.GA477@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110203221346.GA477@kroah.com>
X-Operating-System: Linux/2.6.32-gg298-generic (x86_64)
User-Agent: Mutt/1.5.20 (2009-06-14)
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rebased to apply cleanly against v2.6.38-rc3

---
printk()s without a priority level default to KERN_WARNING. To reduce
noise at KERN_WARNING, this patch set the priority level appriopriately
for unleveled printks()s. This should be useful to folks that look at
dmesg warnings closely.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
---
 drivers/tty/vt/vt.c |   15 ++++++++-------
 1 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 147ede3..d5669ff 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -2157,10 +2157,10 @@ static int do_con_write(struct tty_struct *tty, const unsigned char *buf, int co
 
 	currcons = vc->vc_num;
 	if (!vc_cons_allocated(currcons)) {
-	    /* could this happen? */
-		printk_once("con_write: tty %d not allocated\n", currcons+1);
-	    console_unlock();
-	    return 0;
+		/* could this happen? */
+		pr_warn_once("con_write: tty %d not allocated\n", currcons+1);
+		console_unlock();
+		return 0;
 	}
 
 	himask = vc->vc_hi_font_mask;
@@ -2940,7 +2940,7 @@ static int __init con_init(void)
 	gotoxy(vc, vc->vc_x, vc->vc_y);
 	csi_J(vc, 0);
 	update_screen(vc);
-	printk("Console: %s %s %dx%d",
+	pr_info("Console: %s %s %dx%d",
 		vc->vc_can_do_color ? "colour" : "mono",
 		display_desc, vc->vc_cols, vc->vc_rows);
 	printable = 1;
@@ -3103,7 +3103,7 @@ static int bind_con_driver(const struct consw *csw, int first, int last,
 			clear_buffer_attributes(vc);
 	}
 
-	printk("Console: switching ");
+	pr_info("Console: switching ");
 	if (!deflt)
 		printk("consoles %d-%d ", first+1, last+1);
 	if (j >= 0) {
@@ -3809,7 +3809,8 @@ void do_unblank_screen(int leaving_gfx)
 		return;
 	if (!vc_cons_allocated(fg_console)) {
 		/* impossible */
-		printk("unblank_screen: tty %d not allocated ??\n", fg_console+1);
+		pr_warning("unblank_screen: tty %d not allocated ??\n",
+			   fg_console+1);
 		return;
 	}
 	vc = vc_cons[fg_console].d;
-- 
1.7.3.1

