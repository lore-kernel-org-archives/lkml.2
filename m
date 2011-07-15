Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab1GOWlX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 18:41:23 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47922 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861Ab1GOWlR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 18:41:17 -0400
From: Mandeep Singh Baines <msb@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Mandeep Singh Baines <msb@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Huang Ying <ying.huang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Hugh Dickins <hughd@google.com>, Olaf Hering <olaf@aepfle.de>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@gmail.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH 2/2] panic, vt: do not force oops output when panic_timeout < 0
Date: Fri, 15 Jul 2011 15:40:00 -0700
Message-Id: <1310769600-9234-2-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <1310769600-9234-1-git-send-email-msb@chromium.org>
References: <1310769600-9234-1-git-send-email-msb@chromium.org>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't force output if you intend to reboot immediately.

In this patch, I'm disabling the functionality enabled by
vc->vc_panic_force_write if panic_timeout < 0 (i.e. no timeout).
vc_panic_force_write is only enabled for fb video consoles if the
FBINFO_CAN_FORCE_OUTPUT flag is set.

For our application, we're using ram_oops to preserved the panic in memory.
We want to reliably, and as fast as possible, machine_restart. The
vc_panic_force_write flag results in a bunch of graphics driver code to be
invoked which slows down restart and decreases reliability. Since we're
already storing the panic in RAM and are going to reboot immediately, there
is no benefit in mode switching back to the vc in order to display the panic
output. The log buffer will get flushed by the console_unblank() call so
remote management consoles should see all output.

Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Huang Ying <ying.huang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Olaf Hering <olaf@aepfle.de>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: Dave Airlie <airlied@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
---
 include/linux/vt_kern.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/linux/vt_kern.h b/include/linux/vt_kern.h
index 4d05e14..c2164fa 100644
--- a/include/linux/vt_kern.h
+++ b/include/linux/vt_kern.h
@@ -137,7 +137,7 @@ int vty_init(const struct file_operations *console_fops);
 
 static inline bool vt_force_oops_output(struct vc_data *vc)
 {
-	if (oops_in_progress && vc->vc_panic_force_write)
+	if (oops_in_progress && vc->vc_panic_force_write  && panic_timeout >= 0)
 		return true;
 	return false;
 }
-- 
1.7.3.1

