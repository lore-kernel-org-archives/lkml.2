Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755781Ab0LJPhd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 10:37:33 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44480 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251Ab0LJPhb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 10:37:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type;
        b=P4VLrw6uuv6WGvzTcPv113kndBBYKfPQrRlgZuCa/KW12vaPtTf1KSXYyYp9vUfrrK
         V3DTAjN7cskg8h12T21HQ+73nFsLLSDq+JRcmfDYTEbbxQ2m2/UYQjirWFXvPPfLIQPE
         xeL012LYOiSPdqC87kIsnluiEQRvCapgXhnNQ=
MIME-Version: 1.0
From: Daniel Drake <dsd@laptop.org>
Date: Fri, 10 Dec 2010 15:37:30 +0000
X-Google-Sender-Auth: ffycJCIk2mEFBmezErLnBhLRQyU
Message-ID: <AANLkTinrF-dxiw7OQ=dMhQPgKSqS6yYfDzdcnHfhMtyf@mail.gmail.com>
Subject: MFD cell structure and sharing of resources
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Paul Fox <pgf@laptop.org>, Andres Salomon <dilinger@queued.net>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

I'm hoping you can give us your opinion on a design challenge we are facing.
You recently merged Andres's recent patches to convert cs5536 to a
MFD, with GPIO and MFGPT now as mfd cells.

We also have the olpc-xo1 driver specific to a specific laptop model,
providing power management functions, and this needs to use the cs5536
resources "acpi" and "pms".
https://patchwork.kernel.org/patch/278991/

At the same time, we are working on other improvements to olpc-xo1
(adding suspend/resume support). Due to review comments we are going
to rename this to olpc-xo1-pm and make it builtin only.

Then we are going to add a new driver, perhaps named olpc-xo1-sci,
which deals with things like power button input device, lid switch,
etc. This driver needs to use the "cs5536-acpi" resource which is also
used by olpc-xo1-pm.

So the question is: how can 2 drivers share this MFD resource?

We do not want to merge olpc-xo1-sci and olpc-xo1-pm, because
olpc-xo1-pm can only be builtin (but thankfully is small), and
olpc-xo1-sci will become a bit more bloated and we'd like to make that
modular (in the interests of generic distros).

A few options that spring to mind:

1. Adjust the list of mfd cells in drivers/mfd/cs5535-mfd so that
rather than being a list of resources, it is a list of drivers that
rely on the mfd driver. The entries would be: gpio, mfgpt,
olpc-xo1-pm, olpc-xo1-sci. olpc-xo1-pm would have the 2 resources it
needs (pms & acpi), and the acpi resource would be duplicated into
olpc-xo1-sci  too.

We'd then add a machine_is_olpc()  check inside cs5535-mfd so that the
OLPC-specific cells are only passed to mfd_add_devices on OLPC
laptops.

2. Continue with Andres' olpc-xo1-pm patch that makes that driver act
as a driver for both acpi & pms. When both resources are available, it
could probe an olpc-xo1-sci platform device as a child of itself,
having the ACPI resource shared on the platform_device level (similar
to how MFD shares resources via cells).

3. For olpc-xo1-pm and olpc-xo1-sci, forget about hooking into MFD and
go back to the route of looking for the appropriate device on the PCI
bus and accessing the regions that way.


Thoughts?

Thanks,
Daniel
