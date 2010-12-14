Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757461Ab0LNIkc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 03:40:32 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54426 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757222Ab0LNIk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 03:40:28 -0500
Date: Tue, 14 Dec 2010 09:40:24 +0100
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Liu Ying <liu.y.victor@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-fbdev@vger.kernel.org, Zhang Lily-R58066 <r58066@freescale.com>,
        Arnaud Patard <arnaud.patard@rtp-net.org>
Subject: Re: [PATCH 3/9] Add a mfd IPUv3 driver
Message-ID: <20101214084024.GS6017@pengutronix.de>
References: <1291902441-24712-1-git-send-email-s.hauer@pengutronix.de> <1291902441-24712-4-git-send-email-s.hauer@pengutronix.de> <AANLkTine90yN=e-J_zr03GmGCXekEWTPKv0pB5-EhA1v@mail.gmail.com> <20101213112345.GD6017@pengutronix.de> <AANLkTimuchaGAEuGX24GSnAu5-FVtG_kE_KDozGKo9e-@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTimuchaGAEuGX24GSnAu5-FVtG_kE_KDozGKo9e-@mail.gmail.com>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 09:36:49 up 163 days, 23:47, 32 users,  load average: 0.01, 0.14,
	0.12
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 12:05:07PM +0800, Liu Ying wrote:
> Hello, Sascha,
> 
> Please find my feedback with [LY] embedded.
> 
> Best Regards,
> Liu Ying
> 
> 2010/12/13 Sascha Hauer <s.hauer@pengutronix.de>:
> > Hi Liu Ying,
> >
> > Thanks for looking at the patches.
> [LY] You are welcome.
> >
> > On Sun, Dec 12, 2010 at 01:21:57PM +0800, Liu Ying wrote:
> >> Hello, Sascha,
> >>
> >> IPU is not embedded in i,MX50 SoC, but in i.MX51/53 SoCs, please
> >> modify the commit message.
> >>
> >> I have the following comments for the files editted respectively:
> >> 1) ipu-common.c
> >>     - ipu_idmac_get()/ipu_idmac_put() need a mechanism to protect IPU
> >> IDMAC resources, namely, get rid of potential race condition issue. As
> >> only framebuffer support is added in your patches, there should be no
> >> race condition issue now. After IC channels are supported(maybe as DMA
> >> engine), perhaps, there will be such kind of issue.
> >
> > ok.
> >
> >>     - ipu_idmac_select_buffer() need to add spinlock to protect
> >> IPU_CHA_BUFx_RDY registers.
> >
> > ok.
> >
> >>     - It looks that ipu_uninit_channel() only clears
> >> IPU_CHA_DB_MODE_SEL register, so why not put it in
> >> ipu_idmac_disable_channel()?
> >
> > ok.
> >
> >>     - It looks that ipu_add_client_devices() and your framebuffer
> >> patch assume /dev/fb0 uses DP_BG, /dev/fb1 uses DP_FG and /dev/fb2
> >> uses DC.
> >>       But fb1_platform_data->ipu_channel_bg is
> >> MX51_IPU_CHANNEL_MEM_DC_SYNC, this may make confusion for driver
> >> readers and it is not easy for code maintenance.
> >
> > Do you have a better suggestion? fb2 becomes fb1 when overlay support
> > is not used.
> [LY] How about assigning DP-BG to /dev/fb0, DC to /dev/fb1 and DP_FG
> to /dev/fb2?
> >
> >>     - It also looks that ipu_add_client_devices() and your framebuffer
> >> driver assume DP_BG/DP_FG are bound with DI0 and DC is bound with DI1.
> >>       It is ok for babbage board to support this kind of
> >> configuration, but it may bring some limitation. For example, TVE(TV
> >> encoder) module embedded in MX51 SoC can only connected with DI1 and
> >> users may like to use TV as the primary device(support HW overlay),
> >> and FSL Android BSP does support to use DI1 with LCD as the primary
> >> device on babbage board.
> >
> > SO we need to put the display number into the platform data, right?
> [LY] Yes, I think so. As the primary display port could be DI0 or DI1
> on boards like babbage board(two display ports are used), the primary
> display number in platform data should be configurable(I'm not sure
> whether this can be accepted by community), perhaps, configured by
> kernel bootup command line.

Ok, I'll find a solution for this.

> >
> >>
> >> 2) ipu-cpmem.c
> >>     - In order to improve performance, maybe writing
> >> ipu_ch_param_addr(ch) directly will be fine, but not using memset()
> >> and memcpy() in ipu_ch_param_init().
> >
> > I don't see this function in any performance critical path.
> [LY] Yes, currently, this function is not in performance critical
> path, so it is ok for me now. However, after IC/IRT channels are
> involved, the channels' idmac configuration might be changed from time
> to time and frequently, as the channels could be used as dma engine.

We are talking about 60 frames per second at maximum, right? So the
channel would be reconfigured 60 times a second, that's still not
performance critical, at least not if we are talking about a 100 byte or
something memset.

> >
> >>
> >> 3) ipu-dc.c
> >>     - Looks '#include <asm/atomic.h>' and '#include
> >> <linux/spinlock.h>' are unnecessary.
> >>     - Need to call 'ipu_module_disable(IPU_CONF_DC_EN);' somewhere.
> >
> > ok.
> >
> >>
> >> 4) ipu-di.c
> >>     - Looks '#include <asm/atomic.h>' and '#include <linux/delay.h>'
> >> are unnecessary.
> >
> > ok.
> >
> >>
> >> 5) ipu-dmfc.c
> >>     - Looks '#include <linux/delay.h>' are unnecessary.
> >
> > ok.
> >
> >>
> >> 6) ipu-dp.c
> >>     - Looks '#include <asm/atomic.h>' and '#include <linux/delay.h>'
> >> are unnecessary.
> >
> > ok.
> >
> >>
> >> 7) ipu-prv.h
> >>     - Looks '#include <linux/interrupt.h>' is unnecessary.
> >>     - Please rename 'MX51_IPU_CHANNEL_xxxx' to be 'IPU_CHANNEL_xxxx',
> >> IPUv3 channel names do not depend on SoC name.
> >
> > I was proven wrong each time I believed this.
> [LY] What if IPUv3 will be embedded in more SoCs? Could you please
> tell the reason? Thanks.

Then channel assignments will change, I'll promise.

Sascha


-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
