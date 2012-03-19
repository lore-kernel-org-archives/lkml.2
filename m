Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2CSVm4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 17:42:56 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:49088 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631Ab2CSVmy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 17:42:54 -0400
From: Rob Clark <rob.clark@linaro.org>
To: linaro-mm-sig@lists.linaro.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Cc: patches@linaro.org, daniel.vetter@ffwll.ch, sumit.semwal@linaro.org,
        Rob Clark <rob@ti.com>
Subject: [PATCH] dma-buf: document fd flags and O_CLOEXEC requirement
Date: Mon, 19 Mar 2012 16:42:49 -0500
Message-Id: <1332193370-27820-1-git-send-email-rob.clark@linaro.org>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Rob Clark <rob@ti.com>

Otherwise subsystems will get this wrong and end up with a second
export ioctl with the flag and O_CLOEXEC support added.

Signed-off-by: Rob Clark <rob@ti.com>
Reviewed-by: Daniel Vetter <daniel.vetter@ffwll.ch>
---
Updated version of Daniel's original documentation patch with (hopefully)
improved wording, and a better description of the motivation.

 Documentation/dma-buf-sharing.txt |   18 ++++++++++++++++++
 1 files changed, 18 insertions(+), 0 deletions(-)

diff --git a/Documentation/dma-buf-sharing.txt b/Documentation/dma-buf-sharing.txt
index 225f96d..3b51134 100644
--- a/Documentation/dma-buf-sharing.txt
+++ b/Documentation/dma-buf-sharing.txt
@@ -223,6 +223,24 @@ Miscellaneous notes:
 - Any exporters or users of the dma-buf buffer sharing framework must have
   a 'select DMA_SHARED_BUFFER' in their respective Kconfigs.
 
+- In order to avoid fd leaks on exec, the FD_CLOEXEC flag must be set
+  on the file descriptor.  This is not just a resource leak, but a
+  potential security hole.  It could give the newly exec'd application
+  access to buffers, via the leaked fd, to which it should otherwise
+  not be permitted access.
+
+  The problem with doing this via a separate fcntl() call, versus doing it
+  atomically when the fd is created, is that this is inherently racy in a
+  multi-threaded app[3].  The issue is made worse when it is library code
+  opening/creating the file descriptor, as the application may not even be
+  aware of the fd's.
+
+  To avoid this problem, userspace must have a way to request O_CLOEXEC
+  flag be set when the dma-buf fd is created.  So any API provided by
+  the exporting driver to create a dmabuf fd must provide a way to let
+  userspace control setting of O_CLOEXEC flag passed in to dma_buf_fd().
+
 References:
 [1] struct dma_buf_ops in include/linux/dma-buf.h
 [2] All interfaces mentioned above defined in include/linux/dma-buf.h
+[3] https://lwn.net/Articles/236486/
-- 
1.7.5.4

