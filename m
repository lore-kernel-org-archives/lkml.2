Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755432Ab1GJH13 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 03:27:29 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52387 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755368Ab1GJH1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 03:27:22 -0400
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>
Cc: linux-kernel@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>,
        Nir Tzachar <nir.tzachar@gmail.com>,
        Andrej Gelenberg <andrej.gelenberg@udo.edu>
Subject: [PATCH 2/2] kconfig/nconf: prevent segfault on empty menu
Date: Sun, 10 Jul 2011 03:27:05 -0400
Message-Id: <1310282825-14509-2-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1310282825-14509-1-git-send-email-lacombar@gmail.com>
References: <CACqU3MXvHR0v4Hgn5UMwDtzaX5nWqmKEneN_s7r4PuEGzifauw@mail.gmail.com>
 <1310282825-14509-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

nconf does not check the validity of the current menu when help is requested
(with either <F2>, '?' or 'h'). This leads to a NULL pointer dereference when an
empty menu is encountered.

The following reduced testcase exposes the problem:

config DEP
        bool

menu "FOO"

config BAR
        bool "BAR"
        depends on DEP

endmenu

Issue will happen when entering menu "FOO" and requesting help.

nconf is the only front-end which do not filter the validity of the current
menu. Such filter can not really happen beforehand as other key which does not
deals with the current menu might be entered by the user, so just bails out
earlier if we encounter an invalid menu.

Cc: Nir Tzachar <nir.tzachar@gmail.com>
Cc: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Reported-by: Andrej Gelenberg <andrej.gelenberg@udo.edu>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/nconf.c |    7 ++++++-
 1 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/nconf.c b/scripts/kconfig/nconf.c
index 24fc79a..eb9e49d 100644
--- a/scripts/kconfig/nconf.c
+++ b/scripts/kconfig/nconf.c
@@ -1222,7 +1222,12 @@ static void conf_message_callback(const char *fmt, va_list ap)
 
 static void show_help(struct menu *menu)
 {
-	struct gstr help = str_new();
+	struct gstr help;
+
+	if (!menu)
+		return;
+
+	help = str_new();
 	menu_get_ext_help(menu, &help);
 	show_scroll_win(main_window, _(menu_get_prompt(menu)), str_get(&help));
 	str_free(&help);
-- 
1.7.3.4.574.g608b.dirty

