Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759587Ab0I1HSc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 03:18:32 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:27734 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754086Ab0I1HSb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 03:18:31 -0400
Date: Tue, 28 Sep 2010 09:17:59 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Cc: Jan Beulich <JBeulich@novell.com>,
        "r.marek@assembler.cz" <r.marek@assembler.cz>,
        "fenghua.yu@intel.com" <fenghua.yu@intel.com>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: x86/hwmon: conditionalize coretemp's dependency on PCI
Message-ID: <20100928091759.421b5bf2@endymion.delvare>
In-Reply-To: <20100927130220.GA2277@ericsson.com>
References: <4C8E18790200007800015AF7@vpn.id2.novell.com>
	<20100924185509.GA20155@ericsson.com>
	<4CA05F220200007800018F81@vpn.id2.novell.com>
	<20100927121650.GB31847@ericsson.com>
	<4CA0AE5E0200007800019097@vpn.id2.novell.com>
	<20100927130220.GA2277@ericsson.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Mon, 27 Sep 2010 06:02:20 -0700, Guenter Roeck wrote:
> On Mon, Sep 27, 2010 at 08:46:54AM -0400, Jan Beulich wrote:
> > Guenter Roeck <guenter.roeck@ericsson.com> wrote:
> > > Seems to me the dependency should not exist in the first place, then.
> > > Otherwise, the driver would still be disabled for GENERIC_CPU, which isn't
> > > good either.
> > 
> > Oh, not having a dependency on PCI at all would be even better.
> > I didn't dare to suggest that.
> > 
> > > Are there examples of other drivers which are not defining the PCI 
> > > dependency
> > > but are conditionally calling pci functions ?
> > 
> > I'm not aware of any, but also didn't explicitly look for such.
>
> It still compiles if I remove the PCI dependency and disable PCI. So that is one plus.
> 
> That whole dependency is just to get the host bridge ID which is then used
> to determine tjmax. Personally I would prefer to have a wrong tjmax over not having 
> coretemp at all,

No! Reporting broken monitoring values is worse than not returning any
value at all. The coretemp (and k8/k10temp) driver(s) already have a
very bad reputation for presenting relative temperature readings as
absolute ones, please let's not add to it.

At this point there are 2 things which can be done:
* If building a kernel for the Atom platform without PCI support is
  something relatively common, which makes sense, then we should look
  for an alternative way to determine the TjMax value for these CPUs,
  which doesn't require PCI support.
* If building a kernel for the Atom platform without PCI support is
  something rare, which makes little sense, then we can simply either
  prevent the driver from building at all in this case, or have it
  print a big fat warning (with suggestion to rebuild the kernel with
  PCI support) when it can't determine the TjMax value.

> and the means to determine tjmax through the bridge ID is kind
> of bogus anyway.

Do you mean it is strange from a technical perspective, or do you have
evidences that it doesn't work properly? This trick come from Intel
themselves, I would guess they know their business.

> So at least in this case it would make sense for me to remove
> the dependency completely. Actually, we won't even change functionality,
> since tjmax is only set to a higher value for specific bridge IDs.

Higher or lower doesn't make a difference. As long as the coretemp
driver doesn't properly report the temperature values as being
relative, users don't expect the value to change depending on the
kernel version or configuration options. We have had dozens of user
reports because of this.

-- 
Jean Delvare
