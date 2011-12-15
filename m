Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758928Ab1LOPAq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:00:46 -0500
Received: from ch1ehsobe004.messaging.microsoft.com ([216.32.181.184]:8012
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751651Ab1LOPAp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:00:45 -0500
X-SpamScore: -11
X-BigFish: VS-11(zzbb2dI9371I1432N98dKzz1202hzz8275bh8275dhz2dh2a8h668h839h944h)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-FB-SS: 13,
Date: Thu, 15 Dec 2011 23:13:36 +0800
From: Shawn Guo <shawn.guo@freescale.com>
To: Rob Herring <robherring2@gmail.com>
CC: Grant Likely <grant.likely@secretlab.ca>, Jamie Iles <jamie@jamieiles.com>,
        Sascha Hauer <kernel@pengutronix.de>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        Mike Turquette <mturquette@ti.com>
Subject: Re: [RFC v2 4/9] of: add clock providers
Message-ID: <20111215151335.GB2831@S2100-06.ap.freescale.net>
References: <1323727329-4989-1-git-send-email-grant.likely@secretlab.ca>
 <1323727329-4989-4-git-send-email-grant.likely@secretlab.ca>
 <20111212232903.GC2616@gallagher>
 <CACxGe6t50zJNpo=QWPzgFMpQ6Cfi9YZyrKuMSTrrA2oYiLF2Pw@mail.gmail.com>
 <20111215135129.GA2831@S2100-06.ap.freescale.net>
 <4EEA02D5.9020309@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4EEA02D5.9020309@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 08:23:17AM -0600, Rob Herring wrote:
> 
> 
> On 12/15/2011 07:51 AM, Shawn Guo wrote:
> > On Tue, Dec 13, 2011 at 10:54:58AM -0700, Grant Likely wrote:
> >> On Mon, Dec 12, 2011 at 4:29 PM, Jamie Iles <jamie@jamieiles.com> wrote:
> >>> Hi Grant,
> >>>
> >>> I'm still going through these and trying to digest them but a couple of
> >>> quick questions/comments.
> >>>
> >>> Jamie
> >>>
> >>> On Mon, Dec 12, 2011 at 03:02:04PM -0700, Grant Likely wrote:
> >>>> diff --git a/Documentation/devicetree/bindings/clock/clock-bindings.txt b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> >>>> new file mode 100644
> >>>> index 0000000..e40c436
> >>>> --- /dev/null
> >>>> +++ b/Documentation/devicetree/bindings/clock/clock-bindings.txt
> >>>> @@ -0,0 +1,114 @@
> >>>> +This binding is a work-in-progress, and are based on some experimental
> >>>> +work by benh[1].
> >>>> +
> >>>> +Sources of clock signal can be represented by any node in the device
> >>>> +tree.  Those nodes are designated as clock providers.  Clock consumer
> >>>> +nodes use a phandle and clock specifier pair to connect clock provider
> >>>> +outputs to clock inputs.  Similar to the gpio specifiers, a clock
> >>>> +specifier is an array of one more more cells identifying the clock
> >>>> +output on a device.  The length of a clock specifier is defined by the
> >>>> +value of a #clock-cells property in the clock provider node.
> >>>> +
> >>>> +[1] http://patchwork.ozlabs.org/patch/31551/
> >>>> +
> >>>> +==Clock providers==
> >>>> +
> >>>> +Required properties:
> >>>> +#clock-cells:           Number of cells in a clock specifier; typically will be
> >>>> +                set to 1
> >>>
> >>> I'm not sure I fully understand what the extra cells actually mean for
> >>> clocks.  I think the first integer is the clock output to use but some
> >>> of the versatile and highbank ones only have a phandle or is it more
> >>> implementation defined?  The clock-output-names description hints at
> >>> recommended, so I find this a little confusing, but that could just be
> >>> me!
> >>
> >> I'm following convention here that has been established with
> >> interrupts, gpios, and others.  Sometimes more information is needed
> >> that just the clock number.  Using #clock-cells gives a clock provider
> >> the option of having additional fields for clock flags or other data.
> >> This is very much implementation defined.  Simple clock providers that
> >> only have a single clock output can easily use #clock-cells = <0>.
> >> Providers with multiple outputs will need to use 1 or more cells.
> >>
> > It totally destroys my understanding on #clock-cells :)
> > 
> > I thought it's introduced to reduce the clock nodes in dts.  That said,
> > #clock-cells stands for the number of clks we describe in the node.
> > When #clock-cells > 1 for a node, the node becomes a clk blob which
> > actually contains multiple clks.  I migrated the imx6 clock to your
> > first post with this approach [1], using 70 nodes to describe 110
> > clocks (~35% nodes reduced).
> > 
> > Now, you are saying it's not designed for this purpose.  I'm pretty
> > confused, because the only reasonable use of #clock-cells to me is
> > just that way, and I fail to see why we need #clock-cells if we do
> > not use it that way.
> > 
> > http://comments.gmane.org/gmane.linux.drivers.devicetree/9631
> 
> Think of clock-cells as the size of array elements (minus 1), not the
> number of array elements. If you have more than 1 clock per node, then
> you need more information on the clock input side than just a phandle to
> describe which clock you are using. Typically this would just be the
> phandle plus index of the clock you want. This is just like gpio where
> you have controller phandle plus gpio line number.
> 
It seems I misunderstood/misused the #clock-cells.  So even we have
multiple clks embedded in a node, #clock-cells=1 works for most of the
cases, since what really matters is just the index of the clk we want
the phandle to point to.  And the clock driver has to figure out how
many clks are in there by some other means.  Correct me please, if I
still misunderstand it.

-- 
Regards,
Shawn

