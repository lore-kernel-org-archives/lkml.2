Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab2IKQ35 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 12:29:57 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:44564 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838Ab2IKQ3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 12:29:54 -0400
Date: Tue, 11 Sep 2012 09:28:47 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: NeilBrown <neilb@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH 1/3] raid: replace	list_for_each_continue_rcu with new
 interface
Message-ID: <20120911162847.GG4257@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <502CB924.10200@linux.vnet.ibm.com>
 <502DC999.1040407@linux.vnet.ibm.com>
 <5036D00F.2040009@linux.vnet.ibm.com>
 <504DA513.2060004@linux.vnet.ibm.com>
 <20120911162120.5d5b5fe5@notabene.brown>
 <504ED9DE.2090902@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <504ED9DE.2090902@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091116-4242-0000-0000-000002E17104
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 02:27:42PM +0800, Michael Wang wrote:
> On 09/11/2012 02:21 PM, NeilBrown wrote:
> > On Mon, 10 Sep 2012 16:30:11 +0800 Michael Wang <wangyun@linux.vnet.ibm.com>
> > wrote:
> > 
> >> On 08/24/2012 08:51 AM, Michael Wang wrote:
> >>> On 08/17/2012 12:33 PM, Michael Wang wrote:
> >>>> From: Michael Wang <wangyun@linux.vnet.ibm.com>
> >>>>
> >>>> This patch replaces list_for_each_continue_rcu() with
> >>>> list_for_each_entry_continue_rcu() to save a few lines
> >>>> of code and allow removing list_for_each_continue_rcu().
> >>>>
> >>>
> >>> Hi, Neil
> >>>
> >>> Could I get some comments on this patch?
> >>
> >> Hi, Neil
> >>
> >> Could I get some comments?
> >>
> >> And please forgive and warn me if this patch has came to the wrong
> >> place...I get the address from get_maintainer.
> > 
> > Sorry, August was a bad month.
> > 
> > Yes, patch looks good.  Shall I include it in my tree, do you want to submit
> > them altogether through some rcu tree?
> > Either way is fine by me.  If you want to submit it through some other tree, 
> >    Acked-by: NeilBrown <neilb@suse.de>
> 
> Thanks for your review ;-)
> 
> I think submit to rcu tree may be better, what's your opinion, Paul?

I am fine either way.  If I don't see it in mainline this coming merge
window, I will pull it into the -rcu tree.

							Thanx, Paul

> Regards,
> Michael Wang
> 
> 
> > 
> > If not, it'll probably appear in my -next soonish.
> > 
> > Thanks,
> > NeilBrown
> > 
> > 
> >>
> >> Regards,
> >> Michael Wang
> >>
> >>>
> >>> Regards,
> >>> Michael Wang
> >>>
> >>>> Signed-off-by: Michael Wang <wangyun@linux.vnet.ibm.com>
> >>>> ---
> >>>>  drivers/md/bitmap.c |    9 +++------
> >>>>  1 files changed, 3 insertions(+), 6 deletions(-)
> >>>>
> >>>> diff --git a/drivers/md/bitmap.c b/drivers/md/bitmap.c
> >>>> index 15dbe03..b160828 100644
> >>>> --- a/drivers/md/bitmap.c
> >>>> +++ b/drivers/md/bitmap.c
> >>>> @@ -163,20 +163,17 @@ static struct md_rdev *next_active_rdev(struct md_rdev *rdev, struct mddev *mdde
> >>>>  	 * As devices are only added or removed when raid_disk is < 0 and
> >>>>  	 * nr_pending is 0 and In_sync is clear, the entries we return will
> >>>>  	 * still be in the same position on the list when we re-enter
> >>>> -	 * list_for_each_continue_rcu.
> >>>> +	 * list_for_each_entry_continue_rcu.
> >>>>  	 */
> >>>> -	struct list_head *pos;
> >>>>  	rcu_read_lock();
> >>>>  	if (rdev == NULL)
> >>>>  		/* start at the beginning */
> >>>> -		pos = &mddev->disks;
> >>>> +		rdev = list_entry_rcu(&mddev->disks, struct md_rdev, same_set);
> >>>>  	else {
> >>>>  		/* release the previous rdev and start from there. */
> >>>>  		rdev_dec_pending(rdev, mddev);
> >>>> -		pos = &rdev->same_set;
> >>>>  	}
> >>>> -	list_for_each_continue_rcu(pos, &mddev->disks) {
> >>>> -		rdev = list_entry(pos, struct md_rdev, same_set);
> >>>> +	list_for_each_entry_continue_rcu(rdev, &mddev->disks, same_set) {
> >>>>  		if (rdev->raid_disk >= 0 &&
> >>>>  		    !test_bit(Faulty, &rdev->flags)) {
> >>>>  			/* this is a usable devices */
> >>>>
> >>>
> > 
> 

