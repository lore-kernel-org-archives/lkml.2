Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753232Ab1HKSh7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 14:37:59 -0400
Received: from masquerade.micron.com ([137.201.242.130]:22980 "EHLO
	masquerade.micron.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751463Ab1HKShE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 14:37:04 -0400
Message-ID: <4E442134.7060304@micron.com>
Date: Thu, 11 Aug 2011 12:36:36 -0600
From: Asai Thambi S P <asamymuthupa@micron.com>
Reply-To: <asamymuthupa@micron.com>
Organization: Micron
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Jeff Moyer <jmoyer@redhat.com>, <linux-ide@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: New driver mtipx2xx submission
References: <22A973199D2C2F46933448F6E7990A300204F2BC@ntxboimbx31.micron.com>	<20110428230605.78c55c70@lxorguk.ukuu.org.uk>	<22A973199D2C2F46933448F6E7990A300204F728@ntxboimbx31.micron.com>	<20110502184206.25907c5e@lxorguk.ukuu.org.uk>	<22A973199D2C2F46933448F6E7990A300214B0D6@ntxboimbx31.micron.com>	<20110511202013.075b07cc@lxorguk.ukuu.org.uk>	<4DD722DB.8030303@micron.com>	<x49lixuyhhs.fsf@segfault.boston.devel.redhat.com>	<22A973199D2C2F46933448F6E7990A300239EA77@ntxboimbx31.micron.com>	<x49ipsp9voy.fsf@segfault.boston.devel.redhat.com>	<20110601212129.11534c55@lxorguk.ukuu.org.uk>	<4DF80ADE.8020206@micron.com>	<x49ips75f4j.fsf@segfault.boston.devel.redhat.com>	<22A973199D2C2F46933448F6E7990A3002697E77@ntxboimbx31.micron.com>	<x49boxirnl8.fsf@segfault.boston.devel.redhat.com>	<20110628163125.0f2acc94@lxorguk.ukuu.org.uk>	<x4962nqrmp2.fsf@segfault.boston.devel.redhat.com>	<4E14D712.9090805@micron.com> <20110726114640.2b05dd34@lxorguk.ukuu.org.uk>
In-Reply-To: <20110726114640.2b05dd34@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.16.30.125]
X-TM-AS-Product-Ver: SMEX-10.0.0.4152-6.500.1024-18254.002
X-TM-AS-Result: No--32.698700-0.000000-31
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

Thanks for taking the time to review the errata, performance profiles,
and early driver code.  We've cleaned up much of the ugliness in the
version you inspected so it should be easier on the eyes now.

We changed the driver name from mtipx2xx to mtip32xx. Open to a generic
name if other vendors are planning to use this driver.

> 
> Comments on the driver code
> 
> Questions:
>   Should there be security checks on the ioctl interfaces ?

We added capable(CAP_SYS_ADMIN) checks on the ioctls.

> 
> Code:
>   Use k[mz]alloc/kfree for small objects like structs, vmalloc has a lot
>   of ovherad you don't need

All vmallocs were converted to kzallocs.

> 
> - Lots of global function names with general naming. This causes problems
>   in Linux because all the compiled in drivers share a common namespace.
>   So they really ought to be something like
> 
> 	mtip_ahci_write()
> 
>   and so on

We converted all non-static functions to kernel-compatible nomenclature.
We used the mtip prefix based on your suggestion.

> 
> - Semaphores. Unless you need the counting properties please use mutexes.
>   Sempahores really make for problems in hard real time environments if
>   using the -rt kernel additions

Here we had some trouble.  We needed the counting semaphore to put the
make_request calling context to sleep if there are no empty slots.  We
also needed the rw semaphore to prioritize internal commands and ioctls
during heavy IO load.  There seemed to be a fairness problem that was
best solved through the rw semaphore.  If you have another suggestion
for a "fair" semaphore, we'd love to hear it.

> 
> Style:
> - Confuses our kernel-doc tools as it has its own different comment
>   extraction format. That wants pulling into line (it looks like all the
>   info is there and its a 'perl script from hell' sort of conversion)

We did our best to make the comments and format consistent with other
drivers.

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

We've converted much of the logging to dev_* semantics.  The challenge
for us was reconciling all the messages that we feel are important
against the need to not spam the system log.  We think we've made a
reasonable compromise, at least compared to the last driver we posted.

We are of course open to removing any logging deemed superfluous.

> 
> - for ata_swap_string look at bswap()

We experimented with bswap but in the end felt that be16_to_cpus
was a better choice.

I will post the updated patch shortly.

-- 
Regards,
Asai Thambi
