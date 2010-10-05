Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758082Ab0JEXWA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 19:22:00 -0400
Received: from kroah.org ([198.145.64.141]:46866 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757499Ab0JEXV6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 19:21:58 -0400
Subject: patch "vcs: invoke the vt update callback when /dev/vcs* is written to" added to gregkh-2.6 tree
To: nico@fluxnic.net, akpm@linux-foundation.org, alan@linux.intel.com,
        gregkh@suse.de, linux-kernel@vger.kernel.org,
        nicolas.pitre@canonical.com
From: <gregkh@suse.de>
Date: Tue, 05 Oct 2010 16:18:36 -0700
In-Reply-To: <alpine.LFD.2.00.1009302329370.1146@xanadu.home>
Message-ID: <12863207162395@site>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is a note to let you know that I've just added the patch titled

    vcs: invoke the vt update callback when /dev/vcs* is written to

to my gregkh-2.6 tree which can be found in directory form at:
    http://www.kernel.org/pub/linux/kernel/people/gregkh/gregkh-2.6/patches/
 and in git form at:
    git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/patches.git

The filename of this patch is:
    vcs-invoke-the-vt-update-callback-when-dev-vcs-is-written-to.patch

The patch will show up in the next release of the linux-next tree
(usually sometime within the next 24 hours during the week.)

If this patch meets the merge guidelines for a bugfix, it should be
merged into Linus's tree before the next major kernel release.
If not, it will be merged into Linus's tree during the next merge window.

Either way, you will probably be copied on the patch when it gets sent
to Linus for merging so that others can see what is happening in kernel
development.

If you have any questions about this process, please let me know.


>From nico@fluxnic.net  Tue Oct  5 15:58:16 2010
Date: Fri, 01 Oct 2010 00:10:44 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
To: lkml <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: vcs: invoke the vt update callback when /dev/vcs* is written to
Message-id: <alpine.LFD.2.00.1009302329370.1146@xanadu.home>

A notifier chain is called whenever the vt code modifies a terminal
content, except for one case which is when the modification comes
through writes to /dev/vcs* devices.  Let's add the missing notifier
invocation at the end of vcs_write() for that case too.

Signed-off-by: Nicolas Pitre <nicolas.pitre@canonical.com>
Cc: Alan Cox <alan@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/char/vc_screen.c  |    2 ++
 drivers/char/vt.c         |    5 +++++
 include/linux/selection.h |    1 +
 3 files changed, 8 insertions(+)

--- a/drivers/char/vc_screen.c
+++ b/drivers/char/vc_screen.c
@@ -538,6 +538,8 @@ vcs_write(struct file *file, const char
 	}
 	*ppos += written;
 	ret = written;
+	if (written)
+		vcs_scr_updated(vc);
 
 unlock_out:
 	release_console_sem();
--- a/drivers/char/vt.c
+++ b/drivers/char/vt.c
@@ -4182,6 +4182,11 @@ void vcs_scr_writew(struct vc_data *vc,
 	}
 }
 
+void vcs_scr_updated(struct vc_data *vc)
+{
+	notify_update(vc);
+}
+
 /*
  *	Visible symbols for modules
  */
--- a/include/linux/selection.h
+++ b/include/linux/selection.h
@@ -39,5 +39,6 @@ extern void putconsxy(struct vc_data *vc
 
 extern u16 vcs_scr_readw(struct vc_data *vc, const u16 *org);
 extern void vcs_scr_writew(struct vc_data *vc, u16 val, u16 *org);
+extern void vcs_scr_updated(struct vc_data *vc);
 
 #endif

