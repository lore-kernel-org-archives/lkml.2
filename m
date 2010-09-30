Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756268Ab0I3TXt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:23:49 -0400
Received: from s318.xrea.com ([125.53.25.46]:33483 "HELO s318.xrea.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752337Ab0I3TXs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:23:48 -0400
From: Naohiro Aota <naota@elisp.net>
To: Roman Zippel <zippel@linux-m68k.org>, Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Sam Ravnborg <sam@ravnborg.org>,
        Ulf Magnusson <ulfalizer.lkml@gmail.com>,
        =?iso-8859-1?Q?Uwe_Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Naohiro Aota <naota@elisp.net>
Subject: [PATCH -next] kconfig: Don't go out from read config loop when you read new symbol
Date: Fri, 01 Oct 2010 04:23:17 +0900
Message-ID: <87sk0rghne.fsf@elisp.net>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit 8baefd30b5b0101aa07aa75da44a9eee881eed28 of linux-next replaced
a `switch()' statement with some `if()' statements, but left `break's
in the `switch()' statement untouched. This cause read config loop to
exit and so "make oldconfig" is not much usable (see below).

> $ make oldconfig
><snip>
> scripts/kconfig/conf --oldconfig Kconfig
> #
> # using defaults found in /boot/config-2.6.34-ccs-r1
> #
> *
> * Restart config...
> *
> *
> * General setup
> *
> Prompt for development and/or incomplete code/drivers (EXPERIMENTAL) [N/y/?] (NEW)

(I've already have "CONFIG_EXPERIMENTAL=y" in the old config file. But
that's not read here.)

This patch should fix this problem.

Signed-off-by: Naohiro Aota <naota@elisp.net>
---
 scripts/kconfig/confdata.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/scripts/kconfig/confdata.c b/scripts/kconfig/confdata.c
index f7d89d7..35c08ec 100644
--- a/scripts/kconfig/confdata.c
+++ b/scripts/kconfig/confdata.c
@@ -234,7 +234,7 @@ load:
 				sym = sym_find(line + 2 + strlen(CONFIG_));
 				if (!sym) {
 					sym_add_change_count(1);
-					break;
+					goto setsym;
 				}
 			} else {
 				sym = sym_lookup(line + 2 + strlen(CONFIG_), 0);
@@ -268,7 +268,7 @@ load:
 				sym = sym_find(line + strlen(CONFIG_));
 				if (!sym) {
 					sym_add_change_count(1);
-					break;
+					goto setsym;
 				}
 			} else {
 				sym = sym_lookup(line + strlen(CONFIG_), 0);
@@ -285,6 +285,7 @@ load:
 				conf_warning("unexpected data");
 			continue;
 		}
+setsym:
 		if (sym && sym_is_choice_value(sym)) {
 			struct symbol *cs = prop_get_symbol(sym_get_choice_prop(sym));
 			switch (sym->def[def].tri) {
-- 
1.7.3
