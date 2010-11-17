Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758151Ab0KQPBq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 10:01:46 -0500
Received: from relay01.mx.bawue.net ([193.7.176.67]:40647 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab0KQPBp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 10:01:45 -0500
X-Greylist: delayed 351 seconds by postgrey-1.27 at vger.kernel.org; Wed, 17 Nov 2010 10:01:44 EST
Date: Wed, 17 Nov 2010 15:55:48 +0100
From: Nils Radtke <Nils.Radtke@Think-Future.de>
To: Dan Carpenter <error27@gmail.com>
Cc: gregkh@suse.de, kernel-janitors@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: wlan-ng: p80211netdev.c cleanup
Message-ID: <20101117145548.GA6794@localhost>
Reply-To: Nils Radtke <Nils.Radtke@Think-Future.de>
Mail-Followup-To: Nils Radtke <Nils.Radtke@Think-Future.de>,
	Dan Carpenter <error27@gmail.com>, gregkh@suse.de,
	kernel-janitors@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
References: <1284834652-26171-1-git-send-email-lkml@Think-Future.com>
 <20100918204112.GA6236@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100918204112.GA6236@bicker>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi Dan,

  First off, thanks for your explanatory comments on 
  the patch. 

  Meanwhile some water went down the river as I switched the 
  country (and the job, well.. at least the research for the
  job is ongoing duty.. Anyone looking for some kernel newbie
  to complement his staff? I'm quite willing switching the 
  country again! :-)

On Sat 2010-09-18 @ 10-41-12PM +0200, Dan Carpenter wrote: 
# On Sat, Sep 18, 2010 at 08:30:52PM +0200, Nils Radtke wrote:
# > diff --git a/drivers/staging/wlan-ng/p80211netdev.c b/drivers/staging/wlan-ng/p80211netdev.c
# > index aa1792c..8104e11 100644
# > --- a/drivers/staging/wlan-ng/p80211netdev.c
# > +++ b/drivers/staging/wlan-ng/p80211netdev.c
# > @@ -176,25 +176,30 @@ static struct net_device_stats *p80211knetdev_get_stats(netdevice_t * netdev)
# >  ----------------------------------------------------------------*/
# >  static int p80211knetdev_open(netdevice_t *netdev)
# >  {
# > -	int result = 0;		/* success */
# > +	int ret = 0;
# 
# If it was new code then I also would have prefered "ret" I suppose, but
# really it's not a good idea to rename things for no reason.
Yes, I agree. This happened out of editing an edited edit of a version 
of the patch.. Finally, I wasn't offended and just left it in.

# >  	wlandevice_t *wlandev = netdev->ml_priv;
# >  
# >  	/* Check to make sure the MSD is running */
# > -	if (wlandev->msdstate != WLAN_MSD_RUNNING)
# > -		return -ENODEV;
# > +	if (wlandev->msdstate != WLAN_MSD_RUNNING) {
# > +		ret = -ENODEV;
# > +		goto end;
# > +	}
# 
# It's better to just return directly.  This code makes me wonder what
# happens after I goto end, but actually nothing happens.  So it's
# a little annoying.
Ok, I understand that. I considered this argument but personally
thought it "cleaner" this way.
Having a look at drivers/staging/wlan-ng/hfa384x_usb.c, a quick grep 
for "goto" reveals a multitude of those tags that only have a "return
result;" statement. In some situations I'd prefer a clean exit point
instead of them distributed all over the fct code. If it's rather
unclean to do a fct using a single exit point then one might as well
adopt another scheme. But then, maybe the code should be worked on
anyway. 

# >  	/* Tell the MSD to open */
# > -	if (wlandev->open != NULL) {
# > -		result = wlandev->open(wlandev);
# > -		if (result == 0) {
# > -			netif_start_queue(wlandev->netdev);
# > -			wlandev->state = WLAN_DEVICE_OPEN;
# > -		}
# > -	} else {
# > -		result = -EAGAIN;
# > +	if (wlandev->open == NULL) {
# > +		printk(KERN_ERR "Sorry, got wlandev->open == NULL.\n");
# This printk is not needed.  I haven't looked at this code, but if the
# user can trigger this error message then it can be used to flood
# /var/log/messages and cause a denial of service attack.
Ok. Out of kernel bounds I used to code in a rather conservative way, 
applying informative msgs where useful and required. Dying dead and
not telling nothing nowhere is a bad habit, imo. 

Maybe the ERR code isn't appropriate. But then, it's an error, we're even
checking for that one. Maybe there's a better way in propagating the where,
why and when. I'm new to this kind of code..

# > -	return result;
# > +	ret = wlandev->open(wlandev);
# > +	if (ret) {
# This test is reversed (we return zero on success).  It should be:
True. My bad. Have been "bashing" my head.. ;)

# 	if (ret)
# 		return ret;
# And then the other stuff can be pulled in an indent level.
# 
# > +		netif_start_queue(wlandev->netdev);
# > +		wlandev->state = WLAN_DEVICE_OPEN;
# > +	}
# > +
# > +end:
# > +	return ret;
# >  }
# 
# The other function had many of the same issues.
# 
# The change log for this should have been something like:
# 	This is a cleanup of p80211knetdev_open().  I rearranged the
# 	to unify all the return paths so there was just one return
# 	statement.  I also changed the if statements so I could pull 
# 	the code in one indent level and simplify things a bit.  And I
# 	added a couple printk() to the let the user know about errors.
Very good idea. Thank you. I was a bit short on that. Probably mostly 
because I intended this patch a training one for feedback about the
code, neglecting the importance of workflow and how to do it properly.

# (Except that adding printk()s is a functional change so it goes into a
# separate patch instead of hidden inside a "cleanup" patch.  But you get
# the idea).
Yes, that seems reasonable.
Even at the expense of a growing patch count for tiny changes. But ok.

# It's always dangerous writing patches when you can't test them. Most of
Agreed. Totally. Otoh, I read some mails on kernelnewbies that were about
patches of code for devices the author couldn't test. His notes were: 
Compiled, not tested.

As I was about getting feedback about my approach on cleaning up I thought
it would be acceptable.

# my patches are one liners because and when people ask me to rewrite them
# in a more complicated way I tell them I don't feel comfortable doing
# that because I can't test it.
Fair enough.

# Really though my advice is to start out by fixing bugs instead of
# focusing on cleanup.  I've fixed many of the interesting buffer
I'd really like to do that. Ignoring however whether I'm yet able to handle
that kind of patch in kernel context. I'm still reading LDD 3rd ed. and 
some other books on the topic, doing exercises. 


Other things I noticed:

- In that same directory there are files with many void fcts featuring a
  return statement. Is this worth of cleaning them up?

- When checking skb for NULL, which one is better? (I suppose the former one)
  skb == NULL or !skb 
  Rewrite occurrences of the other one for cleanup?

- drivers/staging/wlan-ng/hfa384x_usb.c +3249 
  Is skb_put a fct that always succeeds? Should I bother to check the retval?
  Ok, I checked skbuff.h, returns a ptr. This ptr is not important in 
  drivers/staging/wlan-ng/hfa384x_usb.c +3249 it seems. Why is this?

I'd be glad to hear your opinion, thanks in advance.

          Cheers,

                  Nils

