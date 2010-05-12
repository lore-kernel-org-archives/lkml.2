Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757287Ab0ELU0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 16:26:18 -0400
Received: from mailrelay008.isp.belgacom.be ([195.238.6.174]:19142 "EHLO
	mailrelay008.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751698Ab0ELU0Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 16:26:16 -0400
X-Belgacom-Dynamic: yes
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAD+r6ktR9LjC/2dsb2JhbAAHgxHILpBrgSaDAWsE
Message-ID: <4BEB0EE6.1060002@belbone.be>
Date: Wed, 12 May 2010 22:26:14 +0200
From: =?UTF-8?B?Q8OpZHJpYyBHb2Rpbg==?= <cedric@belbone.be>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100411 Thunderbird/3.0.4
MIME-Version: 1.0
To: =?UTF-8?B?TWFyZWsgT2zFocOhaw==?= <maraeo@gmail.com>,
       dri-devel@lists.sourceforge.net
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@redhat.com>
Subject: drm regression on resume with -rc7 (bisected to 797fd5b9dad12a100c81b5782573a41259728cb1)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

When resuming my laptop from a -rc7, my X session reacted weirdly.
Reading the dmesg log, I had :

May 12 21:58:03 enea kernel: [  122.627332] [drm:radeon_ib_schedule] 
*ERROR* radeon: couldn't schedule IB(0).
May 12 21:58:03 enea kernel: [  122.627342] [drm:radeon_cs_ioctl] 
*ERROR* Faild to schedule IB !
May 12 21:58:03 enea kernel: [  123.251198] [drm:radeon_ib_schedule] 
*ERROR* radeon: couldn't schedule IB(1).
May 12 21:58:03 enea kernel: [  123.251207] [drm:radeon_cs_ioctl] 
*ERROR* Faild to schedule IB !
May 12 21:58:04 enea kernel: [  123.626341] [drm:radeon_ib_schedule] 
*ERROR* radeon: couldn't schedule IB(2).
May 12 21:58:04 enea kernel: [  123.626351] [drm:radeon_cs_ioctl] 
*ERROR* Faild to schedule IB !
May 12 21:58:04 enea kernel: [  124.256505] [drm:radeon_ib_schedule] 
*ERROR* radeon: couldn't schedule IB(3).
May 12 21:58:04 enea kernel: [  124.256514] [drm:radeon_cs_ioctl] 
*ERROR* Faild to schedule IB !
May 12 21:58:05 enea kernel: [  124.626191] [drm:radeon_ib_schedule] 
*ERROR* radeon: couldn't schedule IB(4).
May 12 21:58:05 enea kernel: [  124.626200] [drm:radeon_cs_ioctl] 
*ERROR* Faild to schedule IB !
May 12 21:58:05 enea kernel: [  125.059095] [drm:radeon_ib_schedule] 
*ERROR* radeon: couldn't schedule IB(5).

And so on until IB(15)

This was not the case with a -rc5 kernel nor with a kernel without KMS 
(radeon.modeset=0).

Bisection gives me (on drivers/gpu):

# bad: [b57f95a38233a2e73b679bea4a5453a1cc2a1cc9] Linux 2.6.34-rc7
# good: [01bf0b64579ead8a82e7cfc32ae44bc667e7ad0f] Linux 2.6.34-rc5
git bisect start 'v2.6.34-rc7' 'v2.6.34-rc5' '--' 'drivers/gpu/'
# bad: [3515387ba90ef2c38602f4d52c4d5ec5fc95ae5c] drm/radeon/kms: fix 
panel scaling adjusted mode setup
git bisect bad 3515387ba90ef2c38602f4d52c4d5ec5fc95ae5c
# good: [88b045077a1462a47503137fd4ca0c31772819ca] drm/radeon: Fix sparc 
regression in r300_scratch()
git bisect good 88b045077a1462a47503137fd4ca0c31772819ca
# bad: [404b017d00a9f472bdf725a06892d42f1cba5ed8] 
drivers/gpu/drm/drm_memory.c: fix check for end of loop
git bisect bad 404b017d00a9f472bdf725a06892d42f1cba5ed8
# bad: [ccb2ad579f910e6146adf4eb3aa50325253ee8c9] drm/radeon/kms/agp The 
wrong AGP chipset can cause a NULL pointer dereference
git bisect bad ccb2ad579f910e6146adf4eb3aa50325253ee8c9

with 797fd5b9dad12a100c81b5782573a41259728cb1 being the culprit

commit 797fd5b9dad12a100c81b5782573a41259728cb1
Author: Marek Olšák <maraeo@gmail.com>
Date:   Tue Apr 13 02:33:36 2010 +0200

     drm/radeon/kms: r300 fix CS checker to allow zbuffer-only fastfill

     Signed-off-by: Marek Olšák <maraeo@gmail.com>


PS: if i've done something wrong, say it, i'm always ready to learn ;-)

Cedric

