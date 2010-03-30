Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932180Ab0CaANS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 20:13:18 -0400
Received: from kroah.org ([198.145.64.141]:51907 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756806Ab0C3XRt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 19:17:49 -0400
X-Mailbox-Line: From linux@linux.site Tue Mar 30 15:56:19 2010
Message-Id: <20100330225618.875353124@linux.site>
User-Agent: quilt/0.47-14.9
Date: Tue, 30 Mar 2010 15:55:11 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
       Kees Cook <kees.cook@canonical.com>, Serge Hallyn <serue@us.ibm.com>,
       James Morris <jmorris@namei.org>, Greg Kroah-Hartman <gregkh@suse.de>
Subject: [033/116] sysctl: require CAP_SYS_RAWIO to set mmap_min_addr
In-Reply-To: <20100330230600.GA28802@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.32-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Kees Cook <kees.cook@canonical.com>

commit 0e1a6ef2dea88101b056b6d9984f3325c5efced3 upstream.

Currently the mmap_min_addr value can only be bypassed during mmap when
the task has CAP_SYS_RAWIO.  However, the mmap_min_addr sysctl value itself
can be adjusted to 0 if euid == 0, allowing a bypass without CAP_SYS_RAWIO.
This patch adds a check for the capability before allowing mmap_min_addr to
be changed.

Signed-off-by: Kees Cook <kees.cook@canonical.com>
Acked-by: Serge Hallyn <serue@us.ibm.com>
Signed-off-by: James Morris <jmorris@namei.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 security/min_addr.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/security/min_addr.c
+++ b/security/min_addr.c
@@ -33,6 +33,9 @@ int mmap_min_addr_handler(struct ctl_tab
 {
 	int ret;
 
+	if (!capable(CAP_SYS_RAWIO))
+		return -EPERM;
+
 	ret = proc_doulongvec_minmax(table, write, buffer, lenp, ppos);
 
 	update_mmap_min_addr();


