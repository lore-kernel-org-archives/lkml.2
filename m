Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754579Ab0KNJZl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 04:25:41 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:33302 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0KNJZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 04:25:39 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=WcSRjRm/Mp+RiSAIlImivWP3tWPyTmMOJK2wFygLKHu6HW8+tReslxN3Say4JGUjVt
         BkUV4d3OfyegXZTnzmO+UsKdzSYtSCIUePDc9pJEWQVSC/YvgnB4im1YM8NhrCqCuw1L
         vq73gMesucVwg/FnqplhOXLtUof1kcdY2vxVg=
Date: Sun, 14 Nov 2010 12:25:33 +0300
From: Vasiliy Kulikov <segoon@openwall.com>
To: Andreas Dilger <adilger.kernel@dilger.ca>
Cc: Andrew Morton <akpm@linux-foundation.org>, kernel-janitors@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] fs: select: fix information leak to userspace
Message-ID: <20101114092533.GB5323@albatros>
References: <1289421483-23907-1-git-send-email-segooon@gmail.com>
 <20101112120834.33062900.akpm@linux-foundation.org>
 <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8D90F8B2-EA29-4EB9-9807-294CE0D5523B@dilger.ca>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On some architectures __kernel_suseconds_t is int.  On these archs
struct timeval has padding bytes at the end.  This struct is copied to
userspace with these padding bytes uninitialized.  This leads to leaking
of contents of kernel stack memory.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Patch v1 used memset(), it was waste of cycles on almost all archs.

 Compile tested.

 fs/select.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/select.c b/fs/select.c
index b7b10aa..43d4805 100644
--- a/fs/select.c
+++ b/fs/select.c
@@ -288,7 +288,6 @@ static int poll_select_copy_remaining(struct timespec *end_time, void __user *p,
 				      int timeval, int ret)
 {
 	struct timespec rts;
-	struct timeval rtv;
 
 	if (!p)
 		return ret;
@@ -306,8 +305,10 @@ static int poll_select_copy_remaining(struct timespec *end_time, void __user *p,
 		rts.tv_sec = rts.tv_nsec = 0;
 
 	if (timeval) {
-		rtv.tv_sec = rts.tv_sec;
-		rtv.tv_usec = rts.tv_nsec / NSEC_PER_USEC;
+		struct timeval rtv = {
+			.tv_sec = rts.tv_sec,
+			.tv_usec = rts.tv_nsec / NSEC_PER_USEC
+		};
 
 		if (!copy_to_user(p, &rtv, sizeof(rtv)))
 			return ret;
-- 
1.7.0.4
