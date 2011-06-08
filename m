Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab1FHFmT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 01:42:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55483 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752429Ab1FHFmS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 01:42:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=eEmbYX1dQuwKyvdWlc21Q09PCaAbzBZKHGwV+p+E4/HBkm7zEYqQAkblUMsE7Pnt5U
         6bZLfkwG2+qRp0XgnvCgCtuDQPEpNIW6fqfmWsdbaknjNTeEY4ZiCrtIzS4V3CLGhD+0
         hC7zeJ+qHrSwrk4kKba5DNIzY3kvL+FJL0Gww=
From: Arnaud Lacombe <lacombar@gmail.com>
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michal Marek <mmarek@suse.cz>, Arnaud Lacombe <lacombar@gmail.com>
Subject: [PATCH] kconfig: do not overwrite symbol direct dependency in assignment
Date: Wed,  8 Jun 2011 01:42:11 -0400
Message-Id: <1307511731-2786-1-git-send-email-lacombar@gmail.com>
X-Mailer: git-send-email 1.7.3.4.574.g608b.dirty
In-Reply-To: <1306301804-12319-1-git-send-email-lacombar@gmail.com>
References: <1306301804-12319-1-git-send-email-lacombar@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michal,

Re-sent, mostly to have the commit log right.

Regards,
 - Arnaud

---
From: Arnaud Lacombe <lacombar@gmail.com>

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
 # CONFIG_B is not set
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

