Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753868Ab2A0K0W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 05:26:22 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:38544
	"EHLO AM1EHSOBE001.bigfish.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751525Ab2A0K0U convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 05:26:20 -0500
X-SpamScore: -20
X-BigFish: VPS-20(zz9371I1432N98dKzz1202hzz15d4R8275bhz2dhc1bhc31hc1ah668h839h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LYGCZJ-02-65H-02
X-M-MSG: 
Date: Fri, 27 Jan 2012 11:26:08 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: <iommu@lists.linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        David Brown <davidb@codeaurora.org>, Tony Lindgren <tony@atomide.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Stuart Yoder <b08248@gmail.com>, Scott Wood <scottwood@freescale.com>,
        Hiroshi Doyu <hdoyu@nvidia.com>
Subject: Re: [PATCH 2/6] iommu/amd: Implement DOMAIN_ATTR_GEOMETRY attribute
Message-ID: <20120127102608.GK19255@amd.com>
References: <1327603257-17028-1-git-send-email-joerg.roedel@amd.com>
 <1327603257-17028-3-git-send-email-joerg.roedel@amd.com>
 <CAK=WgbbZB0hGRr84JV4a7c0KvW7VbVzsnCx1PGg=wjoB0OSrYw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
In-Reply-To: <CAK=WgbbZB0hGRr84JV4a7c0KvW7VbVzsnCx1PGg=wjoB0OSrYw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

On Fri, Jan 27, 2012 at 09:08:44AM +0200, Ohad Ben-Cohen wrote:
> On Thu, Jan 26, 2012 at 8:40 PM, Joerg Roedel <joerg.roedel@amd.com> wrote:
> > Implement the attribute itself and add the code for the
> > AMD IOMMU driver.
> 
> It's somewhat non-intuitive to have the generic attribute code bundled
> with the AMD implementation in the same patch (took me some time to
> find it here :).
> 
> Maybe split this to two patches ?

Yes, that is not ideal. I'll probably split it or move the generic part
to the first patch.

> > diff --git a/drivers/iommu/iommu.c b/drivers/iommu/iommu.c
> > index ef54718..3d0b0bf 100644
> > --- a/drivers/iommu/iommu.c
> > +++ b/drivers/iommu/iommu.c
> > @@ -345,10 +345,23 @@ EXPORT_SYMBOL_GPL(iommu_device_group);
> >  int iommu_domain_get_attr(struct iommu_domain *domain,
> >                          enum iommu_attr attr, void *data)
> >  {
> > -       if (!domain->ops->domain_get_attr)
> > -               return -EINVAL;
> > +       struct iommu_domain_geometry *geometry;
> > +       int ret = 0;
> > +
> > +       switch (attr) {
> > +       case DOMAIN_ATTR_GEOMETRY:
> > +               geometry  = data;
> > +               *geometry = domain->geometry;
> 
> This is not type-safe and will surely bite someone some day.
> 
> Sure, we can't have type safety in a multi-purpose generic interface,
> but I wonder whether this is the right interface for getting the
> geometry ? I.e. why not have a dedicated API for this ?

I fell also uncomfortable with the missing type-safety of this
interface. But the alternative is to have dedicated functions for
set/get each attribute. Well, it depends on how many attributes we have
in the end, but given that the PAMU guys already have need for a number
of hardware specific attributes it is likely that having individual
functions makes the api too complex in the end.

But probably we can replace the 'void *data' with a 'union
domain_attr'? This will give us some type-safety.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

