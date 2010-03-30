Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab0C3Px3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 11:53:29 -0400
Received: from web94902.mail.in2.yahoo.com ([203.104.17.140]:42498 "HELO
	web94902.mail.in2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753397Ab0C3Px2 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 11:53:28 -0400
Message-ID: <693134.37568.qm@web94902.mail.in2.yahoo.com>
X-YMail-OSG: AYFle6kVM1leqnKwZ_3WfREsOtOBew7b66AjwvhqLe8g.DS
 L56NKKyq0BLKxNpVBUO2T6r6UMg4YZv.k.bORcswYgmWATf05xC66wtZ0ADM
 kWt8dlA3Xgbd.MpY0.JOe465s2MpxRPUfeVEhb9IUy4YUAjvFVgRePFhGYnT
 nCALZdmPNrpCTQmh6dWEfHW_hPOt0bCDIRxxspNZZ3zfSRxGWIwsbTl8HFkx
 QsYq2B1yZQXl1M9lrJJ8hDieW9TUXUuueYwZT.iVT.XFH8QjvL3oqWx.Sdd_
 j1st_K5CGQxl4_c4ilgtd_M8-
X-RocketYMMF: pavan_savoy
X-Mailer: YahooMailClassic/10.0.8 YahooMailWebService/0.8.100.260964
Date: Tue, 30 Mar 2010 21:23:23 +0530 (IST)
From: Pavan Savoy <pavan_savoy@ti.com>
Reply-To: pavan_savoy@ti.com
Subject: Re: [PATCH] drivers:staging: sources for ST core
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: marcel@holtmann.org, gregkh@suse.de, linux-kernel@vger.kernel.org
In-Reply-To: <20100330122201.02accf0f@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan,

--- On Tue, 30/3/10, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:

> From: Alan Cox <alan@lxorguk.ukuu.org.uk>
> Subject: Re: [PATCH] drivers:staging: sources for ST core
> To: pavan_savoy@ti.com
> Cc: marcel@holtmann.org, gregkh@suse.de, linux-kernel@vger.kernel.org, pavan_savoy@yahoo.co.in
> Date: Tuesday, 30 March, 2010, 4:52 PM
> > +/* all debug macros go in here
> */
> > +#define ST_DRV_ERR(fmt, arg...)  printk(KERN_ERR
> "(stc):"fmt"\n" , ## arg)
> > +#if defined(DEBUG)   
>     /* limited debug messages */
> > +#define ST_DRV_DBG(fmt, arg...) 
> printk(KERN_INFO "(stc):"fmt"\n" , ## arg)
> > +#define ST_DRV_VER(fmt, arg...)
> > +#elif defined(VERBOSE)   
>     /* very verbose */
> > +#define ST_DRV_DBG(fmt, arg...) 
> printk(KERN_INFO "(stc):"fmt"\n" , ## arg)
> > +#define ST_DRV_VER(fmt, arg...) 
> printk(KERN_INFO "(stc):"fmt"\n" , ## arg)
> > +#else /* error msgs only */
> > +#define ST_DRV_DBG(fmt, arg...)
> > +#define ST_DRV_VER(fmt, arg...)
> > +#endif
> 
> As Greg said earlier - needs to be using the standard debug
> macros

Agree - It's all there because of the organization's coding standards.
Will correct it.

> 
> > +/*
> > + * local data instances
> > + */
> > +static struct st_data_s *st_gdata;
> > +/* function pointer pointing to either,
> > + * st_kim_recv during registration to receive fw
> download responses
> > + * st_int_recv after registration to receive proto
> stack responses
> > + */
> > +void (*st_recv) (const unsigned char *data, long
> count);
> 
> Need some form of context so you can have multiple device
> instances and
> avoid games with globals (which always end up in pain)

Yes, platform device context ? as in per-device ?
However, would face a problem (as mentioned in other mail) - 
which is when a BT/FM driver which are like client drivers want to use this line discipline, do they need to know which context this needs to go into ?

> > +
> >
> +/********************************************************************/
> > +/* internal misc functions */
> > +bool is_protocol_list_empty(void)
> > +{
> > +    unsigned char i = 0;
> > +    ST_DRV_DBG(" %s ", __func__);
> > +    for (i = 0; i < ST_MAX; i++) {
> > +        if
> (st_gdata->list[i] != NULL)
> > +       
>     return ST_NOTEMPTY;
> > +        /* not empty
> */
> > +    }
> > +    /* list empty */
> > +    return ST_EMPTY;
> 
> Why not just keep a count of entries you've added/removed
> ?

One more variable ? to st_gdata ? done. Sounds simple.
> 
> > + *  This is the internal write function - a
> wrapper
> > + *  to tty->ops->write
> > + */
> > +int st_int_write(const unsigned char *data, int
> count)
> > +{
> > +#ifdef VERBOSE       
>     /* for debug */
> > +    int i;
> > +#endif
> > +    struct tty_struct *tty;
> > +    if (unlikely(st_gdata == NULL ||
> st_gdata->tty == NULL)) {
> > +        ST_DRV_ERR("tty
> unavailable to perform write");
> 
> You need to use the tty pointer passed, you don't want to
> walk
> tty->something and back because you may race a hangup.
> Plus you would
> need to manage the krefs (object references)

Do I need to do it in tty_open and _release ?
Because I don't have anything much to release when tty closes.
All I have to do is done in tty_close. 

> > +        return
> ST_ERR_FAILURE;
> 
> Should be using Linux error codes for upstream. A global
> search/replace
> of the ST_ERR_xxx for a similar -Efoo code will do the
> trick I think

Ok, But is it ok, to maintain codes, internally among ST/BT/FM drivers ?
 
> > +/*
> > + * push the skb received to relevant
> > + * protocol stacks
> > + */
> > +void st_send_frame(enum proto_type protoid, struct
> sk_buff *skb)
> > +{
> > +    ST_DRV_DBG(" %s(prot:%d) ",
> __func__, protoid);
> > +
> > +    if (unlikely
> > +        (st_gdata == NULL ||
> skb == NULL
> > +         ||
> st_gdata->list[protoid] == NULL)) {
> > +       
> ST_DRV_ERR("protocol %d not registered, no data to send?",
> > +       
>        protoid);
> > +       
> kfree_skb(skb);
> > +        return;
> > +    }
> 
> What is the locking rule to ensure I don't unregister a
> protocol as send
> frame is called ?

send_frame is called from st_int_recv - which is a SOFT-IRQ I believe, So do I really need that ?

> 
> > + * to call registration complete callbacks
> > + * of all protocol stack drivers
> > + */
> > +void st_reg_complete(char err)
> > +{
> > +    unsigned char i = 0;
> > +    ST_DRV_DBG(" %s ", __func__);
> > +    for (i = 0; i < ST_MAX; i++) {
> > +        if
> (likely(st_gdata != NULL && st_gdata->list[i] !=
> NULL &&
> 
> Except on very hot paths that go odd ways likely and
> unlikely are
> normally a loss.

point taken.
> 
> > +static inline int st_check_data_len(int protoid, int
> len)
> > +{
> > +    register int room =
> skb_tailroom(st_gdata->rx_skb);
> 
> No need to use register - gcc is generally smarter than
> humans here,
> especially in the long term. You may optimise perfectly for
> a single
> cpu/compiler revision but not for all

Ha, this one's a copy/paste piece from hci_ll.c's recv function.
 
> 
> > +/* Decodes received RAW data and forwards to
> corresponding
> > + * client drivers (Bluetooth,FM,GPS..etc).
> > + *
> > + */
> > +void st_int_recv(const unsigned char *data, long
> count)
> 
> There are lots of globals here, in part it seems due to the
> lack of any
> kind of context being passed around
> 

This global function pointer as such is not a necessity.
st_recv can point to st_kim_recv (response to firmware download) or st_int_recv (response to commands).

They are sort of mutually exclusive, firmware will be downloaded once.
and once ready, chip will always use cmd/response st_int_recv.

> 
> >
> > +    /* this function can be invoked in
> more then one context.
> > +     * so have a lock */
> 
> It's a good idea to document what data is locked and what
> the data
> locking assumptions are. I'm finding that part of the code
> quite hard to
> follow

Ok.

> 
> > +/*
> > + * internal wakeup function
> > + * called from either
> > + * - TTY layer when write's finished
> > + * - st_write (in context of the protocol stack)
> > + */
> > +void st_tx_wakeup(struct st_data_s *st_data)
> 
> 
> > +        while ((skb =
> st_int_dequeue(st_data))) {
> 
> Called in two paths but st_int_dequeue seems to have no
> internal locking

The 2nd path doesn't come until the int_dequeue at all, i.e it would know ST_TX_SENDING, and would queue the skb and return.
I remember there was one lock here, removed when I started to have problem on SMP.

> 
> > +/* functions called from ST KIM
> > +*/
> > +void kim_st_list_protocols(char *buf)
> > +{
> > +    unsigned long flags = 0;
> > +#ifdef DEBUG
> > +    unsigned char i = ST_MAX;
> > +#endif
> > +   
> spin_lock_irqsave(&st_gdata->lock, flags);
> > +#ifdef DEBUG       
>     /* more detailed log */
> > +    for (i = 0; i < ST_MAX; i++) {
> > +        if (i == 0) {
> > +       
>     sprintf(buf, "%s is %s",
> protocol_strngs[i],
> > +       
>         st_gdata->list[i]
> !=
> > +       
>         NULL ? "Registered" :
> "Unregistered");
> 
> Always a good idea to use snprintf and track size (plus
> pass buffer size)
> it avoida accidents later. Or also see the seq_ interface
> when you want
> to build proc type files.

Ok, the whole thing will go off.
The plan is to use /dev/rfkill and avoid the sysfs entry altogether.

> >
> +/********************************************************************/
> > +/*
> > + * functions called from protocol stack drivers
> > + * to be EXPORT-ed
> > + */
> > +long st_register(struct st_proto_s *new_proto)
> > +{
> > +    long err = ST_SUCCESS;
> 
> >
> > + * functions called from TTY layer
> > + */
> > +static int st_tty_open(struct tty_struct *tty)
> > +{
> > +    int err = ST_SUCCESS;
> > +    ST_DRV_DBG("%s ", __func__);
> > +
> > +    st_gdata->tty = tty;
> 
> If you do this you need to use krefs and manage the
> reference properly
> over open/close/hangup

ok, But can I really put the kref upon tty_close ?
A bluetooth driver, might have registered, but wouldn't have started communication i.e tty_open might not have occurred.

So, I wouldn't have any trouble with that right ?

> 
> > +static void st_tty_close(struct tty_struct *tty)
> > +{
> > +    /* Flush any pending characters in
> the driver and discipline. */
> 
> > +    tty_driver_flush_buffer(tty);
> 
> Close will deal with this anyway

yep, redundant - will remove it.

> 
> > +static void st_tty_receive(struct tty_struct *tty,
> const unsigned char *data,
> > +       
>        char *tty_flags, int
> count)
> > +{
> > +#ifdef VERBOSE
> > +    long i;
> > +    printk(KERN_ERR "incoming
> data...\n");
> > +    for (i = 0; i < count; i++)
> > +        printk(" %x",
> data[i]);
> > +    printk(KERN_ERR "\n.. data
> end\n");
> > +#endif
> > +
> > +    /*
> > +     * if fw download is in
> progress then route incoming data
> > +     * to KIM for
> validation
> > +     */
> > +    st_recv(data, count);
> 
> If you passed tty up and used tty->disc_data you'd be
> able to handle
> multiple devices

Ok, the only problem here is st_int_write, which is called during firmware download. I don't get a tty there, and hence I copy it onto the st_gdata->tty.
For the rest of callbacks from TTY layer, I can make use of the tty coming into the function.

Considering the other way, if st_gdata went into the tty->disc_data, I have EXPORTED functions like st_register and st_unregister, when I can't get hold of the disc_data.


> >
> +/********************************************************************/
> > +static int __init st_core_init(void)
> > +{
> > +    long err;
> > +    static struct tty_ldisc_ops
> *st_ldisc_ops;
> > +
> > +    /* populate and register to TTY
> line discipline */
> > +    st_ldisc_ops =
> kzalloc(sizeof(*st_ldisc_ops), GFP_KERNEL);
> > +    if (!st_ldisc_ops) {
> > +        ST_DRV_ERR("no
> mem to allocate");
> > +        return
> -ENOMEM;
> > +    }
> > +
> > +    st_ldisc_ops->magic =
> TTY_LDISC_MAGIC;
> > +    st_ldisc_ops->name =
> "n_st";    /*"n_hci"; */
> > +    st_ldisc_ops->open =
> st_tty_open;
> > +    st_ldisc_ops->close =
> st_tty_close;
> > +    st_ldisc_ops->receive_buf =
> st_tty_receive;
> > +    st_ldisc_ops->write_wakeup =
> st_tty_wakeup;
> > +    st_ldisc_ops->flush_buffer =
> st_tty_flush_buffer;
> > +    st_ldisc_ops->owner =
> THIS_MODULE;
> 
> You could just declare this as a static struct like other
> drivers do ?
> 

Yep, I remember doing that, and using a couple of goto-s as well.
Organization coding standards and linux Coding Style collided.
- Will do that.


      The INTERNET now has a personality. YOURS! See your Yahoo! Homepage. http://in.yahoo.com/
