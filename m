Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752565Ab0LYTUS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Dec 2010 14:20:18 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33066 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752443Ab0LYTUQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Dec 2010 14:20:16 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=SpndtzR2TbbKSE/qqu4vxWUXQ9GaHem8f9tRAKHIMUd64V45J53ic5e1/e9TGp4eyC
         os8btxC7pLmG7J/ri/ZiY35Ecu8qWVhKzcn1LKcKoWcvODyUcxetPSCCXbOwcfEdrs3M
         YE0RK99hzM/ki5IJtkMzXRZSCbl3OHiAaoSXk=
Date: Sat, 25 Dec 2010 20:20:08 +0100
From: Jarek Poplawski <jarkao2@gmail.com>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: [2.6.37-rc7] drivers/gpu/drm/drm_edid.c:1303: warning: array
 subscript is above array bounds
Message-ID: <20101225192008.GA2325@del.dom.local>
References: <20101225131343.GA1960@del.dom.local>
 <c6d829$pvchrr@fmsmga001.fm.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c6d829$pvchrr@fmsmga001.fm.intel.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 25, 2010 at 01:38:56PM +0000, Chris Wilson wrote:
> On Sat, 25 Dec 2010 14:13:43 +0100, Jarek Poplawski <jarkao2@gmail.com> wrote:
> > Hi,
> > There is this compile warning in Linus' tree (gcc version 4.3.3):
> > 
> > drivers/gpu/drm/drm_edid.c: In function 'drm_detect_hdmi_monitor':
> > drivers/gpu/drm/drm_edid.c:1303: warning: array subscript is above array bounds
> > drivers/gpu/drm/drm_edid.c: In function 'drm_detect_monitor_audio':
> > drivers/gpu/drm/drm_edid.c:1303: warning: array subscript is above array bounds
> 
> What array? It's declared as "u8 *edid_ext;". At first glance looks like a
> compiler bug, applying subscript testing to an object with unknown bounds.

Maybe a bug but then also something very unique in this place wrt the
rest of the kernel (at least in my config). Btw, a patch below removes
this warning.

Jarek P.

--- drm_edid.c-	2010-12-25 19:24:55.000000000 +0100
+++ drm_edid.c	2010-12-25 19:51:45.000000000 +0100
@@ -1290,7 +1290,7 @@ add_detailed_modes(struct drm_connector 
  */
 static u8 *drm_find_cea_extension(struct edid *edid)
 {
-	u8 *edid_ext = NULL;
+	char *edid_ext = NULL;
 	int i;
 
 	/* No EDID or EDID extensions */
@@ -1299,7 +1299,7 @@ static u8 *drm_find_cea_extension(struct
 
 	/* Find CEA extension */
 	for (i = 0; i < edid->extensions; i++) {
-		edid_ext = (u8 *)edid + EDID_LENGTH * (i + 1);
+		edid_ext = (char *)edid + EDID_LENGTH * (i + 1);
 		if (edid_ext[0] == CEA_EXT)
 			break;
 	}
