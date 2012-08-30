Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754738Ab2H3D15 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 23:27:57 -0400
Received: from www.hansjkoch.de ([178.63.77.200]:50361 "EHLO www.hansjkoch.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab2H3D14 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 23:27:56 -0400
Date: Thu, 30 Aug 2012 05:27:50 +0200
From: "Hans J. Koch" <hjk@hansjkoch.de>
To: "Worth, Kevin" <kevin.worth@hp.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        u.kleine-koenig@pengutronix.de
Subject: Re: Using uio_pdrv to create an platform device for an FPGA, mmap()
 fails
Message-ID: <20120830032735.GA2599@local>
References: <B5EF724456FFB24A8C8AE88E26CE8F4B668404B8@G9W0725.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <B5EF724456FFB24A8C8AE88E26CE8F4B668404B8@G9W0725.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Added driver author to Cc:]

On Wed, Aug 29, 2012 at 11:19:00PM +0000, Worth, Kevin wrote:
> I have below what appears to be a mostly-functional device using the UIO Platform Driver. The /sys entries I'd expect appear,  /proc/iomem contains " d0000000-d0000fff : myfpga", and lsuio sees the properties that I've set. However an mmap() from userspace (either my test program below or lsuio) fails. So close! (at least it would seem)
> 
> Finding a good example for this did not come easily (which is why I'm hitting LKML, since I know it'll get a lot of eyeballs and be archived). Maybe there was something obvious I missed, but the only "official" documentation I could locate was http://www.kernel.org/doc/htmldocs/uio-howto.html#using_uio_pdrv , and most everything else was snippets from presentations, papers, and forums that lacked completeness.
> 
> Thanks for the help any might be able to offer.
> Please CC me on replies as I'm not ready to drink from the fire hose that is an LKML subscription.
> 
> # lsuio -v -m
> uio0: name=uio_myfpga, version=0.1, events=0
>         map[0]: addr=0xD0000000, size=4096, mmap test: FAILED
>         Device attributes:
>         uevent=DRIVER=uio_pdrv
>         modalias=platform:uio_pdrv
> 
> ------Kernelspace portion-------
> 
> #include <linux/platform_device.h>
> #include <linux/uio_driver.h>
> #include <linux/module.h>
> 
> #define MYFPGA_BASE     0xd0000000 // 3G
> #define MYFPGA_SIZE     0x00040000 // 256k
> 
> static struct resource myfpga_resources[] = {
>         {
>                 .start  = MYFPGA_BASE,
>                 .end    = MYFPGA_BASE + MYFPGA_SIZE - 1,
>                 .name   = "myfpga",
>                 .flags  = IORESOURCE_MEM
>         }
> };
> 
> static struct uio_info myfpga_uio_info = {
>    .name = "uio_myfpga",
>    .version = "0.1",
>    .irq = UIO_IRQ_CUSTOM,
>    .mem = {
>         {
>             .name = "myfpga",
>             .memtype = UIO_MEM_PHYS,
>             .addr = MYFPGA_BASE,
>             .size = MYFPGA_SIZE
>         }
>     }
> };
> 
> static struct platform_device_info myfpga_uio_pdevinfo = {
>     .name = "uio_pdrv",
>     .id = -1,
>     .res = myfpga_resources,
>     .num_res = 1,
>     .data = &myfpga_uio_info,
>     .size_data = sizeof(struct uio_info)
> };
> 
> static struct platform_device *myfpga_uio_pdev;
> 
> static int __init myfpga_init(void)
> {
>     myfpga_uio_pdev = platform_device_register_full(&myfpga_uio_pdevinfo);
>     if (IS_ERR(myfpga_uio_pdev)) {
>         return PTR_ERR(myfpga_uio_pdev);
>     }
> 
>     return 0;
> }
> 
> static void __exit myfpga_exit(void)
> {
>     platform_device_unregister(myfpga_uio_pdev);
> }
> 
> module_init(myfpga_init);
> module_exit(myfpga_exit);
> 
> ------Userspace portion-------
> 
> #include <sys/types.h>
> #include <sys/mman.h>
> #include <sys/stat.h>
> 
> #include <dirent.h>
> #include <string.h>
> #include <stdlib.h>
> #include <stdio.h>
> #include <fcntl.h>
> #include <unistd.h>
> 
> #define MYFPGA_BASE     0xd0000000 // 3G
> #define MYFPGA_SIZE     0x00040000 // 256k
> #define MYFPGA_UIO_NUM  0          // uio0

That's misleading regarding its use below. The factor you need for mmap
is the number of the mapping, not uio0, uio1...

> 
> int main (int argc, char *argv[])
> {
>     int fd;
>     void *iomem;
>     fd = open("/dev/uio0", O_RDWR|O_SYNC);

Does it work with O_RDWR ?

Thanks,
Hans

>     if (fd < 0) {
>         printf("failed to open /dev/uio0, quitting\n");
>         return -1;
>     }
>     /* Note offset has a special meaning with uio devices */
>     iomem = mmap(NULL, MYFPGA_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd,
>                  MYFPGA_UIO_NUM * getpagesize());
>     if (iomem == MAP_FAILED) {
>         printf("mmap failed, quitting\n");
>         close(fd);
>         return -2;
>     }
>     printf("mmap successful!\n");
>     munmap(iomem, MYFPGA_SIZE);
>     close(fd);
>     return 0;
> }
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
