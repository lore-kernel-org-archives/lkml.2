Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754858Ab2GQIlW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 04:41:22 -0400
Received: from e06smtp14.uk.ibm.com ([195.75.94.110]:37669 "EHLO
	e06smtp14.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab2GQIlT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 04:41:19 -0400
Date: Tue, 17 Jul 2012 10:39:10 +0200 (CEST)
From: Sebastian Ott <sebott@linux.vnet.ibm.com>
X-X-Sender: sebott@c4eb
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: Ming Lei <ming.lei@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: move uevent call to driver_register
In-Reply-To: <20120717014558.GA28969@kroah.com>
Message-ID: <alpine.LFD.2.02.1207171035350.1650@c4eb>
References: <alpine.LFD.2.02.1207021900100.1784@c4eb> <CACVXFVM+u+o=R0M31mqqzmtRN4YvqgUKvJZKfBYtgH15JDh3bQ@mail.gmail.com> <20120717014558.GA28969@kroah.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
Organization: =?ISO-8859-15?Q?=22IBM_Deutschland_Research_&_Development_GmbH_=2F_Vorsitzende_des_Aufsichtsrats=3A_Martina_Koederitz_Gesch=E4ftsf=FChrung=3A_Dirk_Wittkopp_Sitz_der_Gesellschaft=3A_B=F6blingen_=2F_Registergericht?=
 =?ISO-8859-15?Q?=3A_Amtsgericht_Stuttgart=2C_HRB_243294=22?=
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
x-cbid: 12071708-1948-0000-0000-0000026AE344
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 16 Jul 2012, Greg Kroah-Hartman wrote:
> On Tue, Jul 17, 2012 at 09:35:02AM +0800, Ming Lei wrote:
> > On Tue, Jul 3, 2012 at 1:08 AM, Sebastian Ott <sebott@linux.vnet.ibm.com> wrote:
> > 
> > > --- a/drivers/base/driver.c
> > > +++ b/drivers/base/driver.c
> > > @@ -187,6 +187,9 @@ int driver_register(struct device_driver
> > >         ret = driver_add_groups(drv, drv->groups);
> > >         if (ret)
> > >                 bus_remove_driver(drv);
> > > +
> > > +       kobject_uevent(&drv->p->kobj, KOBJ_ADD);
> > 
> > You should just send the uevent if 'ret' equals to zero., otherwise
> > OOPS may be triggered by kobject_uevent() after the 'drv' has been
> > removed.
> 
> Ugh, just missed that.
> 
> Sebastian, care to send a follow-on patch for this?

Here is the follow-on. (I've also replied with an updated patch..just in
case you want to take that one).

[PATCH] driver core: don't trigger uevent after failure

Do not send the uevent if driver_add_groups failed.

Found-by: Ming Lei <ming.lei@canonical.com>
Signed-off-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
---
 drivers/base/driver.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/base/driver.c
+++ b/drivers/base/driver.c
@@ -185,9 +185,10 @@ int driver_register(struct device_driver
 	if (ret)
 		return ret;
 	ret = driver_add_groups(drv, drv->groups);
-	if (ret)
+	if (ret) {
 		bus_remove_driver(drv);
-
+		return ret;
+	}
 	kobject_uevent(&drv->p->kobj, KOBJ_ADD);
 
 	return ret;

