Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753548Ab2JEM7v (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 08:59:51 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:2939 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751401Ab2JEM7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 08:59:49 -0400
X-Authority-Analysis: v=2.0 cv=dvhZ+ic4 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=MUfJ9gxhfrAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=VaSdnGLr1aUA:10 a=jdP34snFAAAA:8 a=J1Y8HTJGAAAA:8 a=BrdBRmpAAAAA:8 a=QJ5d5w4VovhJ5QoCETsA:9 a=PUjeQqilurYA:10 a=9mtjllxcxZAA:10 a=4N9Db7Z2_RYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349441987.6755.45.camel@gandalf.local.home>
Subject: [STABLE][3.0][3.2][Add PATCH] phy/fixed: use an unique MDIO bus name
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>, stable <stable@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Florian Fainelli <florian@openwrt.org>,
        "David S. Miller" <davem@davemloft.net>
Date: Fri, 05 Oct 2012 08:59:47 -0400
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I started testing my 3.2-rt branch on a powerpc box and it would
constantly spit out the following warning causing ktest to think the
boot failed:

sysfs: cannot create duplicate filename '/class/mdio_bus/0
------------[ cut here ]------------
WARNING: at /work/autotest/nobackup/powerpc-test.git/fs/sysfs/dir.c:481
Modules linked in:
NIP: c0000000001de1d4 LR: c0000000001de1d0 CTR: c00000000034a204
REGS: c00000003e81f6b0 TRAP: 0700   Not tainted  (3.2.0-test-05692-g1c81065)
MSR: 9000000000029032 <SF,HV,EE,ME,IR,DR,RI>  CR: 28000044  XER: 20000000
TASK = c00000003e80d470[1] 'swapper/0' THREAD: c00000003e81c000 CPU: 0
GPR00: c0000000001de1d0 c00000003e81f930 c0000000011d5618 0000000000000042 
GPR04: 0000000000000000 ffffffffffffffff c000000001186f38 ffffffffffffffff 
GPR08: c0000000012150f8 c000000000a80300 000000000eb59c60 0000000000a80000 
GPR12: 0000000024000082 c00000000fff0000 000000003ffffad8 ffffffffffffffff 
GPR16: 0000000000000000 0000000000a11c18 0000000000a11cd8 0000000000000060 
GPR20: 00000000008ef7be 000000003ffffaf0 0000000000000417 0000000000000000 
GPR24: 0000000000000000 0000000000000001 c00000003efe0400 c00000003e81fa40 
GPR28: ffffffffffffffef c00000003c20eff8 c0000000011105b8 c00000003e81f930 
NIP [c0000000001de1d4] .sysfs_add_one+0x9c/0xb8
LR [c0000000001de1d0] .sysfs_add_one+0x98/0xb8
Call Trace:
[c00000003e81f930] [c0000000001de1d0] .sysfs_add_one+0x98/0xb8 (unreliable)
[c00000003e81f9d0] [c0000000001dec74] .sysfs_do_create_link+0x144/0x210
[c00000003e81faa0] [c0000000001ded78] .sysfs_create_link+0x38/0x40
[c00000003e81fb40] [c000000000379bd8] .device_add+0x278/0x5ec
[c00000003e81fc20] [c000000000379f78] .device_register+0x2c/0x34
[c00000003e81fcb0] [c00000000041af14] .mdiobus_register+0xb4/0x1cc
[c00000003e81fd60] [c000000000a00bc4] .fixed_mdio_bus_init+0xd8/0x114
[c00000003e81fe30] [c00000000000a474] .do_one_initcall+0xc8/0x198
[c00000003e81fee0] [c0000000009d0ae0] .kernel_init+0x12c/0x1b8
[c00000003e81ff90] [c00000000001d624] .kernel_thread+0x54/0x70

The warning is triggered by:

int sysfs_add_one(struct sysfs_addrm_cxt *acxt, struct sysfs_dirent *sd)
{
	int ret;

	ret = __sysfs_add_one(acxt, sd);
	if (ret == -EEXIST) {
		char *path = kzalloc(PATH_MAX, GFP_KERNEL);
		WARN(1, KERN_WARNING
		     "sysfs: cannot create duplicate filename '%s'\n",
		     (path == NULL) ? sd->s_name :
		     strcat(strcat(sysfs_pathname(acxt->parent_sd, path), "/"),
		            sd->s_name));
		kfree(path);
	}

	return ret;
}

Doing some investigations, I found it only triggered on some configs,
and it was fixed by 3.3. I ran a ktest.pl reverse bisect (bad is good
and good is bad) and it ended on this commit:

commit 9e6c643bb4502c50b6511206601b7760c610dfcc
Author: Florian Fainelli <florian@openwrt.org>
Date:   Mon Jan 9 23:59:25 2012 +0000

    phy/fixed: use an unique MDIO bus name.
    
    Signed-off-by: Florian Fainelli <florian@openwrt.org>
    Signed-off-by: David S. Miller <davem@davemloft.net>

diff --git a/drivers/net/phy/fixed.c b/drivers/net/phy/fixed.c
index 1fa4d73..633680d 100644
--- a/drivers/net/phy/fixed.c
+++ b/drivers/net/phy/fixed.c
@@ -220,7 +220,7 @@ static int __init fixed_mdio_bus_init(void)
                goto err_mdiobus_reg;
        }
 
-       snprintf(fmb->mii_bus->id, MII_BUS_ID_SIZE, "0");
+       snprintf(fmb->mii_bus->id, MII_BUS_ID_SIZE, "fixed-0");
        fmb->mii_bus->name = "Fixed MDIO Bus";
        fmb->mii_bus->priv = fmb;
        fmb->mii_bus->parent = &pdev->dev;


Sure enough, adding this patch to both 3.2 and 3.0 fixed the bug.

Please pull this patch into the 3.2 and 3.0 stable trees.

Thanks!

-- Steve


