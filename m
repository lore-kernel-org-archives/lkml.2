Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2FSCSG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 22:18:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43936 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752512Ab2FSCSC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 22:18:02 -0400
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Subject: [PATCH 2/7] pstore/ram: Fix error handling during przs allocation
Date: Mon, 18 Jun 2012 19:15:51 -0700
Message-Id: <1340072156-6225-2-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20120619021050.GA19387@lizard>
References: <20120619021050.GA19387@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

persistent_ram_new() returns ERR_PTR() value on errors, so during
freeing of the przs we should check for both NULL and IS_ERR() entries,
otherwise bad things will happen.

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/pstore/ram.c b/fs/pstore/ram.c
index 0b36e91..58b93fb 100644
--- a/fs/pstore/ram.c
+++ b/fs/pstore/ram.c
@@ -260,7 +260,7 @@ static void ramoops_free_przs(struct ramoops_context *cxt)
 	if (!cxt->przs)
 		return;
 
-	for (i = 0; cxt->przs[i]; i++)
+	for (i = 0; !IS_ERR_OR_NULL(cxt->przs[i]); i++)
 		persistent_ram_free(cxt->przs[i]);
 	kfree(cxt->przs);
 }
-- 
1.7.10.4

