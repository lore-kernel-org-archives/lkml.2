Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580Ab3AJJii (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:38:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:41402 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3AJJif (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:38:35 -0500
Date: Thu, 10 Jan 2013 10:38:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Alex Deucher <alexander.deucher@amd.com>
Cc: dri-devel@lists.freedesktop.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
Message-ID: <20130110093831.GA19503@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alex Deucher <alexander.deucher@amd.com>,
	dri-devel@lists.freedesktop.org,
	lkml <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ deliberately breaking the thread because it got too long]

On Sat, Dec 22, 2012 at 09:35:47PM +0100, Borislav Petkov wrote:
> Hi Alex,
> 
> got the sickest bug on 3.8-rc1, see below. The GPU locks up somewhere
> down radeon_fence_wait_seq, judging by the error messages.
> 
> And this doesn't happen with 3.7, of course.
> 
> Let me know if you need any more info, thanks.
> 
> [16273.668350] radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
> [16273.668361] radeon 0000:02:00.0: GPU lockup (waiting for 0x000000000000002b last fence id 0x000000000000002a)
> [16273.882550] plugin-containe[11435]: segfault at 7f1f0a66cc08 ip 00007f1f13289bdb sp 00007f1f0a2fe9e0 error 4 in libflashplayer.so[7f1f130c5000+117b000]
> [16274.502807] ------------[ cut here ]------------
> [16274.502845] WARNING: at lib/list_debug.c:53 __list_del_entry+0x63/0xd0()

Ok, this got fixed by 909d9eb67f1e4e39f2ea88e96bde03d560cde3eb which is
upstream now. And I'm testing -rc2+ which contains this patch already
+ tip/master + another fix from Alan which reworks fb console locking
(should be unrelated) and the machine gets unresponsive for a couple of
seconds and then it is fine again.

See dmesg below, the GPU gets the same lockup CP stall without the list
corruption so it recovers fine. But I didn't have those stalls before so
it has to be something which came up with 3.8 merge window.

[44730.749380] radeon 0000:02:00.0: GPU lockup CP stall for more than 10000msec
[44730.749391] radeon 0000:02:00.0: GPU lockup (waiting for 0x0000000000305211 last fence id 0x0000000000305210)
[44730.750596] radeon 0000:02:00.0: Saved 25 dwords of commands on ring 0.
[44730.750612] radeon 0000:02:00.0: GPU softreset: 0x00000007
[44730.768865] radeon 0000:02:00.0:   R_008010_GRBM_STATUS      = 0xA0003030
[44730.768874] radeon 0000:02:00.0:   R_008014_GRBM_STATUS2     = 0x00000003
[44730.768880] radeon 0000:02:00.0:   R_000E50_SRBM_STATUS      = 0x200000C0
[44730.768885] radeon 0000:02:00.0:   R_008674_CP_STALLED_STAT1 = 0x00000000
[44730.768889] radeon 0000:02:00.0:   R_008678_CP_STALLED_STAT2 = 0x00000000
[44730.768894] radeon 0000:02:00.0:   R_00867C_CP_BUSY_STAT     = 0x00020184
[44730.768898] radeon 0000:02:00.0:   R_008680_CP_STAT          = 0x80028645
[44730.768903] radeon 0000:02:00.0:   R_008020_GRBM_SOFT_RESET=0x00007FEE
[44730.783898] radeon 0000:02:00.0: R_008020_GRBM_SOFT_RESET=0x00000001
[44730.798893] radeon 0000:02:00.0:   R_008010_GRBM_STATUS      = 0xA0003030
[44730.798896] radeon 0000:02:00.0:   R_008014_GRBM_STATUS2     = 0x00000003
[44730.798899] radeon 0000:02:00.0:   R_000E50_SRBM_STATUS      = 0x200080C0
[44730.798901] radeon 0000:02:00.0:   R_008674_CP_STALLED_STAT1 = 0x00000000
[44730.798904] radeon 0000:02:00.0:   R_008678_CP_STALLED_STAT2 = 0x00000000
[44730.798907] radeon 0000:02:00.0:   R_00867C_CP_BUSY_STAT     = 0x00000000
[44730.798909] radeon 0000:02:00.0:   R_008680_CP_STAT          = 0x80100000
[44730.819926] radeon 0000:02:00.0: GPU reset succeeded, trying to resume
[44730.836763] [drm] probing gen 2 caps for device 10de:377 = 1/0
[44730.839732] [drm] PCIE GART of 512M enabled (table at 0x0000000000040000).
[44730.839826] radeon 0000:02:00.0: WB enabled
[44730.839831] radeon 0000:02:00.0: fence driver on ring 0 use gpu addr 0x0000000020000c00 and cpu addr 0xffff880220223c00
[44730.839834] radeon 0000:02:00.0: fence driver on ring 3 use gpu addr 0x0000000020000c0c and cpu addr 0xffff880220223c0c
[44730.871080] [drm] ring test on 0 succeeded in 0 usecs
[44730.871140] [drm] ring test on 3 succeeded in 1 usecs
[44730.871187] [drm] ib test on ring 0 succeeded in 0 usecs
[44730.871206] [drm] ib test on ring 3 succeeded in 1 usecs

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
