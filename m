Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab2DKUEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 16:04:40 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:45315 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756050Ab2DKUEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 16:04:39 -0400
Date: Wed, 11 Apr 2012 22:04:27 +0200
From: Borislav Petkov <bp@amd64.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Andreas Herrmann <andreas.herrmann3@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Subject: Re: x86, microcode: Conversion from sysdev class caused regression
Message-ID: <20120411200427.GD18114@aftab>
References: <20120411163849.GE4794@alberich.amd.com>
 <CAPXgP11mjyK7vJoQtsSf3kD-SYn6d_Y9feobY9KiiSYcFqOwwA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP11mjyK7vJoQtsSf3kD-SYn6d_Y9feobY9KiiSYcFqOwwA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+ Dave.

On Wed, Apr 11, 2012 at 07:06:21PM +0200, Kay Sievers wrote:
> > The reason for the error is that subsys_interface_register() doesn't
> > handle the return value of sif->add_dev (and there's also no unwinding
> > of the interface registration). Instead subsys_interface_register
> > always returns 0.
>
> Which is the intended behaviour of 'subsystem interfaces' from the
> driver-core perspective. It should not matter if one of a bunch of
> devices do not 'like' this 'interface'. It is the same model as a
> 'driver', we do not cancel the link-in of a driver if one device does
> not like the driver.

But you're not looking at the return value of sif->add_dev which looks
strange to me. Let me put it this way: why do you have return values to
->add_dev's interface then if you're not going to look at them?

A warning that one of the dev_add's failed could probably make sense
here...

[..]

> I think a quick return in the microcode driver, for a device which has
> no active interface state is the best solution here.

Actually, it is even easier: the code clumsily does:

sysfs_create_group
microcode_init_cpu
if (err)
	sysfs_remove_group

so we go and create sysfs group, THEN check whether this CPU is
supported and if not, remove the group again which is a bunch of crap if
you ask me. The right way to go should be:

microcode_init_cpu
if (err)
	return;
sysfs_create_group

and then there's no need to do all that sysfs group dancing. Andreas,
let me know if you wanna do it, or I should take care of it.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
