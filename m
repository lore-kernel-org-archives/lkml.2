Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0H3I4h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 04:56:37 -0400
Received: from mga02.intel.com ([134.134.136.20]:29319 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab0H3I4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 04:56:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,291,1280732400"; 
   d="scan'208";a="652533393"
Subject: What reassert_nmi() in default_do_nmi() is for?
From: Huang Ying <ying.huang@intel.com>
To: Ingo Molnar <mingo@elte.hu>, hpa@zytor.com,
        Andi Kleen <andi@firstfloor.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 30 Aug 2010 16:56:34 +0800
Message-ID: <1283158594.3397.68.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, All,

When reading NMI handler code, I find there is reassert_nmi() in the end
of default_do_nmi(). And it is only called if the reason & 0xc0 != 0
(reason = inb(0x61)).

The comments for it is as follow:

	/*
	 * Reassert NMI in case it became active meanwhile
	 * as it's edge-triggered:
	 */
	reassert_nmi();

The implementation of reassert_nmi is as follow:

static inline void reassert_nmi(void)
{
        int old_reg = -1;

        if (do_i_have_lock_cmos())
                old_reg = current_lock_cmos_reg();
        else
                lock_cmos(0); /* register doesn't matter here */
        outb(0x8f, 0x70);
        inb(0x71);              /* dummy */
        outb(0x0f, 0x70);
        inb(0x71);              /* dummy */
        if (old_reg >= 0)
                outb(old_reg, 0x70);
        else
                unlock_cmos();
}

I can not understand the code and the logic. Can anyone explain it in
more detail?

Thanks,
Huang Ying


