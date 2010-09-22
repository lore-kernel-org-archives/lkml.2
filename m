Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab0IVVzL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:55:11 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34821 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752611Ab0IVVzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:55:09 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6114"; a="55266129"
Subject: Re: [PATCH 0/3] Fixing udelay() on SMP (and non-SMP too)
From: Daniel Walker <dwalker@codeaurora.org>
To: Russell King <linux@arm.linux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org,
        Kevin Hilman <khilman@deeprootsystems.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Saravana Kannan <skannan@codeaurora.org>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Colin Cross <ccross@android.com>, Stephen Boyd <sboyd@codeaurora.org>
In-Reply-To: <1283883834-4693-1-git-send-email-sboyd@codeaurora.org>
References: <1283883834-4693-1-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Sep 2010 14:54:47 -0700
Message-ID: <1285192487.14807.58.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Russell

Is this series something you would be willing to pull into your tree?

Daniel

On Tue, 2010-09-07 at 11:23 -0700, Stephen Boyd wrote:
> (Sorry, resending due to stray comma...)
> 
> These patches are another attempt at fixing the udelay()
> issue pointed out on arm-lkml[1][2]. A quick recap: some SMP
> machines can scale their CPU frequencies independent of one
> another. loops_per_jiffy is calibrated globally and used in
> __const_udelay(). If one CPU is running faster than what the
> loops_per_jiffy is calculated (or scaled) for, udelay() will
> be incorrect and not wait long enough (or too long). A similar
> problem occurs if the cpu frequency is scaled during a udelay()
> call.
> 
> We could fix this issue a couple ways, wholesale replacement
> of __udelay() and __const_udelay() (see [2] for that approach),
> or replacement of __delay() (this series). Option 1 can fail if
> anybody uses udelay() before memory is mapped and also duplicates
> most of the code in asm/delay.h. It also needs to hardcode the
> timer tick frequency, which can sometimes be inaccurate. The
> benefit is that loops_per_jiffy stays the same and thus BogoMIPS
> is unchanged.  Option 2 can't fail since the __delay() loop is
> replaced after memory is mapped in, but it suffers from a low
> BogoMIPS when timers are clocked slowly. It also more accurately
> calculates the timer tick frequency through the use of
> calibrate_delay_direct().
> 
> -- Reference --
> [1] http://article.gmane.org/gmane.linux.kernel/977567
> [2] http://article.gmane.org/gmane.linux.ports.arm.kernel/78496 
> 
> Stephen Boyd (3):
>   [ARM] Translate delay.S into (mostly) C
>   [ARM] Allow machines to override __delay()
>   [ARM] Implement a timer based __delay() loop
> 
>  arch/arm/include/asm/delay.h |    5 ++-
>  arch/arm/kernel/armksyms.c   |    4 --
>  arch/arm/lib/delay.S         |   65 ------------------------------
>  arch/arm/lib/delay.c         |   90 ++++++++++++++++++++++++++++++++++++++++++
>  4 files changed, 94 insertions(+), 70 deletions(-)
>  delete mode 100644 arch/arm/lib/delay.S
>  create mode 100644 arch/arm/lib/delay.c
> 

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

