Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754650Ab1HDO50 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 10:57:26 -0400
Received: from casper.infradead.org ([85.118.1.10]:59575 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751560Ab1HDO5X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 10:57:23 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, Han Pingtian <phan@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/4] perf buildid-cache: Zero out buffer of filenames when adding/removing buildid
Date: Thu,  4 Aug 2011 11:57:15 -0300
Message-Id: <1312469838-2884-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.6.2.5
In-Reply-To: <1312469838-2884-1-git-send-email-acme@infradead.org>
References: <1312469838-2884-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Han Pingtian <phan@redhat.com>

The readlink() function doesn't append a null byte to buf. So we should
zero out buf with zalloc(). Or we'll see sometimes error like this:

[root@intel-s3e36-01]~# /usr/bin/perf buildid-cache -a /lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko -v
Adding f64ba8efd5f53c7ad332fc17db1d21de309038e1 /lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko: Ok
[root@intel-s3e36-01]~# /usr/bin/perf buildid-cache -r /lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko -v
Removing f64ba8efd5f53c7ad332fc17db1d21de309038e1 /lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko: FAIL
/lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko wasn't in the cache

The change in build_id_cache__add_s() is a defense.

Tested-by: Jiri Olsa <jolsa@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lkml.kernel.org/r/20110718031314.GA5802@hpt.nay.redhat.com
Signed-off-by: Han Pingtian <phan@redhat.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/header.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index cb2959a..d4f3101 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -189,8 +189,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms)
 {
 	const size_t size = PATH_MAX;
-	char *realname, *filename = malloc(size),
-	     *linkname = malloc(size), *targetname;
+	char *realname, *filename = zalloc(size),
+	     *linkname = zalloc(size), *targetname;
 	int len, err = -1;
 
 	if (is_kallsyms) {
@@ -254,8 +254,8 @@ static int build_id_cache__add_b(const u8 *build_id, size_t build_id_size,
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
 {
 	const size_t size = PATH_MAX;
-	char *filename = malloc(size),
-	     *linkname = malloc(size);
+	char *filename = zalloc(size),
+	     *linkname = zalloc(size);
 	int err = -1;
 
 	if (filename == NULL || linkname == NULL)
-- 
1.6.2.5

