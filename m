Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab2EVOUK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:20:10 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33962 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757687Ab2EVOUG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:20:06 -0400
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
Subject: [PATCH 03/16] pstore/ram_core: Do not reset restored zone's position and size
Date: Tue, 22 May 2012 07:17:46 -0700
Message-Id: <1337696279-8994-3-git-send-email-anton.vorontsov@linaro.org>
X-Mailer: git-send-email 1.7.9.2
In-Reply-To: <20120522141717.GA31574@lizard>
References: <20120522141717.GA31574@lizard>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Otherwise, the files will survive just one reboot, and on a subsequent
boot they will disappear.

Also, as noticed by Colin Cross, this also causes an interesting behavior
change in the console logging. Before this change, the console log would
show only the messages from the last reboot.  After this change, the
console log will have logs from multiple boots appended to each other.

Now to get the only most recent messages we can do:

	tac ramoops-console | sed '/^Linux version.*(.*@.*)/ q' | tac

Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
---
 fs/pstore/ram_core.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/pstore/ram_core.c b/fs/pstore/ram_core.c
index 235513c..f6650d1 100644
--- a/fs/pstore/ram_core.c
+++ b/fs/pstore/ram_core.c
@@ -406,6 +406,7 @@ static int __init persistent_ram_post_init(struct persistent_ram_zone *prz, bool
 				" size %zu, start %zu\n",
 			       buffer_size(prz), buffer_start(prz));
 			persistent_ram_save_old(prz);
+			return 0;
 		}
 	} else {
 		pr_info("persistent_ram: no valid data in buffer"
-- 
1.7.9.2

