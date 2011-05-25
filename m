Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1EYFgw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 01:36:52 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47618 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab1EYFgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 01:36:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=o5uu4ZmXhtTRuS2xjIPTHxrA3zaYDsVGbsjDWVpPDJginW140fX1NDEVBp9xzktLna
         fEZOR/0n+uolV9n4BvblaiJOJ88MXN34cTJI3d5U9/dIh1uKlgJwnXRmwUYMA7CNOjsM
         fwYoNp1xrIWz83oh8L0k2UsitCqgpOMH9L2+Q=
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH] kconfig: do not overwrite symbol direct dependency in assignment
Date: Wed, 25 May 2011 01:36:44 -0400
Message-Id: <1306301804-12319-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Considering the following configuration:

config F
    bool "F"

choice AB
    bool "AB"
config A
    bool "A"
config B
    bool "B"
endchoice

if A
config D
    bool
    default y if F
    select E
config E
    bool "E"
endif

if B
config D
    bool
    default y if F
    select E
config E
    bool "E"
endif

The following configuration:

CONFIG_F=y
CONFIG_A=y
CONFIG_D=y
CONFIG_E=y

emits a spurious warning:

(D) selects E which has unmet direct dependencies (B)

If a symbol appears in two different branch of the tree, it should inherit the
dependency of both parent, not just the last one.

Reported-by: Yann E. Morin <yann.morin.1998@anciens.enib.fr>
Tested-by: Yann E. Morin <yann.morin.1998@anciens.enib.fr>
Signed-off-by: Arnaud Lacombe <lacombar@gmail.com>
---
 scripts/kconfig/menu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/menu.c b/scripts/kconfig/menu.c
index 5fdf10d..d0c65e7 100644
--- a/scripts/kconfig/menu.c
+++ b/scripts/kconfig/menu.c
@@ -350,7 +350,7 @@ void menu_finalize(struct menu *parent)
 			last_menu->next = NULL;
 		}
 
-		sym->dir_dep.expr = parent->dep;
+		sym->dir_dep.expr = expr_alloc_or(sym->dir_dep.expr, parent->dep);
 	}
 	for (menu = parent->list; menu; menu = menu->next) {
 		if (sym && sym_is_choice(sym) &&
-- 
1.7.3.4.574.g608b.dirty

