Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab0JVSlg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 14:41:36 -0400
Received: from kroah.org ([198.145.64.141]:45950 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758837Ab0JVSlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 14:41:31 -0400
X-Mailbox-Line: From gregkh@clark.site Fri Oct 22 11:40:32 2010
Message-Id: <20101022184032.856847478@clark.site>
User-Agent: quilt/0.48-11.2
Date: Fri, 22 Oct 2010 11:39:29 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Dan Rosenberg <drosenberg@vsecurity.com>, Takashi Iwai <tiwai@suse.de>
Subject: [04/17] ALSA: prevent heap corruption in snd_ctl_new()
In-Reply-To: <20101022184048.GA25391@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.27-stable review patch.  If anyone has any objections, please let us know.

------------------

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
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/core/control.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/sound/core/control.c
+++ b/sound/core/control.c
@@ -31,6 +31,7 @@
 
 /* max number of user-defined controls */
 #define MAX_USER_CONTROLS	32
+#define MAX_CONTROL_COUNT	1028
 
 struct snd_kctl_ioctl {
 	struct list_head list;		/* list of all ioctls */
@@ -190,6 +191,8 @@ static struct snd_kcontrol *snd_ctl_new(
 	
 	snd_assert(control != NULL, return NULL);
 	snd_assert(control->count > 0, return NULL);
+	if (control->count > MAX_CONTROL_COUNT)
+		return NULL;
 	kctl = kzalloc(sizeof(*kctl) + sizeof(struct snd_kcontrol_volatile) * control->count, GFP_KERNEL);
 	if (kctl == NULL) {
 		snd_printk(KERN_ERR "Cannot allocate control instance\n");


