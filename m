Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754364Ab2BARC0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 12:02:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39174 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751307Ab2BARCY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 12:02:24 -0500
Date: Wed, 1 Feb 2012 12:01:58 -0500
From: Josh Boyer <jwboyer@redhat.com>
To: John Stultz <john.stultz@linaro.org>, Michal Marek <mmarek@suse.cz>
Cc: kernel-team@fedoraproject.org, linux-kernel@vger.kernel.org
Subject: [PATCH] merge_config.sh: Use the first file as the initial config
Message-ID: <20120201170157.GA4907@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Take the first config fragment and use it verbatim as the initial config set.
This avoids running the verification loop for the first file, as nothing has
actually been merged at this point.  This significantly increases performance
for large config fragments.

Signed-off-by: Josh Boyer <jwboyer@redhat.com>
---

When experimenting with merge_config.sh on the Fedora config fragments, this
cut the execution time of a single invocation with all the config fragments
in half (from 28 seconds to 13 seconds).

 scripts/kconfig/merge_config.sh |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
index ceadf0e..23d738a 100644
--- a/scripts/kconfig/merge_config.sh
+++ b/scripts/kconfig/merge_config.sh
@@ -58,12 +58,16 @@ while true; do
 	esac
 done
 
-
+INITFILE=$1
+shift;
 
 MERGE_LIST=$*
 SED_CONFIG_EXP="s/^\(# \)\{0,1\}\(CONFIG_[a-zA-Z0-9_]*\)[= ].*/\2/p"
 TMP_FILE=$(mktemp ./.tmp.config.XXXXXXXXXX)
 
+echo "Using $INITFILE as base"
+cat $INITFILE > $TMP_FILE
+
 # Merge files, printing warnings on overrided values
 for MERGE_FILE in $MERGE_LIST ; do
 	echo "Merging $MERGE_FILE"
-- 
1.7.8.4

