Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751079Ab1KBTqV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 15:46:21 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:55084 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891Ab1KBTqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 15:46:19 -0400
Date: Wed, 2 Nov 2011 19:45:55 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Brown <davidb@codeaurora.org>
Cc: Daniel Walker <dwalker@fifo99.com>, Bryan Huntsman <bryanh@codeaurora.org>,
        linux-arm-msm@vger.kernel.org, Stephen Boyd <sboyd@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 02/34] msm: clock: Always use an array to iterate
	over clocks
Message-ID: <20111102194555.GE12913@n2100.arm.linux.org.uk>
References: <1320258991-22325-1-git-send-email-davidb@codeaurora.org> <1320258991-22325-3-git-send-email-davidb@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320258991-22325-3-git-send-email-davidb@codeaurora.org>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 11:35:59AM -0700, David Brown wrote:
> If the array of clk_lookups contains aliases for the same struct
> clk, msm_clock_init() will add the clock to the clocks list
> twice.  This would cause list corruption so let's just remove the
> clocks list and any associated code and iterate over the array
> instead.

Hmm...

> @@ -158,13 +152,13 @@ void __init msm_clock_init(struct clk_lookup *clock_tbl, unsigned num_clocks)
>   */
>  static int __init clock_late_init(void)
>  {
> +	unsigned i, count = 0;
>  	unsigned long flags;
> -	struct clk *clk;
> -	unsigned count = 0;
>  
>  	clock_debug_init();
> -	mutex_lock(&clocks_mutex);
> -	list_for_each_entry(clk, &clocks, list) {
> +	for (i = 0; i < msm_num_clocks; i++) {
> +		struct clk *clk = msm_clocks[i].clk;
> +
>  		clock_debug_add(clk);

This means you'll end up calling clock_debug_add() twice for the same
struct clk - this sounds like a bad idea in itself.  It looks like
there's no protection within that function against it being called
twice with the same struct clk.

Are you sure this is safe?
