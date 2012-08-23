Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab2HWXBW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 19:01:22 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38694 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750934Ab2HWXBS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 19:01:18 -0400
Message-ID: <5036B639.20608@gmail.com>
Date: Fri, 24 Aug 2012 01:01:13 +0200
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        Lior Amsalem <alior@marvell.com>, Andrew Lunn <andrew@lunn.ch>,
        Gregory CLEMENT <gregory.clement@free-electrons.com>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/9] pinctrl: mvebu: pinctrl driver core
References: <1344689809-6223-1-git-send-email-sebastian.hesselbarth@gmail.com> <1345623750-10645-1-git-send-email-sebastian.hesselbarth@gmail.com> <1345623750-10645-2-git-send-email-sebastian.hesselbarth@gmail.com> <5035445B.6000500@wwwdotorg.org> <CABJ1b_Tdr80DGqb-FRzwDbF3m7g6fBguk5GtRAfRUYx5Sqy_cA@mail.gmail.com> <50366E44.4030606@wwwdotorg.org> <50369305.6050304@gmail.com> <50369FEE.8000003@wwwdotorg.org>
In-Reply-To: <50369FEE.8000003@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/23/2012 11:26 PM, Stephen Warren wrote:
> As you may have guessed, I strongly prefer the hard-coded static table
> based approach, or at least separating the definition of known
> pins/groups/functions from the configuration nodes that define which
> particular mux settings to actually use.
>
> Puting this all a little more simply, the pinctrl core wants to generate
> a list of all known functions. It is a single global/unified list. It
> first calls pinmux_ops.get_functions_count() to find out how many
> functions there are in the list, then pinmux_ops.get_function_name() for
> each one to find its name, then pinmux_ops.get_function_groups() to find
> out which groups allow that function to be mux'd onto them.

Ok, now this becomes a little bit more clear to me.

Consider uart1 on dove is muxable to:
mpp2 uart1(rts), mpp3 uart1(cts), mpp21 uart1(rts), mpp22 uart1(cts),
and finally mpp_uart1(rx and tx).

So possible, valid combinations for uart1 would be:
(a) mpp_uart1;
(b) mpp_uart1, mpp2, mpp3;
(c) mpp_uart1, mpp21, mpp22;
(d) mpp_uart1, mpp2, mpp22;
(e) mpp_uart1, mpp21, mpp3;

Now what we currently do is, use DT to setup all known functions with e.g.
marvell,pins = "mpp_uart1", "mpp2", "mpp22" and marvell,function = "uart1".
This requires to count all pinctrl DT node children to count the known
functions that can ever be muxed to. It will never allow to mux uart1 to sw
flow control during run-time when there was no DT child node for it.

But you are proposing to scan the list passed from SoC specific driver for all
possible marvell,function ("uart1", "uart2", "sdio0", ...) and build up lists
of pingroups that can be used with this specific marvell,function; or even build
up lists of pingroups that allow uart1(rts), and another one for uart1(cts), ...?

Sebastian
