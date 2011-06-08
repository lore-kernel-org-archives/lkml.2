Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752812Ab1FHFn6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 01:43:58 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:53280 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1FHFn5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 01:43:57 -0400
Date: Wed, 8 Jun 2011 07:43:54 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Dave Airlie <airlied@redhat.com>
Cc: Marek =?utf-8?B?T2zFocOhaw==?= <maraeo@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Latest merge of 'drm-radeon-fixes' breaks my setup
Message-ID: <20110608054354.GA1717@x4.trippels.de>
References: <20110608054002.GA1717@x4.trippels.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110608054002.GA1717@x4.trippels.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011.06.08 at 07:40 +0200, Markus Trippelsdorf wrote:
> The merge of the 'drm-radeon' branch by Linus yesterday breaks my setup
> (RS780). The mouse cursor is just a black block suddenly and I see an
> endless stream of:
>  radeon 0000:01:05.0: r600_check_texture_resource:1338 texture invalid format 26                                           
>  [drm:radeon_cs_ioctl] *ERROR* Invalid command stream !
> 
> A quick git-bisect points to:
> commit fe6f0bd03d697835e76dd18d232ba476c65b8282
> Author: Marek Olšák <maraeo@gmail.com>
> Date:   Sat May 7 01:09:57 2011 +0200
> 
>     drm/radeon/kms: add missing Evergreen texture formats to the CS parser
> 
> Reverting the commit solves the issue.

The following patch is enough to resolve the problem:

diff --git a/drivers/gpu/drm/radeon/r600_cs.c b/drivers/gpu/drm/radeon/r600_cs.c
index 909bda8..cbcc136 100644
--- a/drivers/gpu/drm/radeon/r600_cs.c
+++ b/drivers/gpu/drm/radeon/r600_cs.c
@@ -71,14 +71,14 @@ struct r600_cs_track {
 	u64			db_bo_mc;
 };
 
-#define FMT_8_BIT(fmt, vc)   [fmt] = { 1, 1, 1, vc, CHIP_R600 }
-#define FMT_16_BIT(fmt, vc)  [fmt] = { 1, 1, 2, vc, CHIP_R600 }
-#define FMT_24_BIT(fmt)      [fmt] = { 1, 1, 3,  0, CHIP_R600 }
-#define FMT_32_BIT(fmt, vc)  [fmt] = { 1, 1, 4, vc, CHIP_R600 }
-#define FMT_48_BIT(fmt)      [fmt] = { 1, 1, 6,  0, CHIP_R600 }
-#define FMT_64_BIT(fmt, vc)  [fmt] = { 1, 1, 8, vc, CHIP_R600 }
-#define FMT_96_BIT(fmt)      [fmt] = { 1, 1, 12, 0, CHIP_R600 }
-#define FMT_128_BIT(fmt, vc) [fmt] = { 1, 1, 16,vc, CHIP_R600 }
+#define FMT_8_BIT(fmt, vc)   [fmt] = { 1, 1, 1, vc }
+#define FMT_16_BIT(fmt, vc)  [fmt] = { 1, 1, 2, vc }
+#define FMT_24_BIT(fmt)      [fmt] = { 1, 1, 3,  0 }
+#define FMT_32_BIT(fmt, vc)  [fmt] = { 1, 1, 4, vc }
+#define FMT_48_BIT(fmt)      [fmt] = { 1, 1, 6,  0 }
+#define FMT_64_BIT(fmt, vc)  [fmt] = { 1, 1, 8, vc }
+#define FMT_96_BIT(fmt)      [fmt] = { 1, 1, 12, 0 }
+#define FMT_128_BIT(fmt, vc) [fmt] = { 1, 1, 16,vc }
 
 struct gpu_formats {
 	unsigned blockwidth;
-- 
Markus
