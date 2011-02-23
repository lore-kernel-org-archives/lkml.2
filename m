Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932504Ab1BWTyU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:54:20 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:57624 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab1BWTyS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:54:18 -0500
Date: Wed, 23 Feb 2011 11:54:14 -0800
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Daniel Drake <dsd@laptop.org>, David Woodhouse <dwmw2@infradead.org>,
        cbou@mail.ru, linux-kernel@vger.kernel.org, x86@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        dmitry.torokhov@gmail.com, devicetree-discuss@lists.ozlabs.org,
        "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org
Subject: Re: [PATCH] of/pdt: allow DT device matching by fixing 'name'
 brokenness
Message-ID: <20110223115414.547b8c17@queued.net>
In-Reply-To: <20110223194352.GR14597@angua.secretlab.ca>
References: <20110216222820.487AE9D401C@zog.reactivated.net>
	<1297896277.3011.5.camel@macbook.infradead.org>
	<AANLkTikAF2X1A5jfoNfCPRhZkZ7qPdZ57c8B5b9z4+qr@mail.gmail.com>
	<20110218190659.7f955e4c@queued.net>
	<20110223194352.GR14597@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 12:43:52 -0700
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Fri, Feb 18, 2011 at 07:06:59PM -0800, Andres Salomon wrote:
> > On Fri, 18 Feb 2011 23:42:57 +0000
> > Daniel Drake <dsd@laptop.org> wrote:
> > 
> > > On 16 February 2011 22:44, David Woodhouse <dwmw2@infradead.org>
> > > wrote:
> > > > On Wed, 2011-02-16 at 22:28 +0000, Daniel Drake wrote:
> > > >>
> > > >> +static int __init add_common_platform_devices(void)
> > > >> +{
> > > >> +       struct platform_device *pdev;
> > > >> +
> > > >> +       pdev = platform_device_register_simple("olpc-battery",
> > > >> -1, NULL, 0);
> > > >> +       if (IS_ERR(pdev))
> > > >> +               return PTR_ERR(pdev);
> > > >> +
> > > >> +       return 0;
> > > >> +}
> > > >> +
> > > >
> > > > Still kind of sucks that you have to do this, and can't bind to
> > > > something in the device-tree.
> > > 
> > > OK, feel free to put this patch on hold for now. I started
> > > looking at the device tree approach today. It looks doable but
> > > first we have to fix a DT bug/inconsistency that is preventing us
> > > from correctly binding to the tree's devices.
> > > 
> > > Daniel
> > 
> > 
> > Mea culpa.  The patch below fixes a bug I introduced earlier.
> > Cc'ing the sparc folks, as this probably affects them
> > (although I would think that it fixes broken behavior for them..?)
> 
> Wait; why are you binding to a device based on name?  Binding by name
> and/or device_type is strongly discouraged for new code.  Use
> compatible instead.
> 

Daniel posted a separate patch showing his code, would you mind
commenting on that?  I noticed he didn't cc you though, here's the
patch:

https://patchwork.kernel.org/patch/574901/


> As for this patch, comments below...
> 
> > From: Andres Salomon <dilinger@queued.net>
> > 
> > Commit e2f2a93b changed dp->name from using the 'name' property to
> > using package-to-path.  This fixed /proc/device-tree creation by
> > eliminating conflicts between names (the 'name' property provides
> > names like 'battery', whereas package-to-path provides names like
> > '/foo/bar/battery@0', which we stripped to 'battery@0').  However,
> > it also breaks of_device_id table matching.
> > 
> > The fix that we _really_ wanted was to keep dp->name based upon
> > the name property ('battery'), but based dp->full_name upon
> > package-to-path ('battery@0').  This patch does just that.
> > 
> > Signed-off-by: Andres Salomon <dilinger@queued.net>
> > Reported-by: Daniel Drake <dsd@laptop.org>
> 
> From what I can tell, this only affects OLPC, correct?  It looks like
> SPARC's implementation of of_pdt_node_name() will sidestep most of
> this name retrieval code.
> 


This affects sparc as well; it changes behavior back for dp->name to
what it used to be.  dp->full_name behavior is still the same for sparc.


> > ---
> >  drivers/of/pdt.c |   42 +++++++++++++++++++-----------------------
> >  1 files changed, 19 insertions(+), 23 deletions(-)
> > 
> > diff --git a/drivers/of/pdt.c b/drivers/of/pdt.c
> > index 28295d0..b39d584 100644
> > --- a/drivers/of/pdt.c
> > +++ b/drivers/of/pdt.c
> > @@ -48,7 +48,7 @@ static inline void irq_trans_init(struct
> > device_node *dp) { } 
> >  static inline const char *of_pdt_node_name(struct device_node *dp)
> >  {
> > -	return dp->name;
> > +	return NULL;
> >  }
> 
> Rather than using this hook; perhaps the sparc .path_component_name
> should be enabled for all architectures.  It is a useful data item to
> keep a pointer to, and it would simplify the of_pdt code.
> 
> >  

Yeah, I considered that, but pkg2path works even better for our
purposes.


I'll combine patches and resend, thanks.
