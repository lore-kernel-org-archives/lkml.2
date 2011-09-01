Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab1IARxU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 13:53:20 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:49118 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755244Ab1IARxS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 13:53:18 -0400
From: crquan@gmail.com
To: linux-kbuild@vger.kernel.org, Arnaud Lacombe <lacombar@gmail.com>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        Nir Tzachar <nir.tzachar@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org,
        c.rq541@comcast.net
Subject: [PATCH V3 2/5] scripts/kconfig/nconf: fix memmove's length arg
Date: Thu,  1 Sep 2011 10:52:19 -0700
Message-Id: <1314899542-5848-2-git-send-email-crquan@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1314899542-5848-1-git-send-email-crquan@gmail.com>
References: <CAH5vBdKxbaKDrA2gAj5CoDYShN+5dnfu6Bmd=4+oV-XmnYQnFA@mail.gmail.com>
 <1314899542-5848-1-git-send-email-crquan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cheng Renquan <crquan@gmail.com>

In case KEY_BACKSPACE / KEY_DC to delete a char, it memmove only
(len-cursor_position+1) bytes;
the default case is to insert a char, it should also memmove exactly
(len-cursor_position+1) bytes;

the original use of (len+1) is wrong and may access following memory
that doesn't belong to result, may cause SegFault in theory;

	case KEY_BACKSPACE:
		if (cursor_position > 0) {
			memmove(&result[cursor_position-1],
					&result[cursor_position],
					len-cursor_position+1);
			cursor_position--;
		}
		break;
	case KEY_DC:
		if (cursor_position >= 0 && cursor_position < len) {
			memmove(&result[cursor_position],
					&result[cursor_position+1],
					len-cursor_position+1);
		}
		break;
	default:
		if ((isgraph(res) || isspace(res)) &&
				len-2 < result_len) {
			/* insert the char at the proper position */
			memmove(&result[cursor_position+1],
					&result[cursor_position],
					len-cursor_position+1);
			result[cursor_position] = res;
			cursor_position++;
		}

Signed-off-by: Cheng Renquan <crquan@gmail.com>
Acked-by: Nir Tzachar <nir.tzachar@gmail.com>
---
 scripts/kconfig/nconf.gui.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/nconf.gui.c b/scripts/kconfig/nconf.gui.c
index d3af04e..3ce2a7c 100644
--- a/scripts/kconfig/nconf.gui.c
+++ b/scripts/kconfig/nconf.gui.c
@@ -457,7 +457,7 @@ int dialog_inputbox(WINDOW *main_window,
 				/* insert the char at the proper position */
 				memmove(&result[cursor_position+1],
 						&result[cursor_position],
-						len+1);
+						len-cursor_position+1);
 				result[cursor_position] = res;
 				cursor_position++;
 			} else {
-- 
1.7.6

