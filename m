Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754191Ab2DOIj7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Apr 2012 04:39:59 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35582 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab2DOIj5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Apr 2012 04:39:57 -0400
Date: Sun, 15 Apr 2012 01:38:06 -0700
From: tip-bot for Chanho Park <chanho61.park@samsung.com>
Message-ID: <tip-e3b6193378e8549d04849eda496129f94406ed36@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        mingo@redhat.com, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, chanho61.park@samsung.com,
        kyungmin.park@samsung.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, mingo@redhat.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        tglx@linutronix.de, chanho61.park@samsung.com,
        kyungmin.park@samsung.com
In-Reply-To: <1333348109-12598-1-git-send-email-chanho61.park@samsung.com>
References: <1333348109-12598-1-git-send-email-chanho61.park@samsung.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf archive: Correct cutting of symbolic link
Git-Commit-ID: e3b6193378e8549d04849eda496129f94406ed36
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (terminus.zytor.com [127.0.0.1]); Sun, 15 Apr 2012 01:38:12 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  e3b6193378e8549d04849eda496129f94406ed36
Gitweb:     http://git.kernel.org/tip/e3b6193378e8549d04849eda496129f94406ed36
Author:     Chanho Park <chanho61.park@samsung.com>
AuthorDate: Mon, 2 Apr 2012 15:28:29 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Sat, 14 Apr 2012 13:52:15 -0300

perf archive: Correct cutting of symbolic link

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
