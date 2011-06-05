Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756048Ab1FEMQK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 08:16:10 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:42969 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755919Ab1FEMQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 08:16:09 -0400
Date: Sun, 5 Jun 2011 14:15:56 +0200
From: Borislav Petkov <bp@amd64.org>
To: Brian Gerst <brgerst@gmail.com>
Cc: "greg@kroah.com" <greg@kroah.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] sysdev: Do not register with sysdev when erroring
 on add
Message-ID: <20110605121556.GA3294@aftab>
References: <1296577197-9766-1-git-send-email-bp@amd64.org>
 <BANLkTikJ8jUVeEk=GuV6iaw2ASuOLPA4yw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikJ8jUVeEk=GuV6iaw2ASuOLPA4yw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 05, 2011 at 07:07:34AM -0400, Brian Gerst wrote:
> On Tue, Feb 1, 2011 at 11:19 AM, Borislav Petkov <bp@amd64.org> wrote:
> > From: Borislav Petkov <borislav.petkov@amd.com>
> >
> > When encountering an error while executing the driver's ->add method, we
> > should cancel registration and unwind what we've regged so far. The low
> > level ->add methods do return proper error codes but those aren't looked
> > at in sysdev_driver_register(). Fix that by sharing the unregistering
> > code.
> 
> This patch is causing boot failures on a virtual machine running
> Fedora 15 32-bit.  With this patch, the microcode driver repeatedly
> spews:
> microcode: CPU0: AMD CPU family 0x6 not supported
> modprobe: FATAL: Error inserting microcode: Invalid argument.
> until eventually causing an oops.  Reverting this patch allows the
> boot to proceed.

Yeah, we had a similar issue with a K8 machine on Fedora:
https://bugzilla.kernel.org/show_bug.cgi?id=35522

Another fix would be if you remove the *microcode.rules in
/etc/udev/rules.d/ which tries to load the microcode driver
continuously. The funny thing is, this happens only on Fedora - all the
other distros simply get the -EINVAL from the driver failing to load
and that's it. I guess Fedora's udev doesn't accept the error value and
continues to try to load the module.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
