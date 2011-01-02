Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab1ABHqh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Jan 2011 02:46:37 -0500
Received: from mail.windriver.com ([147.11.1.11]:36200 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754302Ab1ABHYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Jan 2011 02:24:15 -0500
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: stable@kernel.org, linux-kernel@vger.kernel.org
Cc: stable-review@kernel.org, Dan Rosenberg <drosenberg@vsecurity.com>,
        Takashi Iwai <tiwai@suse.de>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [34-longterm 163/260] ALSA: prevent heap corruption in snd_ctl_new()
Date: Sun,  2 Jan 2011 02:17:39 -0500
Message-Id: <1293952756-15010-164-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.3.3
In-Reply-To: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
References: <1293952756-15010-1-git-send-email-paul.gortmaker@windriver.com>
X-OriginalArrivalTime: 02 Jan 2011 07:23:09.0056 (UTC) FILETIME=[E7EE7800:01CBAA4D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Rosenberg <drosenberg@vsecurity.com>

commit 5591bf07225523600450edd9e6ad258bb877b779 upstream.

The snd_ctl_new() function in sound/core/control.c allocates space for a
snd_kcontrol struct by performing arithmetic operations on a
user-provided size without checking for integer overflow.  If a user
provides a large enough size, an overflow will occur, the allocated
chunk will be too small, and a second user-influenced value will be
written repeatedly past the bounds of this chunk.  This code is
reachable by unprivileged users who have permission to open
a /dev/snd/controlC* device (on many distros, this is group "audio") via
the SNDRV_CTL_IOCTL_ELEM_ADD and SNDRV_CTL_IOCTL_ELEM_REPLACE ioctls.

Signed-off-by: Dan Rosenberg <drosenberg@vsecurity.com>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 sound/core/control.c |    5 +++++
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/sound/core/control.c b/sound/core/control.c
index 439ce64..85abc46 100644
--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -31,6 +31,7 @@
 
 /* max number of user-defined controls */
 #define MAX_USER_CONTROLS	32
+#define MAX_CONTROL_COUNT	1028
 
 struct snd_kctl_ioctl {
 	struct list_head list;		/* list of all ioctls */
@@ -191,6 +192,10 @@ static struct snd_kcontrol *snd_ctl_new(struct snd_kcontrol *control,
 	
 	if (snd_BUG_ON(!control || !control->count))
 		return NULL;
+
+	if (control->count > MAX_CONTROL_COUNT)
+		return NULL;
+
 	kctl = kzalloc(sizeof(*kctl) + sizeof(struct snd_kcontrol_volatile) * control->count, GFP_KERNEL);
 	if (kctl == NULL) {
 		snd_printk(KERN_ERR "Cannot allocate control instance\n");
-- 
1.7.3.3

