Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849Ab0IGNgy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 09:36:54 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62699 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754132Ab0IGNgr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 09:36:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l6+0l+wvU/UqZCVAGg/iZ0Q2+3fIc0SRFn7O2feWfAW5eD7DWbYf7FLUnBFLvREvsw
         YbG79LK3cT+wtFZdyBIK5SKFPiQGvbtUiUyB5FyP+kxjo4MAUTAXsjjy3srAY71VkaX8
         Mt1FeT/QopGcpnHu7Ro6ikiVwWZcRwfj9Cx0E=
Date: Tue, 7 Sep 2010 17:31:49 +0400
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] base/platform: Safe handling for NULL platform data
 and resources
Message-ID: <20100907133149.GA28139@oksana.dev.rtsoft.ru>
References: <20100907133107.GA21463@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20100907133107.GA21463@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some users of platform_device_add_{data,resources}() assume that
NULL data and resources will be handled specially, i.e. just ignored.

But the platform core ends up calling kmemdup(NULL, 0, ...), which
returns a non-NULL result (i.e. ZERO_SIZE_PTR), which causes drivers
to oops on a valid code, something like:

  if (platform_data)
  	stuff = platform_data->stuff;

This patch makes the platform core a bit more safe for such cases.

Signed-off-by: Anton Vorontsov <cbouatmailru@gmail.com>
---
 drivers/base/platform.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index c6c933f..67519cd 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -192,6 +192,9 @@ int platform_device_add_resources(struct platform_device *pdev,
 {
 	struct resource *r;
 
+	if (!res)
+		return 0;
+
 	r = kmemdup(res, sizeof(struct resource) * num, GFP_KERNEL);
 	if (r) {
 		pdev->resource = r;
@@ -215,8 +218,12 @@ EXPORT_SYMBOL_GPL(platform_device_add_resources);
 int platform_device_add_data(struct platform_device *pdev, const void *data,
 			     size_t size)
 {
-	void *d = kmemdup(data, size, GFP_KERNEL);
+	void *d;
+
+	if (!data)
+		return 0;
 
+	d = kmemdup(data, size, GFP_KERNEL);
 	if (d) {
 		pdev->dev.platform_data = d;
 		return 0;
-- 
1.7.0.5

