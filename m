Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab0CXQyw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 12:54:52 -0400
Received: from web94905.mail.in2.yahoo.com ([203.104.17.152]:26008 "HELO
	web94905.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932292Ab0CXQyu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 12:54:50 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.in;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=ZL30eCswwFpURsPIXrDGqsk3Rt2CNtOzs3Qzg803ZkYBMN+p/BMDZhFsX3eQx7vJC8YCpnPhK9rggNaKEftk9VM4mzlVUz8WfZpuca5OyNBEhTrDnwDM1GIiMf0moyQrtNsAKbzLou1Nfi20pSqdNpySSXBQQceFxB5gt2zBwmM=;
Message-ID: <132027.10140.qm@web94905.mail.in2.yahoo.com>
X-YMail-OSG: Pt_nkY4VM1kcxGjlGv5ZLdVoU9tn91RPej5xF_oHBb0mP7v
 fwvXzdgXeR.5MifwXcrR.k7LyeqVl_TitgXCnBKdoHP1usSk4V83ll7GKXs7
 YhAnxTYZT37eLlWhNuiCVudlgyBjl8SrlNPy56WjUgVCeVC5G_jtxLlse8CN
 9NH9YA20JfC3e6mKUqdx5iM0MbXM6lLBEOBl.6f0iKfYwdv5HW1N7WOyEzyf
 spo9qa3YsQJ3Kvw0H2t6nuOxqaH1fNN_h9PSBwZIon14LkfB_q2FPdIT99eO
 ojo78SbYd6GqLiPegwXh6yPM-
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Wed, 24 Mar 2010 22:24:44 +0530 (IST)
From: Pavan Savoy <pavan_savoy@yahoo.co.in>
Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Greg KH <gregkh@suse.de>, PavanSavoy <pavan_savoy@ti.com>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1269448680.11714.121.camel@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--- On Wed, 24/3/10, Marcel Holtmann <marcel@holtmann.org> wrote:

> From: Marcel Holtmann <marcel@holtmann.org>
> Subject: Re: [PATCH 4/6] drivers:misc: sources for Init manager module
> To: "Pavan Savoy" <pavan_savoy@yahoo.co.in>
> Cc: "Greg KH" <gregkh@suse.de>, "PavanSavoy" <pavan_savoy@ti.com>, "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
> Date: Wednesday, 24 March, 2010, 10:08 PM
> Hi Pavan,
> 
> > > > I wanted to somehow put this in staging
> because then
> > > it would probably have a thorough architectural
> review
> > > process.
> > > > Some details about this driver - 
> > > > 
> > > > 1. This driver will be used by
> Bluetooth-BlueZ/FM-V4L2
> > > and GPS (probably character device driver) using
> the
> > > EXPORTED symbols (-register/_unregister).
> > > > 
> > > > 2. Much like the hciattach daemon which
> maintains
> > > N_HCI bluetooth line discipline, this driver will
> also have
> > > a User-Space  N_TI_WL Init manager (UIM)
> maintaining
> > > the Line discipline.
> > > 
> > > can you explain why you think this is needed and
> we can not
> > > interface
> > > this directly. If it is a serial port, what
> protocol does
> > > it talk?
> > 
> > Illustration: The BT driver on top of this ST driver,
> would create a hci0 interface, when someone does an DEVUP on
> that interface, the BT driver would then do a st-register -
> which in-turn would ask the hciattach-like daemon to install
> the line discipline for it via the sysfs entry.
> > The same concept goes for FM-V4L2 and GPS character
> driver.
> > 
> > The core of the problem is we cannot
> ask/install/ldisc_put for a line discipline from kernel
> space.
> 
> so let us get the facts straight here. The device in
> question is using a
> serial port to connect to the host and then multiplexing
> BT, FM and GPS
> over it. My question again, what protocol does it talk.

Ok, On TTY/4-wire UART, BT talks standard HCI, and HCI-LL for power management as in hci_ll.c/hciattach_ti.c which is already upstream.

And in a very similar way, FM talks over what is known as "channel 8" and GPS over "channel 9", Although these are not standard.

So, basically data going/coming to/out of chip is 
1,2,3,4 - HCI 
30,31,32,33 for HCI-LL
8 - FM
9 - GPS.

So consider this an extension of hci_ll/hci_ldisc but only more features to accomodate the FM and GPS.

> 
> Also why not just install the line discipline and then
> control the
> subdevices via RFKILL?

The chip side PM would be fine, and is being done so, st_kim.c creates the rfkill entries, and controls them locally, also allows applications to control them.
But ldisc can't be install upon boot, because UART clks would be used up for no reason at all.
(say on a mobile phone, how many times in a day - do we actually use BT/FM or GPS - so UART needs to be most often idle, and ldisc should be installed only upon requirement)

> 
> You need to share some information about your hardware with
> us that
> explain what are your objections and how it works.

Ok, I am already talking to my managers as to how much I can reveal etc..

> 
> > > > 3. Because of the UIM should know when to
> > > install/uninstall line discipline, the /sys entry
> is created
> > > a root called UIM (a new kobject) and UIM daemon
> would write
> > > it's PID to it.
> > > 
> > > I don't understand this. This sounds like a
> broken concept
> > > to me.
> > 
> > Yes, I don't feel good about it either. But how do I
> request for a line discipline from kernel space ?
> > Currently a daemon has to run in user-space to
> maintain the ldisc, at all times, and I don't want to open
> TTY @ boot, and install Ldisc (tiocsetd) on it, without
> BT/FM or GPS core on chip being used - The Power Management
> team here would beat me up if I do that, 
> > and hence the very dumb idea of passing the PID of the
> daemon via sysfs entry, and the driver sending SIGUSR2 to
> that PID, daemon doing a tiocsetd upon that signal.
> 
> Lets forget about this at all. This is not working out at
> all. We need
> to figure out a workable solution.

Yes, couple were discussed, like creating a device node, and UIM would open device node, and ldisc driver then can do a fasync/SIGIO upon it - Sounds complex for a simplistic job.
Any more suggestion ?

requirement is the daemon should open/set-baud/and then TIOCSETD only upon requirement for either BT, FM or GPS.
which is currently only known to ldisc driver via the st_register function.

> > > > 4. As Alan suggested, If I make it
> self-contained by
> > > pushing number of line disciplines to a slightly
> larger
> > > number, then would it be OK ?
> > > 
> > > Just from a quick look, I think within a few
> review cycles
> > > this might be
> > > able to get proper upstream inclusion. No idea
> why bother
> > > with staging
> > > in the first place. Lets do this correctly.
> > > 
> > 
> > The only reason I wanted this to be in staging was to
> have sort of continuous review process, and in hope the
> driver wouldn't be forgotten.
> 
> I dislike using the staging tree as review process. We can
> make a proper
> review on LKML and go towards a real upstream solution.

Well, the idea is the driver isn't forgotten when this sort of thing happens.
Controversial (may be wrong) concepts like sending signal from kernel to user-space, parsing the script request via firmware class, creating a root kobject just to create a sysfs entry.

I am ok with it going in staging or not - but just want the review to happen, and thanks a lot for having a look.

> Regards
> 
> Marcel
> 
> 
> 


      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
