Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754819Ab1LMNsB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 08:48:01 -0500
Received: from smtp2-g21.free.fr ([212.27.42.2]:60300 "EHLO smtp2-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753692Ab1LMNsA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 08:48:00 -0500
Message-ID: <4EE75787.3020101@eukrea.com>
Date: Tue, 13 Dec 2011 14:47:51 +0100
From: =?ISO-8859-15?Q?Eric_B=E9nard?= <eric@eukrea.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: Russell King <linux@arm.linux.org.uk>, Jason Liu <jason.hui@linaro.org>,
        Sascha Hauer <kernel@pengutronix.de>,
        linux-arm-kernel@lists.infradead.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 09/19] clock-imx35: fix reboot in internal boot modeg
References: <1323757911-25217-1-git-send-email-eric@eukrea.com> <1323757911-25217-9-git-send-email-eric@eukrea.com> <20111213100041.GG27267@pengutronix.de>
In-Reply-To: <20111213100041.GG27267@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 13/12/2011 11:00, Sascha Hauer a écrit :
> On Tue, Dec 13, 2011 at 07:31:41AM +0100, Eric Bénard wrote:
>> commit 8d75a2620dc3e33ce504044c375c443ed7ed4128 disable IIM
>> clock after reading silicon revision which will prevent
>> reboot in internal boot mode (see comment a few line before)
>
> I'm a bit unsure. The fix you suggest is the least intrusive, but
> a proper fix would be to move the mentioned block below the
> imx_print_silicon_rev, like this:
>
> 	clk_enable(&iim_clk);
> 	imx_print_silicon_rev("i.MX35", mx35_revision());
> 	clk_disable(&iim_clk);
>
> 	/*
> 	 * Check if we came up in internal boot mode. If yes, we need
> 	 * some
> 	 * extra clocks turned on, otherwise the MX35 boot ROM code will
> 	 * hang after a watchdog reset.
> 	 */
> 	if (!(__raw_readl(CCM_BASE + CCM_RCSR)&  (3<<  10))) {
> 		clk_enable(&iim_clk);
> 		clk_enable(&uart1_clk);
> 		clk_enable(&scc_clk);
> 	}
>
> This would also get the clk enable counters right.
>
OK that's cleaner.
While fixing the patch it seems comment & code are not synced as scc_clk is 
0x3 << 2 and the code was setting 0x3 << 4 which corresponds to sdma_clk (and 
in my configuration, reboot works without any of these clocks forced). I chose 
to have code synced with comment for v2 of the patch.

Eric
