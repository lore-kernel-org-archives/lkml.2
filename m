Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756057Ab2ADPXK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 10:23:10 -0500
Received: from terminus.zytor.com ([198.137.202.10]:36960 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199Ab2ADPXG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 10:23:06 -0500
Date: Wed, 4 Jan 2012 07:22:41 -0800
From: tip-bot for Namhyung Kim <namhyung@gmail.com>
Message-ID: <tip-466e2876bcb9ddc9b92502c46689679bee7d72a0@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@gmail.com, tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@redhat.com, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, namhyung@gmail.com, mingo@elte.hu
In-Reply-To: <1325000151-4463-4-git-send-email-namhyung@gmail.com>
References: <1325000151-4463-4-git-send-email-namhyung@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script: Kill script_spec__delete
Git-Commit-ID: 466e2876bcb9ddc9b92502c46689679bee7d72a0
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Wed, 04 Jan 2012 07:22:47 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  466e2876bcb9ddc9b92502c46689679bee7d72a0
Gitweb:     http://git.kernel.org/tip/466e2876bcb9ddc9b92502c46689679bee7d72a0
Author:     Namhyung Kim <namhyung@gmail.com>
AuthorDate: Wed, 28 Dec 2011 00:35:51 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Tue, 3 Jan 2012 15:06:34 -0200

perf script: Kill script_spec__delete

As script_spec__delete() frees given struct script_spec it should not be
called if we failed to allocate the struct. Also it's the only caller of
the function, we can get rid of the function itself.

Cc: Ingo Molnar <mingo@elte.hu>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1325000151-4463-4-git-send-email-namhyung@gmail.com
Signed-off-by: Namhyung Kim <namhyung@gmail.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c |   13 +------------
 1 files changed, 1 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 3d4c0c7..fd1909a 100644
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
