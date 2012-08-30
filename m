Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901Ab2H3Sk2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 14:40:28 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:38540 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754684Ab2H3SkX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 14:40:23 -0400
From: "Worth, Kevin" <kevin.worth@hp.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "u.kleine-koenig@pengutronix.de" <u.kleine-koenig@pengutronix.de>
Subject: RE: Using uio_pdrv to create an platform device for an FPGA, mmap()
 fails
Thread-Topic: Using uio_pdrv to create an platform device for an FPGA,
 mmap() fails
Thread-Index: Ac2GO7tG6QS6FR2kSHyjyyZF3zS91wAI7NcAAB9odFA=
Date: Thu, 30 Aug 2012 18:36:53 +0000
Message-ID: <B5EF724456FFB24A8C8AE88E26CE8F4B66840BEE@G9W0725.americas.hpqcorp.net>
References: <B5EF724456FFB24A8C8AE88E26CE8F4B668404B8@G9W0725.americas.hpqcorp.net>
 <20120830032735.GA2599@local>
In-Reply-To: <20120830032735.GA2599@local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [16.210.48.13]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the reply, Hans. Your question about opening /dev/uio0 O_RDWR
prompted me to check out how I was creating /dev/uio0 ... my system
isn't using udev, and I was accidentally creating it with major/minor
number 254/0 instead of the correct 253/0 (found by looking at
/proc/devices). Fixed that and the mmap() call started working.

Verified that if /dev/uio0 has permissions 0644, root can open it O_RDWR
and mmap PROT_READ | PROT_WRITE using the below code and write to an
address within my memory map. Of course this contradicts the statement
"/dev/uioX is a read-only file" in the UIO howto.

Including my updated, tested code for completeness.
Note I also cleaned up the device registration a little by
using a different platform_device_register_ call and removing fields
in the struct uio_info that get filled in by uio_pdrv automatically.

-Kevin

# lsuio -m -v
uio0: name=uio_myfpga, version=0.1, events=0
        map[0]: addr=0xD0000000, size=262144, mmap test: OK
        Device attributes:
        uevent=DRIVER=uio_pdrv
        modalias=platform:uio_pdrv

------Kernelspace------
#include <linux/platform_device.h>
#include <linux/uio_driver.h>
#include <linux/module.h>

#define MYFPGA_BASE     0xd0000000 // 3G
#define MYFPGA_SIZE     0x00040000 // 256k

static struct resource myfpga_resources[] = {
    {
        .start = MYFPGA_BASE,
        .end   = MYFPGA_BASE + MYFPGA_SIZE - 1,
        .name  = "myfpga",
        .flags = IORESOURCE_MEM
    }
};

static struct uio_info myfpga_uio_info = {
   .name = "uio_myfpga",
   .version = "0.1",
};

static struct platform_device *myfpga_uio_pdev;

static int __init myfpga_init(void)
{
    myfpga_uio_pdev = platform_device_register_resndata (NULL,
                                                         "uio_pdrv",
                                                         -1,
                                                         myfpga_resources,
                                                         1,
                                                         &myfpga_uio_info,
                                                         sizeof(struct uio_info)
                                                        );
    if (IS_ERR(myfpga_uio_pdev)) {
        return PTR_ERR(myfpga_uio_pdev);
    }

    return 0;
}

static void __exit myfpga_exit(void)
{
    platform_device_unregister(myfpga_uio_pdev);
}

module_init(myfpga_init);
module_exit(myfpga_exit);

------Userspace-------
#include <sys/types.h>
#include <sys/mman.h>
#include <sys/stat.h>

#include <dirent.h>
#include <string.h>
#include <stdlib.h>
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdint.h>

#define MYFPGA_BASE     0xd0000000 // 3G
#define MYFPGA_SIZE     0x00040000 // 256k
#define MYFPGA_MAP_NUM  0 // First and only defined map

#define BIT32(n) (1 << (n))

/* Use mmap()'ped address "iomem", not physical MYFPGA address */
#define MYFPGA_REG(iomem) (volatile uint32_t*)(iomem + 0x8) // Third 32-bit reg

int main (int argc, char *argv[])
{
    int fd;
    void *iomem;
    fd = open("/dev/uio0", O_RDWR|O_SYNC);
    if (fd < 0) {
        printf("failed to open /dev/uio0, quitting\n");
        return -1;
    }
    /* Note offset has a special meaning with uio devices */
    iomem = mmap(NULL, MYFPGA_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd,
                 MYFPGA_MAP_NUM * getpagesize());
    if (iomem == MAP_FAILED) {
        printf("mmap failed, quitting\n");
        close(fd);
        return -2;
    }

    /* Set bit 5 of MYFPGA_REG register */
    *MYFPGA_REG(iomem) |= BIT32(5);

    munmap(iomem, MYFPGA_SIZE);
    close(fd);
    return 0;
}
 
