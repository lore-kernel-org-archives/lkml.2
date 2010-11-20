Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753212Ab0KTMLs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 07:11:48 -0500
Received: from hera.cwi.nl ([192.16.191.8]:55598 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752587Ab0KTMLq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 07:11:46 -0500
Date: Sat, 20 Nov 2010 13:11:21 +0100
From: "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>
To: Borislav Petkov <bp@alien8.de>,
        "Andries E. Brouwer" <Andries.Brouwer@cwi.nl>,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: ide boot failure 2.6.36/2.6.28 - 2.6.27 works
Message-ID: <20101120121121.GA30338@iq>
References: <20101120032828.GA14693@iq>
 <20101120074508.GA16854@liondog.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101120074508.GA16854@liondog.tnic>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 20, 2010 at 08:45:08AM +0100, Borislav Petkov wrote:
> On Sat, Nov 20, 2010 at 04:28:33AM +0100, Andries E. Brouwer wrote:
> > Answering myself (and providing info that can be Googled):
> > 
> > > I wanted to boot a recent kernel on an old machine and failed.
> > > The last kernel that worked was 2.6.27.
> > > What goes wrong is that the disks are no longer detected on 2.6.28.
> > 
> > A typical error would be
> > 
> > 	Cannot open root device 342 or unknown block (3,66)
> > 
> > Reading the code shows that the default probing is no longer done.
> 
> Well, this got changed in 20df429dd6671804999493baf2952f82582869fa since
> we had other problems when having ide-generic and a specific PCI IDE
> controller driver enabled at the same time, AFAIR.

In the meantime I looked at what happened, and how this regression
was introduced. Mikael Pettersson reported that he lost his NIC
because of commit 343a3451e20314d5959b59b992e33fbaadfe52bf that
caused the IDE code to probe where it did not before.
Because of a resource leak, this caused other hardware
not to be found any longer.

One would hope that this resource leak would be investigated further,
but the reaction was to stop IDE probing, causing a few hundred
people to lose their disk.

A regression.

> There are two fixes I can think of - you either enable the specific IDE
> controller driver for your chipset or you enforce probing with
> 
> 	ide_generic.probe_mask=0x3f
> 
> on the kernel command line.

Yes, but my edit was better.

>> Editing ./drivers/ide/ide-generic.c and changing
>>
>> -static int probe_mask;
>> +static int probe_mask = 3;
>>
>> returns my disks to life, and this old machine boots again.


(On the one hand, I have many machines and certainly do not recall
the precise hardware details on all. On the other hand, having a
non-booting kernel that requires separate command-line arguments
is a pain, it requires bookkeeping. The 1-line fix makes it work
without command-line arguments.)

The author of the regression knew that he was breaking some setups
and cleared his conscience by adding a printk
+   printk(KERN_INFO DRV_NAME ": please use \"probe_mask=0x3f\" module "
+   	     	       "parameter for probing all legacy ISA IDE ports\n");
at boot time. Of course this scrolls off the screen too quickly to read.
Since the kernel does not boot, there is no dmesg afterwards, so one would
need serious debugging, using serial console or netconsole, to see it.

I pointed at a bugzilla where this is still described as an unsolved problem.


Andries
