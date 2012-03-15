Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759903Ab2COIHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 04:07:35 -0400
Received: from charybdis-ext.suse.de ([195.135.221.2]:7864 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756213Ab2COIHX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 04:07:23 -0400
Subject: Re: [PATCH] Added backlight driver for Acer Aspire 4736
From: joeyli <jlee@suse.com>
To: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <CABNxG=D3y2GQqS1XN=+B0QRScXpufBkPQtP5-SSNEjSavhtW7g@mail.gmail.com>
References: <1331608337.2267.67.camel@debian.Gayathri>
	 <20120312175130.GA18002@srcf.ucam.org>
	 <1331640592.3485.50.camel@debian.Gayathri>
	 <20120313124738.GB10822@srcf.ucam.org>
	 <CABNxG=Dqg26EHmC3vibf3-SjVhby1qgQfMniQObUeh9eJ6SwEw@mail.gmail.com>
	 <20120313133458.GA11574@srcf.ucam.org>
	 <1331688294.2577.19.camel@debian.Gayathri>
	 <1331680373.10557.169.camel@linux-s257.site>
	 <1331692996.3052.8.camel@debian.Gayathri>
	 <1331704278.10557.190.camel@linux-s257.site>
	 <CABNxG=D3y2GQqS1XN=+B0QRScXpufBkPQtP5-SSNEjSavhtW7g@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 15 Mar 2012 16:05:40 +0800
Message-ID: <1331798740.10557.245.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pradeep, 

於 三，2012-03-14 於 11:47 +0530，Pradeep Subrahmanion 提到：
> On Wed, Mar 14, 2012 at 11:21 AM, joeyli <jlee@suse.com> wrote:
> > 於 三，2012-03-14 於 08:13 +0530，Pradeep Subrahmanion 提到：
> >> Hi Joey ,
> >>
> >> > Per my understood, EC firmware should change brightness but didn't do
> >> > that, another
> >> > way is touch i915 register in _BCM.
> >>
> >>   how do we do this ? you mean change the _BCM implementation ?
> >
> > "BIOS guy" should do something like this:
> >
> >  Method (AINT, 2, NotSerialized)
> > {
> > ...
> >        If (LEqual (Arg0, One))
> >        {
> >            Store (Divide (Multiply (Arg1, 0xFF), 0x64, ), BCLP)
> >            Or (BCLP, 0x80000000, BCLP)         <=== touch BCLP register
> >            Store (0x02, ASLC)
> >        }
> >
> >    Method (_BCM, 1, NotSerialized)
> >    {
> >        If (LAnd (LGreaterEqual (Arg0, Zero), LLessEqual (Arg0, 0x64)))
> >        {
> >            AINT (One, Arg0)     <=== call AINT method
> >            Store (Arg0, BRTL)
> >        }
> >    }
> >
> >
> > Just for reference, they should do that when EC didn't wire to
> > backlight.
> >
> >> >
> >> > Acer machine provide a broken _BCM implementation and they didn't test
> >> > it.
> >> >
> >> > > > > By ' ACPI interface' , I mean 'acpi_video0' inside the
> >> > > > > /sys/class/backlight. I havn't tried the /sys/class/backlight interface
> >> > > > > directly . I will try that also.
> >> > > >
> >> > > > So writing values into /sys/class/backlight/acpi_video0/brightness does
> >> > > > nothing?
> >> > >
> >> > >
> >> > > No change in value when writing
> >> > > to /sys/class/backlight/acpi_video0/brightness.
> >> > >
> >> > > Another thing is that when i did boot with acpi_backlight = 'acer_wmi' ,
> >> > > in new kernel (3.3.0-rc7) , it shows following messages ,
> >> > >
> >> > > [    8.350825] wmi: Mapper loaded
> >> > > [   10.363975] acer_wmi: Acer Laptop ACPI-WMI Extras
> >> > > [   10.396186] acer_wmi: Function bitmap for Communication Device: 0x91
> >> > > [   10.396385] acer_wmi: Brightness must be controlled by generic video
> >> > > driver
> >> > >
> >> > > Also there was no interface inside /sys/class/backlight for acer_wmi.
> >> > >
> >> >
> >> > Yes, acer_wmi support backlight control with AMW0 interface, your
> >> > machine didn't have AMW0 interface.
> >> >
> >> > Normally, backlight should control by standard acpi interface.
> >> >
> >> > > I also tried writing directly to Embedded controller register .But no
> >> > > change.
> >> >
> >> > The machine has broken _BCM method, because EC should do something after
> >> > _BCM changed EC register.
> >>
> >> Thanks ,
> >>
> >> Pradeep Subrahmanion
> >
> > Why they didn't find _BCM not work?
> >
> > My guess is:
> >
> > Because the backlight control is through WDDM driver on Windows platform
> > but not through standard ACPI method _BCM. They only test Windows
> > platform, so, they didn't find _BCM broken.
> >
> > And, they also didn't really follow Microsoft WDDM spec:
> >
> >  http://msdn.microsoft.com/en-us/windows/hardware/gg487382.aspx
> >
> > Per spec,
> > ODM should keep _BCM works fine for any other OS didn't support WDDM
> > driver, but they didn't.
> >
> > At last year, I told Acer PM one time for this issue, they said will
> > check but finally didn't response me.
> >
> 
> >
> > Thanks
> > Joey Lee
> >
> 
> So touching the PCI LBB register is the only feasible solution now
> (even though it may not be a clean  method) ?
> 
> Thanks,
> Pradeep Subrahmanion

That will be better leave LBB register only touched by i915 driver.

If 'acpi_backlight=vendor' works to you, maybe we can add a quirk to
video_detect.c. 
You can try the following patch.


Thanks a lot!
Joey Lee


>From 038bd3c4e53b7195f34e9d46c999b8dcb279da5e Mon Sep 17 00:00:00 2001
From: "Lee, Chun-Yi" <jlee@suse.com>
Date: Thu, 15 Mar 2012 16:03:45 +0800
Subject: [PATCH] acer-wmi: Add quirk table for video backlight vendor mode

Add quirk table for video backlight vendor mode

Signed-off-by: "Lee, Chun-Yi" <jlee@suse.com>
---
 drivers/acpi/video_detect.c |   27 +++++++++++++++++++++++++++
 1 files changed, 27 insertions(+), 0 deletions(-)

diff --git a/drivers/acpi/video_detect.c b/drivers/acpi/video_detect.c
index f3f0fe7..acb15d6 100644
--- a/drivers/acpi/video_detect.c
+++ b/drivers/acpi/video_detect.c
@@ -132,6 +132,32 @@ find_video(acpi_handle handle, u32 lvl, void *context, void **rv)
 	return AE_OK;
 }
 
+static int video_set_backlight_vendor(const struct dmi_system_id *d)
+{
+	acpi_video_support |= ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
+	return 0;
+}
+
+static const struct dmi_system_id video_vendor_dmi_table[] = {
+	{
+	 .callback = video_set_backlight_vendor,
+	 .ident = "Acer Aspire 4736",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "Aspire 4736"),
+		},
+	},
+	{
+	 .callback = video_set_backlight_vendor,
+	 .ident = "Acer TravelMate 4750",
+	 .matches = {
+		DMI_MATCH(DMI_BOARD_VENDOR, "Acer"),
+		DMI_MATCH(DMI_PRODUCT_NAME, "TravelMate 4750"),
+		},
+	},
+	{}
+};
+
 /*
  * Returns the video capabilities of a specific ACPI graphics device
  *
@@ -164,6 +190,7 @@ long acpi_video_get_capabilities(acpi_handle graphics_handle)
 		 *		ACPI_VIDEO_BACKLIGHT_DMI_VENDOR;
 		 *}
 		 */
+		dmi_check_system(video_vendor_dmi_table);
 	} else {
 		status = acpi_bus_get_device(graphics_handle, &tmp_dev);
 		if (ACPI_FAILURE(status)) {
-- 
1.7.7



