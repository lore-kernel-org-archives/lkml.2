Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab0CWW0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 18:26:18 -0400
Received: from 1-1-12-13a.han.sth.bostream.se ([82.182.30.168]:39062 "EHLO
	palpatine.hardeman.nu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab0CWW0R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 18:26:17 -0400
Date: Tue, 23 Mar 2010 23:26:13 +0100
From: David =?iso-8859-1?Q?H=E4rdeman?= <david@hardeman.nu>
To: linux-kernel@vger.kernel.org
Cc: stefani@seibold.net
Subject: [PATCH] fix INIT_KFIFO in include/linux/kfifo.h - part 2
Message-ID: <20100323222613.GA6915@hardeman.nu>
Mail-Followup-To: linux-kernel@vger.kernel.org, stefani@seibold.net
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

DECLARE_KFIFO creates a union with a struct kfifo and a buffer array with
size [size + sizeof(struct kfifo)].

INIT_KFIFO then sets the buffer pointer in struct kfifo to point to the
beginning of the buffer array which means that the first call to kfifo_in
will overwrite members of the struct kfifo.

This patch was the least invasive fix I could come up with...

Signed-off-by: David Härdeman <david@hardeman.nu>
CC: stable@kernel.org
CC: stefani@seibold.net
---
 include/linux/kfifo.h |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/include/linux/kfifo.h b/include/linux/kfifo.h
index ece0b1c..e117b1a 100644
--- a/include/linux/kfifo.h
+++ b/include/linux/kfifo.h
@@ -86,7 +86,8 @@ union { \
  */
 #define INIT_KFIFO(name) \
 	name = __kfifo_initializer(sizeof(name##kfifo_buffer) - \
-				sizeof(struct kfifo), name##kfifo_buffer)
+				sizeof(struct kfifo), \
+				name##kfifo_buffer + sizeof(struct kfifo))
 
 /**
  * DEFINE_KFIFO - macro to define and initialize a kfifo
-- 
1.7.0.3

