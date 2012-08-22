Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab2HVJi7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 05:38:59 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:21219 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346Ab2HVJiz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 05:38:55 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-3e-5034a8ae13ac
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Mandeep Singh Baines'" <msb@chromium.org>, linux-kernel@vger.kernel.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Minho Ban'" <mhban@samsung.com>,
        "'Jaecheol Lee'" <jc.lee@samsung.com>,
        "'Sunyoung Kang'" <sy0816.kang@samsung.com>,
        "'Olof Johansson'" <olofj@chromium.org>
References: <1345058187-18843-1-git-send-email-msb@chromium.org>
In-reply-to: <1345058187-18843-1-git-send-email-msb@chromium.org>
Subject: RE: [PATCH] ARM: SAMSUNG: use spin_lock_irqsave() in clk_set_parent
Date: Wed, 22 Aug 2012 18:38:54 +0900
Message-id: <1b3701cd8049$f20e16f0$d62a44d0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac17Gn7HZBq8tQDmRsWyplWDBb6gVgFGjQMg
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrILMWRmVeSWpSXmKPExsVy+t9jQd11K0wCDF53GFhc3jWHzWLG+X1M
	DkwenzfJBTBGcdmkpOZklqUW6dslcGXMnD6LpeCMcsXziQoNjC/kuhg5OSQETCR+n1vEDGGL
	SVy4t56ti5GLQ0hgOqNE+7rVrBDOX0aJzX0XGUGq2AQ0JA6/f8YOYosIeEs0bPvPDlLELLCd
	SeL799dMIAkhAQeJj+0fwIo4BRwlZr19DWYLC/hInF52kQ3EZhFQlVjY3M8KYvMK2Erc3nWS
	CcIWlPgx+R4LiM0soCWxfudxJghbXmLzmrdAp3IAnaou8eivLogpImAksW2CHUSFiMS+F+8Y
	JzAKzUIyaBaSQbOQDJqFpGUBI8sqRtHUguSC4qT0XEO94sTc4tK8dL3k/NxNjOCAfia1g3Fl
	g8UhRgEORiUeXo8EkwAh1sSy4srcQ4wSHMxKIrzXa4FCvCmJlVWpRfnxRaU5qcWHGKU5WJTE
	efn7DAOEBNITS1KzU1MLUotgskwcnFINjJ5VfS8ld54+m53g/33FzbCpzw6Fl/fZL09KmDPp
	4+t59U9/5idZn9JgfSLvofbnz1v22zqtli+vbN74p1bHxyu2+07AjQXvSvNOvvv6913atUnf
	ZWZctHJ/elZAX3Vihbl/2OJLe8riZ8fu/htycbLxW8tY3qh3FybqzuvPtrWc+cJ3t/u0d3FK
	LMUZiYZazEXFiQD9hESNZAIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mandeep Singh Baines wrote:
> 
> From 0cdf3aff, "ARM: SAMSUNG: use spin_lock_irqsave() in
> clk_{enable,disable}":
> 
>   The clk_enable()and clk_disable() can be used process and ISR either.
>   And actually it is used for real product and other platforms use it
>   now. So spin_lock_irqsave() should be used instead.
> 
> We need to make a similar change in clk_set_parent(). Otherwise,
> you can potentially get spinlock recursion:
> 
> BUG: spinlock recursion on CPU#0, kinteractive/68
>  lock: 807832a8, .magic: dead4ead, .owner: kinteractive/68, .owner_cpu: 0
> [<80015f54>] (unwind_backtrace+0x0/0x128) from [<804f2914>]
> (dump_stack+0x20/0x24)
> [<804f2914>] (dump_stack+0x20/0x24) from [<804f57b8>]
(spin_dump+0x80/0x94)
> [<804f57b8>] (spin_dump+0x80/0x94) from [<804f57f8>] (spin_bug+0x2c/0x30)
> [<804f57f8>] (spin_bug+0x2c/0x30) from [<80222730>]
> (do_raw_spin_lock+0x54/0x150)
> [<80222730>] (do_raw_spin_lock+0x54/0x150) from [<804f96ec>]
> (_raw_spin_lock_irqsave+0x20/0x28)
> [<804f96ec>] (_raw_spin_lock_irqsave+0x20/0x28) from [<80022ea4>]
> (clk_enable+0x3c/0x84)
> [<80022ea4>] (clk_enable+0x3c/0x84) from [<8038336c>]
> (s5p_mfc_clock_on+0x60/0x74)
> [<8038336c>] (s5p_mfc_clock_on+0x60/0x74) from [<8038645c>]
> (s5p_mfc_read_info+0x20/0x38)
> [<8038645c>] (s5p_mfc_read_info+0x20/0x38) from [<8037ca3c>]
> (s5p_mfc_handle_frame+0x2e4/0x4bc)
> [<8037ca3c>] (s5p_mfc_handle_frame+0x2e4/0x4bc) from [<8037d420>]
> (s5p_mfc_irq+0x1ec/0x6cc)
> [<8037d420>] (s5p_mfc_irq+0x1ec/0x6cc) from [<8007fc74>]
> (handle_irq_event_percpu+0x8c/0x244)
> [<8007fc74>] (handle_irq_event_percpu+0x8c/0x244) from [<8007fe78>]
> (handle_irq_event+0x4c/0x6c)
> [<8007fe78>] (handle_irq_event+0x4c/0x6c) from [<80082dd8>]
> (handle_fasteoi_irq+0xe4/0x150)
> [<80082dd8>] (handle_fasteoi_irq+0xe4/0x150) from [<8007f424>]
> (generic_handle_irq+0x3c/0x50)
> [<8007f424>] (generic_handle_irq+0x3c/0x50) from [<8000f7c4>]
> (handle_IRQ+0x88/0xc8)
> [<8000f7c4>] (handle_IRQ+0x88/0xc8) from [<80008564>]
> (gic_handle_irq+0x44/0x68)
> [<80008564>] (gic_handle_irq+0x44/0x68) from [<8000e400>]
> (__irq_svc+0x40/0x60)
> Exception stack(0xef3cbe68 to 0xef3cbeb0)
> [<8000e400>] (__irq_svc+0x40/0x60) from [<80022cfc>]
> (clk_set_parent+0x30/0x74)
> [<80022cfc>] (clk_set_parent+0x30/0x74) from [<803ac7f8>]
> (set_apll.isra.0+0x28/0xb0)
> [<803ac7f8>] (set_apll.isra.0+0x28/0xb0) from [<803ac8e4>]
> (exynos5250_set_frequency+0x64/0xb8)
> [<803ac8e4>] (exynos5250_set_frequency+0x64/0xb8) from [<803ac280>]
> (exynos_target+0x1b0/0x220)
> [<803ac280>] (exynos_target+0x1b0/0x220) from [<803a4a0c>]
> (__cpufreq_driver_target+0xb0/0xd4)
> [<803a4a0c>] (__cpufreq_driver_target+0xb0/0xd4) from [<803aab80>]
> (cpufreq_interactive_updown_task+0x214/0x264)
> [<803aab80>] (cpufreq_interactive_updown_task+0x214/0x264) from
> [<80047d04>] (kthread+0x9c/0xa8)
> [<80047d04>] (kthread+0x9c/0xa8) from [<8000fa48>]
> (kernel_thread_exit+0x0/0x8)
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>
> Suggested-by: Sunil Mazhavanchery <sunilm@samsung.com>
> CC: linux-arm-kernel@lists.infradead.org
> CC: linux-samsung-soc@vger.kernel.org
> CC: Ben Dooks <ben-linux@fluff.org>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> CC: Russell King <linux@arm.linux.org.uk>
> CC: Minho Ban <mhban@samsung.com>
> CC: Jaecheol Lee <jc.lee@samsung.com>
> CC: Sunyoung Kang <sy0816.kang@samsung.com>
> CC: Kukjin Kim <kgene.kim@samsung.com>
> CC: Olof Johansson <olofj@chromium.org>
> ---
>  arch/arm/plat-samsung/clock.c |    5 +++--
>  1 files changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/clock.c b/arch/arm/plat-samsung/clock.c
> index 65c5eca..80eacca 100644
> --- a/arch/arm/plat-samsung/clock.c
> +++ b/arch/arm/plat-samsung/clock.c
> @@ -173,17 +173,18 @@ struct clk *clk_get_parent(struct clk *clk)
> 
>  int clk_set_parent(struct clk *clk, struct clk *parent)
>  {
> +	unsigned long flags;
>  	int ret = 0;
> 
>  	if (IS_ERR(clk))
>  		return -EINVAL;
> 
> -	spin_lock(&clocks_lock);
> +	spin_lock_irqsave(&clocks_lock, flags);
> 
>  	if (clk->ops && clk->ops->set_parent)
>  		ret = (clk->ops->set_parent)(clk, parent);
> 
> -	spin_unlock(&clocks_lock);
> +	spin_unlock_irqrestore(&clocks_lock, flags);
> 
>  	return ret;
>  }
> --
> 1.7.7.3

Yup, right. Applied.

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

