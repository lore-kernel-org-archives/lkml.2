Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753116Ab2DJJFm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 05:05:42 -0400
Received: from mga11.intel.com ([192.55.52.93]:22281 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751657Ab2DJJFl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 05:05:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139832691"
Date: Tue, 10 Apr 2012 17:00:35 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: Stephen Warren <swarren@wwwdotorg.org>, alsa-devel@alsa-project.org,
        Nick Bowler <nbowler@elliptictech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Packard <keithp@keithp.com>
Subject: Re: [PATCH] alsa: hide HDMI/ELD printks unless in debug kernels
Message-ID: <20120410090035.GA24518@localhost>
References: <20120409021517.GA14618@localhost>
 <4F82FC6C.1090501@wwwdotorg.org>
 <s5hty0sunif.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <s5hty0sunif.wl%tiwai@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 08:08:56AM +0200, Takashi Iwai wrote:
> At Mon, 09 Apr 2012 09:12:44 -0600,
> Stephen Warren wrote:
> > 
> > On 04/08/2012 08:15 PM, Fengguang Wu wrote:
> > > These trivial messages will show up repeatedly on hot plug as well as
> > > video mode changes, which could be annoying.
> > > 
> > > Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
> > 
> > Those messages are very useful for end-users to diagnose problems with
> > HDMI audio. Is there a way to make the messages dynamic, so users can
> > get them if they want, without recompiling their kernel?
> 
> We can define a new macro like below, add call like _snd_printd(2,
> ....) instead of snd_printd().
> (Yes, the number 2 can be replaced better in an enum, too.)
> 
> In future, we should move to the standard dynamic_printk, but a patch
> like this would be a good compromise for merging to 3.4 kernel, IMO.

OK. How about this?

Subject: alsa: hide HDMI/ELD printks unless snd.debug=2
Date: Fri Nov 11 19:09:36 CST 2011

Also remove two warnings when CONFIG_SND_DEBUG is not set:

sound/pci/hda/patch_hdmi.c: In function ‘hdmi_intrinsic_event’:
sound/pci/hda/patch_hdmi.c:761:6: warning: unused variable ‘eldv’ [-Wunused-variable]
sound/pci/hda/patch_hdmi.c:760:6: warning: unused variable ‘pd’ [-Wunused-variable]

Signed-off-by: Wu Fengguang <fengguang.wu@intel.com>
---
 include/sound/core.h       |   10 ++++++++++
 sound/pci/hda/hda_eld.c    |    6 +++---
 sound/pci/hda/patch_hdmi.c |    9 ++++-----
 3 files changed, 17 insertions(+), 8 deletions(-)

--- linux.orig/sound/pci/hda/hda_eld.c	2012-04-10 16:51:00.737707853 +0800
+++ linux/sound/pci/hda/hda_eld.c	2012-04-10 16:51:08.105708029 +0800
@@ -418,7 +418,7 @@ static void hdmi_show_short_audio_desc(s
 	else
 		buf2[0] = '\0';
 
-	printk(KERN_INFO "HDMI: supports coding type %s:"
+	_snd_printd(SND_PR_VERBOSE, "HDMI: supports coding type %s:"
 			" channels = %d, rates =%s%s\n",
 			cea_audio_coding_type_names[a->format],
 			a->channels,
@@ -442,14 +442,14 @@ void snd_hdmi_show_eld(struct hdmi_eld *
 {
 	int i;
 
-	printk(KERN_INFO "HDMI: detected monitor %s at connection type %s\n",
+	_snd_printd(SND_PR_VERBOSE, "HDMI: detected monitor %s at connection type %s\n",
 			e->monitor_name,
 			eld_connection_type_names[e->conn_type]);
 
 	if (e->spk_alloc) {
 		char buf[SND_PRINT_CHANNEL_ALLOCATION_ADVISED_BUFSIZE];
 		snd_print_channel_allocation(e->spk_alloc, buf, sizeof(buf));
-		printk(KERN_INFO "HDMI: available speakers:%s\n", buf);
+		_snd_printd(SND_PR_VERBOSE, "HDMI: available speakers:%s\n", buf);
 	}
 
 	for (i = 0; i < e->sad_count; i++)
--- linux.orig/sound/pci/hda/patch_hdmi.c	2012-04-10 16:51:00.745707854 +0800
+++ linux/sound/pci/hda/patch_hdmi.c	2012-04-10 16:55:35.813714391 +0800
@@ -757,8 +757,6 @@ static void hdmi_intrinsic_event(struct
 	struct hdmi_spec *spec = codec->spec;
 	int tag = res >> AC_UNSOL_RES_TAG_SHIFT;
 	int pin_nid;
-	int pd = !!(res & AC_UNSOL_RES_PD);
-	int eldv = !!(res & AC_UNSOL_RES_ELDV);
 	int pin_idx;
 	struct hda_jack_tbl *jack;
 
@@ -768,9 +766,10 @@ static void hdmi_intrinsic_event(struct
 	pin_nid = jack->nid;
 	jack->jack_dirty = 1;
 
-	printk(KERN_INFO
+	_snd_printd(SND_PR_VERBOSE,
 		"HDMI hot plug event: Codec=%d Pin=%d Presence_Detect=%d ELD_Valid=%d\n",
-		codec->addr, pin_nid, pd, eldv);
+		codec->addr, pin_nid,
+		!!(res & AC_UNSOL_RES_PD), !!(res & AC_UNSOL_RES_ELDV));
 
 	pin_idx = pin_nid_to_pin_index(spec, pin_nid);
 	if (pin_idx < 0)
@@ -992,7 +991,7 @@ static void hdmi_present_sense(struct hd
 	if (eld->monitor_present)
 		eld_valid	= !!(present & AC_PINSENSE_ELDV);
 
-	printk(KERN_INFO
+	_snd_printd(SND_PR_VERBOSE,
 		"HDMI status: Codec=%d Pin=%d Presence_Detect=%d ELD_Valid=%d\n",
 		codec->addr, pin_nid, eld->monitor_present, eld_valid);
 
--- linux.orig/include/sound/core.h	2012-04-10 16:51:00.757707854 +0800
+++ linux/include/sound/core.h	2012-04-10 16:51:08.105708029 +0800
@@ -325,6 +325,13 @@ void release_and_free_resource(struct re
 
 /* --- */
 
+/* sound printk debug levels */
+enum {
+	SND_PR_ALWAYS,
+	SND_PR_DEBUG,
+	SND_PR_VERBOSE,
+};
+
 #if defined(CONFIG_SND_DEBUG) || defined(CONFIG_SND_VERBOSE_PRINTK)
 __printf(4, 5)
 void __snd_printk(unsigned int level, const char *file, int line,
@@ -354,6 +361,8 @@ void __snd_printk(unsigned int level, co
  */
 #define snd_printd(fmt, args...) \
 	__snd_printk(1, __FILE__, __LINE__, fmt, ##args)
+#define _snd_printd(level, fmt, args...) \
+	__snd_printk(level, __FILE__, __LINE__, fmt, ##args)
 
 /**
  * snd_BUG - give a BUG warning message and stack trace
@@ -383,6 +392,7 @@ void __snd_printk(unsigned int level, co
 #else /* !CONFIG_SND_DEBUG */
 
 #define snd_printd(fmt, args...)	do { } while (0)
+#define _snd_printd(level, fmt, args...) do { } while (0)
 #define snd_BUG()			do { } while (0)
 static inline int __snd_bug_on(int cond)
 {
