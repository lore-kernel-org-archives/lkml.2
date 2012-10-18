Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932544Ab2JRRzn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 13:55:43 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33237 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932125Ab2JRRzm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 13:55:42 -0400
Message-ID: <1350582941.3072.78.camel@joe-AO722>
Subject: Re: [PATCH 1/4] mmc: core: sd.c: Added a space after comma on an
 argument definition
From: Joe Perches <joe@perches.com>
To: Sangho Yi <antiroot@gmail.com>
Cc: prakity@marvell.com, aaron.lu@amd.com, linus.walleij@linaro.org,
        ulf.hansson@stericsson.com, cjb@laptop.org,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Date: Thu, 18 Oct 2012 10:55:41 -0700
In-Reply-To: <1350580760-3886-1-git-send-email-antiroot@gmail.com>
References: <n> <1350580760-3886-1-git-send-email-antiroot@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-19 at 02:19 +0900, Sangho Yi wrote:
> Added a space between comma and an argument on the function definition

Hi Sangho.

Please don't just be a checkpatch robot, but look at the
code and see if you can improve it.

> diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
> index 74972c2..91a73d7 100644
> --- a/drivers/mmc/core/sd.c
> +++ b/drivers/mmc/core/sd.c
> @@ -44,7 +44,7 @@ static const unsigned int tacc_mant[] = {
>  	35,	40,	45,	50,	55,	60,	70,	80,
>  };
>  
> -#define UNSTUFF_BITS(resp,start,size)					\
> +#define UNSTUFF_BITS(resp, start, size)					\
>  	({								\
>  		const int __size = size;				\
>  		const u32 __mask = (__size < 32 ? 1 << __size : 0) - 1;	\

I'd prefer that UNSTUFF_BITS be converted from
a statement expression macro to a proper function.

Something like:

 drivers/mmc/core/sd.c | 118 +++++++++++++++++++++++++-------------------------
 1 file changed, 59 insertions(+), 59 deletions(-)

diff --git a/drivers/mmc/core/sd.c b/drivers/mmc/core/sd.c
index 74972c2..ec32ba48 100644
--- a/drivers/mmc/core/sd.c
+++ b/drivers/mmc/core/sd.c
@@ -44,19 +44,19 @@ static const unsigned int tacc_mant[] = {
 	35,	40,	45,	50,	55,	60,	70,	80,
 };
 
-#define UNSTUFF_BITS(resp,start,size)					\
-	({								\
-		const int __size = size;				\
-		const u32 __mask = (__size < 32 ? 1 << __size : 0) - 1;	\
-		const int __off = 3 - ((start) / 32);			\
-		const int __shft = (start) & 31;			\
-		u32 __res;						\
-									\
-		__res = resp[__off] >> __shft;				\
-		if (__size + __shft > 32)				\
-			__res |= resp[__off-1] << ((32 - __shft) % 32);	\
-		__res & __mask;						\
-	})
+static __always_inline u32 unstuff_bits(u32 resp[4], int start, int size)
+{
+	const u32 mask = (size < 32 ? 1 << size : 0) - 1;
+	const int offset = 3 - (start / 32);
+	const int shift = start & 31;
+	u32 res;
+
+	res = resp[offset] >> shift;
+	if (size + shift > 32)
+		res |= resp[offset - 1] << ((32 - shift) % 32);
+
+	return res & mask;
+}
 
 /*
  * Given the decoded CSD structure, decode the raw CID to our CID structure.
@@ -71,18 +71,18 @@ void mmc_decode_cid(struct mmc_card *card)
 	 * SD doesn't currently have a version field so we will
 	 * have to assume we can parse this.
 	 */
-	card->cid.manfid		= UNSTUFF_BITS(resp, 120, 8);
-	card->cid.oemid			= UNSTUFF_BITS(resp, 104, 16);
-	card->cid.prod_name[0]		= UNSTUFF_BITS(resp, 96, 8);
-	card->cid.prod_name[1]		= UNSTUFF_BITS(resp, 88, 8);
-	card->cid.prod_name[2]		= UNSTUFF_BITS(resp, 80, 8);
-	card->cid.prod_name[3]		= UNSTUFF_BITS(resp, 72, 8);
-	card->cid.prod_name[4]		= UNSTUFF_BITS(resp, 64, 8);
-	card->cid.hwrev			= UNSTUFF_BITS(resp, 60, 4);
-	card->cid.fwrev			= UNSTUFF_BITS(resp, 56, 4);
-	card->cid.serial		= UNSTUFF_BITS(resp, 24, 32);
-	card->cid.year			= UNSTUFF_BITS(resp, 12, 8);
-	card->cid.month			= UNSTUFF_BITS(resp, 8, 4);
+	card->cid.manfid		= unstuff_bits(resp, 120, 8);
+	card->cid.oemid			= unstuff_bits(resp, 104, 16);
+	card->cid.prod_name[0]		= unstuff_bits(resp, 96, 8);
+	card->cid.prod_name[1]		= unstuff_bits(resp, 88, 8);
+	card->cid.prod_name[2]		= unstuff_bits(resp, 80, 8);
+	card->cid.prod_name[3]		= unstuff_bits(resp, 72, 8);
+	card->cid.prod_name[4]		= unstuff_bits(resp, 64, 8);
+	card->cid.hwrev			= unstuff_bits(resp, 60, 4);
+	card->cid.fwrev			= unstuff_bits(resp, 56, 4);
+	card->cid.serial		= unstuff_bits(resp, 24, 32);
+	card->cid.year			= unstuff_bits(resp, 12, 8);
+	card->cid.month			= unstuff_bits(resp, 8, 4);
 
 	card->cid.year += 2000; /* SD cards year offset */
 }
@@ -96,36 +96,36 @@ static int mmc_decode_csd(struct mmc_card *card)
 	unsigned int e, m, csd_struct;
 	u32 *resp = card->raw_csd;
 
-	csd_struct = UNSTUFF_BITS(resp, 126, 2);
+	csd_struct = unstuff_bits(resp, 126, 2);
 
 	switch (csd_struct) {
 	case 0:
-		m = UNSTUFF_BITS(resp, 115, 4);
-		e = UNSTUFF_BITS(resp, 112, 3);
+		m = unstuff_bits(resp, 115, 4);
+		e = unstuff_bits(resp, 112, 3);
 		csd->tacc_ns	 = (tacc_exp[e] * tacc_mant[m] + 9) / 10;
-		csd->tacc_clks	 = UNSTUFF_BITS(resp, 104, 8) * 100;
+		csd->tacc_clks	 = unstuff_bits(resp, 104, 8) * 100;
 
-		m = UNSTUFF_BITS(resp, 99, 4);
-		e = UNSTUFF_BITS(resp, 96, 3);
+		m = unstuff_bits(resp, 99, 4);
+		e = unstuff_bits(resp, 96, 3);
 		csd->max_dtr	  = tran_exp[e] * tran_mant[m];
-		csd->cmdclass	  = UNSTUFF_BITS(resp, 84, 12);
+		csd->cmdclass	  = unstuff_bits(resp, 84, 12);
 
-		e = UNSTUFF_BITS(resp, 47, 3);
-		m = UNSTUFF_BITS(resp, 62, 12);
+		e = unstuff_bits(resp, 47, 3);
+		m = unstuff_bits(resp, 62, 12);
 		csd->capacity	  = (1 + m) << (e + 2);
 
-		csd->read_blkbits = UNSTUFF_BITS(resp, 80, 4);
-		csd->read_partial = UNSTUFF_BITS(resp, 79, 1);
-		csd->write_misalign = UNSTUFF_BITS(resp, 78, 1);
-		csd->read_misalign = UNSTUFF_BITS(resp, 77, 1);
-		csd->r2w_factor = UNSTUFF_BITS(resp, 26, 3);
-		csd->write_blkbits = UNSTUFF_BITS(resp, 22, 4);
-		csd->write_partial = UNSTUFF_BITS(resp, 21, 1);
+		csd->read_blkbits = unstuff_bits(resp, 80, 4);
+		csd->read_partial = unstuff_bits(resp, 79, 1);
+		csd->write_misalign = unstuff_bits(resp, 78, 1);
+		csd->read_misalign = unstuff_bits(resp, 77, 1);
+		csd->r2w_factor = unstuff_bits(resp, 26, 3);
+		csd->write_blkbits = unstuff_bits(resp, 22, 4);
+		csd->write_partial = unstuff_bits(resp, 21, 1);
 
-		if (UNSTUFF_BITS(resp, 46, 1)) {
+		if (unstuff_bits(resp, 46, 1)) {
 			csd->erase_size = 1;
 		} else if (csd->write_blkbits >= 9) {
-			csd->erase_size = UNSTUFF_BITS(resp, 39, 7) + 1;
+			csd->erase_size = unstuff_bits(resp, 39, 7) + 1;
 			csd->erase_size <<= csd->write_blkbits - 9;
 		}
 		break;
@@ -141,17 +141,17 @@ static int mmc_decode_csd(struct mmc_card *card)
 		csd->tacc_ns	 = 0; /* Unused */
 		csd->tacc_clks	 = 0; /* Unused */
 
-		m = UNSTUFF_BITS(resp, 99, 4);
-		e = UNSTUFF_BITS(resp, 96, 3);
+		m = unstuff_bits(resp, 99, 4);
+		e = unstuff_bits(resp, 96, 3);
 		csd->max_dtr	  = tran_exp[e] * tran_mant[m];
-		csd->cmdclass	  = UNSTUFF_BITS(resp, 84, 12);
-		csd->c_size	  = UNSTUFF_BITS(resp, 48, 22);
+		csd->cmdclass	  = unstuff_bits(resp, 84, 12);
+		csd->c_size	  = unstuff_bits(resp, 48, 22);
 
 		/* SDXC cards have a minimum C_SIZE of 0x00FFFF */
 		if (csd->c_size >= 0xFFFF)
 			mmc_card_set_ext_capacity(card);
 
-		m = UNSTUFF_BITS(resp, 48, 22);
+		m = unstuff_bits(resp, 48, 22);
 		csd->capacity     = (1 + m) << 10;
 
 		csd->read_blkbits = 9;
@@ -186,26 +186,26 @@ static int mmc_decode_scr(struct mmc_card *card)
 	resp[3] = card->raw_scr[1];
 	resp[2] = card->raw_scr[0];
 
-	scr_struct = UNSTUFF_BITS(resp, 60, 4);
+	scr_struct = unstuff_bits(resp, 60, 4);
 	if (scr_struct != 0) {
 		pr_err("%s: unrecognised SCR structure version %d\n",
 			mmc_hostname(card->host), scr_struct);
 		return -EINVAL;
 	}
 
-	scr->sda_vsn = UNSTUFF_BITS(resp, 56, 4);
-	scr->bus_widths = UNSTUFF_BITS(resp, 48, 4);
+	scr->sda_vsn = unstuff_bits(resp, 56, 4);
+	scr->bus_widths = unstuff_bits(resp, 48, 4);
 	if (scr->sda_vsn == SCR_SPEC_VER_2)
 		/* Check if Physical Layer Spec v3.0 is supported */
-		scr->sda_spec3 = UNSTUFF_BITS(resp, 47, 1);
+		scr->sda_spec3 = unstuff_bits(resp, 47, 1);
 
-	if (UNSTUFF_BITS(resp, 55, 1))
+	if (unstuff_bits(resp, 55, 1))
 		card->erased_byte = 0xFF;
 	else
 		card->erased_byte = 0x0;
 
 	if (scr->sda_spec3)
-		scr->cmds = UNSTUFF_BITS(resp, 32, 2);
+		scr->cmds = unstuff_bits(resp, 32, 2);
 	return 0;
 }
 
@@ -240,15 +240,15 @@ static int mmc_read_ssr(struct mmc_card *card)
 		ssr[i] = be32_to_cpu(ssr[i]);
 
 	/*
-	 * UNSTUFF_BITS only works with four u32s so we have to offset the
+	 * unstuff_bits only works with four u32s so we have to offset the
 	 * bitfield positions accordingly.
 	 */
-	au = UNSTUFF_BITS(ssr, 428 - 384, 4);
+	au = unstuff_bits(ssr, 428 - 384, 4);
 	if (au > 0 && au <= 9) {
 		card->ssr.au = 1 << (au + 4);
-		es = UNSTUFF_BITS(ssr, 408 - 384, 16);
-		et = UNSTUFF_BITS(ssr, 402 - 384, 6);
-		eo = UNSTUFF_BITS(ssr, 400 - 384, 2);
+		es = unstuff_bits(ssr, 408 - 384, 16);
+		et = unstuff_bits(ssr, 402 - 384, 6);
+		eo = unstuff_bits(ssr, 400 - 384, 2);
 		if (es && et) {
 			card->ssr.erase_timeout = (et * 1000) / es;
 			card->ssr.erase_offset = eo * 1000;


