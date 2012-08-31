Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751671Ab2HaJFO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 05:05:14 -0400
Received: from antcom.de ([188.40.178.216]:33349 "EHLO chuck.antcom.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751333Ab2HaJFL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 05:05:11 -0400
Message-ID: <50407E44.5080408@antcom.de>
Date: Fri, 31 Aug 2012 11:05:08 +0200
From: Roland Stigge <stigge@antcom.de>
Organization: ANTCOM IT Research & Development
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.5) Gecko/20120624 Icedove/10.0.5
MIME-Version: 1.0
To: =?UTF-8?B?RXJpYyBCw6luYXJk?= <eric@eukrea.com>
CC: Sascha Hauer <s.hauer@pengutronix.de>, linux-mtd@lists.infradead.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: mxc_nand.c on mach-imx/imx53
References: <5035F84E.3000901@antcom.de> <20120829074122.GV26594@pengutronix.de> <503E3331.8050203@antcom.de> <20120829172820.43bbe68e@eb-e6520>
In-Reply-To: <20120829172820.43bbe68e@eb-e6520>
X-Enigmail-Version: 1.4
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On 08/29/2012 05:28 PM, Eric Bénard wrote:
> Le Wed, 29 Aug 2012 17:20:17 +0200,
> Roland Stigge <stigge@antcom.de> a écrit :
>> Using  ".ecclayout_4k = &nandv2_hw_eccoob_4k" also doesn't work. So is
>> there any hint how I can proceed from here? Any plans or hint regarding
>> the "XXX"?
>>
> you may need something like this patch from barebox :
> http://git.pengutronix.de/?p=barebox.git;a=commit;h=632c45795065e6a7471ab82be38e808eb6204341

Thank you for the link!

I tried to port this on top of Sascha's patches for imx53, only for mxc v3 for now, as below.

Unfortunately, I still get:

...
UnCorrectable RS-ECC Error
UnCorrectable RS-ECC Error
UnCorrectable RS-ECC Error
UnCorrectable RS-ECC Error
UnCorrectable RS-ECC Error
...

from mxc_nand.c's mxc_nand_correct_data_v2_v3(). Maybe there's still sth. missing in the
error correction code?

Tracing reveals that in mxc_nand_command()'s switch statement, NAND_CMD_READID is handled,
but the NAND_CMD_PARAM case never gets triggered. (Under which circumstances is this
supposed to happen?) Further, I still wonder why the bootloader identifies the NAND as:

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

But Linux says:

NAND device: Manufacturer ID: 0x2c, Chip ID: 0xdc (Micron NAND 512MiB 3,3V 8-bit), page size: 4096, OOB size: 128

(See OOB size 128 vs. 218).

Thanks in advance,

Roland


---
 drivers/mtd/nand/mxc_nand.c |   36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

--- linux-2.6.orig/drivers/mtd/nand/mxc_nand.c
+++ linux-2.6/drivers/mtd/nand/mxc_nand.c
@@ -150,6 +150,7 @@ struct mxc_nand_devtype_data {
        void (*send_addr)(struct mxc_nand_host *, uint16_t, int);
        void (*send_page)(struct mtd_info *, unsigned int);
        void (*send_read_id)(struct mxc_nand_host *);
+       void (*send_read_param)(struct mxc_nand_host *);
        uint16_t (*get_dev_status)(struct mxc_nand_host *);
        int (*check_int)(struct mxc_nand_host *);
        void (*irq_control)(struct mxc_nand_host *, int);
@@ -543,6 +544,16 @@ static void send_read_id_v3(struct mxc_n
        memcpy32_fromio(host->data_buf, host->main_area0, 16);
 }
 
+static void send_read_param_v3(struct mxc_nand_host *host)
+{
+       /* Read param into main buffer */
+       writel(NFC_OUTPUT, NFC_V3_LAUNCH);
+
+       wait_op_done(host, true);
+
+       memcpy32_fromio(host->data_buf, host->main_area0, 1024);
+}
+
 /* Request the NANDFC to perform a read of the NAND device ID. */
 static void send_read_id_v1_v2(struct mxc_nand_host *host)
 {
@@ -741,6 +752,10 @@ static void mxc_nand_read_buf(struct mtd
 
        n = min(n, len);
 
+       /* handle the read param special case */
+       if ((mtd->writesize == 0) && (len != 0))
+               n = len;
+
        memcpy(buf, host->data_buf + col, n);
 
        host->buf_start += n;
@@ -842,9 +857,12 @@ static void mxc_do_addr_cycle(struct mtd
                 * MXC NANDFC can only perform full page+spare or
                 * spare-only read/write.  When the upper layers
                 * perform a read/write buf operation, the saved column
-                 * address is used to index into the full page.
+                * address is used to index into the full page.
+                *
+                * The colum address must be sent to the flash in
+                * order to get the ONFI header (0x20)
                 */
-               host->devtype_data->send_addr(host, 0, page_addr == -1);
+               host->devtype_data->send_addr(host, column, page_addr == -1);
                if (mtd->writesize > 512)
                        /* another col addr cycle for 2k page */
                        host->devtype_data->send_addr(host, 0, false);
@@ -998,9 +1016,11 @@ static void preset_v3(struct mtd_info *m
 
        writel(0, NFC_V3_IPC);
 
+       /* if the flash has a 224 oob, the NFC must be configured to 218 */
        config2 = NFC_V3_CONFIG2_ONE_CYCLE |
                NFC_V3_CONFIG2_2CMD_PHASES |
-               NFC_V3_CONFIG2_SPAS(mtd->oobsize >> 1) |
+               NFC_V3_CONFIG2_SPAS(((mtd->oobsize > 218) ?
+                                    218 : mtd->oobsize) >> 1) |
                NFC_V3_CONFIG2_ST_CMD(0x70) |
                NFC_V3_CONFIG2_INT_MSK |
                NFC_V3_CONFIG2_NUM_ADDR_PHASE0;
@@ -1124,6 +1144,13 @@ static void mxc_nand_command(struct mtd_
                host->buf_start = column;
                break;
 
+       case NAND_CMD_PARAM:
+               host->devtype_data->send_cmd(host, command, true);
+               mxc_do_addr_cycle(mtd, column, page_addr);
+               host->devtype_data->send_read_param(host);
+               host->buf_start = column;
+               break;
+
        case NAND_CMD_ERASE1:
        case NAND_CMD_ERASE2:
                host->devtype_data->send_cmd(host, command, false);
@@ -1271,13 +1298,14 @@ static const struct mxc_nand_devtype_dat
        .send_addr = send_addr_v3,
        .send_page = send_page_v3,
        .send_read_id = send_read_id_v3,
+       .send_read_param = send_read_param_v3,
        .get_dev_status = get_dev_status_v3,
        .check_int = check_int_v3,
        .irq_control = irq_control_v3,
        .get_ecc_status = get_ecc_status_v3,
        .ecclayout_512 = &nandv2_hw_eccoob_smallpage,
        .ecclayout_2k = &nandv2_hw_eccoob_largepage,
-       .ecclayout_4k = &nandv2_hw_eccoob_smallpage, /* XXX: needs fix */
+       .ecclayout_4k = &nandv2_hw_eccoob_4k,
        .select_chip = mxc_nand_select_chip_v1_v3,
        .correct_data = mxc_nand_correct_data_v2_v3,
        .irqpending_quirk = 0,
