Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754688Ab0ESTIm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:08:42 -0400
Received: from mail.gmx.net ([213.165.64.20]:48619 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754675Ab0ESTIj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:08:39 -0400
X-Authenticated: #10250065
X-Provags-ID: V01U2FsdGVkX182nggo3EM2Ii7/Zcg1G7lFXeq4BHLnXFtgXnM6ZY
	j9nPa1abhyEeCO
Message-ID: <4BF43722.4060601@gmx.de>
Date: Wed, 19 May 2010 21:08:18 +0200
From: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100328)
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Bruno_Pr=E9mont?= <bonbons@linux-vserver.org>
CC: linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn, corbet@lwn.net
Subject: Re: viafb suspend & resume, v2
References: <1272813454-3229-1-git-send-email-FlorianSchandinat@gmx.de> <20100510195636.7936ec76@neptune.home>
In-Reply-To: <20100510195636.7936ec76@neptune.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bruno Prémont schrieb:
> On Sun, 02 May 2010 Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:
>> This is the second version of this patch series. It is forward ported to apply
>> on Jon's current viafb-posted branch. Furthermore the engine is only
>> (re)started if the mmio space is mapped.
>> There are still issues left especially device configuration and it does not yet
>> integrate nicely in the new structure of the driver. However it is in a state
>> where it shouldn't hurt anyone but could be useful for some people.
> 
> Only works with restrictions on my box.

Thanks for testing it.

> If I have accel enabled system freezes during suspend, if accel is disabled
> system suspends&resumes.
>>From a quick glance at the code I don't know what to do to disable accel
> during suspend (and restore it on resume)...

I am wondering where the freeze comes from. We don't use too much of the engine
and we already wait for it to become idle. Can you please test whether this patch
fixes it? It's not really acceleration related but other framebuffers do the same
and maybe it has a side effect for acceleration.

> viafb is not able to get GPU alive from its own, it still needs to have the
> BIOS run VBIOS on resume.

Okay, I guess the current code needs to be cleaned up before I can expect it to
work reliable...


Thanks,

Florian Tobias Schandinat

diff --git a/drivers/video/via/viafbdev.c b/drivers/video/via/viafbdev.c
index f581fb7..10b907a 100644
--- a/drivers/video/via/viafbdev.c
+++ b/drivers/video/via/viafbdev.c
@@ -1750,6 +1750,7 @@ int viafb_suspend(struct pci_dev *pdev, pm_message_t state)
  		fb_set_suspend(viafbinfo, 1);

  		viafb_sync(viafbinfo);
+		viafb_blank(FB_BLANK_POWERDOWN, viafbinfo);

  		pci_save_state(pdev);
  		pci_disable_device(pdev);
