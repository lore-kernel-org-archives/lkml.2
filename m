Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754182Ab1BBAsk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 19:48:40 -0500
Received: from mga11.intel.com ([192.55.52.93]:43069 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753928Ab1BBApO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 19:45:14 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,412,1291622400"; 
   d="scan'208";a="653505357"
From: Andi Kleen <andi@firstfloor.org>
References: <20110201443.618138584@firstfloor.org>
In-Reply-To: <20110201443.618138584@firstfloor.org>
To: drosenberg@vsecurity.com, tiwai@suse.de, gregkh@suse.de,
        ak@linux.intel.com, linux-kernel@vger.kernel.org, stable@kernel.org
Subject: [PATCH] [124/139] sound: Prevent buffer overflow in OSS load_mixer_volumes
Message-Id: <20110202004523.85EBB3E09BD@tassilo.jf.intel.com>
Date: Tue,  1 Feb 2011 16:45:23 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-longterm review patch.  If anyone has any objections, please let me know.

------------------
From: Dan Rosenberg <drosenberg@vsecurity.com>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Andi Kleen <ak@linux.intel.com>

---
 sound/oss/soundcard.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: linux-2.6.35.y/sound/oss/soundcard.c
===================================================================
--- linux-2.6.35.y.orig/sound/oss/soundcard.c
+++ linux-2.6.35.y/sound/oss/soundcard.c
@@ -86,7 +86,7 @@ int *load_mixer_volumes(char *name, int 
 	int             i, n;
 
 	for (i = 0; i < num_mixer_volumes; i++) {
-		if (strcmp(name, mixer_vols[i].name) == 0) {
+		if (strncmp(name, mixer_vols[i].name, 32) == 0) {
 			if (present)
 				mixer_vols[i].num = i;
 			return mixer_vols[i].levels;
@@ -98,7 +98,7 @@ int *load_mixer_volumes(char *name, int 
 	}
 	n = num_mixer_volumes++;
 
-	strcpy(mixer_vols[n].name, name);
+	strncpy(mixer_vols[n].name, name, 32);
 
 	if (present)
 		mixer_vols[n].num = n;
