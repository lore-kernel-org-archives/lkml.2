Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753015Ab2APG7D (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 01:59:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:55169 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750858Ab2APG7B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 01:59:01 -0500
Message-ID: <4F13CB49.8030004@cn.fujitsu.com>
Date: Mon, 16 Jan 2012 15:01:29 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Arnaud Lacombe <lacombar@gmail.com>, Davidlohr Bueso <dave@gnu.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-kbuild@vger.kernel.org
Subject: [PATCH] kconfig: fix a regression when exiting menuconfig without
 saving
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-16 14:57:51,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-01-16 14:57:53,
	Serialize complete at 2012-01-16 14:57:53
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

$ make menuconfig
  HOSTCC  scripts/kconfig/mconf.o
  HOSTLD  scripts/kconfig/mconf
scripts/kconfig/mconf Kconfig

Your configuration changes were NOT saved.

make[1]: *** [menuconfig] Error 1
make: *** [menuconfig] Error 2

Exiting menuconfig without saving, make will report error.
This is a regression, and was introduced by

	commit 564899f9f0a2df85fa367c8749a1fef323cb3215
	Author: Davidlohr Bueso <dave@gnu.org>
	Date:   Sun Aug 21 22:04:09 2011 -0300

	    kconfig: handle SIGINT in menuconfig

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/mconf.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/mconf.c b/scripts/kconfig/mconf.c
index 19e200d..2c6286c 100644
--- a/scripts/kconfig/mconf.c
+++ b/scripts/kconfig/mconf.c
@@ -830,6 +830,8 @@ static int handle_exit(void)
 		fprintf(stderr, _("\n\n"
 				  "Your configuration changes were NOT saved."
 				  "\n\n"));
+		if (res != KEY_ESC)
+			res = 0;
 	}
 
 	return res;
-- 
1.7.3.1
