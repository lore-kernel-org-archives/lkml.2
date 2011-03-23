Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933275Ab1CWQMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 12:12:20 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61595 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933245Ab1CWQMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 12:12:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: RFC: Platform data for onboard USB assets
Date: Wed, 23 Mar 2011 17:12:05 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: andy.green@linaro.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        grant.likely@secretlab.ca
References: <4D79F068.2080009@linaro.org> <201103231132.02690.arnd@arndb.de> <20110323150852.GE6284@kroah.com>
In-Reply-To: <20110323150852.GE6284@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103231712.06184.arnd@arndb.de>
X-Provags-ID: V02:K0:UxXjnjWDS1IqhTziViQnR/fUznxoaCPDPMkt55yos7A
 OCuwzwUITYmXNHOLd0u9H2f/wfc1kesq4+7ec+Zna5Tea1uBB7
 /ex0lzCE1RIliEXtuRPkVC5VBOOLGS4jvWjF11nUPZ04T1WaBY
 wwGAwWV8N9Cm4D0Fks7UsycMy68UtCZSSd7FI7obxc/MgGfUMF
 REtRgBp23PLHp3ZTNUeyQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 March 2011, Greg KH wrote:
> On Wed, Mar 23, 2011 at 11:32:02AM +0100, Arnd Bergmann wrote:
> > On Wednesday 23 March 2011, Andy Green wrote:
> > > It's the case for even usbnet, which is using a broken heuristic to 
> > > decide what to call the interface not even based on vid / pid.
> > 
> > I agree that the heuristics in usbnet is less than helpful here,
> > which among other things leads people to mixing up the two problems
> > of fixing the device naming and fixing the MAC address assignment.
> > 
> > Even though I know Greg disagrees, I'd still prefer sanitising the
> > rules for the default device name that usbnet assigns.
> 
> I'm all for that, but recall, we can't because of previous
> implementations and past history.  I.e. you will break working systems
> if you do this.  So we are stuck with what we have at the moment, sorry.

I would still consider it a bug fix and argue that the number of actual
people impacted by the current behaviour is much larger than the potential
number people that might suffer from changing the behavior in an incompatible
way, given that:

* The common case for this hardware seems to be to ship with an eeprom
  with a valid mac address, as identified by the fact that f4e8ab7c
  "smsc95xx: generate random MAC address once, not every ifup" only recently
  got into the kernel as a bug fix for the random case, though the driver
  has been around since 2008.

* A google search on the term "smsc95xx" find almost exclusively discussions
  about how to get the device to come up with a proper name on the panda
  board, and various proposed workarounds.

* The comment in usbnet.c about this suggests that the intent has always
  been what is proposed now, it just doesn't match the code:

           // heuristic:  "usb%d" for links we know are two-host,
           // else "eth%d" when there's reasonable doubt.  userspace
           // can rename the link if it knows better.
                if ((dev->driver_info->flags & FLAG_ETHER) != 0 &&
                    (net->dev_addr [0] & 0x02) == 0)
                        strcpy (net->name, "eth%d");

  In case of smsc95xx, we *know* that it's ethernet and not two-host,
  there is no reasonable doubt about this. The code almost makes sense
  on generic cdc devices, but not for anything else.

	Arnd
