Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab2BWQkU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:40:20 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8282 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2BWQkS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:40:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Thu, 23 Feb 2012 08:40:00 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "B29396@freescale.com" <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 23 Feb 2012 08:39:58 -0800
Subject: RE: [PATCH 08/20] pinctrl: Assume map table entries can't have a
 NULL name field
Thread-Topic: [PATCH 08/20] pinctrl: Assume map table entries can't have a
 NULL name field
Thread-Index: Aczx5VAyuAp3EGWQRZSuFLXbEv5XiwAY7j0w
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC96D@HQMAIL01.nvidia.com>
References: <1329720360-23227-1-git-send-email-swarren@nvidia.com>
 <1329720360-23227-9-git-send-email-swarren@nvidia.com>
 <CACRpkdYK1epBfxPCu+cc3Edmd_9aZf4nvNyBx8O0sns5V+gNWw@mail.gmail.com>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC323@HQMAIL01.nvidia.com>
 <20120222063440.GB11087@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC6A9@HQMAIL01.nvidia.com>
 <20120223033510.GA9141@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC8E3@HQMAIL01.nvidia.com>
 <20120223035640.GC9141@shlinux2.ap.freescale.net>
 <74CDBE0F657A3D45AFBB94109FB122FF17BD8BC8EE@HQMAIL01.nvidia.com>
 <20120223044825.GD9141@shlinux2.ap.freescale.net>
In-Reply-To: <20120223044825.GD9141@shlinux2.ap.freescale.net>
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

Dong Aisheng wrote at Wednesday, February 22, 2012 9:48 PM:
> On Wed, Feb 22, 2012 at 07:53:44PM -0800, Stephen Warren wrote:
...
> > I'm hoping that we don't do this internal conversion. The rules I'd like are:
...
> > * Every mapping table entry must include a non-NULL name field.
> >
> > * Every call to pinctrl_get()/pinctrl_lookup_state() must pass a non-NULL name
>
> This is a way.
> 
> Before using this, i'm  still wondering what big problems do you think for us to support
> a NULL map name?
> Because the name for devices do not have different state really does not make too much
> sense but extra overhead.

If we disallow NULL names, it simplifies the code in the pinctrl core;
when registering mappings or right at the start of pinctrl_get() or
pinctrl_lookup_state(), we check if the name is NULL and if so error out.
Everywhere else can then assume name!=NULL, and hence not have special-
cases for name==NULL, e.g.:

In debug code:
name ? name : "(unnamed)"
vs.:
name

When matching mapping table entries:
match = !name ? !map->name : !strcmp(name, map->name)
vs.:
match = !strcmp(name, map->name)

Similar for the body of pinctrl_lookup_state().

Equally, it's not possible to generate a mapping table entry with a NULL
name from device tree given the bindings we discussed, so disallowing them
everywhere keeps things consistent.

-- 
nvpublic

