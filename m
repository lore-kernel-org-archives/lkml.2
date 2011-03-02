Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755916Ab1CBI3p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 03:29:45 -0500
Received: from mga02.intel.com ([134.134.136.20]:62172 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751354Ab1CBI3o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 03:29:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,252,1297065600"; 
   d="scan'208";a="608130977"
Subject: Re: perf archive warning
From: Lin Ming <ming.m.lin@intel.com>
To: Han Pingtian <phan@redhat.com>
Cc: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>
In-Reply-To: <AANLkTim+Ls+_cbHnMzdfWAWUj0Wx2rQtnoTCjZJ8Cnro@mail.gmail.com>
References: <20110302042354.GB5186@hpt.nay.redhat.com>
	 <AANLkTim+Ls+_cbHnMzdfWAWUj0Wx2rQtnoTCjZJ8Cnro@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 16:29:41 +0800
Message-ID: <1299054581.8642.36.camel@minggr.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 16:09 +0800, Lin Ming wrote:
> ---------- Forwarded message ----------
> From: Han Pingtian <phan@redhat.com>
> Date: Wed, Mar 2, 2011 at 12:23 PM
> Subject: perf archive warning
> To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
> Cc: Arnaldo Carvalho de Melo <acme@redhat.com>, Peter Zijlstra
> <peterz@infradead.org>
> 
> 
> Hi,
> 
> perf archive has some waring messages, is this a bug?
> 
> root@intel-s3e36-01 perf]# ./perf-archive
> tar: .build-id/b2/370e39ea2898c6e11c188e2f3879e4e3d6d1ef: Cannot stat:
> No such file or directory
> tar: .build-id/b2/370e39ea2898c6e11c188e2f3879e4e3d6d1ef: Cannot stat:
> No such file or directory
> tar: Exiting with failure status due to previous errors

kernel.kallsyms is not created successfully in the buildid-cache.
Could you have a try below patch?

diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 72c124d..d3b5062 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -271,11 +271,16 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms)
 {
 	const size_t size = PATH_MAX;
-	char *realname = realpath(name, NULL),
+	char *realname,
 	     *filename = malloc(size),
 	     *linkname = malloc(size), *targetname;
 	int len, err = -1;
 
+	if (is_kallsyms)
+		realname = (char *)name;
+	else
+		realname = realpath(name, NULL);
+
 	if (realname == NULL || filename == NULL || linkname == NULL)
 		goto out_free;
 
@@ -307,7 +312,8 @@ int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 	if (symlink(targetname, linkname) == 0)
 		err = 0;
 out_free:
-	free(realname);
+	if (!is_kallsyms)
+		free(realname);
 	free(filename);
 	free(linkname);
 	return err;


> Now please run:
> 
> $ tar xvf perf.data.tar.bz2 -C ~/.debug
> 
> wherever you need to run 'perf report' on.
> [root@intel-s3e36-01 perf]# ./perf --version
> perf version 2.6.38.rc6.166.g493f33
> [root@intel-s3e36-01 perf]# ./perf buildid-list
> b2370e39ea2898c6e11c188e2f3879e4e3d6d1ef [kernel.kallsyms]
> dd95cb496ebc4ed922eeb5640965f1243fcfcd9a
> /lib/modules/2.6.32-118.el6.x86_64/kernel/fs/ext4/ext4.ko
> 9e1aca88b83308cec7574d74975fa6f7d654c96e /lib64/libc-2.12.so
> d880be15bf992b5fbcc629e6bbf1c747a928ddd5 /lib64/libglib-2.0.so.0.2200.5
> d1b2ca4e1ec8f81ba820e5f1375d960107ac7e50 /usr/lib64/libstdc++.so.6.0.13
> [root@intel-s3e36-01 perf]#
> 
> --
> Han Pingtian
> Quality Engineer
> hpt @ #kernel-qe
> Red Hat, Inc
> Freedom ... courage ... Commitment ... ACCOUNTABILITY
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


