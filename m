Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653Ab2IKG1x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:27:53 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:45860 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752582Ab2IKG1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:27:51 -0400
Message-ID: <504ED9DE.2090902@linux.vnet.ibm.com>
Date: Tue, 11 Sep 2012 14:27:42 +0800
From: Michael Wang <wangyun@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: NeilBrown <neilb@suse.de>
CC: LKML <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 1/3] raid: replace	list_for_each_continue_rcu with new
 interface
References: <502CB924.10200@linux.vnet.ibm.com> <502DC999.1040407@linux.vnet.ibm.com>	<5036D00F.2040009@linux.vnet.ibm.com> <504DA513.2060004@linux.vnet.ibm.com> <20120911162120.5d5b5fe5@notabene.brown>
In-Reply-To: <20120911162120.5d5b5fe5@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12091106-2674-0000-0000-000005EF7FF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2012 02:21 PM, NeilBrown wrote:
> On Mon, 10 Sep 2012 16:30:11 +0800 Michael Wang <wangyun@linux.vnet.ibm.com>
> wrote:
> 
>> On 08/24/2012 08:51 AM, Michael Wang wrote:
>>> On 08/17/2012 12:33 PM, Michael Wang wrote:
>>>> From: Michael Wang <wangyun@linux.vnet.ibm.com>
>>>>
>>>> This patch replaces list_for_each_continue_rcu() with
>>>> list_for_each_entry_continue_rcu() to save a few lines
>>>> of code and allow removing list_for_each_continue_rcu().
>>>>
>>>
>>> Hi, Neil
>>>
>>> Could I get some comments on this patch?
>>
>> Hi, Neil
>>
>> Could I get some comments?
>>
>> And please forgive and warn me if this patch has came to the wrong
>> place...I get the address from get_maintainer.
> 
> Sorry, August was a bad month.
> 
> Yes, patch looks good.  Shall I include it in my tree, do you want to submit
> them altogether through some rcu tree?
> Either way is fine by me.  If you want to submit it through some other tree, 
>    Acked-by: NeilBrown <neilb@suse.de>

Thanks for your review ;-)

I think submit to rcu tree may be better, what's your opinion, Paul?

Regards,
Michael Wang


> 
> If not, it'll probably appear in my -next soonish.
> 
> Thanks,
> NeilBrown
> 
> 
>>
>> Regards,
>> Michael Wang
>>
>>>
>>> Regards,
>>> Michael Wang
>>>
>>>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
>>>> ---
>>>>  drivers/md/bitmap.c |    9 +++------
>>>>  1 files changed, 3 insertions(+), 6 deletions(-)
>>>>
>>>> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
>>>> index 15dbe03..b160828 100644
>>>> --- a/drivers/md/bitmap.c
>>>> +++ b/drivers/md/bitmap.c
>>>> @@ -163,20 +163,17 @@ static struct md_rdev *next_active_rdev(struct md_rdev *rdev, struct mddev *mdde
>>>>  	 * As devices are only added or removed when raid_disk is < 0 and
>>>>  	 * nr_pending is 0 and In_sync is clear, the entries we return will
>>>>  	 * still be in the same position on the list when we re-enter
>>>> -	 * list_for_each_continue_rcu.
>>>> +	 * list_for_each_entry_continue_rcu.
>>>>  	 */
>>>> -	struct list_head *pos;
>>>>  	rcu_read_lock();
>>>>  	if (rdev == NULL)
>>>>  		/* start at the beginning */
>>>> -		pos = &mddev->disks;
>>>> +		rdev = list_entry_rcu(&mddev->disks, struct md_rdev, same_set);
>>>>  	else {
>>>>  		/* release the previous rdev and start from there. */
>>>>  		rdev_dec_pending(rdev, mddev);
>>>> -		pos = &rdev->same_set;
>>>>  	}
>>>> -	list_for_each_continue_rcu(pos, &mddev->disks) {
>>>> -		rdev = list_entry(pos, struct md_rdev, same_set);
>>>> +	list_for_each_entry_continue_rcu(rdev, &mddev->disks, same_set) {
>>>>  		if (rdev->raid_disk >= 0 &&
>>>>  		    !test_bit(Faulty, &rdev->flags)) {
>>>>  			/* this is a usable devices */
>>>>
>>>
> 

