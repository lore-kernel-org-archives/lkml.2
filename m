Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753397Ab2FJQyr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 12:54:47 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58587 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752149Ab2FJQyp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 12:54:45 -0400
Message-ID: <4FD4D146.80804@gmail.com>
Date: Sun, 10 Jun 2012 18:54:30 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk
Subject: Re: [ 00/82] 3.2.20-stable review
References: <20120608041840.861504477@decadent.org.uk>  <4FD2012F.60309@gmail.com>  <1339164246.21665.119.camel@deadeye.wl.decadent.org.uk> <1339196050.21665.128.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1339196050.21665.128.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

Op 09-06-12 00:54, Ben Hutchings schreef:
> On Fri, 2012-06-08 at 15:04 +0100, Ben Hutchings wrote:
>> On Fri, 2012-06-08 at 15:42 +0200, Maarten Lankhorst wrote:
>>> Hey,
>>>
>>> Op 08-06-12 06:18, Ben Hutchings schreef:
>>>> This is the start of the stable review cycle for the 3.2.20 release.
>>>> There are 82 patches in this series, which will be posted as responses
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Sun Jun 10 13:00:00 UTC 2012.
>>>> Anything received after that time might be too late.
>>>>
>>>> A combined patch relative to 3.2.19 will be posted as an additional
>>>> response to this, and the diffstat can be found below.
>>> Is it too late to nominate patches?
>> [...]
>>
>> It's too late for this time, unless there's something really urgent or
>> needed to avoid some other change in the rc causing a regression.
>>
>> I'll queue these up after 3.2.20.
> I'm sorry, I see you already requested these earlier.  So I should have
> queued them, but anyway it turns out that the last one (commit
> a6a17859f1bdf607650ee055101f54c5f207762b, 'drm/nouveau/disp: fix
> dithering not being enabled on some eDP macbooks') breaks the build:
>
>   CC [M]  drivers/gpu/drm/nouveau/nouveau_connector.o
> drivers/gpu/drm/nouveau/nouveau_connector.c: In function ‘nouveau_connector_detect_depth’:
> drivers/gpu/drm/nouveau/nouveau_connector.c:620:18: error: ‘struct nouveau_connector’ has no member named ‘type’
>
> So you'll need to provide a backported version of that.
>
You're right, with some digging it seems to have been renamed between 3.2
and 3.4, I'm sorry for the inconvenience.
Changing nv_connector->type to nv_connector->dcb->type fixes things,
it seems nouveau_connector and nouveau_encoder both have that same
member with different meaning on older versions until a rework,
so here's it fixed:

diff --git a/drivers/gpu/drm/nouveau/nouveau_connector.c b/drivers/gpu/drm/nouveau/nouveau_connector.c
index eeaa8ca..1e72db5 100644
--- a/drivers/gpu/drm/nouveau/nouveau_connector.c
+++ b/drivers/gpu/drm/nouveau/nouveau_connector.c
@@ -616,7 +616,13 @@ nouveau_connector_detect_depth(struct drm_connector *connector)
 	if (nv_connector->edid && connector->display_info.bpc)
 		return;
 
-	/* if not, we're out of options unless we're LVDS, default to 8bpc */
+	/* EDID 1.4 is *supposed* to be supported on eDP, but, Apple... */
+	if (nv_connector->dcb->type == DCB_CONNECTOR_eDP) {
+		connector->display_info.bpc = 6;
+		return;
+	}
+
+	/* we're out of options unless we're LVDS, default to 8bpc */
 	if (nv_encoder->dcb->type != OUTPUT_LVDS) {
 		connector->display_info.bpc = 8;
 		return;


