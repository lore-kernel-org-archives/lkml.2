Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752666Ab1G2SOL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 14:14:11 -0400
Received: from masquerade.micron.com ([137.201.242.130]:34159 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1G2SOH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 14:14:07 -0400
Message-ID: <4E32F85B.3060800@micron.com>
Date: Fri, 29 Jul 2011 12:13:47 -0600
From: Asai Thambi S P <asamymuthupa@micron.com>
Reply-To: <asamymuthupa@micron.com>
Organization: Micron
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Moyer <jmoyer@redhat.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>
Subject: Re: New driver mtipx2xx submission
References: <22A973199D2C2F46933448F6E7990A300204F2BC@ntxboimbx31.micron.com>	<20110428230605.78c55c70@lxorguk.ukuu.org.uk>	<22A973199D2C2F46933448F6E7990A300204F728@ntxboimbx31.micron.com>	<20110502184206.25907c5e@lxorguk.ukuu.org.uk>	<22A973199D2C2F46933448F6E7990A300214B0D6@ntxboimbx31.micron.com>	<20110511202013.075b07cc@lxorguk.ukuu.org.uk>	<4DD722DB.8030303@micron.com>	<x49lixuyhhs.fsf@segfault.boston.devel.redhat.com>	<22A973199D2C2F46933448F6E7990A300239EA77@ntxboimbx31.micron.com>	<x49ipsp9voy.fsf@segfault.boston.devel.redhat.com>	<20110601212129.11534c55@lxorguk.ukuu.org.uk>	<4DF80ADE.8020206@micron.com>	<x49ips75f4j.fsf@segfault.boston.devel.redhat.com>	<22A973199D2C2F46933448F6E7990A3002697E77@ntxboimbx31.micron.com>	<x49boxirnl8.fsf@segfault.boston.devel.redhat.com>	<20110628163125.0f2acc94@lxorguk.ukuu.org.uk>	<x4962nqrmp2.fsf@segfault.boston.devel.redhat.com>	<4E14D712.9090805@micron.com> <20110726114640.2b05dd34@lxorguk.ukuu.org.uk>
In-Reply-To: <20110726114640.2b05dd34@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.30.125]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.500.1024-18254.002
X-TM-AS-Result: No--22.779200-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/2011 4:46 AM, Alan Cox wrote:
> Sorry this has taken a while - I've been away and also dealing with
> various bits of graphics security stuff.
> 
> I've now been through the errata, the timing data and the driver code in
> somewhat more detail
> 
> Overall:
>   The hardware deviates a bit from AHCI. The AHCI driver could be taught
>   to support it but even with the longer queue supported it's not clear
>   this is the right path, and some of the error handling needs deviate a
>   bit.
> 
>   The performance numbers are pretty definitive, and the data shows that
>   is mostly higher up in the queue handling. That's awkward in some ways
>   because it means there isn't an obvious way to fix it, and we still
>   want the queue stuff for 'normal' disks.
> 
>   Looking at other vendors there don't seem to be a pile of them also
>   planning to do AHCI with extras instead most seem focussed on NVHMCI so
>   it doesn't look like a pile of near identikit drivers will appear. Also
>   if they do we would probably want them all to be related to this driver
>   not to the general AHCI driver.
> 
> So having gone over it all I think the case is rather well made for this
> being added as its own driver matching their specific PCI idents, but with
> some code clean up, and possibly some further compatibility code if it
> turns out some general ide/scsi tools don't work on it as expected.
> 
> Comments on the driver code
> 
> Questions:
>   Should there be security checks on the ioctl interfaces ?
> 
> Code:
>   Use k[mz]alloc/kfree for small objects like structs, vmalloc has a lot
>   of ovherad you don't need
> 
> - Lots of global function names with general naming. This causes problems
>   in Linux because all the compiled in drivers share a common namespace.
>   So they really ought to be something like
> 
> 	mtip_ahci_write()
> 
>   and so on
> 
> - Semaphores. Unless you need the counting properties please use mutexes.
>   Sempahores really make for problems in hard real time environments if
>   using the -rt kernel additions
> 
> Style:
> - Confuses our kernel-doc tools as it has its own different comment
>   extraction format. That wants pulling into line (it looks like all the
>   info is there and its a 'perl script from hell' sort of conversion)
> 
> - Various struct names in capitals - please search/replace those as for
>   style we keep capitals for defines
> 
> - Various ifdefs and a lot of printk stuff. Some of this is clearly
>   because its a development driver, but it ought to be tidied for a final
>   submission. Also use of dev_info/dev_err etc is strongly preferred as
>   it means a user and tools can clearly identify which device generated
>   the message (dev_dbg() supports runtime debug switching so may also
>   deal with stuff you'd otherwise remove later)
> 
> - for ata_swap_string look at bswap()

Thanks for your valuable feedback. We started making changes to the
driver, and expect to complete it soon.

-- 
Regards,
Asai Thambi
