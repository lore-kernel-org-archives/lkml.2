Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753715Ab1KPUqg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 15:46:36 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:47831 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752378Ab1KPUqf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 15:46:35 -0500
MIME-Version: 1.0
In-Reply-To: <1321475553.3274.3.camel@edumazet-laptop>
References: <cover.1321420513.git.david.decotigny@google.com>
 <dcc1ec263220b7bb1f7271933c30a8f89c19d991.1321420513.git.david.decotigny@google.com>
 <20111116085533.0982001e@s6510.linuxnetplumber.net> <1321463694.2709.1.camel@bwh-desktop>
 <CAG88wWa7UsPSfX_NdNDkQeuWN0LYYDVckShgDj9GvMq2mtrpbQ@mail.gmail.com>
 <1321471967.2709.14.camel@bwh-desktop> <1321475553.3274.3.camel@edumazet-laptop>
From: David Decotigny <david.decotigny@google.com>
Date: Wed, 16 Nov 2011 12:46:13 -0800
Message-ID: <CAG88wWYSriipeb41nKnoPTLLhLm9=GDf1EqS6gWxXchkqSPbwA@mail.gmail.com>
Subject: Re: [PATCH net-next v5 07/10] forcedeth: implement ndo_get_stats64() API
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Stephen Hemminger <shemminger@vyatta.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks to you all!

I have an implementation that's similar to sky2's. I will run the
usual set of tests and send the updated patch series here.

Regards,

--
David Decotigny



On Wed, Nov 16, 2011 at 12:32 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mercredi 16 novembre 2011 à 19:32 +0000, Ben Hutchings a écrit :
>> On Wed, 2011-11-16 at 11:25 -0800, David Decotigny wrote:
>> > Thanks for your feedback on these concerns.
>> >
>> > On Wed, Nov 16, 2011 at 9:14 AM, Ben Hutchings
>> > <bhutchings@solarflare.com> wrote:
>> > > On Wed, 2011-11-16 at 08:55 -0800, Stephen Hemminger wrote:
>> > >> Or realize that the Tx side is single threaded by dev->xmit_lock already
>> > >> and the Rx side is single threaded by NAPI.
>> > >
>> > > Right.
>> >
>> > Yes, that's what I meant by "Each software stat field is updated by
>> > one single writer." in a previous email. However, I think that TX and
>> > RX paths are not always synchronized. So I'm afraid that if I'm using
>> > a single seqcount, I might run into trouble in the absence of a lock
>> > around each update.... and I'd really prefer to avoid such a lock. Are
>> > you suggesting I should use 2 independent seqcounts? One for RX path,
>> > the other for TX path, all this without a lock around writers?
>>
>> Yes, there should be 1 for each path.
>
> David, drivers/net/ethernet/marvell/sky2.c contains code like that
> (different syncpfor rx/tx)
>
> TX path:
>                        u64_stats_update_begin(&sky2->tx_stats.syncp);
>                        ++sky2->tx_stats.packets;
>                        sky2->tx_stats.bytes += skb->len;
>                        u64_stats_update_end(&sky2->tx_stats.syncp);
>
>
> RX path:
>
>        u64_stats_update_begin(&sky2->rx_stats.syncp);
>        sky2->rx_stats.packets += packets;
>        sky2->rx_stats.bytes += bytes;
>        u64_stats_update_end(&sky2->rx_stats.syncp);
>
>
>
