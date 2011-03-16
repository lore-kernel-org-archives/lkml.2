Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754144Ab1CPVCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 17:02:04 -0400
Received: from smtp-out.google.com ([74.125.121.67]:24373 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751757Ab1CPVCA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 17:02:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=cCK7GeXjbcWi2Yf5Gi6+w9lIioAG3/CRtRt+8a2NJHmqeWaRZvEth9naPSwOoZ4+yh
         /8p5nh0i27sk/oNzjQuw==
MIME-Version: 1.0
In-Reply-To: <4D812180.5030102@kernel.org>
References: <alpine.DEB.2.00.1103111201470.2968@kaball-desktop>
 <20110311222129.GA3168@dumpdata.com> <alpine.DEB.2.00.1103161150010.3382@kaball-desktop>
 <alpine.DEB.2.00.1103161442210.3382@kaball-desktop> <4D80F992.10603@kernel.org>
 <alpine.DEB.2.00.1103161757040.3382@kaball-desktop> <4D812180.5030102@kernel.org>
From: Mike Waychison <mikew@google.com>
Date: Wed, 16 Mar 2011 14:01:37 -0700
Message-ID: <AANLkTimNva3c_-kGA+JLCPZgrKAbwqLKaN559cwTh7cq@mail.gmail.com>
Subject: Re: [GIT PULL tip/x86/mm] xen/x86 fixes ===> fix sp5100_tco mmio checking.
To: Yinghai Lu <yinghai@kernel.org>
Cc: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Wim Van Sebroeck <wim@iguana.be>, linux-watchdog@vger.kernel.org,
        Priyanka Gupta <priyankag@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 1:45 PM, Yinghai Lu <yinghai@kernel.org> wrote:
> On 03/16/2011 11:02 AM, Stefano Stabellini wrote:
>>
>> On Wed, 16 Mar 2011, Yinghai Lu wrote:
>>>
>>> On 03/16/2011 07:43 AM, Stefano Stabellini wrote:
>>>>
>>>> actually attach the logs :)
>>>>
>>>> On Wed, 16 Mar 2011, Stefano Stabellini wrote:
>>>>>
>>>>> On Fri, 11 Mar 2011, Konrad Rzeszutek Wilk wrote:
>>>>>>
>>>>>> On Fri, Mar 11, 2011 at 01:17:23PM +0000, Stefano Stabellini wrote:
>>>>>>>
>>>>>>> Hello,
>>>>>>> recently we had a couple of long discussions with Yinghai about boot
>>>>>>> crashes on xen, related to pagetable initialization.
>>>>>>> As a result we came up with three patches, two of them fix the first
>>>>>>> [1]
>>>>>>> boot crash and provide a nice cleanup on native:
>>>>>>
>>>>>> I don't know why this is happening now, but it could be very well
>>>>>> related to the build config. Smaller builds don't seem to encounter
>>>>>> this, while
>>>>>> this is a distro type build. If I use:
>>>>>>
>>>>>>> Stefano Stabellini (1):
>>>>>>>        xen: set max_pfn_mapped to the last pfn mapped
>>>>>>
>>>>>> it hangs during bootup. The machine hangs during the box (no keyboard
>>>>>> interaction)
>>>>>> and I can see this in the bootup.
>>>>>
>>>>> Konrad sent me few other logs offline: log1 is the log of the hang and
>>>>> log2 is a successful boot (reverting the problematic patch).
>>>>> It looks like the SP5100 TCO WatchDog Timer Driver is using ioremap on
>>>>> an address (0xb8fe00) that belongs to the memory range used for the
>>>>> pagetable (0x9fc000-0xf43fff).
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000] found SMP MP-table at
>>> [ffff8800000ff780] ff780
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]
>>> memblock_x86_reserve_range: [0x000ff780-0x000ff78f]   * MP-table mpf
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]
>>> memblock_x86_reserve_range: [0x000fd240-0x000fd423]   * MP-table mpc
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]
>>> memblock_x86_reserve_range: [0x01cfd000-0x01d1c0e4]              BRK
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000] MEMBLOCK configuration:
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]  memory size = 0x23fe39000
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]  memory.cnt  = 0x3
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]  memory[0x0]
>>>  [0x00000000010000-0x0000000009afff], 0x8b000 bytes
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]  memory[0x1]
>>>  [0x00000000100000-0x000000bffaffff], 0xbfeb0000 bytes
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]  memory[0x2]
>>>  [0x00000100000000-0x0000027fefdfff], 0x17fefe000 bytes
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]  reserved.cnt  = 0x5
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]  reserved[0x0]
>>>  [0x000000000fd240-0x000000000fd423], 0x1e4 bytes
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]  reserved[0x1]
>>>  [0x000000000ff780-0x000000000ff78f], 0x10 bytes
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]  reserved[0x2]
>>>  [0x00000001000000-0x00000001d1c0e4], 0xd1c0e5 bytes
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]  reserved[0x3]
>>>  [0x00000001e33000-0x00000016a36fff], 0x14c04000 bytes
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]  reserved[0x4]
>>>  [0x000001f0f7e000-0x0000027fefdfff], 0x8ef80000 bytes
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000] Scanning 0 areas for low
>>> memory corruption
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]
>>> memblock_x86_reserve_range: [0x00099000-0x0009afff]       TRAMPOLINE
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]
>>> memblock_x86_reserve_range: [0x00095000-0x00098fff]      ACPI WAKEUP
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000] init_memory_mapping:
>>> 0000000000000000-00000000bffb0000
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000] DEBUG
>>> find_early_table_space: _text=1000000 _end=1e33000 pgtable_start=9fc000
>>> pgtable_end=9fc000
>>>
>>> Mar 15 16:09:04 phenom kernel: [    0.000000]
>>> memblock_x86_reserve_range: [0x009fc000-0x00f43fff]          PGTABLE
>>>
>>> e820 said that range is ram and usable. so it is right for memblock to
>>> use it.
>>>
>>> why TCO watchdog try to use ioremap with RAM?  BIOS put wrong mmio in
>>> that BAR?
>>>
>>> could do some sanitary check in that driver.
>>>
>>
>> Yeah, I think the max_pfn_mapped patch might be exposing bugs in the
>> drivers.
>> Do you remember this patch:
>>
>> https://lkml.org/lkml/2011/2/4/60
>>
>> would you be happy with it as a safer alternative?
>
> we should fix tco driver
>
> Mar 15 16:09:04 phenom kernel: [    9.148536] SP5100 TCO timer: SP5100 TCO
> WatchDog Timer Driver v0.01
>
> Mar 15 16:09:04 phenom kernel: [    9.148628] DEBUG __ioremap_caller WARNING
> address=b8fe00 size=8 valid=1 reserved=1
>
> so BIOS program wrong MMIO info.
>
> need some checking in that driver like
>
> diff --git a/drivers/watchdog/sp5100_tco.c b/drivers/watchdog/sp5100_tco.c
> index 8083728..2fac643 100644
> --- a/drivers/watchdog/sp5100_tco.c
> +++ b/drivers/watchdog/sp5100_tco.c
> @@ -42,6 +42,7 @@
>  #define PFX TCO_MODULE_NAME ": "
>  /* internal variables */
> +static u32 tcobase_phys;
>  static void __iomem *tcobase;
>  static unsigned int pm_iobase;
>  static DEFINE_SPINLOCK(tco_lock);      /* Guards the hardware */
> @@ -305,6 +306,12 @@ static unsigned char __devinit
> sp5100_tco_setupdevice(void)
>        /* Low three bits of BASE0 are reserved. */
>        val = val << 8 | (inb(SP5100_IO_PM_DATA_REG) & 0xf8);
>  +      if (request_mem_region_exclusive(val, SP5100_WDT_MEM_MAP_SIZE,
> "SP5100 TCO")) {
> +               printk(KERN_ERR PFX "mmio address 0x%04x already in use\n",
> val);
> +               goto unreg_region;
> +       }
> +       tcobase_phys = val;
> +
>        tcobase = ioremap(val, SP5100_WDT_MEM_MAP_SIZE);
>        if (tcobase == 0) {

Needs a release_mem_region() in this path.  Otherwise this looks fine.

>                printk(KERN_ERR PFX "failed to get tcobase address\n");
> @@ -414,6 +421,7 @@ static void __devexit sp5100_tco_cleanup(void)
>        /* Deregister */
>        misc_deregister(&sp5100_tco_miscdev);
>        iounmap(tcobase);
> +       release_mem_region(tcobase_phys, SP5100_WDT_MEM_MAP_SIZE);
>        release_region(pm_iobase, SP5100_PM_IOPORTS_SIZE);
>  }
>
