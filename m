Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753976Ab2K2TsO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:48:14 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:39447 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab2K2TsN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:48:13 -0500
MIME-Version: 1.0
In-Reply-To: <1354144069-28611-7-git-send-email-hauke@hauke-m.de>
References: <1354144069-28611-1-git-send-email-hauke@hauke-m.de> <1354144069-28611-7-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Thu, 29 Nov 2012 11:47:50 -0800
X-Google-Sender-Auth: QYXrQMustAbMM7SxSW_bFCgpHfI
Message-ID: <CAB=NE6Ww8SVm51qph=iXNGS8BN1cWdsT-bvKWrDt4b9c7ea9sg@mail.gmail.com>
Subject: Re: [PATCH 6/6] compat-drivers: do not use struct spinlock
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: backports@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arend Van Spriel <arend@broadcom.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Alexander Stein <alexander.stein@systec-electronic.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 28, 2012 at 3:07 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> struct spinlock does not exists on kernel version <= 2.6.32, use
> spinlock_t instead.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> ---
>  patches/network/67-use_spinlock_t.patch |   11 +++++++++++
>  1 file changed, 11 insertions(+)
>  create mode 100644 patches/network/67-use_spinlock_t.patch
>
> diff --git a/patches/network/67-use_spinlock_t.patch b/patches/network/67-use_spinlock_t.patch
> new file mode 100644
> index 0000000..4c9f315
> --- /dev/null
> +++ b/patches/network/67-use_spinlock_t.patch
> @@ -0,0 +1,11 @@
> +--- a/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
> ++++ b/drivers/net/wireless/brcm80211/brcmfmac/fweh.h
> +@@ -158,7 +158,7 @@ typedef int (*brcmf_fweh_handler_t)(stru
> +  */
> + struct brcmf_fweh_info {
> +       struct work_struct event_work;
> +-      struct spinlock evt_q_lock;
> ++      spinlock_t evt_q_lock;
> +       struct list_head event_q;
> +       int (*evt_handler[BRCMF_E_LAST])(struct brcmf_if *ifp,
> +                                        const struct brcmf_event_msg *evtmsg,

This should have still worked, I thought for a second based on your
backport patch we ditched the spinlock_t or perhaps this was related
to the realtime work Thomas has been doing but upon further inspection
I see now this is simply a discrepancy on sloppy driver development.

IMHO your patch should go upstream and a respective patch should be
submitted as well as for these drivers:

mcgrof@frijol ~/linux-next (git::master)$ git grep "struct spinlock" drivers/
drivers/crypto/ux500/cryp/cryp.h:       struct spinlock ctx_lock;
drivers/crypto/ux500/cryp/cryp.h:       struct spinlock power_state_spinlock;
drivers/crypto/ux500/hash/hash_alg.h:   struct spinlock         ctx_lock;
drivers/crypto/ux500/hash/hash_alg.h:   struct spinlock
power_state_lock;
drivers/gpu/drm/i915/i915_drv.h:        struct spinlock gt_lock;
drivers/gpu/drm/i915/i915_drv.h:                struct spinlock lock;
drivers/media/platform/s5p-fimc/mipi-csis.c:    struct spinlock slock;
drivers/media/platform/s5p-jpeg/jpeg-core.h:    struct spinlock         slock;
drivers/watchdog/ie6xx_wdt.c:   struct spinlock unlock_sequence;

Alexander, please also add your driver to the MAINTAINERS file.

  Luis
