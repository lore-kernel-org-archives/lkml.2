Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752362Ab2GZSCf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 14:02:35 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47637 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2GZSCe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 14:02:34 -0400
Message-ID: <50118637.9060205@wwwdotorg.org>
Date: Thu, 26 Jul 2012 12:02:31 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: regulators: creating a regulator device for the AC/USB/BAT/charge
 component of a PMIC?
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark, Liam,

A couple of the regulators I'm looking at (I guess many/most in fact)
are structured as:

Battery, AC, USB, ... -> PMIC -> main output (unregulated?)

main output -> PMIC input pins for some of the SW-controllable
regulators. This is an external connection on the board.

Should this "main output" be represented as a regulator itself?

In more graphical/concrete terms, take the TPS6586x:

        +---------------+
        |               |
AC  --> | \             |
USB --> |  |------> SYS | >---\
BAT --> | /             |     |
        |       VIN_SM0 | <---/
        |         v     |
        |       SM0 OUT | ---> other devices
        ...

... where SM0 is one of the regulators the driver already exposes.

I assume SYS should be an explicit regulator device, because all the
other regulators within the PMIC can be set up to require that a supply
be specified (in the DT, a vin-sm0-supply property is mandatory for the
TPS6586x driver), so some regulator object must exist and be provided as
the supply.

The alternative would be to this would be to ignore this aspect of the
PMIC, and just create a standalone fixed regulator to act as the supply
for the SM0 regulator. However, this doesn't seem like an accurate model
of the HW.

However, some of the regulators in the TPS6586x at least are fed
directly from the SYS output by an internal connection within the PMIC
(e.g. LDO5). Currently, the driver sets up these regulators as having no
supply, which seems wrong too. Presumably the PMIC driver should
internally hook up its SYS as LDO5's supply without needing any platform
data or DT ldo5-supply property to do this?

What are your thoughts here?
