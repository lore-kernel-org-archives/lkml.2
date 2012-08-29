Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab2H2PUV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 11:20:21 -0400
Received: from antcom.de ([188.40.178.216]:44404 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751658Ab2H2PUU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 11:20:20 -0400
Message-ID: <503E3331.8050203@antcom.de>
Date: Wed, 29 Aug 2012 17:20:17 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: Sascha Hauer <s.hauer@pengutronix.de>
CC: linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: mxc_nand.c on mach-imx/imx53
References: <5035F84E.3000901@antcom.de> <20120829074122.GV26594@pengutronix.de>
In-Reply-To: <20120829074122.GV26594@pengutronix.de>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sascha,

On 08/29/2012 09:41 AM, Sascha Hauer wrote:
> On Thu, Aug 23, 2012 at 11:30:54AM +0200, Roland Stigge wrote:
>> Hi,
>>
>> I'd like to know about the current state of mxc_nand.c on imx53, because
>> I got an error on probe() because the clock that mxc_nand is requesting
>> is "nfc" but imx53 only defines the clock "mxc_nand".
> 
> The driver generally works on i.MX53, only some pieces are missing. I
> just resent the corresponding series and put you on Cc.

Good - thank you for the patches, didn't know about them.

Now, my flash is detected:

NAND device: Manufacturer ID: 0x2c, Chip ID: 0xdc (Micron NAND 512MiB
3,3V 8-bit), page size: 4096, OOB size: 128

However, when I read a partition, kernel (mxc_nand_correct_data_v2_v3())
says:

...
UnCorrectable RS-ECC Error
UnCorrectable RS-ECC Error
UnCorrectable RS-ECC Error
UnCorrectable RS-ECC Error
UnCorrectable RS-ECC Error
UnCorrectable RS-ECC Error
UnCorrectable RS-ECC Error
...

I'm using the following dt (on an Emtrion DIMM-MX53 board):

                        nand@63fdb000 {
                                status = "okay";
                                #address-cells = <1>;
                                #size-cells = <1>;
                                nand-bus-width = <8>;
                                nand-ecc-mode = "hw";

                                mtd0@00000000 {
                                        label = "bootstrap";
                                        reg = <0x00000000 0x80000>;
                                        read-only;
                                };
                                mtd1@00080000 {
                                        label = "uboot";
                                        reg = <0x00080000 0x80000>;
                                        read-only;
                                };
                                mtd2@00100000 {
                                        label = "NVRAM";
                                        reg = <0x00100000 0x100000>;
                                };
                                mtd3@00200000 {
                                        label = "bootlogo";
                                        reg = <0x00200000 0x80000>;
                                };
                                mtd4@00280000 {
                                        label = "linux";
                                        reg = <0x00280000 0x400000>;
                                };
                                mtd5@00680000 {
                                        label = "rootfs";
                                        reg = <0x00680000 0x8000000>;
                                };
                                mtd6@08680000 {
                                        label = "appfs";
                                        reg = <0x08680000 0x17980000>;
                                };
                        };

NAND info from u-boot:

NAND:  512 MiB
Manufacturer      : Micron (0x2c)
Device Code       : 0xdc
Cell Technology   : SLC
Chip Size         : 512 MiB
Pages per Block   : 64
Page Geometry     : 4096+218
ECC Strength      : 8 bits
ECC Size          : 512 B
Data Setup Time   : 20 ns
Data Hold Time    : 10 ns
Address Setup Time: 10 ns
GPMI Sample Delay : 6 ns
tREA              : Unknown
tRLOH             : Unknown
tRHOH             : Unknown
Description       : MT29F4G08ABAEA

I guess I hit a documented open issue:

/* v3.2b: i.MX53 */
static const struct mxc_nand_devtype_data imx53_nand_devtype_data = {
        .preset = preset_v3,
        .send_cmd = send_cmd_v3,
        .send_addr = send_addr_v3,
        .send_page = send_page_v3,
        .send_read_id = send_read_id_v3,
        .get_dev_status = get_dev_status_v3,
        .check_int = check_int_v3,
        .irq_control = irq_control_v3,
        .get_ecc_status = get_ecc_status_v3,
        .ecclayout_512 = &nandv2_hw_eccoob_smallpage,
        .ecclayout_2k = &nandv2_hw_eccoob_largepage,
        .ecclayout_4k = &nandv2_hw_eccoob_smallpage, /* XXX: needs fix */

Using  ".ecclayout_4k = &nandv2_hw_eccoob_4k" also doesn't work. So is
there any hint how I can proceed from here? Any plans or hint regarding
the "XXX"?

Thanks in advance,

Roland
