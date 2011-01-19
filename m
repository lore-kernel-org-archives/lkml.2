Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214Ab1ASQPe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 11:15:34 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61441 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753245Ab1ASQPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 11:15:32 -0500
MIME-Version: 1.0
In-Reply-To: <20110114183816.GB1288@mcarlson.broadcom.com>
References: <20101215081606.18e12fc9@xenia.leun.net>
	<AANLkTi=hGRW+DwoKQzxPAZao6-y_tvn6nNXS-tj_-Y6T@mail.gmail.com>
	<20110107032459.GA17959@mcarlson.broadcom.com>
	<AANLkTi=N6jFE7T1=W-WLo_eHYWeE=oB6n8C8zPGoBNQF@mail.gmail.com>
	<20110113012157.GA28147@mcarlson.broadcom.com>
	<AANLkTimz3Mw5itChtTgHTeGT4seJauy3+FVrpEJn1iez@mail.gmail.com>
	<20110113205056.GA29254@mcarlson.broadcom.com>
	<AANLkTimQ1T0erugwK17o0zuSwxVh-Ro4yCsBpOqCykyr@mail.gmail.com>
	<20110114011533.GA29723@mcarlson.broadcom.com>
	<AANLkTi=Z4mtV5SUqORivPKPxEGddsmQQ2sVdkeOAogeY@mail.gmail.com>
	<20110114183816.GB1288@mcarlson.broadcom.com>
Date: Wed, 19 Jan 2011 08:15:31 -0800
Message-ID: <AANLkTink=6oLA5zkmjrOvFk9Ze3i=m8_T-dQio_y2uvQ@mail.gmail.com>
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

On Fri, Jan 14, 2011 at 10:38 AM, Matt Carlson <mcarlson@broadcom.com> wrote:
>> >> > In the meantime, I think what we have should go upstream. ?Just to be
>> >> > absolutely clear though, your position is that VLAN tags should always
>> >> > be stripped?
>> >>
>> >> That's what the other converted drivers do by default (though most of
>> >> them also provide an ethtool set_flags() method to change this). ?It's
>> >> generally the most efficient and is now safe to do in all cases. ?It's
>> >> also the consistent with what was happening before, since stripping
>> >> was enabled when a vlan device was configured. ?So, yes, normally I
>> >> think stripping should be enabled.
>> >>
>> >> I assumed that disabling stripping in most situations was just an
>> >> oversight. ?Was there a reason why you feel it is better not to use
>> >> it?
>> >
>> > Actually, the tg3 driver was trying to disable VLAN tag stripping
>> > when possible. ?I believe this was primarily to support the raw packet
>> > interface.
>>
>> Hmm, is this really true?
>>
>>         if (!tp->vlgrp &&
>>             !(tp->tg3_flags & TG3_FLAG_ENABLE_ASF))
>>                 rx_mode |= RX_MODE_KEEP_VLAN_TAG;
>>
>> So if a vlan device is registered or ASF is enabled we will use
>> stripping.  That seems like it is using stripping in the common case
>> when vlans are used.
>
> Right.
>
>> Before 2.6.37 it was only possible to deliver stripped tags if a vlan
>> group was configured.  This means that if ASF was enabled and forced
>> stripping but no group was configured we would lose the tag.  In this
>> situation tg3 manually reinserts the tags so raw packet capture will
>> see them, as you say.
>
> Right.  VLAN tagged frames can still arrive if CONFIG_VLAN_8021Q or
> CONFIG_VLAN_8021Q_MODULE is not set.  That's why the driver was trying
> to keep them inline.  To eliminate the unnecessary overhead of
> reinjecting the VLAN tag.

OK, I understand now why you are saying that the driver was trying to
keep stripping disabled.  I was thinking about having vlan groups
configured as the common case for receiving vlans and therefore the
case to optimize.

>
>> However, in the current tree this limitation no
>> longer exists and it is always possible to deliver stripped tags to
>> the networking core, which should do the right thing in all
>> situations.
>
> Yes.  Even though the stack is capable of reinjecting the VLAN tag,
> doesn't it make sense to avoid that if we knew they would never be
> needed out-of-packet?

Maybe in theory but a relatively small optimization to the raw packet
interface doesn't seem terribly important to me.  After all of the
drivers have been converted to the new vlan interfaces I'll be
removing the ndo_vlan_rx_register() function from net_device_ops, so
the driver won't actually know how the vlan tag will be used.  The
impetus for this is that there were quite a few bugs and inconsistent
behavior in drivers around stripping logic.  Therefore, by moving all
of this into the networking core we can reduce code and get consistent
behavior, which is more important than a corner case optimization.
