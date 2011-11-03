Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754764Ab1KCOCF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 10:02:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:37104 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447Ab1KCOCA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 10:02:00 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,450,1315206000"; 
   d="scan'208";a="80865377"
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Artem Bityutskiy <dedekind1@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/1 (variant 1)] remap-log: fix map generator
Date: Thu,  3 Nov 2011 16:01:51 +0200
Message-Id: <1320328912-15148-2-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.7.6.4
In-Reply-To: <1320328912-15148-1-git-send-email-dedekind1@gmail.com>
References: <1320328912-15148-1-git-send-email-dedekind1@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>

This patch fixes a bug in the 'parse_diff()' function. This function iterates
over every changed file and every hunk in this file and at each iteration it
prints the hunk's map for the _previous_ iteration. This is taken into account
when it switches to the next file - just before starting processing hunks in
this file, it prints the map for the last hunk of the _previous_ file.

However, if we are at the very last file or we have a diff which changes only
one single file, and the last hunk is processed - we do not print the map of
this last hunk and just exit. The result is a buggy map - because the map of
the very last hunk is not printed.

Here is a short example to demonstrate the bug. The diff is:

|||diff --git a/sound/soc/codecs/sn95031.c b/sound/soc/codecs/sn95031.c
|||index 920e7bb..8c43fdd 100644
|||--- a/sound/soc/codecs/sn95031.c
|||+++ b/sound/soc/codecs/sn95031.c
|||@@ -811,0 +812 @@ static int sn95031_pcm_hs_mute(struct snd_soc_dai *dai, int mute)
|||+       int tmp = !mute;
|||@@ -813 +814 @@ static int sn95031_pcm_hs_mute(struct snd_soc_dai *dai, int mute)
|||-                       SN95031_HSLVOLCTRL, BIT(7), (!mute << 7));
|||+                       SN95031_HSLVOLCTRL, BIT(7), tmp << 7);
|||@@ -815 +816,3 @@ static int sn95031_pcm_hs_mute(struct snd_soc_dai *dai, int mute)
|||-                       SN95031_HSRVOLCTRL, BIT(7), (!mute << 7));
|||+                       SN95031_HSRVOLCTRL, BIT(7), tmp << 7);
|||+       snd_soc_update_bits(dai->codec,
|||+                       SN95031_DRIVEREN, BIT(0) | BIT(1), tmp | tmp << 1);

And remap-log generates an incorrect map:

M sound/soc/codecs/sn95031.c sound/soc/codecs/sn95031.c
1 1
812 813
813 0
814 815
815 0

Notice that the last map entry basically says that all lines in the old file
starting from line 815 have been deleted, which is not true - only one line
number 815 has been deleted.

The correct map should look like this:

M sound/soc/codecs/sn95031.c sound/soc/codecs/sn95031.c
1 1
812 813
813 0
814 815
815 0
816 819

To fix the bug this patch re-works the 'parse_diff()' function a little and
makes it print the map of the current hunk at each iteration, not the previous
hunk.

Signed-off-by: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
---
 tools/remap-log.c |   14 +++-----------
 1 files changed, 3 insertions(+), 11 deletions(-)

diff --git a/tools/remap-log.c b/tools/remap-log.c
index 327b870..011a7cb 100644
--- a/tools/remap-log.c
+++ b/tools/remap-log.c
@@ -331,7 +331,6 @@ void parse_diff(void)
 {
 	int skipping = -1, suppress = 1;
 	char *name1 = NULL, *name2 = NULL;
-	int from = 1, to = 1;
 	int l1, l2, n1, n2;
 	enum cmd {
 		Diff, Hunk, New, Del, Copy, Rename, Junk
@@ -367,21 +366,15 @@ void parse_diff(void)
 					printf("M %s %s\n", name1, name2);
 				if (!parse_hunk(&l1, &l2, &n1, &n2))
 					goto Ediff;
-				if (l1 > from)
-					printf("%d %d\n", from, to);
+				if (!skipping && l1 > 1)
+					printf("1 1\n");
 				if (n1)
 					printf("%d 0\n", l1);
-				from = l1 + n1;
-				to = l2 + n2;
+				printf("%d %d\n", l1 + n1, l2 + n2);
 			}
 			skipping = 1;
 			break;
 		case Diff:
-			if (!suppress) {
-				if (!skipping)
-					printf("M %s %s\n", name1, name2);
-				printf("%d %d\n", from, to);
-			}
 			free(name1);
 			free(name2);
 			name2 = strrchr(line, ' ');
@@ -401,7 +394,6 @@ void parse_diff(void)
 				goto Ediff;
 			skipping = 0;
 			suppress = 0;
-			from = to = 1;
 			break;
 		case New:
 			if (skipping)
-- 
1.7.7.1

