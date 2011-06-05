Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756298Ab1FEVqG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 17:46:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40401 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755967Ab1FEVqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 17:46:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=gYkt4rndxVQIGnNizEc8P4f+eDU/rlZjO+e0+cubDX7WB//tlxgq36u4lHpz0NPiI3
         33CgcC568GsK1PcMik4lSxI0Mrt5UtGTvnlGUyPxtp5I/oMEVo/iyxgZwvPMQOgAGUCy
         tGlG9pYhUUbXRCKyKKABlbM1qxlhk5jpgOFQs=
Message-ID: <4DEBF96D.3030209@gmail.com>
Date: Sun, 05 Jun 2011 23:47:25 +0200
From: Emese Revfy <re.emese@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Kees Cook <kees.cook@canonical.com>, linux-kernel@vger.kernel.org,
        cocci@diku.dk
Subject: Re: [Cocci] Re: status of constification
References: <20101108223844.GS5876@outflux.net> <4CD9BF25.4090306@gmail.com> <20110528031348.GA19633@outflux.net> <Pine.LNX.4.64.1105280838150.30088@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1105280838150.30088@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Could I see the semantic patch?  The clean up issue sounds interesting.
> Perhaps there is a way around it.

Hi,
I no longer use Coccinelle to generate constification patch, but only to find
candidate structures for constification. This is because I ran into several issues
some of which I will try describe now from memory (unfortunately I don't have
those Cocci scripts anymore):

1. Sometimes (always?) cocci removed NULL initialization while emitting the constified patch:

linux-2.6.39-rc7/arch/frv/mb93090-mb00/pci-vdk.c
@@ -356,7 +356,7 @@ void __init pcibios_fixup_bus(struct pci
  
  int __init pcibios_init(void)
  {
-       struct pci_ops *dir = NULL;
+       const struct pci_ops *dir;
  
         if (!mb93090_mb00_detected)
                 return -ENXIO;

2. Sometimes (always?) cocci joined structure field lines into one line while constifying  them:

linux-2.6.39-rc7/arch/x86/include/asm/x86_init.h
@@ -119,14 +119,7 @@ struct x86_init_pci {
   *
   */
  struct x86_init_ops {
-       struct x86_init_resources       resources;
-       struct x86_init_mpparse         mpparse;
-       struct x86_init_irqs            irqs;
-       struct x86_init_oem             oem;
-       struct x86_init_paging          paging;
-       struct x86_init_timers          timers;
-       struct x86_init_iommu           iommu;
-       struct x86_init_pci             pci;
+       const struct x86_init_resources resources;const struct x86_init_mpparse mpparse;const struct x86_init_irqs irqs;const struct x86_init_oem oem;const struct x86_init_paging paging;const struct x86_init_timers timers;const struct x86_init_iommu iommu;const struct x86_init_pci pci;
  };

  /**

3. Sometimes cocci removed comment lines while joining others, maybe related
    to the previous issue:
  
linux-2.6.39-rc7/drivers/net/wireless/ath/ath9k/hw.h
@@ -753,9 +753,7 @@ struct ath_hw {
         } enable_32kHz_clock;

         /* Private to hardware code */
-       struct ath_hw_private_ops private_ops;
-       /* Accessed by the lower level driver */
-       struct ath_hw_ops ops;
+       const struct ath_hw_private_ops private_ops;const struct ath_hw_ops ops;

         /* Used to program the radio on non single-chip devices */
         u32 *analogBank0Data;

4. My constification patch generator cocci script didn't find all structures that it should have, I don't know whether it was a bug in my script or in cocci but in the end I just gave it up.

--
Emese
