Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756518Ab2CWE1s (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Mar 2012 00:27:48 -0400
Received: from nat.nue.novell.com ([195.135.221.2]:41527 "EHLO
	nat.nue.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753288Ab2CWE1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Mar 2012 00:27:41 -0400
Subject: Re: [PATCH] Added backlight driver for Acer Aspire 4736
From: joeyli <jlee@suse.com>
To: Pradeep Subrahmanion <subrahmanion.pradeep@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, rpurdie@rpsys.net,
        FlorianSchandinat@gmx.de, akpm@linux-foundation.org,
        linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1332473811.3051.5.camel@debian.Gayathri>
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
	 <1331798740.10557.245.camel@linux-s257.site>
	 <1332047432.6304.13.camel@debian.Gayathri>
	 <1332122514.10557.270.camel@linux-s257.site>
	 <1332241764.10557.329.camel@linux-s257.site>
	 <1332269710.3921.31.camel@debian.Gayathri>
	 <1332298845.10557.343.camel@linux-s257.site>
	 <1332473811.3051.5.camel@debian.Gayathri>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Mar 2012 12:25:39 +0800
Message-ID: <1332476739.10557.438.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

於 五，2012-03-23 於 09:06 +0530，Pradeep Subrahmanion 提到：
> On Wed, 2012-03-21 at 11:00 +0800, joeyli wrote:
> > think the hotkey of backlight control only works with acpi_osi=Linux ?
> 
> yes , hot key control only works with this option.Any ideas about where
> the hot key events gets handled ? I tried logging inside
> 'acpi_video_device_notify' method in video.c . But the control does not
> seem to reach here . 
> 
> Thanks, 
> 
> Pradeep Subrahmanion

Hotkey change status is through _Q11 and _Q12 event but not wmi:


    Method (_Q11, 0, NotSerialized)             /* Brightness down */
    {
        If (LGreaterEqual (OSYS, 0x07D6))       /* Vista or later */
        {
            If (LEqual (OBV, 0xFF))
            {
                Notify (^^^PEGP.VGA.LCD, 0x87)
            }
            Else
            {
                Notify (^^^OVGA.DD03, 0x87)
            }
        }
        Else                                    /* 0x07D1 (XP) or 0x03E8 (Linux) */
        {
            ^^^OVGA.AINT (One, BRTS)		/* access AINT, it touch BCLP register */
            If (LEqual (^^^WMID.BAEF, One))
            {
                Store (BRTS, Local1)
                Store (^^^WMID.LBL0, Local2)
                Add (Local2, Local1, Local2)
                Store (Local2, ^^^WMID.NTDC)
                Notify (WMID, 0x80)
            }
        }
    }

Method (AINT, 2, NotSerialized)
{
...
    Else
    {
        If (LEqual (Arg0, One))         /* Linux or XP */
        {
            Add (Arg1, One, Arg1)
            Store (Divide (Multiply (Arg1, 0xFF), 0x0A, ), BCLP)
            Or (BCLP, 0x80000000, BCLP)		/* touch BCLP register */
            Store (0x02, ASLC)
        }


That's why I said acpi_osi"!Windows 2006" should also works to you. Unfortunately,
there have something wrong in video driver for support this machine on XP mode.


thanks a lot!
Joey Lee

