Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756418Ab0KJUiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Nov 2010 15:38:13 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43462 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755341Ab0KJUiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Nov 2010 15:38:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=bFBhPRM42LeWHzPK7p7nHmM5Eq863fYDVCRCnqh1LZ0Jgg4Zrd9pPJr0++tjDBQVm3
         tJJeuP0fBzRNonvBI15ggEVw2jNH7m+vh/FFYL8pMsqOgGkcZ5NoZsXm1tinKeP/RsDa
         2u9X/vQI3PdVOagAW0WSfsSZvDgcxckpla4Fc=
From: Vasiliy Kulikov <segooon@gmail.com>
To: kernel-janitors@vger.kernel.org
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] fs: select: fix information leak to userspace
Date: Wed, 10 Nov 2010 23:38:02 +0300
Message-Id: <1289421483-23907-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some architectures __kernel_suseconds_t is int.  On these archs
struct timeval has padding bytes at the end.  This struct is copied to
userspace with these padding bytes uninitialized.  This leads to leaking
of contents of kernel stack memory.

This bug was added with v2.6.27-rc5-286-gb773ad4.

Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
---
 Compile tested.

 fs/select.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index b7b10aa..32cf018 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -306,6 +306,7 @@ static int poll_select_copy_remaining(struct timespec *end_time, void __user *p,
 		rts.tv_sec = rts.tv_nsec = 0;
 
 	if (timeval) {
+		memset(&rtv, 0, sizeof(rtv));
 		rtv.tv_sec = rts.tv_sec;
 		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
 
-- 
1.7.0.4

