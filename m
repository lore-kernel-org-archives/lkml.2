Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754672Ab1L0Pgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 10:36:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54966 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754611Ab1L0PgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 10:36:10 -0500
From: Namhyung Kim <namhyung@gmail.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org
Subject: [PATCH -tip:perf/core 4/4] perf script: Kill script_spec__delete
Date: Wed, 28 Dec 2011 00:35:51 +0900
Message-Id: <1325000151-4463-4-git-send-email-namhyung@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1325000151-4463-1-git-send-email-namhyung@gmail.com>
References: <1325000151-4463-1-git-send-email-namhyung@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

As script_spec__delete() frees given struct script_spec
it should not be called if we failed to allocate the
struct. Also it's the only caller of the function, we
can get rid of the function itself.

Signed-off-by: Namhyung Kim <namhyung@gmail.com>
---
 tools/perf/builtin-script.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index ea71c5e1a94f..d9c049e98a58 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -536,12 +536,6 @@ static struct script_spec *script_spec__new(const char *spec,
 	return s;
 }
 
-static void script_spec__delete(struct script_spec *s)
-{
-	free(s->spec);
-	free(s);
-}
-
 static void script_spec__add(struct script_spec *s)
 {
 	list_add_tail(&s->node, &script_specs);
@@ -567,16 +561,11 @@ static struct script_spec *script_spec__findnew(const char *spec,
 
 	s = script_spec__new(spec, ops);
 	if (!s)
-		goto out_delete_spec;
+		return NULL;
 
 	script_spec__add(s);
 
 	return s;
-
-out_delete_spec:
-	script_spec__delete(s);
-
-	return NULL;
 }
 
 int script_spec_register(const char *spec, struct scripting_ops *ops)
-- 
1.7.6

