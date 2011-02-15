Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754123Ab1BOQ3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 11:29:53 -0500
Received: from cantor.suse.de ([195.135.220.2]:48251 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751201Ab1BOQ3u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 11:29:50 -0500
Date: Tue, 15 Feb 2011 08:29:33 -0800
From: Greg KH <gregkh@suse.de>
To: KY Srinivasan <kys@microsoft.com>
Cc: Jiri Slaby <jirislaby@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: [PATCH 2/3]: Staging: hv: Use native wait primitives
Message-ID: <20110215162933.GA30626@suse.de>
References: <1297447183-21807-1-git-send-email-kys@microsoft.com>
 <4D5A4565.5030501@gmail.com>
 <FB42D5CCD7B5934EB1827DB5ED9B850E07085CF8@TK5EX14MBXC104.redmond.corp.microsoft.com>
 <20110215140305.GA10301@suse.de>
 <FB42D5CCD7B5934EB1827DB5ED9B850E07085D7F@TK5EX14MBXC104.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <FB42D5CCD7B5934EB1827DB5ED9B850E07085D7F@TK5EX14MBXC104.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 15, 2011 at 04:22:20PM +0000, KY Srinivasan wrote:
> 
> 
> > -----Original Message-----
> > From: Greg KH [mailto:gregkh@suse.de]
> > Sent: Tuesday, February 15, 2011 9:03 AM
> > To: KY Srinivasan
> > Cc: Jiri Slaby; linux-kernel@vger.kernel.org; devel@linuxdriverproject.org;
> > virtualization@lists.osdl.org
> > Subject: Re: [PATCH 2/3]: Staging: hv: Use native wait primitives
> > 
> > On Tue, Feb 15, 2011 at 01:35:56PM +0000, KY Srinivasan wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Jiri Slaby [mailto:jirislaby@gmail.com]
> > > > Sent: Tuesday, February 15, 2011 4:21 AM
> > > > To: KY Srinivasan
> > > > Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> > > > devel@linuxdriverproject.org; virtualization@lists.osdl.org
> > > > Subject: Re: [PATCH 2/3]: Staging: hv: Use native wait primitives
> > > >
> > > > On 02/11/2011 06:59 PM, K. Y. Srinivasan wrote:
> > > > > In preperation for getting rid of the osd layer; change
> > > > > the code to use native wait interfaces. As part of this,
> > > > > fixed the buggy implementation in the osd_wait_primitive
> > > > > where the condition was cleared potentially after the
> > > > > condition was signalled.
> > > > ...
> > > > > @@ -566,7 +567,11 @@ int vmbus_establish_gpadl(struct vmbus_channel
> > > > *channel, void *kbuffer,
> > > > >
> > > > >  		}
> > > > >  	}
> > > > > -	osd_waitevent_wait(msginfo->waitevent);
> > > > > +	wait_event_timeout(msginfo->waitevent,
> > > > > +				msginfo->wait_condition,
> > > > > +				msecs_to_jiffies(1000));
> > > > > +	BUG_ON(msginfo->wait_condition == 0);
> > > >
> > > > The added BUG_ONs all over the code look scary. These shouldn't be
> > > > BUG_ONs at all. You should maybe warn and bail out, but not kill the
> > > > whole machine.
> > >
> > > This is Linux code running as a guest on a Windows host; and so the guest
> > cannot
> > > tolerate a failure of the host. In the cases where I have chosen to BUG_ON,
> > there
> > > is no reasonable recovery possible when the host is non-functional (as
> > determined
> > > by a non-responsive host).
> > 
> > If you have a non-responsive host, wouldn't that imply that this guest
> > code wouldn't run at all?  :)
> 
> The fact  that on a particular transaction the host has not responded within an expected
> time interval does not necessarily  mean that the guest code would not be running. There may be 
> issues on the host side that may be either transient or permanent that may cause problems like
> this. Keep in mind, HyperV is a type 1 hypervisor that would schedule all VMs including the host
> and so, guest would get scheduled.
> 
> > 
> > Having BUG_ON() in drivers is not a good idea either way.  Please remove
> > these in future patches.
> 
> In situations where there is not a reasonable rollback strategy (for
> instance in one of the cases, we are granting access to the guest
> physical pages to the host) we really have only 2 options:
> 
> 1) Wait until the host responds. This wait could potentially be unbounded
> and in fact this  was the way the code was to begin with. One of the reviewers
> had suggested that unbounded wait was to be corrected.
> 2) Wait for a specific period and if the host does not respond
> within a reasonable period, kill the guest since there is no recovery
> possible.

Killing the guest is a very serious thing, causing all sorts of possible
problems with it, right?

> I chose option 2, as part of addressing some of the prior review
> comments. If the consensus now is to go back to option 1, I am fine with that;

Unbounded waits aren't ok either, you need some sort of timeout.

But, as this is a bit preferable to dieing, I suggest doing this, and
comment the heck out of it to explain all of this for anyone who reads
it.

thanks,

greg k-h
