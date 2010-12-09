Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756240Ab0LIWyX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 17:54:23 -0500
Received: from web31809.mail.mud.yahoo.com ([68.142.207.72]:47346 "HELO
	web31809.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754858Ab0LIWyV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 17:54:21 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=MMs02AC8CtUWtIdFXY72Hy3a3/U4OANz1Zr0XAvSgC3IJB7gnDYzN/K/AyoEhuZtQFKHAVsGF9LemBXnHzK/PRCJKXiXFZBeRU7ql8yxNzdHRRCdmUq981AjPTqVTrVQ4G5DSkk3wYozjkCbn/EYzICnpF1F0mnOgNbYfAzq528=;
Message-ID: <463402.63193.qm@web31809.mail.mud.yahoo.com>
X-YMail-OSG: V1q06JcVM1n7el7YLM8ZqWyfNiJ13WH9hx.SQQVCGp77mdp
 ypnxfIcA4by8Uu59UEcNMf4bpP.vX0MPnGAq7Vj0l6s2PgkxJV1.p8WiQWHr
 A3pNnFAKriMQuU9_vCg1cH8Kn5Cqs00F2r1oeDCC27n3shdoYIzpY5b9s3iW
 RCa0Nn4xQitrFV5XtCrf2biLVzJskHTHmr25yew4Lc3aXvPrG6_eeP4rKANS
 BrHgTkv_YLGWyNscs8ZyL4YgEG7UEOXmc_TRkDQ0J0cDsvhD9i5bdfgtHDdr
 HVZdfalTqMjDOIUp42dv.CpT8B3dDPwihIZy2cC9kgk3QqYK8.O4dmTrO_Mx
 cLtWVTfj0xwEpFdESUT7ucXcgV8HybWnR38_OkzJJD2__d32i0Yz7dpSMoVm
 XybRhIf0pO6DP
X-Mailer: YahooMailClassic/11.4.20 YahooMailWebService/0.8.107.289296
Date: Thu, 9 Dec 2010 14:54:19 -0800 (PST)
From: Luben Tuikov <ltuikov@yahoo.com>
Reply-To: ltuikov@yahoo.com
Subject: Re: [PATCH 2/4] [USB] UASP: Add MaxNumStreams module parameter
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
In-Reply-To: <20101209205820.GA6014@xanatos>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Thu, 12/9/10, Sarah Sharp <sarah.a.sharp@linux.intel.com> wrote:
> -0800, Luben Tuikov wrote:
> > Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> > ---
> >  The long story is that we see some host
> controllers misreport their
> >  PSA as they solved 2^v = streams, instead of
> 2^(v+1) = streams. Thus
> >  They report that they support 32 streams when in
> fact they support 16.
> >  When the device attempts to return status for
> stream > 15, the host
> >  says ACK(NumP=0), the device goes in flow
> control, blah, blah, this
> >  module parameter allows you to set a max cap on
> the number of streams
> >  the driver will ask XHCI HCD to allocate.
> 
> If this is an issue with a host then the work-around should
> be in the
> xHCI driver instead.  It should be based on the
> vendor/device ID of the
> offending host instead of being a module parameter in the
> UAS driver.
> The only people who benefit from this patch are the people
> "in the know"
> about which hosts are buggy, not normal Linux users.

The OS might want to limit the number of streams for reasons other than a buggy HC. So this module parameter add flexibility other than making a buggy HC work.

(I didn't know you were reading my patches and yet to a "competing" driver of a driver where you're listed as a co-author...)

> Streams could be used for things other than UAS in the
> future, so the
> fix should really be in the xHCI host controller
> driver.  And please put
> the information about the host bug in the commit message,
> so your
> private comments don't get lost in the bowels of the
> linux-usb mailing
> list.

I've an updated HC of this particular make sitting on my desk which I've not had time to test... The HC this was found in is an early version of that make.

> In the future, please Cc me on any patches that involve
> xHCI, or bulk
> streams in general.

In this case, you should probably not add 1 to the number of streams a protocol driver requests, if that number is already a power of 2.  To extend this and make it foolproof, the XHCI should probably know if the number of streams came from a descriptor or the driver made it up (in which case you know more precisely what to do). Now, since you return the number of streams the driver can use, implementing the former is probably just enough.

Also please add a comment as to the return value therein, to the effect that the range of streams the caller can use is [1, the value returned], WLG.

> I'm not an enemy; I frankly don't
> care which UAS
> driver gets in the kernel,

I see.

> I just want one good, well
> documented driver,
> and for the xHCI driver to be as good as possible.

Uh-huh.

> 
> Sarah Sharp
> 
> 
> >  drivers/usb/storage/uasp.c |   21
> ++++++++++++++++++++-
> >  1 files changed, 20 insertions(+), 1
> deletions(-)
> > 
> > diff --git a/drivers/usb/storage/uasp.c
> b/drivers/usb/storage/uasp.c
> > index 3b10efd..e5a26e9 100644
> > --- a/drivers/usb/storage/uasp.c
> > +++ b/drivers/usb/storage/uasp.c
> > @@ -30,6 +30,19 @@
> >  #include <scsi/scsi_host.h>
> >  #include <scsi/scsi_tcq.h>
> >  
> > +int MaxNumStreams = -1;
> > +
> > +module_param(MaxNumStreams, int, 0444);
> > +MODULE_PARM_DESC(MaxNumStreams, "\n"
> > +    "\tSome host controllers and/or
> devices report a larger number of\n"
> > +    "\tstreams that they in fact
> support. This parameter allows you\n"
> > +    "\tto limit the number of streams
> this driver will request the XHCI\n"
> > +    "\tHCD to allocate. If set to -1,
> the default value, then this driver\n"
> > +    "\twill use the value reported by
> the attached device. Else the\n"
> > +    "\tnumber of streams will be
> limited to the minimum reported by the\n"
> > +    "\tattached device and this value.
> Valid values are -1, default,\n"
> > +    "\tand 1 to 0xFFEF.");
> > +
> >  /* Information unit types
> >   */
> >  #define IU_CMD   1
> > @@ -938,6 +951,8 @@ static int uasp_ep_conf(struct
> uasp_tport_info *tpinfo)
> >         
>        
>      tpinfo->eps[3]->desc.bEndpointAddress);
> >  
> >      if (udev->speed ==
> USB_SPEED_SUPER) {
> > +        int
> max_streams;
> > +
> >          for (i =
> 1; i < 4; i++) {
> >         
>     if (tpinfo->max_streams == 0)
> >         
>         tpinfo->max_streams
> =
> USB_SS_MAX_STREAMS(tpinfo->eps[i]->ss_ep_comp.bmAttributes);
> > @@ -952,9 +967,13 @@ static int uasp_ep_conf(struct
> uasp_tport_info *tpinfo)
> >          }
> >          
> >         
> tpinfo->use_streams = 1;
> > +        if (1 <=
> MaxNumStreams && MaxNumStreams <= 0xFFEF)
> > +       
>     max_streams = min(MaxNumStreams,
> tpinfo->max_streams);
> > +        else
> > +       
>     max_streams = tpinfo->max_streams;
> >         
> tpinfo->num_streams = usb_alloc_streams(iface,
> >         
>            
>        
> &tpinfo->eps[1], 3,
> > -       
>            
>        
> tpinfo->max_streams,
> > +       
>            
>         max_streams,
> >         
>            
>         GFP_KERNEL);
> >          if
> (tpinfo->num_streams <= 0) {
> >         
>     dev_err(&udev->dev,
> > -- 
> > 1.7.0.1
> > 
> > 
> > --
> > To unsubscribe from this list: send the line
> "unsubscribe linux-usb" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
