Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933806Ab1DNSFv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 14:05:51 -0400
Received: from mail.windriver.com ([147.11.1.11]:42245 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965029Ab1DNR6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 13:58:55 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 190/209] sound: Prevent buffer overflow in OSS load_mixer_volumes
Date: Thu, 14 Apr 2011 13:55:48 -0400
Message-Id: <1302803767-9715-77-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.4.4
In-Reply-To: <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
References: <1302803039-9400-1-git-send-email-paul.gortmaker@windriver.com>
 <1302803767-9715-1-git-send-email-paul.gortmaker@windriver.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

  =====================================================================
  | This is a commit scheduled for the next v2.6.34 longterm release. |
  | If you see a problem with using this for longterm, please comment.|
  =====================================================================

commit d81a12bc29ae4038770e05dce4ab7f26fd5880fb upstream.

The load_mixer_volumes() function, which can be triggered by
unprivileged users via the SOUND_MIXER_SETLEVELS ioctl, is vulnerable to
a buffer overflow.  Because the provided "name" argument isn't
guaranteed to be NULL terminated at the expected 32 bytes, it's possible
to overflow past the end of the last element in the mixer_vols array.
Further exploitation can result in an arbitrary kernel write (via
subsequent calls to load_mixer_volumes()) leading to privilege
escalation, or arbitrary kernel reads via get_mixer_levels().  In
addition, the strcmp() may leak bytes beyond the mixer_vols array.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/oss/soundcard.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/oss/soundcard.c b/sound/oss/soundcard.c
index 2d9c513..5739d8b 100644
--- a/sound/oss/soundcard.c
+++ b/sound/oss/soundcard.c
@@ -86,7 +86,7 @@ int *load_mixer_volumes(char *name, int *levels, int present)
 	int             i, n;
 
 	for (i = 0; i < num_mixer_volumes; i++) {
-		if (strcmp(name, mixer_vols[i].name) == 0) {
+		if (strncmp(name, mixer_vols[i].name, 32) == 0) {
 			if (present)
 				mixer_vols[i].num = i;
 			return mixer_vols[i].levels;
@@ -98,7 +98,7 @@ int *load_mixer_volumes(char *name, int *levels, int present)
 	}
 	n = num_mixer_volumes++;
 
-	strcpy(mixer_vols[n].name, name);
+	strncpy(mixer_vols[n].name, name, 32);
 
 	if (present)
 		mixer_vols[n].num = n;
-- 
1.7.4.4

