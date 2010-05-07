Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753282Ab0EGFzV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 01:55:21 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:60729 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753151Ab0EGFzR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 01:55:17 -0400
Message-ID: <4BE3ABB3.7040406@cn.fujitsu.com>
Date: Fri, 07 May 2010 13:57:07 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Michal Marek <mmarek@suse.cz>
CC: Randy Dunlap <randy.dunlap@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kbuild@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH v2 3/8] kconfig: fix to tag NEW symbols correctly
References: <4BE3AB91.80606@cn.fujitsu.com>
In-Reply-To: <4BE3AB91.80606@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Those configs are not new:

  $ cat .config
  ...
  CONFIG_NAMESPACES=y
  ...
  CONFIG_BLOCK=y
  ...

But are tagged as NEW:

  $ yes "" | make config > myconf
  $ cat myconf | grep '(NEW)'
  Namespaces support (NAMESPACES) [Y/?] (NEW) y
  ...
  Enable the block layer (BLOCK) [Y/?] (NEW) y
  ...

You can also notice this bug when using gconfig/xconfig.

It's because the SYMBOL_DEF_USER bit of an invisible symbol is cleared
when the config file is read:

int conf_read(const char *name)
{
	...
	for_all_symbols(i, sym) {
		if (sym_has_value(sym) && !sym_is_choice_value(sym)) {
			/* Reset values of generates values, so they'll appear
			 * as new, if they should become visible, but that
			 * doesn't quite work if the Kconfig and the saved
			 * configuration disagree.
			 */
			if (sym->visible == no && !conf_unsaved)
				sym->flags &= ~SYMBOL_DEF_USER;
	...
}

But a menu item which represents an invisible symbol is still
visible, if it's sub-menu is visible, so its SYMBOL_DEF_USER
bit should be set to indicate it's not NEW.

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
---
 scripts/kconfig/menu.c |    8 ++++++--
 1 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index c547692..85ccd02 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -419,9 +419,13 @@ bool menu_is_visible(struct menu *menu)
 	if (!sym || sym_get_tristate_value(menu->sym) == no)
 		return false;
 
-	for (child = menu->list; child; child = child->next)
-		if (menu_is_visible(child))
+	for (child = menu->list; child; child = child->next) {
+		if (menu_is_visible(child)) {
+			if (sym)
+				sym->flags |= SYMBOL_DEF_USER;
 			return true;
+		}
+	}
 
 	return false;
 }
-- 
1.6.3

