Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753152Ab2DBG3M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 02:29:12 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:34140 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751240Ab2DBG3K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 02:29:10 -0400
X-AuditID: cbfee61b-b7baeae000004fa7-ad-4f7947348444
From: Chanho Park <chanho61.park@samsung.com>
To: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        acme@ghostprotocols.net
Cc: linux-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org,
        Chanho Park <chanho61.park@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [PATCH] perf: archive: correct cutting of symbolic link
Date: Mon, 02 Apr 2012 15:28:29 +0900
Message-id: <1333348109-12598-1-git-send-email-chanho61.park@samsung.com>
X-Mailer: git-send-email 1.7.5.4
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If a '$PERF_BUILDID_DIR'(typically $HOME/.debug) is a symbolic
link directory, cutting of the path will be failed.
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
---
 tools/perf/perf-archive.sh |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

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
1.7.5.4

