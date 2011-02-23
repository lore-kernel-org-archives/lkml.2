Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932221Ab1BWQ4e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 11:56:34 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:64445 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932204Ab1BWQ4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 11:56:32 -0500
Date: Wed, 23 Feb 2011 09:56:29 -0700
From: Grant Likely <grant.likely@secretlab.ca>
To: Michal Simek <monstr@monstr.eu>
Cc: linux-i2c@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        john.williams@petalogix.com, linux-kernel@vger.kernel.org,
        John.Linn@xilinx.com
Subject: Re: [PATCH v3 2/2] i2c: xiic: Use 32bit accesses only
Message-ID: <20110223165629.GF14597@angua.secretlab.ca>
References: <1298396971-611-1-git-send-email-monstr@monstr.eu>
 <1298396971-611-2-git-send-email-monstr@monstr.eu>
 <AANLkTinRVKMdOU-8DYLHe5q92nb3ysKnnG-jq8f++AEs@mail.gmail.com>
 <4D64C08F.5030604@monstr.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D64C08F.5030604@monstr.eu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 23, 2011 at 09:08:47AM +0100, Michal Simek wrote:
> Grant Likely wrote:
> >On Tue, Feb 22, 2011 at 10:49 AM, Michal Simek <monstr@monstr.eu> wrote:
> >>i2c driver is used for LE/BE that's why is useful to use
> >>32bit accesses. Then it is not necessary to solve any
> >>endian issues.
> >
> >Are you sure?  I would expect the BE version needs to use
> >io{read,write}32be variants of the accessors.  What platforms have you
> >tested on?
> 
> iowrite32 is the same with iowrite32be for Microblaze.
> I have no problem to change it to iowrite32be if you like.
> 
> I have tested it on microblaze big and little endian platforms.

But this driver was written for x86, and it should be usable on
powerpc too.  You'll need to account for both possibilities.

g.

> 
> Thanks,
> Michal
> 
> 
> >
> >>Signed-off-by: Michal Simek <monstr@monstr.eu>
> >>---
> >> drivers/i2c/busses/i2c-xiic.c |   66 +++++++++++++++++------------------------
> >> 1 files changed, 27 insertions(+), 39 deletions(-)
> >>
> >>diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
> >>index 0b7647b..78b3b82 100644
> >>--- a/drivers/i2c/busses/i2c-xiic.c
> >>+++ b/drivers/i2c/busses/i2c-xiic.c
> >>@@ -178,21 +178,6 @@ struct xiic_i2c {
> >> static void xiic_start_xfer(struct xiic_i2c *i2c);
> >> static void __xiic_start_xfer(struct xiic_i2c *i2c);
> >>
> >>-static inline void xiic_setreg8(struct xiic_i2c *i2c, int reg, u8 value)
> >>-{
> >>-       iowrite8(value, i2c->base + reg);
> >>-}
> >>-
> >>-static inline u8 xiic_getreg8(struct xiic_i2c *i2c, int reg)
> >>-{
> >>-       return ioread8(i2c->base + reg);
> >>-}
> >>-
> >>-static inline void xiic_setreg16(struct xiic_i2c *i2c, int reg, u16 value)
> >>-{
> >>-       iowrite16(value, i2c->base + reg);
> >>-}
> >>-
> >> static inline void xiic_setreg32(struct xiic_i2c *i2c, int reg, int value)
> >> {
> >>       iowrite32(value, i2c->base + reg);
> >>@@ -230,10 +215,11 @@ static inline void xiic_irq_clr_en(struct xiic_i2c *i2c, u32 mask)
> >> static void xiic_clear_rx_fifo(struct xiic_i2c *i2c)
> >> {
> >>       u8 sr;
> >>-       for (sr = xiic_getreg8(i2c, XIIC_SR_REG_OFFSET);
> >>+       for (sr = xiic_getreg32(i2c, XIIC_SR_REG_OFFSET);
> >>               !(sr & XIIC_SR_RX_FIFO_EMPTY_MASK);
> >>-               sr = xiic_getreg8(i2c, XIIC_SR_REG_OFFSET))
> >>-               xiic_getreg8(i2c, XIIC_DRR_REG_OFFSET);
> >>+               sr = xiic_getreg32(i2c, XIIC_SR_REG_OFFSET)) {
> >>+               xiic_getreg32(i2c, XIIC_DRR_REG_OFFSET);
> >>+       }
> >> }
> >>
> >> static void xiic_reinit(struct xiic_i2c *i2c)
> >>@@ -241,13 +227,13 @@ static void xiic_reinit(struct xiic_i2c *i2c)
> >>       xiic_setreg32(i2c, XIIC_RESETR_OFFSET, XIIC_RESET_MASK);
> >>
> >>       /* Set receive Fifo depth to maximum (zero based). */
> >>-       xiic_setreg8(i2c, XIIC_RFD_REG_OFFSET, IIC_RX_FIFO_DEPTH - 1);
> >>+       xiic_setreg32(i2c, XIIC_RFD_REG_OFFSET, IIC_RX_FIFO_DEPTH - 1);
> >>
> >>       /* Reset Tx Fifo. */
> >>-       xiic_setreg8(i2c, XIIC_CR_REG_OFFSET, XIIC_CR_TX_FIFO_RESET_MASK);
> >>+       xiic_setreg32(i2c, XIIC_CR_REG_OFFSET, XIIC_CR_TX_FIFO_RESET_MASK);
> >>
> >>       /* Enable IIC Device, remove Tx Fifo reset & disable general call. */
> >>-       xiic_setreg8(i2c, XIIC_CR_REG_OFFSET, XIIC_CR_ENABLE_DEVICE_MASK);
> >>+       xiic_setreg32(i2c, XIIC_CR_REG_OFFSET, XIIC_CR_ENABLE_DEVICE_MASK);
> >>
> >>       /* make sure RX fifo is empty */
> >>       xiic_clear_rx_fifo(i2c);
> >>@@ -265,8 +251,9 @@ static void xiic_deinit(struct xiic_i2c *i2c)
> >>       xiic_setreg32(i2c, XIIC_RESETR_OFFSET, XIIC_RESET_MASK);
> >>
> >>       /* Disable IIC Device. */
> >>-       cr = xiic_getreg8(i2c, XIIC_CR_REG_OFFSET);
> >>-       xiic_setreg8(i2c, XIIC_CR_REG_OFFSET, cr & ~XIIC_CR_ENABLE_DEVICE_MASK);
> >>+       cr = xiic_getreg32(i2c, XIIC_CR_REG_OFFSET);
> >>+       xiic_setreg32(i2c, XIIC_CR_REG_OFFSET,
> >>+                                       cr & ~XIIC_CR_ENABLE_DEVICE_MASK);
> >> }
> >>
> >> static void xiic_read_rx(struct xiic_i2c *i2c)
> >>@@ -274,22 +261,22 @@ static void xiic_read_rx(struct xiic_i2c *i2c)
> >>       u8 bytes_in_fifo;
> >>       int i;
> >>
> >>-       bytes_in_fifo = xiic_getreg8(i2c, XIIC_RFO_REG_OFFSET) + 1;
> >>+       bytes_in_fifo = xiic_getreg32(i2c, XIIC_RFO_REG_OFFSET) + 1;
> >>
> >>       dev_dbg(i2c->adap.dev.parent, "%s entry, bytes in fifo: %d, msg: %d"
> >>               ", SR: 0x%x, CR: 0x%x\n",
> >>               __func__, bytes_in_fifo, xiic_rx_space(i2c),
> >>-               xiic_getreg8(i2c, XIIC_SR_REG_OFFSET),
> >>-               xiic_getreg8(i2c, XIIC_CR_REG_OFFSET));
> >>+               xiic_getreg32(i2c, XIIC_SR_REG_OFFSET),
> >>+               xiic_getreg32(i2c, XIIC_CR_REG_OFFSET));
> >>
> >>       if (bytes_in_fifo > xiic_rx_space(i2c))
> >>               bytes_in_fifo = xiic_rx_space(i2c);
> >>
> >>       for (i = 0; i < bytes_in_fifo; i++)
> >>               i2c->rx_msg->buf[i2c->rx_pos++] =
> >>-                       xiic_getreg8(i2c, XIIC_DRR_REG_OFFSET);
> >>+                       xiic_getreg32(i2c, XIIC_DRR_REG_OFFSET);
> >>
> >>-       xiic_setreg8(i2c, XIIC_RFD_REG_OFFSET,
> >>+       xiic_setreg32(i2c, XIIC_RFD_REG_OFFSET,
> >>               (xiic_rx_space(i2c) > IIC_RX_FIFO_DEPTH) ?
> >>               IIC_RX_FIFO_DEPTH - 1 :  xiic_rx_space(i2c) - 1);
> >> }
> >>@@ -297,7 +284,7 @@ static void xiic_read_rx(struct xiic_i2c *i2c)
> >> static int xiic_tx_fifo_space(struct xiic_i2c *i2c)
> >> {
> >>       /* return the actual space left in the FIFO */
> >>-       return IIC_TX_FIFO_DEPTH - xiic_getreg8(i2c, XIIC_TFO_REG_OFFSET) - 1;
> >>+       return IIC_TX_FIFO_DEPTH - xiic_getreg32(i2c, XIIC_TFO_REG_OFFSET) - 1;
> >> }
> >>
> >> static void xiic_fill_tx_fifo(struct xiic_i2c *i2c)
> >>@@ -317,9 +304,9 @@ static void xiic_fill_tx_fifo(struct xiic_i2c *i2c)
> >>                       data |= XIIC_TX_DYN_STOP_MASK;
> >>                       dev_dbg(i2c->adap.dev.parent, "%s TX STOP\n", __func__);
> >>
> >>-                       xiic_setreg16(i2c, XIIC_DTR_REG_OFFSET, data);
> >>+                       xiic_setreg32(i2c, XIIC_DTR_REG_OFFSET, data);
> >>               } else
> >>-                       xiic_setreg8(i2c, XIIC_DTR_REG_OFFSET, data);
> >>+                       xiic_setreg32(i2c, XIIC_DTR_REG_OFFSET, data);
> >>       }
> >> }
> >>
> >>@@ -348,7 +335,8 @@ static void xiic_process(struct xiic_i2c *i2c)
> >>
> >>       dev_dbg(i2c->adap.dev.parent, "%s entry, IER: 0x%x, ISR: 0x%x, "
> >>               "pend: 0x%x, SR: 0x%x, msg: %p, nmsgs: %d\n",
> >>-               __func__, ier, isr, pend, xiic_getreg8(i2c, XIIC_SR_REG_OFFSET),
> >>+               __func__, ier, isr, pend,
> >>+               xiic_getreg32(i2c, XIIC_SR_REG_OFFSET),
> >>               i2c->tx_msg, i2c->nmsgs);
> >>
> >>       /* Do not processes a devices interrupts if the device has no
> >>@@ -479,7 +467,7 @@ out:
> >>
> >> static int xiic_bus_busy(struct xiic_i2c *i2c)
> >> {
> >>-       u8 sr = xiic_getreg8(i2c, XIIC_SR_REG_OFFSET);
> >>+       u8 sr = xiic_getreg32(i2c, XIIC_SR_REG_OFFSET);
> >>
> >>       return (sr & XIIC_SR_BUS_BUSY_MASK) ? -EBUSY : 0;
> >> }
> >>@@ -522,17 +510,17 @@ static void xiic_start_recv(struct xiic_i2c *i2c)
> >>       rx_watermark = msg->len;
> >>       if (rx_watermark > IIC_RX_FIFO_DEPTH)
> >>               rx_watermark = IIC_RX_FIFO_DEPTH;
> >>-       xiic_setreg8(i2c, XIIC_RFD_REG_OFFSET, rx_watermark - 1);
> >>+       xiic_setreg32(i2c, XIIC_RFD_REG_OFFSET, rx_watermark - 1);
> >>
> >>       if (!(msg->flags & I2C_M_NOSTART))
> >>               /* write the address */
> >>-               xiic_setreg16(i2c, XIIC_DTR_REG_OFFSET,
> >>+               xiic_setreg32(i2c, XIIC_DTR_REG_OFFSET,
> >>                       (msg->addr << 1) | XIIC_READ_OPERATION |
> >>                       XIIC_TX_DYN_START_MASK);
> >>
> >>       xiic_irq_clr_en(i2c, XIIC_INTR_BNB_MASK);
> >>
> >>-       xiic_setreg16(i2c, XIIC_DTR_REG_OFFSET,
> >>+       xiic_setreg32(i2c, XIIC_DTR_REG_OFFSET,
> >>               msg->len | ((i2c->nmsgs == 1) ? XIIC_TX_DYN_STOP_MASK : 0));
> >>       if (i2c->nmsgs == 1)
> >>               /* very last, enable bus not busy as well */
> >>@@ -551,7 +539,7 @@ static void xiic_start_send(struct xiic_i2c *i2c)
> >>       dev_dbg(i2c->adap.dev.parent, "%s entry, msg: %p, len: %d, "
> >>               "ISR: 0x%x, CR: 0x%x\n",
> >>               __func__, msg, msg->len, xiic_getreg32(i2c, XIIC_IISR_OFFSET),
> >>-               xiic_getreg8(i2c, XIIC_CR_REG_OFFSET));
> >>+               xiic_getreg32(i2c, XIIC_CR_REG_OFFSET));
> >>
> >>       if (!(msg->flags & I2C_M_NOSTART)) {
> >>               /* write the address */
> >>@@ -561,7 +549,7 @@ static void xiic_start_send(struct xiic_i2c *i2c)
> >>                       /* no data and last message -> add STOP */
> >>                       data |= XIIC_TX_DYN_STOP_MASK;
> >>
> >>-               xiic_setreg16(i2c, XIIC_DTR_REG_OFFSET, data);
> >>+               xiic_setreg32(i2c, XIIC_DTR_REG_OFFSET, data);
> >>       }
> >>
> >>       xiic_fill_tx_fifo(i2c);
> >>@@ -653,7 +641,7 @@ static int xiic_xfer(struct i2c_adapter *adap, struct i2c_msg *msgs, int num)
> >>       int err;
> >>
> >>       dev_dbg(adap->dev.parent, "%s entry SR: 0x%x\n", __func__,
> >>-               xiic_getreg8(i2c, XIIC_SR_REG_OFFSET));
> >>+               xiic_getreg32(i2c, XIIC_SR_REG_OFFSET));
> >>
> >>       err = xiic_busy(i2c);
> >>       if (err)
> >>--
> >>1.5.5.6
> >>
> >>--
> >>To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> >>the body of a message to majordomo@vger.kernel.org
> >>More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>Please read the FAQ at  http://www.tux.org/lkml/
> >>
> >
> >
> >
> 
> 
> -- 
> Michal Simek, Ing. (M.Eng)
> w: www.monstr.eu p: +42-0-721842854
> Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
> Microblaze U-BOOT custodian
