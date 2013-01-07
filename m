Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753518Ab3AGDDe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 22:03:34 -0500
Received: from mail-la0-f51.google.com ([209.85.215.51]:56621 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753379Ab3AGDDc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 22:03:32 -0500
MIME-Version: 1.0
In-Reply-To: <20130107024827.GZ27530@wantstofly.org>
References: <1357522042-39255-1-git-send-email-nickolai@csail.mit.edu> <20130107024827.GZ27530@wantstofly.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Mon, 7 Jan 2013 14:03:10 +1100
Message-ID: <CAGRGNgVF_s1ux9TjL6TqUDF=NB9e-XS0CQvowEGV=9Vj5r9Osg@mail.gmail.com>
Subject: Re: [PATCH] drivers/net/wireless/mwl8k.c: avoid use-after-free
To: Lennert Buytenhek <buytenh@wantstofly.org>
Cc: Nickolai Zeldovich <nickolai@csail.mit.edu>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lennert,

On Mon, Jan 7, 2013 at 1:48 PM, Lennert Buytenhek
<buytenh@wantstofly.org> wrote:
> On Sun, Jan 06, 2013 at 08:27:22PM -0500, Nickolai Zeldovich wrote:
>
>> Do not dereference p->station_id after kfree(cmd) because p
>> points into the cmd data structure.
>
> Good catch, but the patch would be better titled "mwl8k.c: avoid
> having a working driver", as the station_id return code _is_ needed
> by the caller in case of success.

Are you sure?

>> diff --git a/drivers/net/wireless/mwl8k.c b/drivers/net/wireless/mwl8k.c
>> index f221b95..83564d3 100644
>> --- a/drivers/net/wireless/mwl8k.c
>> +++ b/drivers/net/wireless/mwl8k.c
>> @@ -4250,9 +4250,11 @@ static int mwl8k_cmd_update_stadb_add(struct ieee80211_hw *hw,
>>       p->amsdu_enabled = 0;
>>
>>       rc = mwl8k_post_cmd(hw, &cmd->header);
>> +     if (!rc)
>> +             rc = p->station_id;
>>       kfree(cmd);
>>
>> -     return rc ? rc : p->station_id;

If I'm reading this right, the removed line is equivalent to:

if( rc )
    return rc;
else
    return p->station_id;

which is equivalent to:

if( !rc )
    rc = p->station_id;

return rc;


Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
