Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755370Ab1BOQAf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:00:35 -0500
Received: from cantor.suse.de ([195.135.220.2]:46442 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755302Ab1BOQAe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:00:34 -0500
Date: Tue, 15 Feb 2011 06:03:05 -0800
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 2/3]: Staging: hv: Use native wait primitives
Message-ID: <20110215140305.GA10301@suse.de>
References: <1297447183-21807-1-git-send-email-kys@microsoft.com>
 <4D5A4565.5030501@gmail.com>
 <FB42D5CCD7B5934EB1827DB5ED9B850E07085CF8@TK5EX14MBXC104.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FB42D5CCD7B5934EB1827DB5ED9B850E07085CF8@TK5EX14MBXC104.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 01:35:56PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Jiri Slaby [mailto:jirislaby@gmail.com]
> > Sent: Tuesday, February 15, 2011 4:21 AM
> > To: KY Srinivasan
> > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > devel@linuxdriverproject.org; virtualization@lists.osdl.org
> > Subject: Re: [PATCH 2/3]: Staging: hv: Use native wait primitives
> > 
> > On 02/11/2011 06:59 PM, K. Y. Srinivasan wrote:
> > > In preperation for getting rid of the osd layer; change
> > > the code to use native wait interfaces. As part of this,
> > > fixed the buggy implementation in the osd_wait_primitive
> > > where the condition was cleared potentially after the
> > > condition was signalled.
> > ...
> > > @@ -566,7 +567,11 @@ int vmbus_establish_gpadl(struct vmbus_channel
> > *channel, void *kbuffer,
> > >
> > >  		}
> > >  	}
> > > -	osd_waitevent_wait(msginfo->waitevent);
> > > +	wait_event_timeout(msginfo->waitevent,
> > > +				msginfo->wait_condition,
> > > +				msecs_to_jiffies(1000));
> > > +	BUG_ON(msginfo->wait_condition == 0);
> > 
> > The added BUG_ONs all over the code look scary. These shouldn't be
> > BUG_ONs at all. You should maybe warn and bail out, but not kill the
> > whole machine.
> 
> This is Linux code running as a guest on a Windows host; and so the guest cannot
> tolerate a failure of the host. In the cases where I have chosen to BUG_ON, there 
> is no reasonable recovery possible when the host is non-functional (as determined 
> by a non-responsive host). 

If you have a non-responsive host, wouldn't that imply that this guest
code wouldn't run at all?  :)

Having BUG_ON() in drivers is not a good idea either way.  Please remove
these in future patches.

> > And looking at the code, more appropriate would be completion instead of
> > wait events.
> > 
> > And msecs_to_jiffies(1000) == HZ.
> 
> Agreed. In this first round of cleanup, I chose to keep the primitives
> as they were in osd.c. Greg, if it is ok with you, I will send you a
> patch that fixes these issues on top of the patches I have already
> sent.

Yes, that is fine.

thanks,

greg k-h
