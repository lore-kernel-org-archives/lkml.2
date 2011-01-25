Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923Ab1AYWBu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 17:01:50 -0500
Received: from mailout10.t-online.de ([194.25.134.21]:45646 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752478Ab1AYWBs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 17:01:48 -0500
Message-ID: <4D3F4849.4030905@t-online.de>
Date: Tue, 25 Jan 2011 23:01:45 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Chris Wilson <chris@chris-wilson.co.uk>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/i915/sdvo: If at first we don't succeed in reading
 the response, wait
References: <4D3EB90C.9020901@t-online.de> <1295967967-26041-1-git-send-email-chris@chris-wilson.co.uk>
In-Reply-To: <1295967967-26041-1-git-send-email-chris@chris-wilson.co.uk>
Content-Type: multipart/mixed;
 boundary="------------060105070206040801090204"
X-ID: TiEjBvZTwhnquJd92Ig0sZOgn77wsx9gypIbFX4TbMpoZhVcOdQILd6Noc7n4Rig-Y
X-TOI-MSGID: 302ca864-bc35-4626-bca2-28c072d44d57
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------060105070206040801090204
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Am 25.01.2011 16:06, schrieb Chris Wilson:
> We were not pausing after detecting the response was pending and so did
> not allow the hardware sufficient time to complete before aborting. This
> lead to transient failures whilst probing SDVO devices.
>
> Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
> ---
>
> Knut, this should fix one of the failures in the log:
>
> [  680.371855] [drm:intel_sdvo_debug_write], SDVOC: W: 0B (SDVO_CMD_GET_ATTACHED_DISPLAYS)
> [  680.417190] [drm:intel_sdvo_write_cmd], command returns response Pending [4]
>
> which caused the detect routine to return connector_status_unknown.
>
> However, there is still immediately following that:
>
> [  680.419880] [drm:intel_sdvo_debug_write], SDVOC: W: 11 00 00 (SDVO_CMD_SET_TARGET_OUTPUT)
> [  680.450190] [drm:intel_sdvo_write_cmd], command returns response Invalid arg 
> [3]
>
> which implies that we are mishandling that odd VGA-2 connector.
> -Chris
>
>   

Well, you are great, better than you thought yourself ;-)

The floating VGA-2 status is rock solid now, both problems solved.

The machine idles at 800Mhz, load increases speed to 1860 MHz. The code had
actually less time to execute under load, time became to short without
the delay ...

I think that patch also should be a candidate for 2.6.37.1 as it fixes a
regression
introduced in 2.6.37.

Something new:

Have a look at the attached new log.  I connected a 2nd monitor, so
there is a monitor attached to both
the VGA-1 and DVI-1 connectors. At the framebuffer console prompt (no X
running)
I changed to console 2 and back to console 1. The log starts at the
point of switching
back to console 1. Now ... shouldn't I read something about a
output_poll_execute for VGA-1?

Knut




--------------060105070206040801090204
Content-Type: text/plain;
 name="2Chris"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="2Chris"

[  629.662700] [drm:drm_crtc_helper_set_config],
[  629.662705] [drm:drm_crtc_helper_set_config], [CRTC:3] [FB:87] #connectors=1 (x y) (0 0)
[  629.662724] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
[  629.662728] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:4]
[  629.662732] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[  629.662735] [drm:drm_crtc_helper_set_config],  [CONNECTOR:5:VGA-1] set DPMS on
[  629.662739] [drm:drm_crtc_helper_set_config],
[  629.662741] [drm:drm_crtc_helper_set_config], [CRTC:4] [FB:87] #connectors=1 (x y) (0 0)
[  629.662749] [drm:drm_crtc_helper_set_config], [CONNECTOR:5:VGA-1] to [CRTC:3]
[  629.662753] [drm:drm_crtc_helper_set_config], [CONNECTOR:8:DVI-D-1] to [CRTC:4]
[  629.662756] [drm:drm_crtc_helper_set_config], Setting connector DPMS state to on
[  629.662760] [drm:drm_crtc_helper_set_config],  [CONNECTOR:8:DVI-D-1] set DPMS on

[  631.576055] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  631.587810] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[  631.604015] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[  631.606959] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  631.624124] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  631.755023] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[  631.758257] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  631.839893] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  631.860027] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[  631.862974] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 2 to 2

[  634.880024] [drm:intel_sdvo_debug_write], SDVOB: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  634.895785] [drm:intel_sdvo_read_response], SDVOB: R: (Success) 01 00
[  634.920022] [drm:intel_sdvo_detect], SDVO response 1 0 [1]
[  634.922971] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  634.945705] [drm:intel_sdvo_debug_write], SDVOB: W: 7A 02                      (SDVO_CMD_SET_CONTROL_BUS_SWITCH)
[  635.270273] [drm:output_poll_execute], [CONNECTOR:8:DVI-D-1] status updated from 1 to 1
[  635.288772] [drm:intel_sdvo_debug_write], SDVOC: W: 0B                         (SDVO_CMD_GET_ATTACHED_DISPLAYS)
[  635.449262] [drm:intel_sdvo_read_response], SDVOC: R: (Success) 00 00
[  635.493740] [drm:intel_sdvo_detect], SDVO response 0 0 [2]
[  635.510435] [drm:output_poll_execute], [CONNECTOR:44:VGA-2] status updated from 2 to 2

--------------060105070206040801090204--
