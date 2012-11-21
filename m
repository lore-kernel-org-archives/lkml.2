Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220Ab2KUPmb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:42:31 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:36857 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755106Ab2KUPma convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:42:30 -0500
MIME-Version: 1.0
Message-ID: <6912a721-cd5b-4c12-91b2-795eb58ace66@default>
Date: Wed, 21 Nov 2012 07:42:19 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jan Beulich <JBeulich@suse.com>
Cc: xen-devel@lists.xen.org, Konrad Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: RE: [Xen-devel] [PATCH] xen: tmem: selfballooning should be enabled
 when xen tmem is enabled
References: <748aba10-531a-4ad5-bad3-7af0f86c0489@default>
 <50AC9CFF02000078000AA43C@nat28.tlf.novell.com>
In-Reply-To: <50AC9CFF02000078000AA43C@nat28.tlf.novell.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6665.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Jan Beulich [mailto:JBeulich@suse.com]
> Sent: Wednesday, November 21, 2012 1:21 AM
> To: Dan Magenheimer
> Cc: xen-devel@lists.xen.org; Konrad Wilk; linux-kernel@vger.kernel.org
> Subject: Re: [Xen-devel] [PATCH] xen: tmem: selfballooning should be enabled when xen tmem is enabled
> 
> >>> On 20.11.12 at 23:42, Dan Magenheimer <dan.magenheimer@oracle.com> wrote:
> > Konrad: Any chance this can get in for the upcoming window?
> > (Or is it enough of a bug fix that it can go in at an -rcN?)
> >
> > It was just pointed out to me that some kernels have
> > cleancache and frontswap and xen_tmem enabled but NOT
> > xen_selfballooning!  While this configuration should be
> > possible, nearly all kernels that have CONFIG_XEN_TMEM=y should
> > also have CONFIG_XEN_SELFBALLOONING=y, since Transcendent
> > Memory (tmem) for Xen has very limited value without
> > selfballooning.
> >
> > This is probably a result of a Kconfig mistake fixed I think
> > by the patch below.  Note that the year-old Oracle UEK2 kernel
> > distro has both CONFIG_XEN_TMEM and CONFIG_XEN_SELFBALLOONING
> > enabled, as does a Fedora 17 kernel update (3.6.6-1.fc17), so
> > the combination should be well tested.  Also, Xen tmem (and thus
> > selfballooning) are currently only enabled when a kernel boot
> > parameter is supplied so there is no runtime impact without
> > that boot parameter.
> >
> > Signed-off-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> >
> > diff --git a/drivers/xen/Kconfig b/drivers/xen/Kconfig
> > index d4dffcd..b5f02f3 100644
> > --- a/drivers/xen/Kconfig
> > +++ b/drivers/xen/Kconfig
> > @@ -10,9 +10,9 @@ config XEN_BALLOON
> >  	  return unneeded memory to the system.
> >
> >  config XEN_SELFBALLOONING
> > -	bool "Dynamically self-balloon kernel memory to target"
> 
> Why would you want to take away the configurability of this?
> You wanting it always on in your use case doesn't mean everyone
> agrees. This would be the right way only when the option being
> off despite all its dependencies being enabled is actively wrong.

I'd like it to be configurable, but my config steps
(e.g. yes "" | make oldconfig, after enabling CLEANCACHE and
FRONTSWAP and XEN_TMEM) failed to enable it.  Removing the
prompt is the only thing that worked.
 
> > -	depends on XEN && XEN_BALLOON && CLEANCACHE && SWAP && XEN_TMEM
> > -	default n
> > +	bool
> > +	depends on XEN_BALLOON && SWAP
> > +	default y if XEN_TMEM
> 
> Changing the default, otoh, is certainly acceptable. However, this
> should imo be (assuming that you dropped the CLEANCACHE
> dependency for an unrelated [and unexplained] reason),
> 
> 	depends on XEN_BALLOON && SWAP && XEN_TMEM
> 	default XEN_TMEM
> 
> i.e. the default selection can be simplified, but if you indeed
> have a good reason to drop the prompt, the
> dependencies should continue to include the symbol referenced
> by the default directive, as otherwise you may end up with a
> .config pointlessly having
> 
> # CONFIG_XEN_SELFBALLOONING is disabled. This is particularly
> annoying when subsequently this gets a prompt re-added, since
> at that point a "make oldconfig" won't ask for the item to get
> possibly enabled as there is a value known for it already.
> 
> >  	help
> >  	  Self-ballooning dynamically balloons available kernel memory driven
> >  	  by the current usage of anonymous memory ("committed AS") and
> 
> If you take away the prompt, keeping the help text isn't useful
> either.

Thanks for the feedback.  I'm an idiot with Kconfig and have
to play with it until it works as I expect.  Since Konrad
isn't going to accept it for the upcoming window anyway,
I'll play with it some more, but if the answer is obvious,
please spoon feed it to me. :-)

Dan

P.S. I removed the CLEANCACHE dependency because that dependency
is present for XEN_TMEM and I assumed dependencies are transitive.
