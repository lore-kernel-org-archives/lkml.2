Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751952Ab0KWTxg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 14:53:36 -0500
Received: from hera.kernel.org ([140.211.167.34]:56297 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab0KWTxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 14:53:35 -0500
Date: Tue, 23 Nov 2010 19:52:06 GMT
From: tip-bot for Rabin Vincent <rabin@rab.in>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, tzanussi@gmail.com, rabin@rab.in,
        a.p.zijlstra@chello.nl, imunsie@au1.ibm.com, tglx@linutronix.de,
        tom.leiming@gmail.com, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, rabin@rab.in,
        tzanussi@gmail.com, a.p.zijlstra@chello.nl, imunsie@au1.ibm.com,
        tglx@linutronix.de, tom.leiming@gmail.com, mingo@elte.hu
In-Reply-To: <20101123163106.GA25677@debian>
References: <20101123163106.GA25677@debian>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf symbols: Remove incorrect open-coded container_of()
Message-ID: <tip-02a9d03772aa1ff33a26180a2da0bfb191240eda@git.kernel.org>
Git-Commit-ID: 02a9d03772aa1ff33a26180a2da0bfb191240eda
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 23 Nov 2010 19:52:08 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  02a9d03772aa1ff33a26180a2da0bfb191240eda
Gitweb:     http://git.kernel.org/tip/02a9d03772aa1ff33a26180a2da0bfb191240eda
Author:     Rabin Vincent <rabin@rab.in>
AuthorDate: Tue, 23 Nov 2010 22:08:18 +0530
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 23 Nov 2010 16:30:32 -0200

perf symbols: Remove incorrect open-coded container_of()

At least on ARM, padding is inserted between rb_node and sym in struct
symbol_name_rb_node, causing "((void *)sym) - sizeof(struct rb_node)" to
point inside rb_node rather than to the symbol_name_rb_node.  Fix this
by converting the code to use container_of().

Cc: Ian Munsie <imunsie@au1.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Ming Lei <tom.leiming@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Tom Zanussi <tzanussi@gmail.com>
LKML-Reference: <20101123163106.GA25677@debian>
Signed-off-by: Rabin Vincent <rabin@rab.in>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/symbol.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index b39f499..0500895 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -295,7 +295,9 @@ static void symbols__insert_by_name(struct rb_root *self, struct symbol *sym)
 {
 	struct rb_node **p = &self->rb_node;
 	struct rb_node *parent = NULL;
-	struct symbol_name_rb_node *symn = ((void *)sym) - sizeof(*parent), *s;
+	struct symbol_name_rb_node *symn, *s;
+
+	symn = container_of(sym, struct symbol_name_rb_node, sym);
 
 	while (*p != NULL) {
 		parent = *p;
