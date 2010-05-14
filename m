Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760063Ab0ENWtz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 18:49:55 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:2464 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752139Ab0ENWtx (ORCPT
	<rfc822;groupwise-jlee@novell.com:7:1>);
	Fri, 14 May 2010 18:49:53 -0400
Message-Id: <4BEE602B020000230001928D@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 14 May 2010 16:49:47 -0600
From: "Joey Lee" <jlee@novell.com>
To: <dmitry.torokhov@gmail.com>, <gregkh@suse.de>
Cc: <mzxreary@0pointer.de>, <greg@kroah.com>, <rpurdie@linux.intel.com>,
       <mjg@redhat.com>, <linux-kernel@vger.kernel.org>,
       <platform-driver-x86@vger.kernel.org>
Subject: Re: [PATCH 4/4] msi-laptop: Add i8042 filter to sync sw state
	 with BIOS when function key pressed
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=__Part86AC2D9B.6__="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a MIME message. If you are reading this text, you may want to 
consider changing to a mail reader or gateway that understands how to 
properly handle MIME multipart messages.

--=__Part86AC2D9B.6__=
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline

Hi all, 

Thank's for Dmitry and Garg's review and point our my driver's problem.

Please kindly review my attached additional patch for clean up all
objects used by MSI scm model when driver initial fail or exit.




Thank's
Joey Lee

於 四，2010-05-13 於 15:54 -0700，Greg KH 提到：
> On Thu, May 13, 2010 at 05:53:04AM -0600, Joey Lee wrote:
> > Hi Dmitry, 
> > 
> > Thank's for your review.
> > 
> > 於 四，2010-05-13 於 00:52 -0700，Dmitry Torokhov 提到：
> > > On Wed, May 12, 2010 at 11:56:47AM -0700, Greg KH wrote:
> > > >  static int __init msi_init(void)
> > > > @@ -819,6 +875,7 @@ static void __exit msi_cleanup(void)
> > > >  	platform_driver_unregister(&msipf_driver);
> > > >  	backlight_device_unregister(msibl_device);
> > > >  
> > > > +	i8042_remove_filter(msi_laptop_i8042_filter);
> > > 
> > > You also need cancel_delayed_work_sync() here. Sorry for not noticing
> > > this before.
> > > 
> > 
> > Yes, you are right, need add cancel_delayed_work_sync().
> 
> Want to make up an additional patch to add on top of this that does it?
> 
> thanks,
> 
> greg k-h


--=__Part86AC2D9B.6__=
Content-Type: text/plain; name="0011-Clean-up-all-objects-used-by-scm-model-when-driver-i.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="0011-Clean-up-all-objects-used-by-scm-model-when-driver-i.patch"

>From 6dd1bf2049496e932e681534c0e1f0ffc0b7a47d Mon Sep 17 00:00:00 =
2001=0AFrom: Lee, Chun-Yi <jlee@novell.com>=0ADate: Sat, 15 May 2010 =
06:18:54 +0800=0ASubject: [PATCH] Clean up all objects used by scm model =
when driver initial fail or exit=0A=0AClean up i8042 filter, rfkill and =
cancel delayed work when msi-laptop driver initial fail or exit on MSI scm =
model.=0A=0ASigned-off-by: Lee, Chun-Yi <jlee@novell.com>=0A---=0A =
drivers/platform/x86/msi-laptop.c |   13 ++++++++++---=0A 1 files changed, =
10 insertions(+), 3 deletions(-)=0A=0Adiff --git a/drivers/platform/x86/msi=
-laptop.c b/drivers/platform/x86/msi-laptop.c=0Aindex cd2c15e..e536232 =
100644=0A--- a/drivers/platform/x86/msi-laptop.c=0A+++ b/drivers/platform/x=
86/msi-laptop.c=0A@@ -811,6 +811,11 @@ static int __init msi_init(void)=0A =
=0A fail_platform_device2:=0A =0A+	if (load_scm_model) {=0A+		=
i8042_remove_filter(msi_laptop_i8042_filter);=0A+		cancel_dela=
yed_work_sync(&msi_rfkill_work);=0A+		rfkill_cleanup();=0A+	=
}=0A 	platform_device_del(msipf_device);=0A =0A fail_platform_device1:=0A=
@@ -830,15 +835,17 @@ fail_backlight:=0A =0A static void __exit msi_cleanup=
(void)=0A {=0A+	if (load_scm_model) {=0A+		i8042_remove_filter=
(msi_laptop_i8042_filter);=0A+		cancel_delayed_work_sync(&msi_rfkil=
l_work);=0A+		rfkill_cleanup();=0A+	}=0A =0A 	sysfs_remov=
e_group(&msipf_device->dev.kobj, &msipf_attribute_group);=0A 	platform_de=
vice_unregister(msipf_device);=0A 	platform_driver_unregister(&msipf_d=
river);=0A 	backlight_device_unregister(msibl_device);=0A =0A-	=
i8042_remove_filter(msi_laptop_i8042_filter);=0A-	rfkill_cleanup();=
=0A-=0A 	/* Enable automatic brightness control again */=0A 	if =
(auto_brightness !=3D 2)=0A 		set_auto_brightness(1);=0A-- =
=0A1.6.0.2=0A=0A
--=__Part86AC2D9B.6__=--
