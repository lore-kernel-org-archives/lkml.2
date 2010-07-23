Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab0GWSib (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 14:38:31 -0400
Received: from fold.natur.cuni.cz ([195.113.57.32]:35973 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751626Ab0GWSi3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 14:38:29 -0400
Message-ID: <4C49E1A2.7050606@ribosome.natur.cuni.cz>
Date: Fri, 23 Jul 2010 20:38:26 +0200
From: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100516 Gentoo/2.0.4-r1 SeaMonkey/2.0.4
MIME-Version: 1.0
To: Jay Fenlason <fenlason@redhat.com>
CC: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.35-rc6 to 2.6.32.16: JuJu firewire issues
References: <4C49A291.20001@ribosome.natur.cuni.cz> <20100723180807.GA32319@redhat.com>
In-Reply-To: <20100723180807.GA32319@redhat.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jay,
  thank you for you thorough explanation. Let me just briefly re-phrase what
I have. The topology is as of now:

           A                                                B

        VT6306                                           R5C552
         |   |                                            |   |
         |   ------------- firewire-net+sbp2---------------   |
         |                                                    --- unused port
         |
         ------ external drive enclosure (2 FW ports, 1USB port, one PWR port)


  In other words, I did not plugin two firewire cables into the two sockets on the
external drive enclosure, each coming from a different computer. I am not that
desperate user. ;) I suspect you thought I have the external drive in between
both computers. No, I don't.

  Computer A (desktop) has VT6306 Fire II IEEE 1394 chip, 3 ports, one connected
to the external hard drive, another to computer B (laptop) used for the TCP IP
networking.

  Computer B has Ricoh Co Ltd R5C552 IEEE 1394 chip. I should blacklist firewire_sbp
driver so that the laptop does not try to access the external hard drive.

  Yes, I have realized that the old firewire modules take precedence over the new
JuJu stuff. I used only the JuJu driver but after experiencing problems I decided
to compile as modules also the old drivers. I will repoduce this with the JuJu
drivers alone once again. (I have given that up meanwhile and I use the USB port
to transfer the data now - but will re-try and re-post.)

Thanks,
Martin


Jay Fenlason wrote:
> On Fri, Jul 23, 2010 at 04:09:21PM +0200, Martin Mokrejs wrote:
>> Hi,
>>   I bought a external harddrive with firewire and USB interfaces (IcyBOX IB-250StUE-B).
>> If I connect it to a desktop computer A I get kernel crash during boot (see
>> both attached dmesg-*.txt files).
>>
>>   Further, a laptop computer B is connected to A via firewire as well through
>> firewire-net module. I do not understand why but on computer B I see in dmesg
>> complains from firewire_sbp about the external drive physically connected to
>> computer A! Is that a bug or feature? Nevertheless, the host B cannot really
>> talk to the drive (see below snippet from 2.6.34.1 kernel on the laptop below
>> in the body of this email).
>>
>>   Sorry for mixing the two issue into a single email. Maybe this is because
>> of similar underlying issues? The desktop has 2 firewire ports and the laptop
>> also 2 ports. While taking into account that both have firewire_net inserted
>> into the running kernel and on both machines I see only firewire0 interface
>> and not additional firewire1 interface I wonder whether the kernels realizes
>> there are two physical ports on each computer and maybe it mixes together
>> some data or takes an action on the wrong port. You may think of my yesterdays
>> email as of yet another kernel crash and bug in JuJu firewire stack under subject
>> "2.6.31.14: firewire_net issue in generic_sync_sb_inodes".
> 
> I think you are confused about how firewire works.  Firewire is a bus,
> not a point-to-point technology.  Any device on a firewire bus may
> talk to any other device on the same bus, whether the are directly
> physically connected or not.  Otherwise you would not be able to
> daisy-chain disks, cameras, audio devices, etc.  The only way you can
> have multiple firewire busses on a device is to have multiple firewire
> controllers.  (You can do this by putting two firewire PCI cards in a
> computer, or by putting a FirWire CardBus card in a laptop with an
> on-board firewire controller, but I don't know of any machines that
> ship with multiple firewire busses.)  Each controller can have any
> number (*up to 63, with 1-3 being the most comment) of ports on it.
> 
>>From what you've said above, each of your computers has a single
> firewire controller in it (lspci will tell you for sure).  One of the
> computers has two ports on its controller, and the other has three.
> (This in not uncommon on many firewire based systems because the
> commonly used PHY chips support up to three ports.)
> 
> Hard disks (and things that emulate them) generally allow only a
> single host to control them at a time.  (Ignoring for the moment
> specialized "multi-initiator" capable hardware used for shared storage
> in clustering applications.)  This is because if two machines mount
> the same (non clustering-aware) filesystem at the same time, they will
> write over each others changes to the filesystem and eventually trash
> the filesystem's data structures beyond repair.  So when you have
> created a single bus with two computers and a single hard disk on it,
> it's unsurprising that only one of the computers can successfully talk
> to it.
> 
> I see in your dmesg that your 2.6.32.16-default computer is using the
> old ieee1394 stack, and not the the firewire stack, so it should not
> have loaded firewire-net.  It should have loaded eth1394 instead.  I'm
> troubled by the traceback in nodemgr, but since the old stack is
> unmaintained and buggy, your first step should be to completely
> eliminate iee1394, ohci1394, sbp2 and eth1394 from it and replace them
> with firewire-core, firewire-ohci, firewire-sbp2, and firewire-net on
> it.  Nobody is going to bother to debug the old stack at this point.
> 
> You should then either blacklist firewire-sbp2 on the computer that
> you do not want to use the external disk from, or tell firewire-sbp2
> not to try to attach to it (I believe Stefan Richter wrote directions
> on how to do that a year or two ago.  Check the linux1394-devel
> archives). Otherwise both machines will race to connect to it, one of
> them will win, and the other will get errors.
> 
> 			-- JF
> 
> 
