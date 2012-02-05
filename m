Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755039Ab2BEWgs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 17:36:48 -0500
Received: from 1wt.eu ([62.212.114.60]:62094 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754256Ab2BEW04 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 17:26:56 -0500
Message-Id: <20120205220950.855083859@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Sun, 05 Feb 2012 23:10:22 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Anton Blanchard <anton@samba.org>, Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH 33/91] powerpc/kdump: Fix timeout in crash_kexec_wait_realmode
In-Reply-To: <0635750f5f06ed2ca212b91fcb5c4483@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-longterm review patch.  If anyone has any objections, please let us know.

------------------

commit 63f21a56f1cc0b800a4c00349c59448f82473d19 upstream.

The existing code it pretty ugly.  How about we clean it up even more
like this?

From: Anton Blanchard <anton@samba.org>

We check for timeout expiry in the outer loop, but we also need to
check it in the inner loop or we can lock up forever waiting for a
CPU to hit real mode.

Signed-off-by: Anton Blanchard <anton@samba.org>
Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 arch/powerpc/kernel/crash.c |    6 +-----
 1 files changed, 1 insertions(+), 5 deletions(-)

Index: longterm-2.6.27/arch/powerpc/kernel/crash.c
===================================================================
--- longterm-2.6.27.orig/arch/powerpc/kernel/crash.c	2012-02-05 22:34:33.998915277 +0100
+++ longterm-2.6.27/arch/powerpc/kernel/crash.c	2012-02-05 22:34:39.544914550 +0100
@@ -176,12 +176,8 @@
 
 		while (paca[i].kexec_state < KEXEC_STATE_REAL_MODE) {
 			barrier();
-			if (!cpu_possible(i)) {
+			if (!cpu_possible(i) || !cpu_online(i) || (msecs <= 0))
 				break;
-			}
-			if (!cpu_online(i)) {
-				break;
-			}
 			msecs--;
 			mdelay(1);
 		}


