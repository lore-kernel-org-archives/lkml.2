Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab2CLGxA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 02:53:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:62391 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753743Ab2CLGwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 02:52:53 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6646"; a="171568513"
X-IronPort-AV: E=Sophos;i="4.73,569,1325491200"; 
   d="scan'208";a="282137891"
Message-ID: <4F5D9D3D.6090206@qca.qualcomm.com>
Date: Mon, 12 Mar 2012 12:22:45 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Willy Tarreau <w@1wt.eu>
CC: Ben Hutchings <ben@decadent.org.uk>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, Pavel Roskin <proski@gnu.org>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: [ 08/12] mac80211: zero initialize count field in ieee80211_tx_rate
References: <20120312002046.282831520@1wt.eu> <1331517472.3022.150.camel@deadeye> <4F5D7D47.102@qca.qualcomm.com> <20120312063412.GD8971@1wt.eu>
In-Reply-To: <20120312063412.GD8971@1wt.eu>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.30.48.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Willy,

> On Mon, Mar 12, 2012 at 10:06:23AM +0530, Mohammed Shafi Shajakhan wrote:
>>> So I'm pretty sure this patch is wrong for 2.6.32; it could be
>>> backported but I don't think the change is necessary anyway.
>>
>> true, but i think its better to initialize the count = 0 rather than
>> count = 1, though the older version driver checks for rate[i].idx>= 0
>> in ath_rc_tx_status. while the ath_tx_status has no such iteration in
>> the older driver code.
>
> In practice, if the patch brings nothing and not even correctness, I'd
> rather drop it than make us believe that some issue is fixed. However
> if you think it does happen to fix a real issue in 2.6.32 (possibly
> combined with some other missing patch), please tell me so and I will
> happily undelete it.
>

we can drop it. also as there was no driver code checking for 
rate[i].count in the 2.6.32 driver. i am also not sure this fixes 
something in 2.6.32 but the patch itself is correct.

Pavel fixed a rate control crash in ath9k because of invalid rate index 
(-1) access. we were wondering how is it possible the driver can be 
using a invalid rate index ?
we can simply rule out a rate is invalid checking for (rate[i].idx < 0 
&& rate[i].count != 0)

Pavel found that the driver previously checks "only" for rate[i].count 
as non-zero and this itself seems sufficient as we assumed the invalid 
rate indexes are initialized with  -1, 0 for rate[i].idx and 
rate[i].count respectively. later found that mac80211 rate[i].count 
initializes with '1' for the 'rate[i].count' field.

thus we generically fixed in mac80211(also as per doc) to avoid any such 
issues in any rate control, though we can blame the driver for not 
checking for invalid rate.idx while blindly believing on rate[i].count.

thank you!

-- 
thanks,
shafi
