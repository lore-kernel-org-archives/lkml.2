Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755931Ab2GCRoT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 13:44:19 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:32061 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750768Ab2GCRoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 13:44:18 -0400
Date: Tue, 3 Jul 2012 13:36:07 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: xen-devel <xen-devel@lists.xen.org>, linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH 4/4] xen/hvc: Fix up checks when the info is
 allocated.
Message-ID: <20120703173607.GA24259@phenom.dumpdata.com>
References: <1341330038-21686-1-git-send-email-konrad.wilk@oracle.com>
 <1341330038-21686-5-git-send-email-konrad.wilk@oracle.com>
 <4FF335C6020000780008D613@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FF335C6020000780008D613@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 05:11:18PM +0100, Jan Beulich wrote:
> >>> On 03.07.12 at 17:40, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:
> > Coverity would complain about this - even thought it looks OK.
> > 
> > CID 401957
> > Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> > ---
> >  drivers/tty/hvc/hvc_xen.c |   15 ++++++---------
> >  1 files changed, 6 insertions(+), 9 deletions(-)
> > 
> > diff --git a/drivers/tty/hvc/hvc_xen.c b/drivers/tty/hvc/hvc_xen.c
> > index 944eaeb..fbf41be 100644
> > --- a/drivers/tty/hvc/hvc_xen.c
> > +++ b/drivers/tty/hvc/hvc_xen.c
> > @@ -209,10 +209,8 @@ static int xen_hvm_console_init(void)
> >  		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
> >  		if (!info)
> >  			return -ENOMEM;
> > -	}
> > -
> > -	/* already configured */
> > -	if (info->intf != NULL)
> > +	} else if (info->intf != NULL) {
> > +		/* already configured */
> >  		return 0;
> 
> Is this patch perhaps stale? There appears to be a missing } here,
> without which I can't see how this would have built, ...

<sighs> Yes. That is what I get for cherry-picking and in a hurry picking
the options.


> 
> >  	/*
> >  	 * If the toolstack (or the hypervisor) hasn't set these values, the
> > @@ -220,6 +218,7 @@ static int xen_hvm_console_init(void)
> >  	 * theoretically correct values, in practice they never are and they
> >  	 * mean that a legacy toolstack hasn't initialized the pv console correctly.
> >  	 */
> > +	 */
> 
> ... and this one likely wouldn't build either.

Heh. It certainly does not. The "real" patch has that fix.
> 
> Jan
> 
> >  	r = hvm_get_parameter(HVM_PARAM_CONSOLE_EVTCHN, &v);
> >  	if (r < 0 || v == 0)
> >  		goto err;
> > @@ -259,12 +258,10 @@ static int xen_pv_console_init(void)
> >  		info = kzalloc(sizeof(struct xencons_info), GFP_KERNEL | __GFP_ZERO);
> >  		if (!info)
> >  			return -ENOMEM;
> > -	}
> > -
> > -	/* already configured */
> > -	if (info->intf != NULL)
> > +	} else if (info->intf != NULL) {
> > +		/* already configured */
> >  		return 0;
> > -
> > +	}
> >  	info->evtchn = xen_start_info->console.domU.evtchn;
> >  	info->intf = mfn_to_virt(xen_start_info->console.domU.mfn);
> >  	info->vtermno = HVC_COOKIE;
> 
