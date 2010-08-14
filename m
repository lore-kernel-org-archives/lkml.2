Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756331Ab0HNMnc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 08:43:32 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:34743 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756216Ab0HNMnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 08:43:31 -0400
Date: Sat, 14 Aug 2010 14:43:29 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Michal Marek <mmarek@suse.cz>, linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH]
Message-ID: <20100814124329.GA28377@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 705dbd8a31520722bda78e1bc731e2880f8df0ff Mon Sep 17 00:00:00 2001
From: Sam Ravnborg <sam@ravnborg.org>
Date: Sat, 14 Aug 2010 14:40:00 +0200
Subject: [PATCH] kconfig: fix segfault when detecting recursive dependency

Following sample Kconfig generated a segfault:

config FOO
        bool
        select PERF_EVENTS if HAVE_HW_BREAKPOINT

config PERF_EVENTS
        bool

config HAVE_HW_BREAKPOINT
        bool
        depends on PERF_EVENTS

Fix by reverting back to a valid property if there was no
property on the stack of symbols.

The above pattern were seen in sh Kconfig.
A fix for the Kconfig file has been sent to the sh folks.

Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
---
 scripts/kconfig/symbol.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/scripts/kconfig/symbol.c b/scripts/kconfig/symbol.c
index e95718f..943712c 100644
--- a/scripts/kconfig/symbol.c
+++ b/scripts/kconfig/symbol.c
@@ -937,6 +937,8 @@ static void sym_check_print_recursive(struct symbol *last_sym)
 		sym = stack->sym;
 		next_sym = stack->next ? stack->next->sym : last_sym;
 		prop = stack->prop;
+		if (prop == NULL)
+			prop = stack->sym->prop;
 
 		/* for choice values find the menu entry (used below) */
 		if (sym_is_choice(sym) || sym_is_choice_value(sym)) {
-- 
1.6.0.6

