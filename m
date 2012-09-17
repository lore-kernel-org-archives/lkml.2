Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755966Ab2IQL31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2012 07:29:27 -0400
Received: from mail.anarazel.de ([217.115.131.40]:42808 "EHLO mail.anarazel.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab2IQL3Z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2012 07:29:25 -0400
From: Andres Freund <andres@anarazel.de>
To: LKML <linux-kernel@vger.kernel.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: radeon: Regression between v3.6-rc4 and v3.6-rc6: unable to allocate a PPLL
Date: Mon, 17 Sep 2012 13:29:15 +0200
User-Agent: KMail/1.13.7 (Linux/3.6.0-rc6-andres-dirty; KDE/4.8.4; x86_64; ; )
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201209171329.15699.andres@anarazel.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

While debugging another issue I upgraded from v3.6-rc4 to latest git (which 
exactly is v3.6-rc6). After X started up one of my three monitors blacked out. 
A look into the kernel log revealed:
[drm:radeon_atom_pick_pll] *ERROR* unable to allocate a PPLL

During that first start I tried to correct that using xrand, which failed. 
After restarting X (gdm) once more the monitor was still blank, the error was 
still logged, but could be enabled by using xrandr. A bit strange.

A quick look into git revealed:

$ git log --pretty=short v3.6-rc4.. drivers/gpu/drm/radeon/
commit f492c171a38d77fc13a8998a0721f2da50835224
Author: Christian König <deathsimple@vodafone.de>

    drm/radeon: make 64bit fences more robust v3

commit 985f61f7ee647ad570c05eab0b74915da2ac8e19
Author: Alex Deucher <alexander.deucher@amd.com>

    drm/radeon: rework pll selection (v3)

The latter seems to be a probably cause. Anything I can do to diagnose the 
issue?

$ xrandr|grep -E 'connected|Screen'
Screen 0: minimum 320 x 200, current 4960 x 1920, maximum 16384 x 16384
DVI-1 connected 2560x1600+1200+0 (normal left inverted right x axis y axis) 
641mm x 401mm
DisplayPort-0 connected 1200x1920+0+0 left (normal left inverted right x axis y 
axis) 518mm x 324mm
HDMI-0 disconnected (normal left inverted right x axis y axis)
DVI-0 connected 1200x1920+3760+0 left (normal left inverted right x axis y 
axis) 518mm x 324mm

# lspci -v -s 08:00.0
08:00.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Barts 
XT [Radeon HD 6800 Series] (prog-if 00 [VGA controller])
	Subsystem: PC Partner Limited Device 174b
	Flags: bus master, fast devsel, latency 0, IRQ 76
	Memory at d0000000 (64-bit, prefetchable) [size=256M]
	Memory at fbec0000 (64-bit, non-prefetchable) [size=128K]
	I/O ports at e000 [size=256]
	Expansion ROM at fbea0000 [disabled] [size=128K]
	Capabilities: [50] Power Management version 3
	Capabilities: [58] Express Legacy Endpoint, MSI 00
	Capabilities: [a0] MSI: Enable+ Count=1/1 Maskable- 64bit+
	Capabilities: [100] Vendor Specific Information: ID=0001 Rev=1 Len=010 <?>
	Capabilities: [150] Advanced Error Reporting
	Kernel driver in use: radeon

Greetings,

Andres
