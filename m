Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758264Ab2B2RXE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 12:23:04 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:3807 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758031Ab2B2RXC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 12:23:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Wed, 29 Feb 2012 09:22:43 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 29 Feb 2012 09:22:42 -0800
Subject: RE: [PATCH V2 4/6] pinctrl: API changes to support multiple states
 per device
Thread-Topic: [PATCH V2 4/6] pinctrl: API changes to support multiple states
 per device
Thread-Index: Acz2rQ5bGSBuVie7Qaq921skLmGsxwAWOB4Q
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BDDF207C@HQMAIL01.nvidia.com>
References: <1330460852-23486-1-git-send-email-swarren@nvidia.com>
 <1330460852-23486-5-git-send-email-swarren@nvidia.com>
 <20120229064633.GA14703@shlinux2.ap.freescale.net>
In-Reply-To: <20120229064633.GA14703@shlinux2.ap.freescale.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dong Aisheng wrote at Tuesday, February 28, 2012 11:47 PM:
> On Tue, Feb 28, 2012 at 01:27:30PM -0700, Stephen Warren wrote:
...
> > +static struct pinctrl *find_pinctrl(struct device *dev)
> > +{
> > +	struct pinctrl *p;
> > +
> > +	list_for_each_entry(p, &pinctrldev_list, node)
>
> s/pinctrldev_list/pinctrl_list ?

Uggh. I could have sworn I fixed that before. Perhaps I had the same
silly error somewhere else too. Thanks for catching it.
> 
> > +static int pinctrl_select_state_locked(struct pinctrl *p,
> > +				       struct pinctrl_state *state)
...
> > +	if (p->state) {
> > +		/*
> > +		 * The set of groups with a mux configuration in the old state
> > +		 * may not be identical to the set of groups with a mux setting
> > +		 * in the new state. While this might be unusual, it's entirely
> > +		 * possible for the "user"-supplied mapping table to be written
> > +		 * that way. For each group that was configured in the old state
> > +		 * but not in the new state, this code puts that group into a
> > +		 * safe/disabled state.
>
> It means the old state function of some groups may not have been disabled before
> enabling the new function mode.
> May it be a little error-prone?
> Maybe we can not depend on user to disable a function before enable another for
> a group when doing pinmux_enable_setting considering they may be different
> registers.

The idea here is that there are two cases:

1) (hopefully the typical case)

Group X HAS a mux function set in OLD state
Group X HAS a mux function set in NEW state

In this case, we simply call pinmux_enable_setting(new state).

We do this so that we can transition directly from the old state to the
new state without going through any artificial intermediate states, to
make the mux switching as glitchless as possible.

If the HW has some restriction where it has to operate like:

Old state -> idle -> new state

Rather than:

Old state -> new state

Then I think that should be taken care of within the individual driver;
given most mux selection is just a register field that feeds into a simple
signal mux in HW, such a requirement seems pretty unlikely to me, but you
never know.

2)

Group X HAS a mux function set in OLD state
Group X DOES NOT have a mux function set in NEW state

In this case, we call pinmux_disable_setting(old state) to ensure that
the pin is put into some idle state that can't interfere with any other
pin.

-- 
nvpublic

