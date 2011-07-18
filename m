Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753365Ab1GRDNN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 23:13:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19454 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751736Ab1GRDNM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 23:13:12 -0400
Date: Mon, 18 Jul 2011 11:13:14 +0800
From: Han Pingtian <phan@redhat.com>
To: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        jolsa@redhat.com
Subject: [PATCH] perf: buildid-cache zero out buffer of filenames when
 adding/remoing buildid
Message-ID: <20110718031314.GA5802@hpt.nay.redhat.com>
Mail-Followup-To: linux-kernel@vger.kernel.org,
	Arnaldo Carvalho de Melo <acme@redhat.com>, jolsa@redhat.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

readlink() doesn't append a null byte to buf. So we should zero out buf
with zalloc(). Or we'll see sometimes error like this:

[root@intel-s3e36-01]~# /usr/bin/perf buildid-cache -a /lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko -v
Adding f64ba8efd5f53c7ad332fc17db1d21de309038e1 /lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko: Ok
[root@intel-s3e36-01]~# /usr/bin/perf buildid-cache -r /lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko -v
Removing f64ba8efd5f53c7ad332fc17db1d21de309038e1 /lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko: FAIL
/lib/modules/2.6.32-130.el6.x86_64/kernel/crypto/twofish_common.ko wasn't in the cache

The change in build_id_cache__add_s() is a defense.

Signed-off-by: Han Pingtian <phan@redhat.com>
---
 tools/perf/util/header.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index afb0849..36d723d 100644
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
1.7.1
