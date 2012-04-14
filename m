Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755677Ab2DNRD6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 13:03:58 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39478 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751233Ab2DNRD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 13:03:57 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Chanho Park <chanho61.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5/5] perf archive: Correct cutting of symbolic link
Date: Sat, 14 Apr 2012 14:03:47 -0300
Message-Id: <1334423027-2220-6-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.7.9.2.358.g22243
In-Reply-To: <1334423027-2220-1-git-send-email-acme@infradead.org>
References: <1334423027-2220-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chanho Park <chanho61.park@samsung.com>

If a '$PERF_BUILDID_DIR'(typically $HOME/.debug) is a symbolic link
directory, cutting of the path will fail.

Here is an example where a buildid directory is a symbolic link.

/ # ls -al /root
lrwxrwxrwx    1 root     root            13 Mar 26  2012 /root -> opt/home/root
/ # cd ~
/opt/home/root # perf record -a -g sleep 1
[ perf record: Woken up 1 times to write data ]
[ perf record: Captured and wrote 0.322 MB perf.data (~14057 samples) ]
/opt/home/root # perf archive
tar: Removing leading `/' from member names
Now please run:

$ tar xvf perf.data.tar.bz2 -C ~/.debug

wherever you need to run 'perf report' on.
/opt/home/root # mkdir temp
/opt/home/root # tar xf perf.data.tar.bz2 -C ./temp
/opt/home/root # find ./temp -name "*kernel*"
./temp/opt/home/root/.debug/[kernel.kallsyms]

-> If successfully cut off the path, [kernel.kallsyms] is located
in top of the archived file.

This patch enables to cut correctly even if the buildid directory
is a symbolic link.

Signed-off-by: Chanho Park <chanho61.park@samsung.com>
Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Kyungmin Park <kyungmin.park@samsung.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1333348109-12598-1-git-send-email-chanho61.park@samsung.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/perf-archive.sh |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/tools/perf/perf-archive.sh b/tools/perf/perf-archive.sh
index 677e59d..95b6f8b 100644
--- a/tools/perf/perf-archive.sh
+++ b/tools/perf/perf-archive.sh
@@ -29,13 +29,14 @@ if [ ! -s $BUILDIDS ] ; then
 fi
 
 MANIFEST=$(mktemp /tmp/perf-archive-manifest.XXXXXX)
+PERF_BUILDID_LINKDIR=$(readlink -f $PERF_BUILDID_DIR)/
 
 cut -d ' ' -f 1 $BUILDIDS | \
 while read build_id ; do
 	linkname=$PERF_BUILDID_DIR.build-id/${build_id:0:2}/${build_id:2}
 	filename=$(readlink -f $linkname)
 	echo ${linkname#$PERF_BUILDID_DIR} >> $MANIFEST
-	echo ${filename#$PERF_BUILDID_DIR} >> $MANIFEST
+	echo ${filename#$PERF_BUILDID_LINKDIR} >> $MANIFEST
 done
 
 tar cfj $PERF_DATA.tar.bz2 -C $PERF_BUILDID_DIR -T $MANIFEST
-- 
1.7.9.2.358.g22243

