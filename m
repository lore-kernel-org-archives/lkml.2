Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab1BFXqM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 18:46:12 -0500
Received: from 1wt.eu ([62.212.114.60]:60308 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540Ab1BFXqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 18:46:07 -0500
Message-Id: <20110206232253.251296233@pcw.home.local>
User-Agent: quilt/0.48-1
Date: Mon, 07 Feb 2011 00:23:09 +0100
From: Willy Tarreau <w@1wt.eu>
To: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org
Cc: Dan Rosenberg <drosenberg@vsecurity.com>, Takashi Iwai <tiwai@suse.de>,
        Greg Kroah-Hartman <gregkh@suse.de>, Willy Tarreau <w@1wt.eu>
Subject: [PATCH 17/23] sound: Prevent buffer overflow in OSS load_mixer_volumes
In-Reply-To: <4beed4da27f06efb2c13d6ed48850634@local>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27.58-stable review patch.  If anyone has any objections, please let us know.

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
Signed-off-by: Willy Tarreau <w@1wt.eu>

---
 sound/oss/soundcard.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

Index: longterm-2.6.27/sound/oss/soundcard.c
===================================================================
--- longterm-2.6.27.orig/sound/oss/soundcard.c	2011-01-29 11:19:14.734064117 +0100
+++ longterm-2.6.27/sound/oss/soundcard.c	2011-01-29 11:27:20.586064152 +0100
@@ -87,7 +87,7 @@
 	int             i, n;
 
 	for (i = 0; i < num_mixer_volumes; i++) {
-		if (strcmp(name, mixer_vols[i].name) == 0) {
+		if (strncmp(name, mixer_vols[i].name, 32) == 0) {
 			if (present)
 				mixer_vols[i].num = i;
 			return mixer_vols[i].levels;
@@ -99,7 +99,7 @@
 	}
 	n = num_mixer_volumes++;
 
-	strcpy(mixer_vols[n].name, name);
+	strncpy(mixer_vols[n].name, name, 32);
 
 	if (present)
 		mixer_vols[n].num = n;


