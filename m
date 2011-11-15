Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932163Ab1KOTbL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:31:11 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38881 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757248Ab1KOTbJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:31:09 -0500
MIME-Version: 1.0
In-Reply-To: <20111114171039.34a04369@nehalam.linuxnetplumber.net>
References: <cover.1321313729.git.david.decotigny@google.com>
 <e2dd16618bc1bd5108e6dea3c7531ee229e4c699.1321313729.git.david.decotigny@google.com>
 <20111114171039.34a04369@nehalam.linuxnetplumber.net>
From: David Decotigny <david.decotigny@google.com>
Date: Tue, 15 Nov 2011 11:30:33 -0800
Message-ID: <CAG88wWa2S3iQbk0t8rat39aPX0XXVfMG5ub2496gchoqgFBPhA@mail.gmail.com>
Subject: Re: [PATCH net-next v3 5/9] forcedeth: implement ndo_get_stats64() API
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Ben Hutchings <bhutchings@solarflare.com>,
        Jiri Pirko <jpirko@redhat.com>, Joe Perches <joe@perches.com>,
        Szymon Janc <szymon@janc.net.pl>, Richard Jones <rick.jones2@hp.com>,
        Ayaz Abdulla <AAbdulla@nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Mon, Nov 14, 2011 at 5:10 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> Please existing u64_stats_sync rather than inventing your own
> method. The u64_stats_sync is faster and does require locking.

Thanks for your review.
This should be fixed in the v4 series I just sent:
http://patchwork.ozlabs.org/patch/125861/

Regards,

--
David Decotigny



On Mon, Nov 14, 2011 at 5:10 PM, Stephen Hemminger
<shemminger@vyatta.com> wrote:
> On Mon, 14 Nov 2011 16:11:15 -0800
> David Decotigny <david.decotigny@google.com> wrote:
>
>> This commit implements the ndo_get_stats64() API for forcedeth. Since
>> these stats are being updated from different contexts (process and
>> timer), this commit adds protection (locking + atomic variables).
>>
>> Tested:
>>   - 16-way SMP x86_64 ->
>>     RX bytes:7244556582 (7.2 GB)  TX bytes:181904254 (181.9 MB)
>>   - pktgen + loopback: identical rx_bytes/tx_bytes and rx_packets/tx_packets
>>
>>
>>
>> Signed-off-by: David Decotigny <david.decotigny@google.com>
>> ---
>>  drivers/net/ethernet/nvidia/forcedeth.c |  182 ++++++++++++++++++++++++-------
>>  1 files changed, 141 insertions(+), 41 deletions(-)
>>
>> diff --git a/drivers/net/ethernet/nvidia/forcedeth.c b/drivers/net/ethernet/nvidia/forcedeth.c
>> index ee8cce5..a67c1f4 100644
>> --- a/drivers/net/ethernet/nvidia/forcedeth.c
>> +++ b/drivers/net/ethernet/nvidia/forcedeth.c
>> @@ -692,6 +692,21 @@ struct nv_ethtool_stats {
>>  #define NV_DEV_STATISTICS_V2_COUNT (NV_DEV_STATISTICS_V3_COUNT - 3)
>>  #define NV_DEV_STATISTICS_V1_COUNT (NV_DEV_STATISTICS_V2_COUNT - 6)
>>
>> +/* driver statistics */
>> +struct nv_driver_stat {
>> +     atomic_t delta;  /* increase since last nv_update_stats() */
>> +     u64 total;  /* cumulative, requires netdev_priv(dev)->stats_lock */
>> +};
>
> Please existing u64_stats_sync rather than inventing your own
> method. The u64_stats_sync is faster and does require locking.
>
