Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab2AXCoN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 21:44:13 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756394Ab2AXCoJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 21:44:09 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Mon Jan 23 18:39:25 2012
Message-Id: <20120124023925.179069692@clark.kroah.org>
User-Agent: quilt/0.50-11.1
Date: Mon, 23 Jan 2012 18:33:54 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Takashi Iwai <tiwai@suse.de>
Subject: [014/129] ALSA: hda - Return the error from get_wcaps_type() for invalid NIDs
In-Reply-To: <20120124024041.GA18422@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------
Content-Length: 1521
Lines: 49

From: Takashi Iwai <tiwai@suse.de>

commit 3a90274de3548ebb2aabfbf488cea8e275a73dc6 upstream.

When an invalid NID is given, get_wcaps() returns zero as the error,
but get_wcaps_type() takes it as the normal value and returns a bogus
AC_WID_AUD_OUT value.  This confuses the parser.

With this patch, get_wcaps_type() returns -1 when value 0 is given,
i.e. an invalid NID is passed to get_wcaps().

Bugzilla: https://bugzilla.novell.com/show_bug.cgi?id=740118

Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 sound/pci/hda/hda_local.h |    7 ++++++-
 sound/pci/hda/hda_proc.c  |    2 ++
 2 files changed, 8 insertions(+), 1 deletion(-)

--- a/sound/pci/hda/hda_local.h
+++ b/sound/pci/hda/hda_local.h
@@ -487,7 +487,12 @@ static inline u32 get_wcaps(struct hda_c
 }
 
 /* get the widget type from widget capability bits */
-#define get_wcaps_type(wcaps) (((wcaps) & AC_WCAP_TYPE) >> AC_WCAP_TYPE_SHIFT)
+static inline int get_wcaps_type(unsigned int wcaps)
+{
+	if (!wcaps)
+		return -1; /* invalid type */
+	return (wcaps & AC_WCAP_TYPE) >> AC_WCAP_TYPE_SHIFT;
+}
 
 static inline unsigned int get_wcaps_channels(u32 wcaps)
 {
--- a/sound/pci/hda/hda_proc.c
+++ b/sound/pci/hda/hda_proc.c
@@ -54,6 +54,8 @@ static const char *get_wid_type_name(uns
 		[AC_WID_BEEP] = "Beep Generator Widget",
 		[AC_WID_VENDOR] = "Vendor Defined Widget",
 	};
+	if (wid_value == -1)
+		return "UNKNOWN Widget";
 	wid_value &= 0xf;
 	if (names[wid_value])
 		return names[wid_value];


