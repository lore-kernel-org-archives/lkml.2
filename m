Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755619Ab0LNVqm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:46:42 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:44507 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302Ab0LNVqk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:46:40 -0500
MIME-Version: 1.0
In-Reply-To: <20101214191500.GD19951@mcarlson.broadcom.com>
References: <1291536233.2806.102.camel@edumazet-laptop>
	<20101205105528.49fa9a9f@xenia.leun.net>
	<20101205114404.7c0cddc2@xenia.leun.net>
	<AANLkTikrDTCDxsyOG4m0XcrOY=3pTRwWqnPGsio9cBFj@mail.gmail.com>
	<20101206203437.54b550e0@xenia.leun.net>
	<AANLkTikKkAesHc4Fi4SwAkV0e65D0TQRztrRYoDNu3MP@mail.gmail.com>
	<20101206222703.32fbe852@xenia.leun.net>
	<AANLkTinLMCzKz7n45HdeAwNxsWjCADAkgfK+MjXVcFqh@mail.gmail.com>
	<20101213224510.GB17400@mcarlson.broadcom.com>
	<AANLkTi=9BYt=vkNkAiTBxnfnCjCX7AqCG=ML6coc4vdZ@mail.gmail.com>
	<20101214191500.GD19951@mcarlson.broadcom.com>
Date: Tue, 14 Dec 2010 13:46:39 -0800
Message-ID: <AANLkTiktJXEyofbaoOvSJEtqk5bL5VbzP7fbbFHZkru+@mail.gmail.com>
Subject: Re: [PATCH 2.6.36] vlan: Avoid hwaccel vlan packets when vid not used
From: Jesse Gross <jesse@nicira.com>
To: Matt Carlson <mcarlson@broadcom.com>
Cc: Michael Leun <lkml20101129@newton.leun.net>,
        Michael Chan <mchan@broadcom.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        David Miller <davem@davemloft.net>,
        Ben Greear <greearb@candelatech.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 11:15 AM, Matt Carlson <mcarlson@broadcom.com> wrote:
> @@ -9538,17 +9505,8 @@ static void __tg3_set_rx_mode(struct net_device *dev)
>        /* When ASF is in use, we always keep the RX_MODE_KEEP_VLAN_TAG
>         * flag clear.
>         */
> -#if TG3_VLAN_TAG_USED
> -       if (!tp->vlgrp &&
> -           !(tp->tg3_flags & TG3_FLAG_ENABLE_ASF))
> -               rx_mode |= RX_MODE_KEEP_VLAN_TAG;
> -#else
> -       /* By definition, VLAN is disabled always in this
> -        * case.
> -        */
>        if (!(tp->tg3_flags & TG3_FLAG_ENABLE_ASF))
>                rx_mode |= RX_MODE_KEEP_VLAN_TAG;
> -#endif

Just one comment:

I don't think this does quite the right thing: it will always disable
vlan stripping unless ASF is in use.  However, it's now OK to always
use vlan stripping, so we might as well take advantage of it.  Since
without the set_flags Ethtool op there is no way to change this
setting, we should be able to just drop this code block completely
(and the check for  RX_MODE_KEEP_VLAN_TAG on receive).

In addition, this should also remove any differences between ASF
enabled/disabled firmware (at least with respect to vlans) since it
will no longer be a factor.

Thanks.
