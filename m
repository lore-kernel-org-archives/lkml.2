Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758953Ab0DAXXr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 19:23:47 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:61426 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758987Ab0DAXXl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 19:23:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=rgLcKz49g/7Z0GMJ50YHdfAJVfxjCZy8BTxc2Rw2R+QlIup78HgmFGH3DFRbVfuOQK
         SpUEd0X2kIqc0Sh3GEDxnJ8RSJTd24SrAwCkU6jFJqpaWjrtY5v7SkTTX79I2P3GBWPa
         RnI9YeqPmrbPi2cudz1VfOZyrdYRbSflR3uHc=
MIME-Version: 1.0
In-Reply-To: <k2q1b68c6791003312234qe5da41e7oa1a0c7f535dbb179@mail.gmail.com>
References: <4BAAD5BB.7050101@samsung.com>
	 <1b68c6791003242234h106d9530p12b5a046a906227e@mail.gmail.com>
	 <63386a3d1003250130w6f34854ag2ca163799e9b7bed@mail.gmail.com>
	 <1b68c6791003250517y4e2789baoe147e5982c363682@mail.gmail.com>
	 <63386a3d1003250820x3cf81000i9d27e95c755b9ca8@mail.gmail.com>
	 <k2q1b68c6791003312234qe5da41e7oa1a0c7f535dbb179@mail.gmail.com>
Date: Fri, 2 Apr 2010 01:23:37 +0200
Message-ID: <t2t63386a3d1004011623m43212bb4z4dde424b30e3d184@mail.gmail.com>
Subject: Re: [PATCH v2] PL330: Add PL330 DMA controller driver
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: jassi brar <jassisinghbrar@gmail.com>
Cc: Joonyoung Shim <jy0922.shim@samsung.com>, dan.j.williams@intel.com,
       kyungmin.park@samsung.com, linux-kernel@vger.kernel.org,
       linux-arm-kernel@lists.infradead.org,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       Ben Dooks <ben-linux@fluff.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jassi,

this is looking good.

The only advantage of the other driver by Joonyoung is that it is finished and
ready for integration. If you finalize the DMA devices/engine API and post
this in time for the next merge window I would easily vote for including this
one rather than the other one. (Whatever that means for the world.)
Simply for technical merits.

It's sad that you two have done duplicate work but such is life..

I understand it that as this is the core engine so you intend to keep the core
in arch/arm/common/* and then a separate interface to the DMAdevices
implementing <linux/dmaengine.h> in drivers/dma/ and this is what the
"DMA API" referenced below refers to?

In that case I really like this clear separation between hardware driver
and DMA devices/engine API. And I see that the DMA API is not far
away. If you implement it you will be able to excersise this with the
DMA engine memcpy test to assure it's working.

There is nothing wrong with moving this entire thing except the header
file into drivers/dma it will be more comfortable there, with the other
DMA drivers. Whether the header should be in include/linux/amba
or include/linux/dma is however a good question for the philosophers,
but I would stick it into linux/amba with the rest of the PrimeCells.
But perhaps you have better ideas.

2010/4/1 jassi brar <jassisinghbrar@gmail.com>:

> o  The DMA API driver submits 'request' to PL330 engine.
>     A request is a sequence of DMA 'xfers' to be done before the DMA
> API driver wants to be notified.

This hints that there is some other patch to provide that API
<linux/dmaengine.h> that is not part of this patch, right?

>     A req can be a scatter-Gather-List.

This is great, do you also plan to support that for M<->M xfers like we
added for the DMA40? Then we might want to lift that into the generic
DMA engine.

> o  PL330 engine accepts requests from DMA API drivers in ping-pong manner,
>    i.e, at any time maximum two reqs can be queued. Other reqs have
>    to be buffered by DMA API drivers and enqueued whenever a req-finish
>    callback is made.

Nice!

> o  TODO: Desirable is to implement true LLI using MicroCode
> modification during each
>    request enqueue, so that the xfer continues even while IRQ is
> handled and callbacks made.
>    To me, there doesn't seem to be a way to flush ICACHE of a channel
> without halting it, so we
>    can't modify MicroCode in runtime. Using two channels per client
> to achieve true LLI is the last resort.

True, not as elegant as being able to do it with microcode but
still quite elegant.

>    So currently, cpu intervention is required to trigger each xfer,
> hence interrupt latency might play
>    some role.

>From the DMA API level in the PrimeCell drivers the crucial driver that
need something like this is the AMBA PL011 UART driver, RX part,
where data comes in from the outside and we have no control over
the data flow. I trigger one transfer to a buffer here, then wait for it
to complete or be interrupted. If it completes, I immediately trigger
another transfer to the second buffer before I start processing the just
recieved buffer (like front/back buffers).

I just hope that this will always be fast enough, queueing two transfers
after each other at the same time first would perhaps be better if the
hardware can handle it, now we have no hardware that can actually
queue that up so we can work it over the day we see something like
that...

(I don't know if I'm making myself clear, the PL011 patch may
speak for itself rather.)

> o  TODO: PAUSE/RESUME support. Currently the DMA API driver has to emulate it.

The only PrimeCell that needs this is currently again the PL011.
It needs to PAUSE then get the number of pending bytes and then
terminate the transfer. This is done when we timeout transfers e.g.
for UART consoles. So being able to pause and retrieve the number
of bytes left and then cancel is the most advanced sequence that
will be used by a PrimeCell currently.

I've seen sample PCM/I2S drivers that wants PAUSE/RESUME though.

(...)
> Basic PL330 engine driver
>
> Signed-off-by: Jassi Brar <jassi.brar@samsung.com>
> ---
>  arch/arm/common/Kconfig               |    3 +
>  arch/arm/common/Makefile              |    1 +
>  arch/arm/common/pl330.c               | 1891 +++++++++++++++++++++++++++++++++
>  arch/arm/include/asm/hardware/pl330.h |  197 ++++
>  4 files changed, 2092 insertions(+), 0 deletions(-)
>  create mode 100644 arch/arm/common/pl330.c
>  create mode 100644 arch/arm/include/asm/hardware/pl330.h

Contemplate moving all but the header file to drivers/dma (not that I
have any strong feelings about it, just feels right).

(...)
> +/* Register and Bit field Definitions */
> +#define DS             0x0
> +#define DS_ST_STOP     0x0
> +#define DS_ST_EXEC     0x1
> +#define DS_ST_CMISS    0x2
> +#define DS_ST_UPDTPC   0x3
> +#define DS_ST_WFE      0x4
> +#define DS_ST_ATBRR    0x5
> +#define DS_ST_QBUSY    0x6
> +#define DS_ST_WFP      0x7
> +#define DS_ST_KILL     0x8
> +#define DS_ST_CMPLT    0x9
> +#define DS_ST_FLTCMP   0xe
> +#define DS_ST_FAULT    0xf
> +
> +#define DPC            0x4
> +#define INTEN          0x20
> +#define ES             0x24
> +#define INTSTATUS      0x28
> +#define INTCLR         0x2c
> +#define FSM            0x30
> +#define FSC            0x34
> +#define FTM            0x38
> +
> +#define _FTC           0x40
> +#define FTC(n)         (_FTC + (n)*0x4)
> +
> +#define _CS            0x100
> +#define CS(n)          (_CS + (n)*0x8)
> +#define CS_CNS         (1 << 21)
> +
> +#define _CPC           0x104
> +#define CPC(n)         (_CPC + (n)*0x8)
> +
> +#define _SA            0x400
> +#define SA(n)          (_SA + (n)*0x20)
> +
> +#define _DA            0x404
> +#define DA(n)          (_DA + (n)*0x20)
> +
> +#define _CC            0x408
> +#define CC(n)          (_CC + (n)*0x20)
> +
> +#define CC_SRCINC      (1 << 0)
> +#define CC_DSTINC      (1 << 14)
> +#define CC_SRCPRI      (1 << 8)
> +#define CC_DSTPRI      (1 << 22)
> +#define CC_SRCNS       (1 << 9)
> +#define CC_DSTNS       (1 << 23)
> +#define CC_SRCIA       (1 << 10)
> +#define CC_DSTIA       (1 << 24)
> +#define CC_SRCBRSTLEN_SHFT     4
> +#define CC_DSTBRSTLEN_SHFT     18
> +#define CC_SRCBRSTSIZE_SHFT    1
> +#define CC_DSTBRSTSIZE_SHFT    15
> +#define CC_SRCCCTRL_SHFT       11
> +#define CC_SRCCCTRL_MASK       0x7
> +#define CC_DSTCCTRL_SHFT       25
> +#define CC_DRCCCTRL_MASK       0x7
> +#define CC_SWAP_SHFT   28
> +
> +#define _LC0           0x40c
> +#define LC0(n)         (_LC0 + (n)*0x20)
> +
> +#define _LC1           0x410
> +#define LC1(n)         (_LC1 + (n)*0x20)
> +
> +#define DBGSTATUS      0xd00
> +#define DBG_BUSY       (1 << 0)
> +
> +#define DBGCMD         0xd04
> +#define DBGINST0       0xd08
> +#define DBGINST1       0xd0c
> +
> +#define CR0            0xe00
> +#define CR1            0xe04
> +#define CR2            0xe08
> +#define CR3            0xe0c
> +#define CR4            0xe10
> +#define CRD            0xe14
> +
> +#define PERIPH_ID      0xfe0
> +#define PCELL_ID       0xff0
> +
> +#define CR0_PERIPH_REQ_SET     (1 << 0)
> +#define CR0_BOOT_EN_SET                (1 << 1)
> +#define CR0_BOOT_MAN_NS                (1 << 2)
> +#define CR0_NUM_CHANS_SHIFT    4
> +#define CR0_NUM_CHANS_MASK     0x7
> +#define CR0_NUM_PERIPH_SHIFT   12
> +#define CR0_NUM_PERIPH_MASK    0x1f
> +#define CR0_NUM_EVENTS_SHIFT   17
> +#define CR0_NUM_EVENTS_MASK    0x1f
> +
> +#define CR1_ICACHE_LEN_SHIFT   0
> +#define CR1_ICACHE_LEN_MASK    0x7
> +#define CR1_NUM_ICACHELINES_SHIFT      4
> +#define CR1_NUM_ICACHELINES_MASK       0xf
> +
> +#define CRD_DATA_WIDTH_SHIFT   0
> +#define CRD_DATA_WIDTH_MASK    0x7
> +#define CRD_WR_CAP_SHIFT       4
> +#define CRD_WR_CAP_MASK                0x7
> +#define CRD_WR_Q_DEP_SHIFT     8
> +#define CRD_WR_Q_DEP_MASK      0xf
> +#define CRD_RD_CAP_SHIFT       12
> +#define CRD_RD_CAP_MASK                0x7
> +#define CRD_RD_Q_DEP_SHIFT     16
> +#define CRD_RD_Q_DEP_MASK      0xf
> +#define CRD_DATA_BUFF_SHIFT    20
> +#define CRD_DATA_BUFF_MASK     0x3ff
> +
> +#define        PART            0x330
> +#define DESIGNER       0x41
> +#define REVISION       0x0
> +#define INTEG_CFG      0x0
> +#define PERIPH_ID_VAL  ((PART << 0) | (DESIGNER << 12) \
> +                         | (REVISION << 20) | (INTEG_CFG << 24))
> +
> +#define PCELL_ID_VAL   0xb105f00d
> +
> +#define PL330_STATE_STOPPED            (1 << 0)
> +#define PL330_STATE_EXECUTING          (1 << 1)
> +#define PL330_STATE_WFE                        (1 << 2)
> +#define PL330_STATE_FAULTING           (1 << 3)
> +#define PL330_STATE_COMPLETING         (1 << 4)
> +#define PL330_STATE_WFP                        (1 << 5) /* TOUT for exit? */
> +#define PL330_STATE_KILLING            (1 << 6)
> +#define PL330_STATE_FAULT_COMPLETING   (1 << 7)
> +#define PL330_STATE_CACHEMISS          (1 << 8)
> +#define PL330_STATE_UPDTPC             (1 << 9)
> +#define PL330_STATE_ATBARRIER          (1 << 10) /* TOUT for exit? */
> +#define PL330_STATE_QUEUEBUSY          (1 << 11) /* TOUT for exit? */
> +#define PL330_STATE_INVALID            (1 << 15) /* To catch error */
> +
> +#define PL330_STABLE_STATES (PL330_STATE_STOPPED | PL330_STATE_EXECUTING \
> +                               | PL330_STATE_WFE | PL330_STATE_FAULTING)
> +
> +#define CMD_DMAADDH    0x54
> +#define CMD_DMAEND     0x00
> +#define CMD_DMAFLUSHP  0x35
> +#define CMD_DMAGO      0xa0
> +#define CMD_DMALD      0x04
> +#define CMD_DMALDP     0x25
> +#define CMD_DMALP      0x20
> +#define CMD_DMALPEND   0x28
> +#define CMD_DMAKILL    0x01
> +#define CMD_DMAMOV     0xbc
> +#define CMD_DMANOP     0x18
> +#define CMD_DMARMB     0x12
> +#define CMD_DMASEV     0x34
> +#define CMD_DMAST      0x08
> +#define CMD_DMASTP     0x29
> +#define CMD_DMASTZ     0x0c
> +#define CMD_DMAWFE     0x36
> +#define CMD_DMAWFP     0x30
> +#define CMD_DMAWMB     0x13
> +
> +#define SZ_DMAADDH     3
> +#define SZ_DMAEND      1
> +#define SZ_DMAFLUSHP   2
> +#define SZ_DMALD       1
> +#define SZ_DMALDP      2
> +#define SZ_DMALP       2
> +#define SZ_DMALPEND    2
> +#define SZ_DMAKILL     1
> +#define SZ_DMAMOV      6
> +#define SZ_DMANOP      1
> +#define SZ_DMARMB      1
> +#define SZ_DMASEV      2
> +#define SZ_DMAST       1
> +#define SZ_DMASTP      2
> +#define SZ_DMASTZ      1
> +#define SZ_DMAWFE      2
> +#define SZ_DMAWFP      2
> +#define SZ_DMAWMB      1
> +#define SZ_DMAGO       6
> +
> +#define BRST_LEN(ccr)  ((((ccr) >> CC_SRCBRSTLEN_SHFT) & 0xf) + 1)
> +#define BRST_SIZE(ccr) (1 << (((ccr) >> CC_SRCBRSTSIZE_SHFT) & 0x7))
> +
> +#define BYTE_TO_BURST(b, ccr)          ((b) / BRST_SIZE(ccr))
> +#define BURST_TO_BYTE(c, ccr)          ((c) * BRST_SIZE(ccr))
> +
> +/* With 256 bytes, we can do more than 2.5MB and 5MB xfers per req
> + * at 1byte/burst for P<->M and M<->M respectively.
> + * For typical scenario, at 1word/burst, 10MB and 20MB xfers per req
> + * should be enough for P<->M and M<->M respectively.
> + */


I like multiline comments like this, notice blank first line:

/*
 * Foo
 */

(Yeah I know it's picky. Applies to entire file.)

> +#define MCODE_BUFF_PER_REQ     256
> +
> +/* If program counter 'pc' is at req 'r' */
> +#define PC_AT_REQ(r, sz, pc)   (((pc) >= (r)->mc_bus) && \
> +                               ((pc) < ((r)->mc_bus + sz)))
> +
> +#define msecs_to_loops(t) (loops_per_jiffy / 1000 * HZ * t)
> +
> +struct _xfer_spec {
> +       u32 ccr;
> +       struct pl330_req *r;
> +       struct pl330_xfer *x;
> +};
> +
> +enum dmamov_dst {
> +       SAR = 0,
> +       CCR,
> +       DAR,
> +};
> +
> +enum pl330_dst {
> +       SRC = 0,
> +       DST,
> +};
> +
> +enum pl330_cond {
> +       SINGLE,
> +       BURST,
> +       ALWAYS,
> +};
> +
> +struct _pl330_req {
> +       u32 mc_bus;
> +       void *mc_cpu;
> +       struct pl330_req *r;
> +       /* hook to attach to DMAC's list of reqs with callbacks due */
> +       struct list_head rqd;
> +};
> +
> +struct _pl330_tbd {
> +       /* DMAC needs to be reset */
> +       unsigned reset_dmac:1;
> +       /* manager needs to be reset */
> +       unsigned reset_mngr:1;

Contemplate using bool for these two members.

> +       /* which thread needs to be reset */
> +       unsigned reset_chan:8;

Why not use:
u8 reset_chan;

> +};
> +
> +struct pl330_thread { /* Each DMA Channel */
> +       u8 id;
> +       int ev;
> +       /* If the channel is not yet acquired by any client */
> +       bool free;
> +       /* 0 for inactive, index of active request + 1, otherwise */
> +       unsigned active;
> +       struct mutex mtx;
> +       /* Only two at a time */
> +       struct _pl330_req req[2];
> +       /* parent DMAC */
> +       struct pl330_dmac *dmac;
> +};
> +
> +enum pl330_dmac_state {
> +       UNINIT,
> +       INIT,
> +       DYING,
> +};
> +
> +/* Each DMA Controller */
> +struct pl330_dmac {
> +       struct _pl330_tbd       dmac_tbd;
> +       spinlock_t              lock;
> +       /* hook to attach to global list of DMACs */
> +       struct list_head        node;
> +       /* Holds list of reqs with due callbacks */
> +       struct list_head        req_done;
> +       struct device           *dev;
> +       struct pl330_info       pinfo;
> +       /* Maximum possible events/irqs */
> +       int                     events[32];
> +       /* BUS address of buffer allocated for MicroCode for all Channels */
> +       u32                     mcode_bus;
> +       /* CPU address of buffer allocated for MicroCode for all Channels*/
> +       void                    *mcode_cpu;
> +       struct pl330_thread     *channels;
> +       /* MANAGER thread is _always_ the last one */
> +       struct pl330_thread     *manager;
> +       struct tasklet_struct   tasks;
> +       enum pl330_dmac_state   state;
> +};
> +
> +/* All PL-330 DMACs are added to this list */
> +static LIST_HEAD(pl330_list);
> +/* Protection mutex while list manipulation */
> +static DEFINE_MUTEX(pl330_mutex);
> +
> +static inline void _callback(struct pl330_req *r, int err)
> +{
> +       if (r && r->xfer_cb)
> +               r->xfer_cb(r->token, err);
> +}
> +
> +static inline bool _queue_empty(struct pl330_thread *thrd)
> +{
> +       return (thrd->req[0].r || thrd->req[1].r) ? false : true;
> +}
> +
> +static inline bool _queue_full(struct pl330_thread *thrd)
> +{
> +       return (thrd->req[0].r && thrd->req[1].r) ? true : false;
> +}
> +
> +static inline bool is_manager(struct pl330_thread *thrd)
> +{
> +       struct pl330_dmac *pl330 = thrd->dmac;
> +
> +       /* MANAGER is indexed at the end */
> +       if (thrd->id == pl330->pinfo.pcfg.num_chan)
> +               return true;
> +       else
> +               return false;
> +}
> +
> +/* If manager of the thread is in Non-Secure mode */
> +static inline bool _manager_ns(struct pl330_thread *thrd)
> +{
> +       struct pl330_dmac *pl330 = thrd->dmac;
> +
> +       return (pl330->pinfo.pcfg.mode & DMAC_MODE_NS) ? true : false;
> +}
> +
> +static inline u32 get_id(struct pl330_dmac *pl330, u32 off)
> +{
> +       void __iomem *r = pl330->pinfo.base;
> +       u32 id = 0;
> +
> +       id |= (readb(r + off + 0x0) << 0);
> +       id |= (readb(r + off + 0x4) << 8);
> +       id |= (readb(r + off + 0x8) << 16);
> +       id |= (readb(r + off + 0xc) << 24);
> +
> +       return id;
> +}
> +
> +static inline u32 _emit_ADDH(unsigned dry_run, u8 buf[],
> +               enum pl330_dst da, u16 val)
> +{
> +       if (dry_run)
> +               return SZ_DMAADDH;
> +
> +       buf[0] = CMD_DMAADDH;
> +       buf[0] |= (da << 1);
> +       *((u16 *)&buf[1]) = val;
> +
> +       return SZ_DMAADDH;
> +}
> +
> +static inline u32 _emit_END(unsigned dry_run, u8 buf[])
> +{
> +       if (dry_run)
> +               return SZ_DMAEND;
> +
> +       buf[0] = CMD_DMAEND;
> +
> +       return SZ_DMAEND;
> +}
> +
> +static inline u32 _emit_FLUSHP(unsigned dry_run, u8 buf[], u8 peri)
> +{
> +       if (dry_run)
> +               return SZ_DMAFLUSHP;
> +
> +       buf[0] = CMD_DMAFLUSHP;
> +
> +       peri &= 0x1f;
> +       peri <<= 3;
> +       buf[1] = peri;
> +
> +       return SZ_DMAFLUSHP;
> +}
> +
> +static inline u32 _emit_LD(unsigned dry_run, u8 buf[], enum pl330_cond cond)
> +{
> +       if (dry_run)
> +               return SZ_DMALD;
> +
> +       buf[0] = CMD_DMALD;
> +
> +       if (cond == SINGLE)
> +               buf[0] |= (0 << 1) | (1 << 0);
> +       else if (cond == BURST)
> +               buf[0] |= (1 << 1) | (1 << 0);
> +
> +       return SZ_DMALD;
> +}
> +
> +static inline u32 _emit_LDP(unsigned dry_run, u8 buf[],
> +               enum pl330_cond cond, u8 peri)
> +{
> +       if (dry_run)
> +               return SZ_DMALDP;
> +
> +       buf[0] = CMD_DMALDP;
> +
> +       if (cond == BURST)
> +               buf[0] |= (1 << 1);
> +
> +       peri &= 0x1f;
> +       peri <<= 3;
> +       buf[1] = peri;
> +
> +       return SZ_DMALDP;
> +}
> +
> +static inline u32 _emit_LP(unsigned dry_run, u8 buf[],
> +               unsigned loop, u8 cnt)
> +{
> +       if (dry_run)
> +               return SZ_DMALP;
> +
> +       buf[0] = CMD_DMALP;
> +
> +       if (loop)
> +               buf[0] |= (1 << 1);
> +
> +       buf[1] = cnt;
> +
> +       return SZ_DMALP;
> +}
> +
> +struct _arg_LPEND {
> +       enum pl330_cond cond;
> +       bool forever;
> +       unsigned loop;
> +       u8 bjump;
> +};
> +
> +static inline u32 _emit_LPEND(unsigned dry_run, u8 buf[],
> +               const struct _arg_LPEND *arg)
> +{
> +       enum pl330_cond cond = arg->cond;
> +       bool forever = arg->forever;
> +       unsigned loop = arg->loop;
> +       u8 bjump = arg->bjump;
> +
> +
> +       if (dry_run)
> +               return SZ_DMALPEND;
> +
> +       buf[0] = CMD_DMALPEND;
> +
> +       if (loop)
> +               buf[0] |= (1 << 2);
> +
> +       if (forever)
> +               buf[0] |= (1 << 4);
> +
> +       if (cond == SINGLE)
> +               buf[0] |= (0 << 1) | (1 << 0);
> +       else if (cond == BURST)
> +               buf[0] |= (1 << 1) | (1 << 0);
> +
> +       buf[1] = bjump;
> +
> +       return SZ_DMALPEND;
> +}
> +
> +static inline u32 _emit_KILL(unsigned dry_run, u8 buf[])
> +{
> +       if (dry_run)
> +               return SZ_DMAKILL;
> +
> +       buf[0] = CMD_DMAKILL;
> +
> +       return SZ_DMAKILL;
> +}
> +
> +static inline u32 _emit_MOV(unsigned dry_run, u8 buf[],
> +               enum dmamov_dst dst, u32 val)
> +{
> +       if (dry_run)
> +               return SZ_DMAMOV;
> +
> +       buf[0] = CMD_DMAMOV;
> +       buf[1] = dst;
> +       *((u32 *)&buf[2]) = val;
> +
> +       return SZ_DMAMOV;
> +}
> +
> +static inline u32 _emit_NOP(unsigned dry_run, u8 buf[])
> +{
> +       if (dry_run)
> +               return SZ_DMANOP;
> +
> +       buf[0] = CMD_DMANOP;
> +
> +       return SZ_DMANOP;
> +}
> +
> +static inline u32 _emit_RMB(unsigned dry_run, u8 buf[])
> +{
> +       if (dry_run)
> +               return SZ_DMARMB;
> +
> +       buf[0] = CMD_DMARMB;
> +
> +       return SZ_DMARMB;
> +}
> +
> +static inline u32 _emit_SEV(unsigned dry_run, u8 buf[], u8 ev)
> +{
> +       if (dry_run)
> +               return SZ_DMASEV;
> +
> +       buf[0] = CMD_DMASEV;
> +
> +       ev &= 0x1f;
> +       ev <<= 3;
> +       buf[1] = ev;
> +
> +       return SZ_DMASEV;
> +}
> +
> +static inline u32 _emit_ST(unsigned dry_run, u8 buf[], enum pl330_cond cond)
> +{
> +       if (dry_run)
> +               return SZ_DMAST;
> +
> +       buf[0] = CMD_DMAST;
> +
> +       if (cond == SINGLE)
> +               buf[0] |= (0 << 1) | (1 << 0);
> +       else if (cond == BURST)
> +               buf[0] |= (1 << 1) | (1 << 0);
> +
> +       return SZ_DMAST;
> +}
> +
> +static inline u32 _emit_STP(unsigned dry_run, u8 buf[],
> +               enum pl330_cond cond, u8 peri)
> +{
> +       if (dry_run)
> +               return SZ_DMASTP;
> +
> +       buf[0] = CMD_DMASTP;
> +
> +       if (cond == BURST)
> +               buf[0] |= (1 << 1);
> +
> +       peri &= 0x1f;
> +       peri <<= 3;
> +       buf[1] = peri;
> +
> +       return SZ_DMASTP;
> +}
> +
> +static inline u32 _emit_STZ(unsigned dry_run, u8 buf[])
> +{
> +       if (dry_run)
> +               return SZ_DMASTZ;
> +
> +       buf[0] = CMD_DMASTZ;
> +
> +       return SZ_DMASTZ;
> +}
> +
> +static inline u32 _emit_WFE(unsigned dry_run, u8 buf[], u8 ev,
> +               unsigned invalidate)
> +{
> +       if (dry_run)
> +               return SZ_DMAWFE;
> +
> +       buf[0] = CMD_DMAWFE;
> +
> +       ev &= 0x1f;
> +       ev <<= 3;
> +       buf[1] = ev;
> +
> +       if (invalidate)
> +               buf[1] |= (1 << 1);
> +
> +       return SZ_DMAWFE;
> +}
> +
> +static inline u32 _emit_WFP(unsigned dry_run, u8 buf[],
> +               enum pl330_cond cond, u8 peri)
> +{
> +       if (dry_run)
> +               return SZ_DMAWFP;
> +
> +       buf[0] = CMD_DMAWFP;
> +
> +       if (cond == SINGLE)
> +               buf[0] |= (0 << 1) | (0 << 0);
> +       else if (cond == BURST)
> +               buf[0] |= (1 << 1) | (0 << 0);
> +       else
> +               buf[0] |= (0 << 1) | (1 << 0);
> +
> +       peri &= 0x1f;
> +       peri <<= 3;
> +       buf[1] = peri;
> +
> +       return SZ_DMAWFP;
> +}
> +
> +static inline u32 _emit_WMB(unsigned dry_run, u8 buf[])
> +{
> +       if (dry_run)
> +               return SZ_DMAWMB;
> +
> +       buf[0] = CMD_DMAWMB;
> +
> +       return SZ_DMAWMB;
> +}
> +
> +struct _arg_GO {
> +       u8 chan;
> +       u32 addr;
> +       unsigned ns:1;
> +};
> +
> +static inline u32 _emit_GO(unsigned dry_run, u8 buf[],
> +               const struct _arg_GO *arg)
> +{
> +       u8 chan = arg->chan;
> +       u32 addr = arg->addr;
> +       unsigned ns = arg->ns;
> +
> +       if (dry_run)
> +               return SZ_DMAGO;
> +
> +       buf[0] = CMD_DMAGO;
> +       if (ns)
> +               buf[0] |= (ns << 1);
> +
> +       buf[1] = chan & 0x7;
> +
> +       *((u32 *)&buf[2]) = addr;
> +
> +       return SZ_DMAGO;
> +}

With all these emit_* functions you have half a microcode compiler in the
driver, but I really, really like it! It's the right foundation for
hackers that want
to have fun with the microcode generation later on.

> +static inline void _execute_DBGINSN(struct pl330_thread *thrd,
> +               u8 insn[], bool as_manager)
> +{
> +       void __iomem *regs = thrd->dmac->pinfo.base;
> +       u32 val;
> +
> +       val = (insn[0] << 16) | (insn[1] << 24);
> +       if (!as_manager) {
> +               val |= (1 << 0);
> +               val |= (thrd->id << 8); /* Channel Number */
> +       }
> +       writel(val, regs + DBGINST0);
> +
> +       val = *((u32 *)&insn[2]);
> +       writel(val, regs + DBGINST1);
> +}
> +
> +/* Returns Time-Out */
> +static bool _until_dmac_idle(struct pl330_thread *thrd)
> +{
> +       void __iomem *regs = thrd->dmac->pinfo.base;
> +       unsigned long loops = msecs_to_loops(5);
> +
> +       do {
> +               /* Until Manager is Idle */
> +               if (!(readl(regs + DBGSTATUS) & DBG_BUSY))
> +                       break;
> +
> +               cpu_relax();
> +       } while (--loops);
> +
> +       if (!loops)
> +               return true;
> +
> +       return false;
> +}
> +
> +static inline u32 _state(struct pl330_thread *thrd)
> +{
> +       void __iomem *regs = thrd->dmac->pinfo.base;
> +       u32 val;
> +
> +       if (is_manager(thrd))
> +               val = readl(regs + DS) & 0xf;
> +       else
> +               val = readl(regs + CS(thrd->id)) & 0xf;
> +
> +       switch (val) {
> +       case DS_ST_STOP:
> +               return PL330_STATE_STOPPED;
> +       case DS_ST_EXEC:
> +               return PL330_STATE_EXECUTING;
> +       case DS_ST_CMISS:
> +               return PL330_STATE_CACHEMISS;
> +       case DS_ST_UPDTPC:
> +               return PL330_STATE_UPDTPC;
> +       case DS_ST_WFE:
> +               return PL330_STATE_WFE;
> +       case DS_ST_FAULT:
> +               return PL330_STATE_FAULTING;
> +       case DS_ST_ATBRR:
> +               if (is_manager(thrd))
> +                       return PL330_STATE_INVALID;
> +               else
> +                       return PL330_STATE_ATBARRIER;
> +       case DS_ST_QBUSY:
> +               if (is_manager(thrd))
> +                       return PL330_STATE_INVALID;
> +               else
> +                       return PL330_STATE_QUEUEBUSY;
> +       case DS_ST_WFP:
> +               if (is_manager(thrd))
> +                       return PL330_STATE_INVALID;
> +               else
> +                       return PL330_STATE_WFP;
> +       case DS_ST_KILL:
> +               if (is_manager(thrd))
> +                       return PL330_STATE_INVALID;
> +               else
> +                       return PL330_STATE_KILLING;
> +       case DS_ST_CMPLT:
> +               if (is_manager(thrd))
> +                       return PL330_STATE_INVALID;
> +               else
> +                       return PL330_STATE_COMPLETING;
> +       case DS_ST_FLTCMP:
> +               if (is_manager(thrd))
> +                       return PL330_STATE_INVALID;
> +               else
> +                       return PL330_STATE_FAULT_COMPLETING;
> +       default:
> +               return PL330_STATE_INVALID;
> +       }
> +}
> +
> +/* Use this _only_ to wait on transient states */
> +#define UNTIL(t, s)    while (!(_state(t) & (s))) cpu_relax();
> +
> +/* Start doing req 'idx' of thread 'thrd' */
> +static bool _trigger(struct pl330_thread *thrd, unsigned idx)
> +{
> +       void __iomem *regs = thrd->dmac->pinfo.base;
> +       struct _pl330_req *req = &thrd->req[idx];
> +       struct pl330_req *r = req->r;
> +       struct _arg_GO go;
> +       unsigned ns;

bool

> +       u8 insn[6] = {0, 0, 0, 0, 0, 0};
> +
> +       /* Return if already ACTIVE */
> +       if (_state(thrd) != PL330_STATE_STOPPED)
> +               return true;
> +
> +       /* Return if no request */
> +       if (!r)
> +               return true;
> +
> +       /* If timed out due to halted state-machine */
> +       if (_until_dmac_idle(thrd))
> +               return false;
> +
> +       if (r->cfg)
> +               ns = r->cfg->nonsecure ? 1 : 0;

Since you defined nonsecure as :1 you could just assign it.
But please make both ns and cfg->nonsecure bool.

> +       else if (readl(regs + CS(thrd->id)) & CS_CNS)
> +               ns = 1;
> +       else
> +               ns = 0;
> +
> +       /* See 'Abort Sources' point-4 at Page 2-25 */
> +       if (_manager_ns(thrd) && !ns)
> +               printk(KERN_INFO "%s:%d Recipe for ABORT!\n",
> +                       __func__, __LINE__);


dev_info(thrd->dmac->dev, "....");

> +
> +       go.chan = thrd->id;
> +       go.addr = req->mc_bus;
> +       go.ns = ns;
> +       _emit_GO(0, insn, &go);
> +
> +       /* Set to generate interrupts for SEV */
> +       writel(readl(regs + INTEN) | (1 << thrd->ev), regs + INTEN);
> +
> +       /* Only manager can execute GO */
> +       _execute_DBGINSN(thrd, insn, true);
> +
> +       return true;
> +}
> +
> +/* Makes sure the thread is in STOPPED state */
> +static void _stop(struct pl330_thread *thrd)
> +{
> +       u8 insn[6] = {0, 0, 0, 0, 0, 0};
> +
> +       /* Return if already STOPPED */
> +       if (_state(thrd) == PL330_STATE_STOPPED)
> +               return;
> +
> +       if (is_manager(thrd))
> +               _emit_END(0, insn);
> +       else
> +               _emit_KILL(0, insn);
> +
> +       _execute_DBGINSN(thrd, insn, is_manager(thrd));
> +}
> +
> +static bool _start(struct pl330_thread *thrd)
> +{
> +       switch (_state(thrd)) {
> +       case PL330_STATE_FAULT_COMPLETING:
> +               UNTIL(thrd, PL330_STATE_FAULTING | PL330_STATE_KILLING);
> +
> +               if (_state(thrd) == PL330_STATE_KILLING)
> +                       UNTIL(thrd, PL330_STATE_STOPPED)
> +
> +       case PL330_STATE_FAULTING:
> +               _stop(thrd);
> +
> +       case PL330_STATE_KILLING:
> +       case PL330_STATE_COMPLETING:
> +               UNTIL(thrd, PL330_STATE_STOPPED)
> +
> +       case PL330_STATE_STOPPED:
> +               return _trigger(thrd, thrd->req[0].r ? 0 : 1);
> +
> +       case PL330_STATE_WFP:
> +       case PL330_STATE_QUEUEBUSY:
> +       case PL330_STATE_ATBARRIER:
> +       case PL330_STATE_UPDTPC:
> +       case PL330_STATE_CACHEMISS:
> +       case PL330_STATE_EXECUTING:
> +               return true;
> +
> +       case PL330_STATE_WFE: /* for PAUSE - nothing yet */
> +       default: /* Shouldn't reach here with some transient state */
> +               return false;
> +       }
> +}
> +
> +static inline u32 _prepare_ccr(struct pl330_reqcfg *rqc)
> +{
> +       u32 ccr = 0;
> +
> +       if (rqc->src_inc)
> +               ccr |= CC_SRCINC;
> +
> +       if (rqc->dst_inc)
> +               ccr |= CC_DSTINC;
> +
> +       /* We set same protection levels for Src and DST for now */
> +       if (rqc->privileged)
> +               ccr |= CC_SRCPRI | CC_DSTPRI;
> +       if (rqc->nonsecure)
> +               ccr |= CC_SRCNS | CC_DSTNS;
> +       if (rqc->insnaccess)
> +               ccr |= CC_SRCIA | CC_DSTIA;
> +
> +       ccr |= (((rqc->brst_len - 1) & 0xf) << CC_SRCBRSTLEN_SHFT);
> +       ccr |= (((rqc->brst_len - 1) & 0xf) << CC_DSTBRSTLEN_SHFT);
> +
> +       ccr |= (rqc->brst_size << CC_SRCBRSTSIZE_SHFT);
> +       ccr |= (rqc->brst_size << CC_DSTBRSTSIZE_SHFT);
> +
> +       ccr |= (rqc->dcctl << CC_SRCCCTRL_SHFT);
> +       ccr |= (rqc->scctl << CC_DSTCCTRL_SHFT);
> +
> +       ccr |= (rqc->swap << CC_SWAP_SHFT);
> +
> +       return ccr;
> +}
> +
> +static inline bool _is_valid(u32 ccr)
> +{
> +       enum pl330_dstcachectrl dcctl;
> +       enum pl330_srccachectrl scctl;
> +
> +       dcctl = (ccr >> CC_DSTCCTRL_SHFT) & CC_DRCCCTRL_MASK;
> +       scctl = (ccr >> CC_SRCCCTRL_SHFT) & CC_SRCCCTRL_MASK;
> +
> +       if (dcctl == DINVALID1 || dcctl == DINVALID2
> +                       || scctl == SINVALID1 || scctl == SINVALID2)
> +               return false;
> +       else
> +               return true;
> +}
> +
> +static inline int _ldst_memtomem(unsigned dry_run, u8 buf[],
> +               const struct _xfer_spec *pxs, int cyc)
> +{
> +       int off = 0;
> +
> +       while (cyc--) {
> +               /* Do we need RMB/WMB for each load/store? REVISIT XXX */
> +               off += _emit_LD(dry_run, &buf[off], ALWAYS);
> +               off += _emit_RMB(dry_run, &buf[off]);
> +               off += _emit_ST(dry_run, &buf[off], ALWAYS);
> +               off += _emit_WMB(dry_run, &buf[off]);
> +       }
> +
> +       return off;
> +}
> +
> +static inline int _ldst_devtomem(unsigned dry_run, u8 buf[],
> +               const struct _xfer_spec *pxs, int cyc)
> +{
> +       int off = 0;
> +
> +       while (cyc--) {
> +               /* Do we need WFP for every cycle? REVISIT XXX */
> +               off += _emit_WFP(dry_run, &buf[off], SINGLE, pxs->r->peri);
> +               off += _emit_LDP(dry_run, &buf[off], SINGLE, pxs->r->peri);
> +               off += _emit_ST(dry_run, &buf[off], ALWAYS);
> +               /* Do we need FLUSHP for every cycle? REVISIT XXX */
> +               off += _emit_FLUSHP(dry_run, &buf[off], pxs->r->peri);
> +       }
> +
> +       return off;
> +}
> +
> +static inline int _ldst_memtodev(unsigned dry_run, u8 buf[],
> +               const struct _xfer_spec *pxs, int cyc)
> +{
> +       int off = 0;
> +
> +       while (cyc--) {
> +               /* Do we need WFP for every cycle? REVISIT XXX */
> +               off += _emit_WFP(dry_run, &buf[off], SINGLE, pxs->r->peri);
> +               off += _emit_LD(dry_run, &buf[off], ALWAYS);
> +               off += _emit_STP(dry_run, &buf[off], SINGLE, pxs->r->peri);
> +               /* Do we need FLUSHP for every cycle? REVISIT XXX */
> +               off += _emit_FLUSHP(dry_run, &buf[off], pxs->r->peri);
> +       }
> +
> +       return off;
> +}
> +
> +static int _bursts(unsigned dry_run, u8 buf[],
> +               const struct _xfer_spec *pxs, int cyc)
> +{
> +       int off = 0;
> +
> +       switch (pxs->r->rqtype) {
> +       case MEMTODEV:
> +               off += _ldst_memtodev(dry_run, &buf[off], pxs, cyc);
> +               break;
> +
> +       case DEVTOMEM:
> +               off += _ldst_devtomem(dry_run, &buf[off], pxs, cyc);
> +               break;
> +
> +       case MEMTOMEM:
> +               off += _ldst_memtomem(dry_run, &buf[off], pxs, cyc);
> +               break;
> +
> +       default:
> +               off += 0x40000000; /* Scare off the Client */
> +               break;
> +       }
> +
> +       return off;
> +}
> +
> +/* Returns bytes consumed and updates bursts */
> +static inline int _loop(unsigned dry_run, u8 buf[],
> +               unsigned long *bursts, const struct _xfer_spec *pxs)
> +{
> +       int cyc, cycmax, szlp, szlpend, szbrst, off;
> +       unsigned lcnt0, lcnt1, ljmp0, ljmp1;
> +       struct _arg_LPEND lpend;
> +
> +       /* Max iterations possibile in DMALP is 256 */
> +       if (*bursts >= 256*256) {
> +               lcnt1 = 256;
> +               lcnt0 = 256;
> +               cyc = *bursts / lcnt1 / lcnt0;
> +       } else if (*bursts > 256) {
> +               lcnt1 = 256;
> +               lcnt0 = *bursts / lcnt1;
> +               cyc = 1;
> +       } else {
> +               lcnt1 = *bursts;
> +               lcnt0 = 0;
> +               cyc = 1;
> +       }
> +
> +       szlp = _emit_LP(1, buf, 0, 0);
> +       szbrst = _bursts(1, buf, pxs, 1);
> +
> +       lpend.cond = ALWAYS;
> +       lpend.forever = false;
> +       lpend.loop = 0;
> +       lpend.bjump = 0;
> +       szlpend = _emit_LPEND(1, buf, &lpend);
> +
> +       if (lcnt0) {
> +               szlp *= 2;
> +               szlpend *= 2;
> +       }
> +
> +       /** Do not mess with the construct **/

Which means? Hackers like to mess with stuff... Note to self?
Usually comments like that is a trace of questionable design
so if the design is solid, remove the comments because then it
will be obvious that you don't want to mess with the construct.

> +
> +       /* Max bursts that we can unroll due to limit on the
> +        * size of backward jump that can be encoded in DMALPEND
> +        * which is 8-bits and hence 255
> +        */
> +       cycmax = (255 - (szlp + szlpend)) / szbrst;
> +
> +       cyc = (cycmax < cyc) ? cycmax : cyc;
> +
> +       off = 0;
> +
> +       ljmp0 = off;
> +       if (lcnt0)
> +               off += _emit_LP(dry_run, &buf[off], 0, lcnt0);
> +
> +       ljmp1 = off;
> +       off += _emit_LP(dry_run, &buf[off], 1, lcnt1);
> +
> +       off += _bursts(dry_run, &buf[off], pxs, cyc);
> +
> +       lpend.cond = ALWAYS;
> +       lpend.forever = false;
> +       lpend.loop = 1;
> +       lpend.bjump = off - ljmp1;
> +       off += _emit_LPEND(dry_run, &buf[off], &lpend);
> +
> +       if (lcnt0) {
> +               lpend.cond = ALWAYS;
> +               lpend.forever = false;
> +               lpend.loop = 0;
> +               lpend.bjump = off - ljmp0;
> +               off += _emit_LPEND(dry_run, &buf[off], &lpend);
> +       }
> +       /***********************************/
> +
> +       *bursts = lcnt1 * cyc;
> +       if (lcnt0)
> +               *bursts *= lcnt0;
> +
> +       return off;
> +}
> +
> +static inline int _setup_loops(unsigned dry_run, u8 buf[],
> +               const struct _xfer_spec *pxs)
> +{
> +       struct pl330_xfer *x = pxs->x;
> +       u32 ccr = pxs->ccr;
> +       unsigned long c, bursts = BYTE_TO_BURST(x->bytes, ccr);
> +       int off = 0;
> +
> +       while (bursts) {
> +               c = bursts;
> +               off += _loop(dry_run, &buf[off], &c, pxs);
> +               bursts -= c;
> +       }
> +
> +       return off;
> +}
> +
> +static inline int _setup_xfer(unsigned dry_run, u8 buf[],
> +               const struct _xfer_spec *pxs)
> +{
> +       struct pl330_xfer *x = pxs->x;
> +       int off = 0;
> +
> +       /* DMAMOV SAR, x->src_addr */
> +       off += _emit_MOV(dry_run, &buf[off], SAR, x->src_addr);
> +       /* DMAMOV DAR, x->dst_addr */
> +       off += _emit_MOV(dry_run, &buf[off], DAR, x->dst_addr);
> +
> +       /* Setup Loop(s) */
> +       off += _setup_loops(dry_run, &buf[off], pxs);
> +
> +       return off;
> +}
> +
> +/* A req is a sequence of one or more xfer units.
> + * Returns the number of bytes taken to setup the MC
> + * for the req.
> + */
> +static int _setup_req(unsigned dry_run, struct pl330_thread *thrd,
> +               unsigned index, struct _xfer_spec *pxs)
> +{
> +       struct _pl330_req *req = &thrd->req[index];
> +       struct pl330_xfer *x;
> +       u8 *buf = req->mc_cpu;
> +       int off = 0;
> +
> +       /* DMAMOV CCR, ccr */
> +       off += _emit_MOV(dry_run, &buf[off], CCR, pxs->ccr);
> +
> +       x = pxs->r->x;
> +       do {
> +               /* Error if xfer length is not aligned at burst size */
> +               if (x->bytes % BRST_SIZE(pxs->ccr))
> +                       return -EINVAL;
> +
> +               pxs->x = x;
> +               off += _setup_xfer(dry_run, &buf[off], pxs);
> +
> +               x = x->next;
> +       } while (x);
> +
> +       /* DMAFLUSHP peripheral */
> +       off += _emit_FLUSHP(dry_run, &buf[off], pxs->r->peri);
> +       /* DMASEV peripheral/event */
> +       off += _emit_SEV(dry_run, &buf[off], thrd->ev);
> +       /* DMAEND */
> +       off += _emit_END(dry_run, &buf[off]);
> +
> +       return off;
> +}
> +
> +/* Submit a list of xfers after which the client wants notification.
> + * Client is not notified after each xfer unit, just once after all
> + * xfer units are done or some error occurs.
> + * The actual xfer on bus starts automatically
> + */
> +int pl330_submit_req(void *ch_id, struct pl330_req *r)
> +{
> +       struct pl330_thread *thrd = ch_id;
> +       struct pl330_info *pi;
> +       struct _xfer_spec xs;
> +       void __iomem *regs;
> +       u32 ccr;
> +       unsigned idx;
> +       int ret = 0;
> +
> +       /* No Req or Unacquired Channel or DMAC stopping */
> +       if (!r || !thrd || thrd->free || thrd->dmac->state == DYING)
> +               return -EINVAL;
> +
> +       pi = &thrd->dmac->pinfo;
> +       regs = pi->base;
> +
> +       /* If request for non-existing peripheral */
> +       if (r->peri >= pi->pcfg.num_peri)
> +               return -EINVAL;
> +
> +       mutex_lock(&thrd->mtx);
> +
> +       if (_queue_full(thrd)) {
> +               ret = -EBUSY;
> +               goto xfer_exit;
> +       }
> +
> +       /* Use last settings, if not provided */
> +       if (r->cfg)
> +               ccr = _prepare_ccr(r->cfg);
> +       else
> +               ccr = readl(regs + CC(thrd->id));
> +
> +       /* If this req doesn't have valid xfer settings */
> +       if (!_is_valid(ccr)) {
> +               ret = -EINVAL;
> +               goto xfer_exit;
> +       }
> +
> +       idx = thrd->req[0].r ? 1 : 0;
> +
> +       xs.ccr = ccr;
> +       xs.r = r;
> +
> +       /* First dry run to check if req is acceptable */
> +       ret = _setup_req(1, thrd, idx, &xs);
> +       if (ret < 0)
> +               goto xfer_exit;
> +
> +       if (ret > pi->mcbufsz / 2) {
> +               ret = -ENOMEM;
> +               goto xfer_exit;
> +       }
> +
> +       ret = 0;
> +
> +       /* Hook the request */
> +       _setup_req(0, thrd, idx, &xs);
> +       thrd->req[idx].r = r;
> +
> +       if (!_start(thrd)) { /* Could not start */
> +               ret = -EIO;
> +               goto xfer_exit;
> +       }
> +
> +xfer_exit:
> +       mutex_unlock(&thrd->mtx);
> +       return ret;
> +}
> +EXPORT_SYMBOL(pl330_submit_req);

For all exported symbols: I have a hard time seeing anyone compiling the
DMA engine driver or anything else using this as a module and making use
of all these exports. But maybe for testing, what do I know...

> +static void pl330_dotask(unsigned long data)
> +{
> +       struct pl330_dmac *pl330 = (struct pl330_dmac *) data;
> +       struct pl330_info *pi = &pl330->pinfo;
> +       struct pl330_thread *thrd;
> +       int i;
> +
> +       /* The DMAC itself gone nuts */
> +       if (pl330->dmac_tbd.reset_dmac) {
> +               pl330->state = DYING;
> +
> +               for (i = 0; i < pi->pcfg.num_chan; i++) {
> +                       thrd = &pl330->channels[i];
> +
> +                       /* Mark thread as infected */
> +                       pl330->dmac_tbd.reset_chan |= (1 << thrd->id);
> +               }
> +
> +               pl330->dmac_tbd.reset_mngr = 1;
> +       }
> +
> +       if (pl330->dmac_tbd.reset_mngr)
> +               _stop(pl330->manager);
> +
> +       for (i = 0; i < pi->pcfg.num_chan; i++) {
> +               thrd = &pl330->channels[i];
> +
> +               if (pl330->dmac_tbd.reset_chan & (1 << thrd->id)) {
> +                       if (thrd->active) {
> +                               struct pl330_req *r1, *r2;
> +                               enum pl330_op_err err;
> +                               void __iomem *regs = pi->base;
> +                               unsigned active;
> +
> +                               active = thrd->active - 1;
> +
> +                               r1 = thrd->req[active].r;
> +                               r2 = thrd->req[1 - active].r;
> +
> +                               thrd->req[active].r = NULL;
> +                               thrd->req[1 - active].r = NULL;
> +                               thrd->active = 0;
> +
> +                               if (readl(regs + FSC) & (1 << thrd->id))
> +                                       err = PL330_ERR_FAIL;
> +                               else
> +                                       err = PL330_ERR_ABORT;
> +
> +                               _callback(r1, err);
> +                               _callback(r2, err);
> +                       }
> +
> +                       _stop(thrd);
> +               }
> +       }
> +
> +       /* Clear all errors */
> +       pl330->dmac_tbd.reset_dmac = 0;
> +       pl330->dmac_tbd.reset_mngr = 0;
> +       pl330->dmac_tbd.reset_chan = 0;
> +
> +       return;
> +}
> +
> +/* Returns 1 if state was updated, 0 otherwise */
> +int pl330_update(struct pl330_info *pi)
> +{
> +       struct pl330_dmac *pl330;
> +       void __iomem *regs;
> +       u32 val;
> +       int id, ev, ret = 0;
> +
> +       if (!pi)
> +               return 0;
> +
> +       pl330 = container_of(pi, struct pl330_dmac, pinfo);
> +
> +       if (pl330->state == DYING)
> +               return 0;
> +
> +       regs = pi->base;
> +
> +       val = readl(regs + FSM) & 0x1;
> +       pl330->dmac_tbd.reset_mngr |= val;
> +
> +       val = readl(regs + FSC) & ((1 << pi->pcfg.num_chan) - 1);
> +       pl330->dmac_tbd.reset_chan |= val;
> +
> +       /* Check which event happened i.e, thread notified */
> +       val = readl(regs + ES);
> +       if (pi->pcfg.num_events < 32
> +                       && val & ~((1 << pi->pcfg.num_events) - 1)) {
> +               pl330->dmac_tbd.reset_dmac = 1;
> +               printk(KERN_INFO "%s:%d Unexpected!\n", __func__, __LINE__);

dev_info(pl330->dev, "...");

> +               ret = 1;
> +               goto updt_exit;
> +       }
> +
> +       INIT_LIST_HEAD(&pl330->req_done);
> +
> +       for (ev = 0; ev < pi->pcfg.num_events; ev++) {
> +
> +               struct _pl330_req *rqdone;
> +               struct pl330_thread *thrd;
> +               int active;
> +
> +               if (val & (1 << ev)) { /* Event occured */
> +
> +                       id = pl330->events[ev];
> +
> +                       thrd = &pl330->channels[id];
> +
> +                       mutex_lock(&thrd->mtx);
> +
> +                       if (!thrd->active) {
> +                               pl330->dmac_tbd.reset_chan |= (1 << id);
> +                               printk(KERN_INFO "%s:%d Unexpected!\n",
> +                                       __func__, __LINE__);

dev_info(pl330->dev, "....");

> +                       }
> +
> +                       active = thrd->active - 1;
> +                       rqdone = &thrd->req[active];
> +                       rqdone->r = NULL;
> +
> +                       if (thrd->req[1 - active].r)
> +                               thrd->active = 2 - active;
> +                       else
> +                               thrd->active = 0;
> +
> +                       /* Get going again ASAP */
> +                       _start(thrd);
> +
> +                       /* For now, just make a list of callbacks to be done */
> +                       list_add_tail(&rqdone->rqd, &pl330->req_done);
> +
> +                       mutex_unlock(&thrd->mtx);
> +
> +                       ret = 1;
> +               }
> +       }
> +
> +       /* Clear all event interrupts */
> +       writel(val, regs + INTCLR);
> +
> +       /* Now that we are in no hurry, do the callbacks */
> +       while (!list_empty(&pl330->req_done)) {
> +               struct _pl330_req *rqdone =
> +                               container_of(pl330->req_done.next,
> +                                       struct _pl330_req, rqd);
> +
> +               list_del_init(&rqdone->rqd);
> +
> +               _callback(rqdone->r, PL330_ERR_NONE);
> +       }
> +
> +updt_exit:
> +
> +       if (pl330->dmac_tbd.reset_dmac
> +                       || pl330->dmac_tbd.reset_mngr
> +                       || pl330->dmac_tbd.reset_chan) {
> +               ret = 1;
> +               tasklet_schedule(&pl330->tasks);
> +       }
> +
> +       return ret;
> +}
> +EXPORT_SYMBOL(pl330_update);
> +
> +/* This must be atomic. Since the DMA client calls this,
> + * there is no need to do callbacks. Otherwise, this may not be atomic.
> + */
> +int pl330_chan_ctrl(void *ch_id, enum pl330_chan_op op)
> +{
> +       struct pl330_thread *thrd = ch_id;
> +       int ret = 0;
> +
> +       if (!thrd || thrd->free || thrd->dmac->state == DYING)
> +               return -EINVAL;
> +
> +       mutex_lock(&thrd->mtx);
> +
> +       if (_queue_empty(thrd))
> +               goto ctrl_exit;
> +
> +       switch (op) {
> +       case PL330_OP_FLUSH:
> +               _stop(thrd);
> +               thrd->req[0].r = NULL;
> +               thrd->req[1].r = NULL;
> +               thrd->active = 0;
> +               break;
> +
> +       case PL330_OP_ABORT:
> +               _stop(thrd);
> +
> +               /* ABORT is only for the active req */
> +               if (!thrd->active)
> +                       break;
> +
> +               thrd->req[thrd->active - 1].r = NULL;
> +
> +               if (_queue_empty(thrd)) {
> +                       thrd->active = 0;
> +                       break;
> +               }
> +
> +       case PL330_OP_START: /* Should be un-necessary */
> +               if (!_queue_empty(thrd) && !_start(thrd))
> +                       ret = -EIO;
> +
> +               break;
> +
> +       default:
> +               ret = -EINVAL;
> +       }
> +
> +ctrl_exit:
> +       mutex_unlock(&thrd->mtx);
> +       return ret;
> +}
> +EXPORT_SYMBOL(pl330_chan_ctrl);
> +
> +int pl330_chan_status(void *ch_id, struct pl330_chanstatus *pstatus)
> +{
> +       struct pl330_thread *thrd = ch_id;
> +       struct pl330_dmac *pl330;
> +       struct pl330_info *pi;
> +       void __iomem *regs;
> +       int i;
> +       u32 val;
> +
> +       if (!pstatus || !thrd || thrd->free)
> +               return -EINVAL;
> +
> +       mutex_lock(&thrd->mtx);
> +
> +       pl330 = thrd->dmac;
> +       pi = &pl330->pinfo;
> +       regs = pi->base;
> +
> +       /* The client should remove the DMAC and add again */
> +       if (pl330->state == DYING)
> +               pstatus->dmac_halted = true;
> +       else
> +               pstatus->dmac_halted = false;
> +
> +       val = readl(regs + FSC);
> +       if (val & (1 << thrd->id))
> +               pstatus->faulting = true;
> +       else
> +               pstatus->faulting = false;
> +
> +       val = readl(regs + CPC(thrd->id));
> +       if (PC_AT_REQ(&thrd->req[0], pi->mcbufsz / 2, val))
> +               i = 1;
> +       else if (PC_AT_REQ(&thrd->req[1], pi->mcbufsz / 2, val))
> +               i = 2;
> +       else
> +               i = 0;
> +
> +       /* If channel inactive while req in queue */
> +       if ((thrd->active != i) || (!_queue_empty(thrd) && !i))
> +               printk(KERN_INFO "%s:%d DBG: Invalid state!",
> +                       __func__, __LINE__);

dev_err(pl330->dev, "....");

Notice err! Not info.

> +
> +       if (i) {
> +               i--;
> +               pstatus->act_req = thrd->req[i].r;
> +               pstatus->enq_req = thrd->req[1-i].r;
> +       } else {
> +               pstatus->act_req = NULL;
> +               pstatus->enq_req = NULL;
> +       }
> +
> +       pstatus->src_addr = readl(regs + SA(thrd->id));
> +       pstatus->dst_addr = readl(regs + DA(thrd->id));
> +
> +       mutex_unlock(&thrd->mtx);
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(pl330_chan_status);
> +
> +static inline void _reset_thread(struct pl330_thread *thrd)
> +{
> +       struct pl330_dmac *pl330 = thrd->dmac;
> +       struct pl330_info *pi = &pl330->pinfo;
> +
> +       thrd->req[0].r = NULL;
> +       thrd->req[0].mc_cpu = pl330->mcode_cpu
> +                               + (thrd->id * pi->mcbufsz);
> +       thrd->req[0].mc_bus = pl330->mcode_bus
> +                               + (thrd->id * pi->mcbufsz);
> +
> +       thrd->req[1].r = NULL;
> +       thrd->req[1].mc_cpu = thrd->req[0].mc_cpu
> +                               + pi->mcbufsz / 2;
> +       thrd->req[1].mc_bus = thrd->req[0].mc_bus
> +                               + pi->mcbufsz / 2;
> +}
> +
> +/* Reserve an event */
> +static inline int _alloc_event(struct pl330_thread *thrd)
> +{
> +       struct pl330_dmac *pl330 = thrd->dmac;
> +       struct pl330_info *pi = &pl330->pinfo;
> +       int ev;
> +
> +       for (ev = 0; ev < pi->pcfg.num_events; ev++) {
> +               if (pl330->events[ev] == -1) {
> +                       pl330->events[ev] = thrd->id;
> +                       return ev;
> +               }
> +       }
> +
> +       return -1;
> +}
> +
> +/* Release an event */
> +static inline void _free_event(struct pl330_thread *thrd, int ev)
> +{
> +       struct pl330_dmac *pl330 = thrd->dmac;
> +       struct pl330_info *pi = &pl330->pinfo;
> +
> +       if (ev >= 0 && ev < pi->pcfg.num_events
> +                       && pl330->events[ev] == thrd->id)
> +               pl330->events[ev] = -1;
> +}
> +
> +void *pl330_request_channel(struct pl330_info *pi)
> +{
> +       struct pl330_dmac *pl330;
> +       struct pl330_thread *thrd;
> +       unsigned long flags;
> +       int chans, i;
> +
> +       if (!pi)
> +               return NULL;
> +
> +       pl330 = container_of(pi, struct pl330_dmac, pinfo);
> +
> +       if (pl330->state == DYING)
> +               return NULL;
> +
> +       chans = pi->pcfg.num_chan;
> +
> +       spin_lock_irqsave(&pl330->lock, flags);
> +
> +       thrd = NULL;
> +       for (i = 0; i < chans; i++) {
> +               if (pl330->channels[i].free) {
> +                       thrd = &pl330->channels[i];
> +                       _reset_thread(thrd);
> +                       thrd->ev = _alloc_event(thrd);
> +                       if (thrd->ev >= 0) {
> +                               thrd->free = false;
> +                               break;
> +                       }
> +                       thrd = NULL;
> +               }
> +       }
> +
> +       spin_unlock_irqrestore(&pl330->lock, flags);
> +
> +       return thrd;
> +}
> +EXPORT_SYMBOL(pl330_request_channel);
> +
> +void pl330_release_channel(void *ch_id)
> +{
> +       struct pl330_thread *thrd = ch_id;
> +       struct pl330_dmac *pl330;
> +       struct pl330_req *r1, *r2;
> +       unsigned long flags;
> +
> +       if (!thrd || thrd->free || thrd->dmac->state == DYING)
> +               return;
> +
> +       pl330 = thrd->dmac;
> +
> +       if (thrd->active == 1) {
> +               r1 = thrd->req[0].r;
> +               r2 = thrd->req[1].r;
> +       } else {
> +               r1 = thrd->req[1].r;
> +               r2 = thrd->req[0].r;
> +       }
> +
> +       mutex_lock(&thrd->mtx);
> +
> +       _stop(thrd);
> +
> +       mutex_unlock(&thrd->mtx);
> +
> +       _callback(r1, PL330_ERR_ABORT);
> +       _callback(r2, PL330_ERR_ABORT);
> +
> +       spin_lock_irqsave(&pl330->lock, flags);
> +       _reset_thread(thrd);
> +       _free_event(thrd, thrd->ev);
> +       thrd->free = true;
> +       spin_unlock_irqrestore(&pl330->lock, flags);
> +}
> +EXPORT_SYMBOL(pl330_release_channel);
> +
> +static int dmac_alloc_threads(struct pl330_dmac *pl330)
> +{
> +       struct pl330_info *pi = &pl330->pinfo;
> +       int chans = pi->pcfg.num_chan;
> +       struct pl330_thread *thrd;
> +       int i;
> +
> +       /* Allocate 1 Manager and 'chans' Channel threads */
> +       pl330->channels = kzalloc((1 + chans) * sizeof(*thrd),
> +                                       GFP_KERNEL);
> +       if (!pl330->channels)
> +               return -ENOMEM;
> +
> +       /* Init Channel threads */
> +       for (i = 0; i < chans; i++) {
> +               thrd = &pl330->channels[i];
> +               thrd->id = i;
> +               thrd->dmac = pl330;
> +               mutex_init(&thrd->mtx);
> +               _reset_thread(thrd);
> +               thrd->free = true;
> +       }
> +
> +       /* MANAGER is indexed at the end */
> +       thrd = &pl330->channels[chans];
> +       thrd->id = chans;
> +       thrd->dmac = pl330;
> +       thrd->free = false; /* Manager can't do xfer */
> +       mutex_init(&thrd->mtx);
> +       pl330->manager = thrd;
> +
> +       return 0;
> +}
> +
> +static int dmac_free_threads(struct pl330_dmac *pl330)
> +{
> +       struct pl330_info *pi = &pl330->pinfo;
> +       int chans = pi->pcfg.num_chan;
> +       struct pl330_thread *thrd;
> +       int i;
> +
> +       /* Release Channel threads */
> +       for (i = 0; i < chans; i++) {
> +               thrd = &pl330->channels[i];
> +               pl330_release_channel((void *)thrd);
> +       }
> +
> +       /* Free memory */
> +       kfree(pl330->channels);
> +
> +       return 0;
> +}
> +
> +/* Must be called after pl330_info has been initialized */
> +static int dmac_alloc_resources(struct pl330_dmac *pl330)
> +{
> +       struct pl330_info *pi = &pl330->pinfo;
> +       int chans = pi->pcfg.num_chan;
> +       int ret;
> +
> +       /* Alloc MicroCode buffer for 'chans' Channel threads.
> +        * A channel's buffer offset is (Channel_Id * MCODE_BUFF_PERCHAN)
> +        */
> +       pl330->mcode_cpu = dma_alloc_coherent(pl330->dev,
> +                               chans * pi->mcbufsz,
> +                               &pl330->mcode_bus, GFP_KERNEL);
> +       if (!pl330->mcode_cpu) {
> +               printk(KERN_INFO "Unable to allocate MCODE buffer\n");

dev_err(pl330->dev, "....");
ERR!

> +               return -ENOMEM;
> +       }
> +
> +       ret = dmac_alloc_threads(pl330);
> +       if (ret) {
> +               printk(KERN_INFO "Unable to create channels for DMAC\n");


dev_err(pl330->dev, "....");
ERR!

> +               dma_free_coherent(pl330->dev,
> +                               chans * pi->mcbufsz,
> +                               pl330->mcode_cpu, pl330->mcode_bus);
> +               return ret;
> +       }
> +
> +       return 0;
> +}
> +
> +static void dmac_free_resources(struct pl330_dmac *pl330)
> +{
> +       struct pl330_info *pi = &pl330->pinfo;
> +       int chans = pi->pcfg.num_chan;
> +
> +       dmac_free_threads(pl330);
> +
> +       dma_free_coherent(pl330->dev, chans * pi->mcbufsz,
> +                               pl330->mcode_cpu, pl330->mcode_bus);
> +}
> +/* Initialize the structure for PL330 configuration, that can be used
> + * by the client driver the make best use of the DMAC
> + */
> +static void read_dmac_config(struct pl330_dmac *pl330)
> +{
> +       struct pl330_info *pi = &pl330->pinfo;
> +       void __iomem *regs = pi->base;
> +       u32 val;
> +
> +       val = readl(regs + CRD) >> CRD_DATA_WIDTH_SHIFT;
> +       val &= CRD_DATA_WIDTH_MASK;
> +       pi->pcfg.data_bus_width = 8 * (1 << val);
> +
> +       val = readl(regs + CR0) >> CR0_NUM_CHANS_SHIFT;
> +       val &= CR0_NUM_CHANS_MASK;
> +       val += 1;
> +       pi->pcfg.num_chan = val;
> +
> +       val = readl(regs + CR0);
> +       if (val & CR0_PERIPH_REQ_SET) {
> +               val = (val >> CR0_NUM_PERIPH_SHIFT) & CR0_NUM_PERIPH_MASK;
> +               val += 1;
> +               pi->pcfg.num_peri = val;
> +               pi->pcfg.peri_ns = readl(regs + CR4);
> +       } else {
> +               pi->pcfg.num_peri = 0;
> +       }
> +
> +       val = readl(regs + CR0);
> +       if (val & CR0_BOOT_MAN_NS)
> +               pi->pcfg.mode |= DMAC_MODE_NS;
> +       else
> +               pi->pcfg.mode &= ~DMAC_MODE_NS;
> +
> +       val = readl(regs + CR0) >> CR0_NUM_EVENTS_SHIFT;
> +       val &= CR0_NUM_EVENTS_MASK;
> +       val += 1;
> +       pi->pcfg.num_events = val;
> +
> +       pi->pcfg.irq_ns = readl(regs + CR3);
> +
> +       pi->pcfg.periph_id = get_id(pl330, PERIPH_ID);
> +       pi->pcfg.pcell_id = get_id(pl330, PCELL_ID);
> +}
> +
> +/* After pl330_alloc, initialize pl330_info.base
> + * before calling pl330_add
> + */
> +int pl330_add(struct pl330_info *pi)
> +{
> +       struct pl330_dmac *pl330, *pt;
> +       void __iomem *regs;
> +       int i;
> +
> +       if (!pi)
> +               return -EINVAL;
> +
> +       pl330 = container_of(pi, struct pl330_dmac, pinfo);
> +
> +       regs = pi->base;
> +
> +       /* If the SoC can perform reset on the DMAC, then do it
> +        * before reading its configuration.
> +        */
> +       if (pi->dmac_reset)
> +               pi->dmac_reset(pi);
> +
> +       /* Check if we can handle this DMAC */
> +       if (get_id(pl330, PERIPH_ID) != PERIPH_ID_VAL
> +          || get_id(pl330, PCELL_ID) != PCELL_ID_VAL) {
> +               printk(KERN_INFO "PERIPH_ID 0x%x, PCELL_ID 0x%x !\n",
> +                       readl(regs + PERIPH_ID), readl(regs + PCELL_ID));

dev_info(pl330->dev, ...)

> +               return -EINVAL;
> +       }

If the parent device (IMO a DMAdevices/DMAengine) is an struct amba_device
I don't think this ID check is necessary, there is already PrimeCell
matching code in
<linux/amba/bus.h>

> +
> +       /* Make sure it isn't already added */
> +       list_for_each_entry(pt, &pl330_list, node)
> +               if (pt == pl330)

Perhaps print some warning here. Doesn't seem sound that this
would happen.

> +                       return 0;
> +
> +       /* Read the configuration of the DMAC */
> +       read_dmac_config(pl330);
> +
> +       if (pi->pcfg.num_events == 0) {
> +               printk(KERN_INFO "%s:%d Can't work without events!\n",
> +                       __func__, __LINE__);

dev_info(pl330->dev, "....");

> +               return -EINVAL;
> +       }
> +
> +       /* Use default MC buffer size if not provided */
> +       if (!pi->mcbufsz)
> +               pi->mcbufsz = MCODE_BUFF_PER_REQ * 2;
> +
> +       /* Mark all events as free */
> +       for (i = 0; i < pi->pcfg.num_events; i++)
> +               pl330->events[i] = -1;
> +
> +       /* Allocate resources needed by the DMAC */
> +       i = dmac_alloc_resources(pl330);
> +       if (i) {
> +               printk(KERN_INFO "Unable to create channels for DMAC\n");

dev_info(pl330->dev, "....");

> +               return i;
> +       }
> +
> +       mutex_lock(&pl330_mutex);
> +       list_add_tail(&pl330->node, &pl330_list);
> +       mutex_unlock(&pl330_mutex);
> +
> +       tasklet_init(&pl330->tasks, pl330_dotask,
> +                               (unsigned long) pl330);
> +
> +       pl330->state = INIT;
> +
> +       return 0;
> +}
> +EXPORT_SYMBOL(pl330_add);
> +
> +/* Drop DMAC from the list
> + */
> +void pl330_del(struct pl330_info *pi)
> +{
> +       struct pl330_dmac *pl330, *pt;
> +       int found;
> +
> +       if (!pi)
> +               return;
> +
> +       pl330 = container_of(pi, struct pl330_dmac, pinfo);
> +
> +       pl330->state = UNINIT;
> +
> +       /* Make sure it is already added */
> +       found = 0;
> +       list_for_each_entry(pt, &pl330_list, node)
> +               if (pt == pl330)
> +                       found = 1;
> +
> +       if (!found)
> +               return;
> +
> +       tasklet_kill(&pl330->tasks);
> +
> +       mutex_lock(&pl330_mutex);
> +       list_del(&pl330->node);
> +       mutex_unlock(&pl330_mutex);
> +
> +       /* Free DMAC resources */
> +       dmac_free_resources(pl330);
> +}
> +EXPORT_SYMBOL(pl330_del);
> +
> +struct pl330_info *pl330_alloc(struct device *dev)
> +{
> +       struct pl330_dmac *pl330;
> +
> +       pl330 = kzalloc(sizeof(*pl330), GFP_KERNEL);
> +       if (!pl330)
> +               return NULL;
> +
> +       spin_lock_init(&pl330->lock);
> +
> +       pl330->dev = dev;
> +
> +       return &pl330->pinfo;
> +}
> +EXPORT_SYMBOL(pl330_alloc);
> +
> +void pl330_free(struct pl330_info *pi)
> +{
> +       struct pl330_dmac *pl330;
> +
> +       if (!pi)
> +               return;
> +
> +       pl330_del(pi);
> +
> +       pl330 = container_of(pi, struct pl330_dmac, pinfo);
> +
> +       kfree(pl330);
> +}
> +EXPORT_SYMBOL(pl330_free);
> diff --git a/arch/arm/include/asm/hardware/pl330.h
> b/arch/arm/include/asm/hardware/pl330.h
> new file mode 100644
> index 0000000..4e907ad
> --- /dev/null
> +++ b/arch/arm/include/asm/hardware/pl330.h
> @@ -0,0 +1,197 @@
> +/* linux/include/asm/hardware/pl330.h
> + *
> + * Copyright (C) 2010 Samsung Electronics Co Ltd.
> + *     Jaswinder Singh <jassi.brar@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */
> +
> +#ifndef __PL330_CORE_H
> +#define __PL330_CORE_H
> +
> +enum pl330_srccachectrl {
> +       SCCTRL0 = 0, /* Noncacheable and nonbufferable */
> +       SCCTRL1, /* Bufferable only */
> +       SCCTRL2, /* Cacheable, but do not allocate */
> +       SCCTRL3, /* Cacheable and bufferable, but do not allocate */
> +       SINVALID1,
> +       SINVALID2,
> +       SCCTRL6, /* Cacheable write-through, allocate on reads only */
> +       SCCTRL7, /* Cacheable write-back, allocate on reads only */
> +};
> +
> +enum pl330_dstcachectrl {
> +       DCCTRL0 = 0, /* Noncacheable and nonbufferable */
> +       DCCTRL1, /* Bufferable only */
> +       DCCTRL2, /* Cacheable, but do not allocate */
> +       DCCTRL3, /* Cacheable and bufferable, but do not allocate */
> +       DINVALID1 = 8,
> +       DINVALID2,
> +       DCCTRL6, /* Cacheable write-through, allocate on writes only */
> +       DCCTRL7, /* Cacheable write-back, allocate on writes only */
> +};
> +
> +/* Populated by the PL330 core driver for DMA API driver's info */
> +struct pl330_config {
> +       u32     periph_id;
> +       u32     pcell_id;
> +#define DMAC_MODE_NS   (1 << 0)
> +       unsigned int    mode;
> +       unsigned int    data_bus_width:10; /* In number of bits */
> +       unsigned int    num_chan:4;
> +       unsigned int    num_peri:6;
> +       u32             peri_ns;
> +       unsigned int    num_events:6;
> +       u32             irq_ns;
> +};
> +
> +/* Handle to the DMAC provided by PL330 engine */
> +struct pl330_info {

Contemplate adding:
      /* Owning device */
      struct device *dev;

> +       /* Size of MicroCode buffers for each channel */
> +       unsigned mcbufsz;
> +       /* ioremap'ed address of PL330 registers */
> +       void __iomem    *base;
> +       /* Client can freely use it */
> +       void    *private_data;
> +       /* Populated by the PL330 core driver during pl330_add */
> +       struct pl330_config     pcfg;
> +       /* If the DMAC has some reset mechanism, then the client
> +        * may want to provide pointer to the relevent function.
> +        */
> +       void (*dmac_reset)(struct pl330_info *pi);
> +};
> +
> +enum pl330_byteswap {
> +       SWAP_NO = 0,
> +       SWAP_2,
> +       SWAP_4,
> +       SWAP_8,
> +       SWAP_16,
> +};
> +
> +enum pl330_reqtype {
> +       MEMTOMEM,
> +       MEMTODEV,
> +       DEVTOMEM,
> +       DEVTODEV,
> +};
> +
> +/* Request Configuration.
> + * The PL330 core uses the last working configuration if the
> + * request doesn't provide any.
> + *
> + * The Client may want to provide this info only for the
> + * first request and a request with new settings.
> + */
> +struct pl330_reqcfg {
> +       /* Implies Incrementing address */
> +       unsigned dst_inc:1;
> +       unsigned src_inc:1;
> +
> +       /* For now, the SRC & DST protection levels
> +        * and burst size/length are assumed same
> +        */
> +       unsigned nonsecure:1;
> +       unsigned privileged:1;
> +       unsigned insnaccess:1;

For all of these things using just one bit, contemplate
turning them into bool instead, because that's what they are.

> +       unsigned brst_len:5;
> +       unsigned brst_size:3; /* power of 2 */
> +
> +       enum pl330_dstcachectrl dcctl;
> +       enum pl330_srccachectrl scctl;
> +       enum pl330_byteswap swap;
> +};
> +
> +/* One cycle of DMAC operation.
> + * There may be more than one xfer in a request.
> + */
> +struct pl330_xfer {
> +       u32 src_addr;
> +       u32 dst_addr;
> +       /* Number of total _bytes_ to xfer */
> +       u32 bytes;
> +       /* Pointer to next xfer in the list.
> +        * The last xfer in the req must point to NULL
> +        */
> +       struct pl330_xfer *next;
> +};
> +
> +/* A request defining Scatter-Gather List ending with NULL xfer */
> +struct pl330_req {
> +       enum pl330_reqtype rqtype;
> +       /* Index of peripheral for the xfer */
> +       unsigned peri:5;
> +       /* Unique token for this xfer, set by the DMA engine */
> +       void *token;
> +       /* Callback to be called after xfer */
> +       void (*xfer_cb)(void *token, int result);
> +       /* If NULL, req will be done at last set parameters */
> +       struct pl330_reqcfg *cfg;
> +       /* Pointer to first xfer in the List */
> +       struct pl330_xfer *x;
> +};
> +
> +/* To know the status of the channel and DMAC, the client
> + * provides a pointer to this structure. The PL330 core
> + * fills it with current information
> + */
> +struct pl330_chanstatus {
> +       /* If the DMAC engine halted due to some error,
> +        * the client should remove-add DMAC */
> +       bool dmac_halted;
> +       /* If channel is halted due to some error,
> +        * the client may ABORT or FLUSH the channel */
> +       bool faulting;
> +       /* Location of last load */
> +       u32 src_addr;
> +       /* Location of last store */
> +       u32 dst_addr;
> +       /* Pointer to the active req */
> +       struct pl330_req *act_req;
> +       /* Pointer to req waiting in the queue */
> +       struct pl330_req *enq_req;
> +};
> +
> +/* The callbacks are made with one of these arguments */
> +enum pl330_op_err {
> +       /* The all xfers in the request were success */
> +       PL330_ERR_NONE,
> +       /* If req aborted due to global error */
> +       PL330_ERR_ABORT,
> +       /* If req failed due to problem with Channel */
> +       PL330_ERR_FAIL,
> +};
> +
> +enum pl330_chan_op {
> +       /* Start the channel */
> +       PL330_OP_START,
> +       /* Abort the active xfer */
> +       PL330_OP_ABORT,
> +       /* Stop xfer and flush queue */
> +       PL330_OP_FLUSH,
> +};
> +
> +extern struct pl330_info *pl330_alloc(struct device *);
> +extern int pl330_add(struct pl330_info *);
> +extern void pl330_del(struct pl330_info *pi);
> +extern int pl330_update(struct pl330_info *pi);
> +extern void pl330_release_channel(void *ch_id);
> +extern void *pl330_request_channel(struct pl330_info *pi);
> +extern int pl330_chan_status(void *ch_id, struct pl330_chanstatus *pstatus);
> +extern int pl330_chan_ctrl(void *ch_id, enum pl330_chan_op op);
> +extern int pl330_submit_req(void *ch_id, struct pl330_req *r);
> +extern void pl330_free(struct pl330_info *pi);


Do you really need both pairs:

pl330_alloc() + pl330_add() and
pl330_del() + pl330_free()

to be public and exposed in the interface and exported? I would suggest making
removing two of them unless there is something I don't get here.
IMO:

int pl330_add(struct device *, struct pl330_info *);
Should be enough, pl330_info will be filled in if the call returns sucessfully.
You could also

struct pl330_info *pl330_add(struct device *);

If you prefer to use macros like IS_ERR() etc on the returned pointer.

> +#endif /* __PL330_CORE_H */
> --
> 1.6.2.5
>

Yours,
Linus Walleij
