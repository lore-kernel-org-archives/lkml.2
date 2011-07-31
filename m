Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab1GaATP (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 20:19:15 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43608 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751715Ab1GaATM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 20:19:12 -0400
MIME-Version: 1.0
In-Reply-To: <9c81beb9cd84f84b58abbd24ebfae85dfe8d8ee1.1311936524.git.viresh.kumar@st.com>
References: <cover.1311936523.git.viresh.kumar@st.com>
	<9c81beb9cd84f84b58abbd24ebfae85dfe8d8ee1.1311936524.git.viresh.kumar@st.com>
Date: Sun, 31 Jul 2011 02:19:11 +0200
X-Google-Sender-Auth: iu2UJmfqdhLqyvtjZS71xf9GprY
Message-ID: <CAKnu2Mp0Xs3ivj0Vd1=Euj1CyKsWpBLrf_L_jYWuOnoRMpxGGQ@mail.gmail.com>
Subject: Re: [PATCH 09/18] dmaengine/amba-pl08x: Schedule tasklet in case of
 error interrupt
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@st.com>
Cc: vinod.koul@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux@arm.linux.org.uk, armando.visconti@st.com, shiraz.hashim@st.com,
        vipin.kumar@st.com, rajeev-dlh.kumar@st.com, deepak.sikri@st.com,
        vipulkumar.samar@st.com, amit.virdi@st.com, pratyush.anand@st.com,
        bhupesh.sharma@st.com, viresh.linux@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/7/29 Viresh Kumar <viresh.kumar@st.com>:

(...)
> -       u32 mask = 0;
(...)
> +       if (!err && !tc)
> +               return IRQ_NONE;
(...)
> -
> -                       mask |= (1 << i);
> -       /* Clear only the terminal interrupts on channels we processed */
> -       writel(mask, pl08x->base + PL080_TC_CLEAR);
>
> -       return mask ? IRQ_HANDLED : IRQ_NONE;
> +       return IRQ_HANDLED;

NAK.

These snippets illustrate what is not good about this patch, you're making
the driver fragile by removing checks for spurious IRQ.

So for example if there is an error or TC IRQ on a channel that is not
in use, what happens now?

It used to result in IRQ_NONE, now all of a sudden we start handling
spurious IRQs and claim IRQ_HANDLED with totally unpredictable
results, whereas they would previously gather error metrics for
spurious IRQs.

Yours,
Linus Walleij
