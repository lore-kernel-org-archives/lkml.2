Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754500Ab1BONf7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 08:35:59 -0500
Received: from smtp.microsoft.com ([131.107.115.215]:35764 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab1BONf5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 08:35:57 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Jiri Slaby <jirislaby@gmail.com>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: RE: [PATCH 2/3]: Staging: hv: Use native wait primitives
Thread-Topic: [PATCH 2/3]: Staging: hv: Use native wait primitives
Thread-Index: AQHLyhRfU1AHw/SIZkauajJIU383GpQC1SmA//+ugvA=
Date: Tue, 15 Feb 2011 13:35:56 +0000
Message-ID: <FB42D5CCD7B5934EB1827DB5ED9B850E07085CF8@TK5EX14MBXC104.redmond.corp.microsoft.com>
References: <1297447183-21807-1-git-send-email-kys@microsoft.com>
 <4D5A4565.5030501@gmail.com>
In-Reply-To: <4D5A4565.5030501@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Jiri Slaby [mailto:jirislaby@gmail.com]
> Sent: Tuesday, February 15, 2011 4:21 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org
> Subject: Re: [PATCH 2/3]: Staging: hv: Use native wait primitives
> 
> On 02/11/2011 06:59 PM, K. Y. Srinivasan wrote:
> > In preperation for getting rid of the osd layer; change
> > the code to use native wait interfaces. As part of this,
> > fixed the buggy implementation in the osd_wait_primitive
> > where the condition was cleared potentially after the
> > condition was signalled.
> ...
> > @@ -566,7 +567,11 @@ int vmbus_establish_gpadl(struct vmbus_channel
> *channel, void *kbuffer,
> >
> >  		}
> >  	}
> > -	osd_waitevent_wait(msginfo->waitevent);
> > +	wait_event_timeout(msginfo->waitevent,
> > +				msginfo->wait_condition,
> > +				msecs_to_jiffies(1000));
> > +	BUG_ON(msginfo->wait_condition == 0);
> 
> The added BUG_ONs all over the code look scary. These shouldn't be
> BUG_ONs at all. You should maybe warn and bail out, but not kill the
> whole machine.

This is Linux code running as a guest on a Windows host; and so the guest cannot
tolerate a failure of the host. In the cases where I have chosen to BUG_ON, there 
is no reasonable recovery possible when the host is non-functional (as determined 
by a non-responsive host). 

> 
> And looking at the code, more appropriate would be completion instead of
> wait events.
> 
> And msecs_to_jiffies(1000) == HZ.

Agreed. In this first round of cleanup, I chose to keep the primitives as they were in osd.c. Greg, if it is ok with you, I will send you a patch that fixes these issues on top of the patches I have already sent.

Regards,

K. Y
> 
> > @@ -689,7 +693,8 @@ static void vmbus_ongpadl_torndown(
> >  				memcpy(&msginfo->response.gpadl_torndown,
> >  				       gpadl_torndown,
> >  				       sizeof(struct
> vmbus_channel_gpadl_torndown));
> > -				osd_waitevent_set(msginfo->waitevent);
> > +				msginfo->wait_condition = 1;
> > +				wake_up(&msginfo->waitevent);
> >  				break;
> >  			}
> >  		}
> > @@ -730,7 +735,8 @@ static void vmbus_onversion_response(
> >  			memcpy(&msginfo->response.version_response,
> >  			      version_response,
> >  			      sizeof(struct vmbus_channel_version_response));
> > -			osd_waitevent_set(msginfo->waitevent);
> > +			msginfo->wait_condition = 1;
> > +			wake_up(&msginfo->waitevent);
> >  		}
> >  	}
> >  	spin_unlock_irqrestore(&vmbus_connection.channelmsg_lock, flags);
> 
> regards,
> --
> js

