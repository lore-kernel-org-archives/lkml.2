Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751988Ab2FDEGK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 00:06:10 -0400
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:27483
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750744Ab2FDEGI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 00:06:08 -0400
X-Forefront-Antispam-Report: CIP:137.71.25.55;KIP:(null);UIP:(null);IPV:NLI;H:nwd2mta1.analog.com;RD:nwd2mail10.analog.com;EFVD:NLI
X-SpamScore: -11
X-BigFish: VPS-11(zz9371I542M1432N98dKa706lzz1202hzz8275dhz2dh2a8h668h839h944hd25hf0ah)
From: "Zhang, Sonic" <Sonic.Zhang@analog.com>
To: Mike Frysinger <vapier@gentoo.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        Sonic Zhang <sonic.adi@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>
Date: Mon, 4 Jun 2012 00:05:36 -0400
Subject: RE: [uclinux-dist-devel] [PATCH 2/2] crypto: bfin_crc: CRC hardware
	accelerator driver for BF60x family processors.
Thread-Topic: [uclinux-dist-devel] [PATCH 2/2] crypto: bfin_crc: CRC
 hardware	accelerator driver for BF60x family processors.
Thread-Index: Ac1AkBpAkVBGQnjlSkiOnvLAqfJPQQBbT/yg
Message-ID: <DB904C5425BA6F4E8424B3B51A1414D170234DC573@NWD2CMBX1.ad.analog.com>
References: <1337939654-12222-1-git-send-email-sonic.adi@gmail.com>
	<1337939654-12222-2-git-send-email-sonic.adi@gmail.com>
 <201206020319.14870.vapier@gentoo.org>
In-Reply-To: <201206020319.14870.vapier@gentoo.org>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: zh-CN, en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: analog.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>-----Original Message-----
>From: uclinux-dist-devel-bounces@blackfin.uclinux.org [mailto:uclinux-dist-devel-
>bounces@blackfin.uclinux.org] On Behalf Of Mike Frysinger
>Sent: Saturday, June 02, 2012 3:19 PM
>To: uclinux-dist-devel@blackfin.uclinux.org
>Cc: Herbert Xu; Sonic Zhang; David S. Miller; LKML; linux-crypto@vger.kernel.org
>Subject: Re: [uclinux-dist-devel] [PATCH 2/2] crypto: bfin_crc: CRC hardware
>accelerator driver for BF60x family processors.
>
>On Friday 25 May 2012 05:54:14 Sonic Zhang wrote:
>> --- a/drivers/crypto/Kconfig
>> +++ b/drivers/crypto/Kconfig
>>
>> +config CRYPTO_DEV_BFIN_CRC
>> +    tristate "Support for Blackfin CRC hareware accelerator"
>
>hardware
>
>> +    depends on BF60x
>> +    help
>> +      Blackfin processors have CRC hardware accelerator.
>
>Newer Blackfin processors have a CRC hardware accelerator.
>
>> --- /dev/null
>> +++ b/drivers/crypto/bfin_crc.c
>>
>> +struct bfin_crypto_crc_list {
>> +    struct list_head        dev_list;
>> +    spinlock_t              lock;
>> +} crc_list;
>
>static
>
>> +    if (sg_count(req->src) > CRC_MAX_DMA_DESC) {
>> +            dev_dbg(crc->dev, "init: requested sg list is too big > %d\n",
>> +                    CRC_MAX_DMA_DESC);
>> +            return -EINVAL;
>> +    }
>
>do you need to do this ?  considering the crc is stream based, why can't you fill up
>as many as possible, wait for it to finish, and then send more data ?
>

No, the async hash crypto API should not wait for the DMA to complete.


>> +    /* init crc results */
>> +    *(__le32 *)req->result =
>> +            cpu_to_le32p(&crc_ctx->key);
>
>right handed casts are generally frowned upon if not banned.  plus, result is a u8*,
>so it seems like a pretty bad idea to do this on a Blackfin (which doesn't allow
>unaligned accesses).  isn't this what you want:
>       put_unaligned_le32(crc_ctx->key, req->result);

The result element in structure ahash_request is always 4-byte aligned. So, put_unaligned_le32 is not necessary.
Of course, it is fine as well.

>
>> +            /* chop current sg dma len to multiply of 32 bits */
>
>"multiply" -> "multiple"
>
>> +            dma_count = (dma_count >> 2) << 2;
>
>dma_count &= ~0x3;
>
>> +    if (i == 0)
>> +            return ;
>
>no space before the ;
>
>> +#define MIN(x,y) ((x) < (y) ? x : y)
>
>linux/kernel.h already provides min() macros for you
>
>> +            /* Pack small data which is less than 32bit to buffer for next
>update.*/
>
>needs a space after the period
>
>> +            /* punch crc buffer size to multiply of 32 bit */
>
>i think you mean "chop" rather than "punch", and it should be "multiple"
>rather than "multiply"
>
>> +            ctx->sg_buflen = (ctx->sg_buflen >> 2) << 2;
>
>ctx->sg_buflen &= ~0x3;
>
>> +                    memset(ctx->bufnext, 0, CHKSUM_DIGEST_SIZE);
>
>use a space after the , not a tab
>
>> +                    nextlen = ctx->bufnext_len;
>> +                    for (i = nsg - 1; i >= 0; i--) {
>> +                            sg = sg_get(ctx->sg, nsg, i);
>
>this is the only place you use sg_get(), and it looks like it's extremely
>inefficient.  i guess it's not possible to re-order the pointer walking though.
>
>> +static int bfin_crypto_crc_setkey(struct crypto_ahash *tfm, const u8 *key,
>> +                  unsigned int keylen)
>> +{
>> +    struct bfin_crypto_crc_ctx *crc_ctx = crypto_ahash_ctx(tfm);
>> +
>> +    dev_dbg(crc_ctx->crc->dev, "crc_setkey\n");
>> +        if (keylen != CHKSUM_DIGEST_SIZE) {
>> +                crypto_ahash_set_flags(tfm, CRYPTO_TFM_RES_BAD_KEY_LEN);
>> +                return -EINVAL;
>> +        }
>
>indentation seems to be off here.  suggest you run this through checkpatch.pl.
>
>> +    crc_ctx->key = le32_to_cpu(*(__le32 *)key);
>
>shouldn't this be get_unaligned_le32 ?
>
>> +            /* prepare results */
>> +            *(__le32 *)crc->req->result =
>> +                    cpu_to_le32p((u32 *)&crc->regs->result);
>
>put_unaligned_le32()
>
>> +static int bfin_crypto_crc_suspend(struct platform_device *pdev,
>> pm_message_t state) +{
>> +    struct bfin_crypto_crc *crc = platform_get_drvdata(pdev);
>> +    int i = 100000;
>> +
>> +    while ((crc->regs->control & BLKEN) && --i)
>> +            cpu_relax();
>> +
>> +    if (i == 0)
>> +            crc->regs->control &= ~BLKEN;
>> +
>> +    return 0;
>> +}
>
>should this return -EBUSY instead of clearing BLKEN ?
>
>> +static int bfin_crypto_crc_resume(struct platform_device *pdev)
>> +{
>> +    return 0;
>> +}
>
>if there's nothing to resume, do you need to provide your own func ?
>
>> +static int __devinit bfin_crypto_crc_probe(struct platform_device *pdev)
>> +{
>> +    struct device *dev = &pdev->dev;
>> +    struct resource *res;
>> +    struct bfin_crypto_crc *crc = NULL;
>
>not much point in setting this to NULL considering the first thing you do is
>allocate it
>
>> +    ret = request_irq(crc->irq, bfin_crypto_crc_handler, IRQF_SHARED,
>> DRIVER_NAME, crc);
>
>you could use dev_name() rather than DRIVER_NAME
>
>> +    ret = request_dma(crc->dma_ch, DRIVER_NAME);
>
>same here
>
>> +    /* need at most CRC_MAX_DMA_DESC sg + CRC_MAX_DMA_DESC
>middle  +
>> +       1 last + 1 next dma descriptors
>> +     */
>
>multiline comments look like:
>       /*
>        * foo
>        * bar
>        */
>
>> +    while (!(crc->regs->status & LUTDONE) && (--timeout) > 0)
>> +            cpu_relax();
>
>no need for paren around the timeout decrement, and this should be an actual
>timer based timeout rather than some big integer.  pretty easy to do with
>wait_for_completion_timeout().

Wait_for_completion_timeout() depends on an LUTDONE interrupt to wake up the probing task. But, there is no such interrupt available in bfin CRC device.
May be call yield() other than cpu_relax() is what you expected?

>
>> +static int __devexit bfin_crypto_crc_remove(struct platform_device *pdev)
>> +{
>> +    struct bfin_crypto_crc *crc = platform_get_drvdata(pdev);
>> +
>> +    if (!crc)
>> +            return -ENODEV;
>
>is this even possible ?

In case the platform drvdata is corrupted.

>
>> +static int __init bfin_crypto_crc_mod_init(void)
>> +{
>> +    int ret;
>> +
>> +    pr_info("Blackfin hardware CRC crypto driver\n");
>> +
>> +    INIT_LIST_HEAD(&crc_list.dev_list);
>> +    spin_lock_init(&crc_list.lock);
>> +
>> +    ret = platform_driver_register(&bfin_crypto_crc_driver);
>> +    if (ret) {
>> +            pr_info(KERN_ERR "unable to register driver\n");
>> +            return ret;
>> +    }
>> +
>> +    return 0;
>> +}
>
>if you declare the list/spin_lock separately and not together in a structure,

It is clean and better to keep the spin lock in structure crc_list.


Sonic

>you could statically initialize them (rather than needing to do it at
>runtime), and then you could drop the init/exit functions here and replace
>them with a single module_platform_driver(bfin_crypto_crc_driver).
>-mike

