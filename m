Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab1HVUnl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 16:43:41 -0400
Received: from yuna.grokhost.net ([87.117.228.63]:55907 "EHLO
	yuna.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753764Ab1HVUnj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 16:43:39 -0400
Message-ID: <4E52BF78.8060809@bootc.net>
Date: Mon, 22 Aug 2011 21:43:36 +0100
From: Chris Boot <bootc@bootc.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: Tejun Heo <tj@kernel.org>, linux1394-devel@lists.sourceforge.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firewire-sbp2: fix panic after rmmod with slow targets
References: <1314017561-1976-1-git-send-email-bootc@bootc.net> <20110822163526.5b76d535@stein>
In-Reply-To: <20110822163526.5b76d535@stein>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22/08/2011 15:35, Stefan Richter wrote:
> On Aug 22 Chris Boot wrote:
>> If firewire-sbp2 starts a login to a target that doesn't complete ORBs
>> in a timely manner (and has to retry the login), and the module is
>> removed before the operation times out, you end up with a null-pointer
>> dereference and a kernel panic.
>>
>> This happens because the code in sbp2_remove() just does a
>> sbp2_target_put(), assuming it will be the last remaining reference. If
>> there are jobs in the workqueue, this is not the case, and the module is
>> successfully unloaded while references still exist.
> The problem is not that sbp2_target_put()'s caller assumes that it is
> putting the last reference.  sbp2_target_put()'s very purpose is to clean
> up when, and only when, the last reference is gone.

Yes that's what I meant by my message, but I guess I wasn't clear 
enough. I edited it a bit with the second revision, I hope it's a bit 
clearer now.

[snip]

>> Signed-off-by: Chris Boot<bootc@bootc.net>
>> ---
>>   drivers/firewire/sbp2.c |    5 +++++
>>   1 files changed, 5 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
>> index 41841a3..3867aaa 100644
>> --- a/drivers/firewire/sbp2.c
>> +++ b/drivers/firewire/sbp2.c
>> @@ -1198,6 +1198,11 @@ static int sbp2_remove(struct device *dev)
>>   {
>>   	struct fw_unit *unit = fw_unit(dev);
>>   	struct sbp2_target *tgt = dev_get_drvdata(&unit->device);
>> +	struct sbp2_logical_unit *lu, *next;
>> +
>> +	list_for_each_entry_safe(lu, next,&tgt->lu_list, link) {
>> +		cancel_delayed_work_sync(&lu->work);
>> +	}
>>
>>   	sbp2_target_put(tgt);
>>   	return 0;
> list_for_each_entry() is sufficient here.  You are not changing the list
> while you iterate over it.
>
> Would you please resend the patch with list_for_each_entry()?

Done.

> More importantly, I think the whole sbp2_target instance reference
> counting can be removed with his work canceling in place.  But I have not
> analyzed this fully yet, and I don't expect you to do this for me.  Though
> if you like to do so, that would of course be welcome.

If you don't mind I'll let you do that as I'm not yet familiar enough 
with the kernel - only enough to be dangerous! :-)

Chris

