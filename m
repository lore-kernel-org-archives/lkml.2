Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757158Ab1CRQjQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 12:39:16 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:44773 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756842Ab1CRQjI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 12:39:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=ffuJToml7A5V05qkb0od+mdTkSuiaZMur0ZsPCtam3fF0yUHbGcr9MldO2Q3o9v/9f
         TRQBUO3ANqcQ1fLeZ0ar6btWSPKb2VS7b+4p4u91prw+TKLvvTDyPYbRouGiCN4ODZ1U
         qLNN5XeKqBhIjHt2EaSx5NkFa9zX6xHkXLx8Q=
MIME-Version: 1.0
In-Reply-To: <20110318131025.GA3786@dumpdata.com>
References: <20110311222129.GA3168@dumpdata.com>
	<alpine.DEB.2.00.1103161150010.3382@kaball-desktop>
	<alpine.DEB.2.00.1103161442210.3382@kaball-desktop>
	<4D80F992.10603@kernel.org>
	<alpine.DEB.2.00.1103161757040.3382@kaball-desktop>
	<4D812180.5030102@kernel.org>
	<AANLkTimNva3c_-kGA+JLCPZgrKAbwqLKaN559cwTh7cq@mail.gmail.com>
	<4D812919.30706@kernel.org>
	<20110317022331.GA3528@dumpdata.com>
	<4D817973.7000407@kernel.org>
	<20110318131025.GA3786@dumpdata.com>
Date: Fri, 18 Mar 2011 09:39:06 -0700
X-Google-Sender-Auth: pFI6SpcfKjIW8sLrGNOfQJy3a4k
Message-ID: <AANLkTinP0hGieOsgvPzm3f2LWWG0fUKGYMHGXxEGZ+Fi@mail.gmail.com>
Subject: Re: [Xen-devel] [PATCH -v3] watchdog, SP5100: Check if firmware has
 set correct value in tcobase.
From: Yinghai Lu <yinghai@kernel.org>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Priyanka Gupta <priyankag@google.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        linux-watchdog@vger.kernel.org,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mike Waychison <mikew@google.com>, Wim Van Sebroeck <wim@iguana.be>,
        "H. Peter Anvin" <hpa@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 18, 2011 at 6:10 AM, Konrad Rzeszutek Wilk
<konrad.wilk@oracle.com> wrote:
> On Wed, Mar 16, 2011 at 08:01:07PM -0700, Yinghai Lu wrote:
>>
>> Stefano found SP5100 TCO watchdog driver using wrong address.
>>
>> [    9.148536] SP5100 TCO timer: SP5100 TCO WatchDog Timer Driver v0.01
>> [    9.148628] DEBUG __ioremap_caller WARNING address=b8fe00 size=8 valid=1 reserved=1
>>
>> and e820 said that range is RAM.
>>
>> We should check if we can use that reading out. BIOS could just program wrong address there.
>>
>> -v2: Mike pointed out one path need one release.
>> -v3: corrected logic checking with request_mem_region_exclusive()
>>      Found by Konrad.
>
> Yinghai:
> Not sure what you are using as a base, but I had to modify this patch
> to go on top of 2.6.38. Here is the patch that applies cleanly:


after

commit 4562f53940432369df88e195ef8f9b642bdf7cd6
Author: Wim Van Sebroeck <wim@iguana.be>
Date:   Mon Feb 21 12:16:44 2011 +0000

    watchdog: convert to DEFINE_PCI_DEVICE_TABLE

    Convert static struct pci_device_id *[] to static
DEFINE_PCI_DEVICE_TABLE tables.

    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>

diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
index 8083728..1bc4938 100644
--- a/drivers/watchdog/sp5100_tco.c
+++ b/drivers/watchdog/sp5100_tco.c
@@ -259,7 +259,7 @@ static struct miscdevice sp5100_tco_miscdev = {
  * register a pci_driver, because someone else might
  * want to register another driver on the same PCI id.
  */
-static struct pci_device_id sp5100_tco_pci_tbl[] = {
+static DEFINE_PCI_DEVICE_TABLE(sp5100_tco_pci_tbl) = {
        { PCI_VENDOR_ID_ATI, PCI_DEVICE_ID_ATI_SBX00_SMBUS, PCI_ANY_ID,
          PCI_ANY_ID, },
        { 0, },                 /* End of list */

commit 15e28bf130081a574192fb934b832ac7d07739f7
Author: Priyanka Gupta <priyankag@google.com>
Date:   Mon Oct 25 17:58:04 2010 -0700

    watchdog: Add support for sp5100 chipset TCO

    This driver adds /dev/watchdog support for the AMD sp5100 aka
SB7x0 chipsets.

    It follows the same conventions found in other /dev/watchdog drivers.

    Signed-off-by: Priyanka Gupta <priyankag@google.com>
    Signed-off-by: Mike Waychison <mikew@google.com>
    Signed-off-by: Wim Van Sebroeck <wim@iguana.be>
