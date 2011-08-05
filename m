Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1HEKH3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:07:29 -0400
Received: from hera.kernel.org ([140.211.167.34]:32900 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755913Ab1HEKHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:07:06 -0400
Date: Fri, 5 Aug 2011 10:06:58 GMT
From: tip-bot for Han Pingtian <phan@redhat.com>
Message-ID: <tip-4f9bae351d299149a84f76cd34bf0150614e8c8e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, hpa@zytor.com,
        mingo@redhat.com, phan@redhat.com, tglx@linutronix.de,
        jolsa@redhat.com
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        acme@redhat.com, phan@redhat.com, tglx@linutronix.de, jolsa@redhat.com
In-Reply-To: <20110718031314.GA5802@hpt.nay.redhat.com>
References: <20110718031314.GA5802@hpt.nay.redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf buildid-cache: Zero out buffer of filenames when adding/removing buildid
Git-Commit-ID: 4f9bae351d299149a84f76cd34bf0150614e8c8e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 05 Aug 2011 10:07:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4f9bae351d299149a84f76cd34bf0150614e8c8e
Gitweb:     http://git.kernel.org/tip/4f9bae351d299149a84f76cd34bf0150614e8c8e
Author:     Han Pingtian <phan@redhat.com>
AuthorDate: Mon, 18 Jul 2011 11:13:14 +0800
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 22 Jul 2011 08:59:26 -0300

perf buildid-cache: Zero out buffer of filenames when adding/removing buildid

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
