Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932963Ab1EMAJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 20:09:17 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54095 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932356Ab1EMAJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 20:09:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to;
        b=cYWf3D1yeeaek45/KRQ9YL6VIs79ikLh86EBl7oOmmarU3hImxHrRaVND37CBzSsIM
         UqKEoIjsd7HGcaXD19Z42lscdOEvYk8Euo9Wl7VUfCCgbp0NRk/f26W77IM8jtUf2I+R
         TsiZ0v4K/7UJ29gt7USMAaYTy1heZ0Eex/8c8=
From: mfmooney@gmail.com
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: [PATCH v2] package: Makefile: fix perf target bug
Date: Thu, 12 May 2011 17:09:03 -0700
Message-Id: <e5dfdb7d9a9909d6f9faa20c45115142ebce2ae2.1305244842.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <BANLkTimrW=ZG2sGG1Q8QehSnh5rW1eBzGw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Specify --git-dir and --work-tree when building perf targets to
allow out-of-tree builds using O=<build-dir>.

The cat command had to be changed to allow proper file name expansion
of the files listed in MANIFEST.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
Okay, so I decided to just go ahead and send this. It removes the --work-tree
option from the git rev-parse command. I did test it the way you said, without
--work-tree on either statement, but the git archive command fails in that case.

Thanks,
matt

 scripts/package/Makefile |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/scripts/package/Makefile b/scripts/package/Makefile
index 1b7eaea..2747f1f 100644
--- a/scripts/package/Makefile
+++ b/scripts/package/Makefile
@@ -118,10 +118,13 @@ perf-tar=perf-$(KERNELVERSION)
 
 quiet_cmd_perf_tar = TAR
       cmd_perf_tar = \
-git archive --prefix=$(perf-tar)/ HEAD^{tree}                       \
-	$$(cat $(srctree)/tools/perf/MANIFEST) -o $(perf-tar).tar;  \
+git --git-dir=$(srctree)/.git --work-tree=$(srctree)                \
+	archive --prefix=$(perf-tar)/ HEAD^{tree}                   \
+	$(addprefix $(srctree)/,                                    \
+	  $(shell cat $(srctree)/tools/perf/MANIFEST))              \
+	-o $(perf-tar).tar;                                         \
 mkdir -p $(perf-tar);                                               \
-git rev-parse HEAD > $(perf-tar)/HEAD;                              \
+git --git-dir=$(srctree)/.git rev-parse HEAD > $(perf-tar)/HEAD;    \
 tar rf $(perf-tar).tar $(perf-tar)/HEAD;                            \
 rm -r $(perf-tar);                                                  \
 $(if $(findstring tar-src,$@),,                                     \
-- 
1.7.4.4

