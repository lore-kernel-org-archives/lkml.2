Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758079Ab2AEHfg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 02:35:36 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:15490 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758037Ab2AEHf3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 02:35:29 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 04 Jan 2012 23:35:29 -0800
From: Laxman Dewangan <ldewangan@nvidia.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Laxman Dewangan <ldewangan.com@nvidia.com>
CC: "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>
Date: Thu, 5 Jan 2012 13:05:25 +0530
Subject: RE: [PATCH V1] regulator: fixed: Move drivers to
	subsys_initcall_sync()
Thread-Topic: [PATCH V1] regulator: fixed: Move drivers to
	subsys_initcall_sync()
Thread-Index: AczLbyKO1iqS9QGKTlKicht3eSDNcgADEIIw
Message-ID: <96C9D994977DD0439FB6D3FE3B13DD907DBD3A9DEC@BGMAIL01.nvidia.com>
References: <1325693335-1905-1-git-send-email-ldewangan@nvidia.com>
 <20120105055900.GE11867@opensource.wolfsonmicro.com>
In-Reply-To: <20120105055900.GE11867@opensource.wolfsonmicro.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
Content-Language: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: linux-pm-owner@vger.kernel.org [mailto:linux-pm-owner@vger.kernel.org]
> On Behalf Of Mark Brown
> Sent: Thursday, January 05, 2012 11:29 AM


> > The fixed regulator is used to enable/disable rails which are
> > mainly controlled by the switch. The switches are toggled by
> > gpio apis.
> > The switches are connected through on-chip gpios or through
> > external devices' gpios like mfd, i2c based gpio expander etc.
> > The registration of the fixed regulator get success only if the
> > required gpios are already available in the system at this time.
> > The on-chip gpios are available till this time as on-chip gpios
> > are initialized in arch_init(). But external peripheral's gpios
> > may not be available at this time as they get initialized as part
> > of subsys_initcall() and due to this registration of the fixed
> > regulator may fails.
> > Moving the driver to subsys_initcall_sync() will make sure that
> > all gpios i.e. on-chip gpios as well as external peripheral's gpios
> > are available before fixed regulator registration.
> 
> I don't really think this is worth faffing about with, it seems at least
> as likely to create more problems with things that depend on the
> regulator as it is to make the regulator work.  Really we need Grant's
> probe retry stuff or something else to solve the init ordering issues
> properly.
Yes, I agree, the init ordering need to be done properly but this is how we
have as of now to make ordering.
I have the switchA which is connected on regulatorA (from PMIC) and the
switchB which is in the gpio of the pmic. The fixed regulator registration for
switchA and switchB are failing because it did not found the valid supply/gpio.
The one way to resolve the call probe of the fixed regulator only when pmic
initialization is done and it is in subsys_init().
The other way is to do the platform device registration of the fixed regulator
is in subsys_initcall_sync() in place of arch_init, although driver is in
subsys_initcall() to postponed the probe calling.

What do you suggest on this case?

