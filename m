Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758804Ab0FVCOs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 22:14:48 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:41871 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753190Ab0FVCOr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 22:14:47 -0400
Message-ID: <001401cb11b0$aee32870$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Intel OTC" <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Tue, 22 Jun 2010 11:14:42 +0900
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2800.1983
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2800.1983
X-Hosting-Pf: 0
X-NAI-Spam-Score: 1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

Sorry, for late patch releasing.

I have modified like below.
We will release today.

>
> On Thursday 17 June 2010, Masayuki Ohtak wrote:
> > +
> > +#define PCH_READ_REG(a) ioread32(pch_phub_reg.pch_phub_base_address + (a))
> > +
> > +#define PCH_WRITE_REG(a, b) iowrite32((a), pch_phub_reg.pch_phub_base_address +\
> > + (b))
>
> I'd recommend just getting rid of these abstractions. You only use
> them in one or two functions each, so you can just as well add a local
> variable there and do
>
> void __iomem *p = pch_phub_reg.pch_phub_base_address;
> foo = ioread32(p + foo_offset);
> bar = ioread32(p + bar_offset);
> ...
>
> Not really important, but this way it would be more conventional
> without having to write extra code.
Modified like above.


>
> > +/*--------------------------------------------
> > + global variables
> > +--------------------------------------------*/
> > +/**
> > + * struct pch_phub_reg_t - PHUB register structure
> > + * @phub_id_reg: PHUB_ID register val
> > + * @q_pri_val_reg: QUEUE_PRI_VAL register val
> > + * @rc_q_maxsize_reg: RC_QUEUE_MAXSIZE register val
> > + * @bri_q_maxsize_reg: BRI_QUEUE_MAXSIZE register val
> > + * @comp_resp_timeout_reg: COMP_RESP_TIMEOUT register val
> > + * @bus_slave_control_reg: BUS_SLAVE_CONTROL_REG register val
> > + * @deadlock_avoid_type_reg:  DEADLOCK_AVOID_TYPE register val
> > + * @intpin_reg_wpermit_reg0:  INTPIN_REG_WPERMIT register 0 val
> > + * @intpin_reg_wpermit_reg1:  INTPIN_REG_WPERMIT register 1 val
> > + * @intpin_reg_wpermit_reg2:  INTPIN_REG_WPERMIT register 2 val
> > + * @intpin_reg_wpermit_reg3:  INTPIN_REG_WPERMIT register 3 val
> > + * @int_reduce_control_reg: INT_REDUCE_CONTROL registers val
> > + * @clkcfg_reg: CLK CFG register val
> > + * @pch_phub_base_address:  register base address
> > + * @pch_phub_extrom_base_address:  external rom base address
> > + * @pch_phub_suspended: PHUB status val
> > + */
> > +struct pch_phub_reg_t {
>
> It would be better to drop the _t postfix on the type name.
> By convention, we use this only for typedefs on simple data
> types like off_t but not for structures.
Deleted '_t' prefix

>
> > + __u32 phub_id_reg;
> > + __u32 q_pri_val_reg;
> > + __u32 rc_q_maxsize_reg;
>
> When I told you to change the ioctl arguments to use __u32 instead
> of u32, I was only referring to those parts that are in the user-visible
> section of the header file. While it does not hurt to use __u32 in
> the kernel, you should understand the distinction.
The following types are modified like below except user-visible secton '__u8 mac_addr[6].
__u32 -> unsigned int
__s32 -> int
__u8  -> unsigned char
__s8  -> char


>
> > +/** pch_phub_write - Implements the write functionality of the Packet Hub
> > + *  module.
> > + *  @file: Contains the reference of the file structure
> > + *  @buf: Usermode buffer pointer
> > + *  @size: Usermode buffer size
> > + *  @ppos: Contains the reference of the file structure
> > + */
> > +static ssize_t pch_phub_write(struct file *file, const char __user *buf,
> > + size_t size, loff_t *ppos)
> > +{
> > + static __u32 data;
>
> No need to make data static.
Deleted 'static'.

>
> > + __s32 ret_value;
> > + __u32 addr_offset = 0;
> > + loff_t pos = *ppos;
> > +
> > + if (pos < 0)
> > + return -EINVAL;
> > +
> > + for (addr_offset = 0; addr_offset < size; addr_offset++) {
> > + get_user(data, &buf[addr_offset]);
> > +
> > + ret_value = pch_phub_write_serial_rom(0x80 + addr_offset + pos,
> > + data);
> > + if (ret_value)
> > + return -EFAULT;
>
> You should return -EFAULT if the get_user() call fails, otherwise you have
> a possible security hole. If pch_phub_write_serial_rom fails, the correct
> return code would be -EIO.
Modified to care returned value of get_user.
Modified retunrn code of pch_phub_write_serial_rom to -EIO.

>
> > +/**
> > + * file_operations structure initialization
> > + */
> > +static const struct file_operations pch_phub_fops = {
> > + .owner = THIS_MODULE,
> > + .read = pch_phub_read,
> > + .write = pch_phub_write,
> > + .unlocked_ioctl = pch_phub_ioctl,
> > +};
>
> If would be good to add a line of
> .llseek = default_llseek,
> here. I have a patch to change the default llseek method to one
> that disallows seeking, so if you add this line, there is one
> less driver for me to patch.
Added a line of '.llseek = default_llseek'.

Thanks,
Ohtake

----- Original Message ----- 
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Wang, Yong Y" <yong.y.wang@intel.com>; "Wang, Qi" <qi.wang@intel.com>; "Intel OTC" <joel.clark@intel.com>; "Andrew"
<andrew.chih.howe.khor@intel.com>; "LKML" <linux-kernel@vger.kernel.org>; "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Sent: Friday, June 18, 2010 8:49 AM
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver


> Hi Arnd,
>
> I will modify for your comments by today or tomorrow.
>
> Thanks,
> Ohtake
>
> ----- Original Message ----- 
> From: "Arnd Bergmann" <arnd@arndb.de>
> To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
> Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>; "LKML" <linux-kernel@vger.kernel.org>; "Andrew"
> <andrew.chih.howe.khor@intel.com>; "Intel OTC" <joel.clark@intel.com>; "Wang, Qi" <qi.wang@intel.com>; "Wang, Yong Y"
> <yong.y.wang@intel.com>
> Sent: Thursday, June 17, 2010 8:59 PM
> Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
>
>
> > Looks almost good to me now. Some more details (only the -EFAULT return code
> > is a real issue, the other ones are cosmetic changes):
> >
> > On Thursday 17 June 2010, Masayuki Ohtak wrote:
> > > +
> > > +#define PCH_READ_REG(a) ioread32(pch_phub_reg.pch_phub_base_address + (a))
> > > +
> > > +#define PCH_WRITE_REG(a, b) iowrite32((a), pch_phub_reg.pch_phub_base_address +\
> > > + (b))
> >
> > I'd recommend just getting rid of these abstractions. You only use
> > them in one or two functions each, so you can just as well add a local
> > variable there and do
> >
> > void __iomem *p = pch_phub_reg.pch_phub_base_address;
> > foo = ioread32(p + foo_offset);
> > bar = ioread32(p + bar_offset);
> > ...
> >
> > Not really important, but this way it would be more conventional
> > without having to write extra code.
> >
> > > +/*--------------------------------------------
> > > + global variables
> > > +--------------------------------------------*/
> > > +/**
> > > + * struct pch_phub_reg_t - PHUB register structure
> > > + * @phub_id_reg: PHUB_ID register val
> > > + * @q_pri_val_reg: QUEUE_PRI_VAL register val
> > > + * @rc_q_maxsize_reg: RC_QUEUE_MAXSIZE register val
> > > + * @bri_q_maxsize_reg: BRI_QUEUE_MAXSIZE register val
> > > + * @comp_resp_timeout_reg: COMP_RESP_TIMEOUT register val
> > > + * @bus_slave_control_reg: BUS_SLAVE_CONTROL_REG register val
> > > + * @deadlock_avoid_type_reg:  DEADLOCK_AVOID_TYPE register val
> > > + * @intpin_reg_wpermit_reg0:  INTPIN_REG_WPERMIT register 0 val
> > > + * @intpin_reg_wpermit_reg1:  INTPIN_REG_WPERMIT register 1 val
> > > + * @intpin_reg_wpermit_reg2:  INTPIN_REG_WPERMIT register 2 val
> > > + * @intpin_reg_wpermit_reg3:  INTPIN_REG_WPERMIT register 3 val
> > > + * @int_reduce_control_reg: INT_REDUCE_CONTROL registers val
> > > + * @clkcfg_reg: CLK CFG register val
> > > + * @pch_phub_base_address:  register base address
> > > + * @pch_phub_extrom_base_address:  external rom base address
> > > + * @pch_phub_suspended: PHUB status val
> > > + */
> > > +struct pch_phub_reg_t {
> >
> > It would be better to drop the _t postfix on the type name.
> > By convention, we use this only for typedefs on simple data
> > types like off_t but not for structures.
> >
> > > + __u32 phub_id_reg;
> > > + __u32 q_pri_val_reg;
> > > + __u32 rc_q_maxsize_reg;
> >
> > When I told you to change the ioctl arguments to use __u32 instead
> > of u32, I was only referring to those parts that are in the user-visible
> > section of the header file. While it does not hurt to use __u32 in
> > the kernel, you should understand the distinction.
> >
> > > +/** pch_phub_write - Implements the write functionality of the Packet Hub
> > > + *  module.
> > > + *  @file: Contains the reference of the file structure
> > > + *  @buf: Usermode buffer pointer
> > > + *  @size: Usermode buffer size
> > > + *  @ppos: Contains the reference of the file structure
> > > + */
> > > +static ssize_t pch_phub_write(struct file *file, const char __user *buf,
> > > + size_t size, loff_t *ppos)
> > > +{
> > > + static __u32 data;
> >
> > No need to make data static.
> >
> > > + __s32 ret_value;
> > > + __u32 addr_offset = 0;
> > > + loff_t pos = *ppos;
> > > +
> > > + if (pos < 0)
> > > + return -EINVAL;
> > > +
> > > + for (addr_offset = 0; addr_offset < size; addr_offset++) {
> > > + get_user(data, &buf[addr_offset]);
> > > +
> > > + ret_value = pch_phub_write_serial_rom(0x80 + addr_offset + pos,
> > > + data);
> > > + if (ret_value)
> > > + return -EFAULT;
> >
> > You should return -EFAULT if the get_user() call fails, otherwise you have
> > a possible security hole. If pch_phub_write_serial_rom fails, the correct
> > return code would be -EIO.
> >
> > > +/**
> > > + * file_operations structure initialization
> > > + */
> > > +static const struct file_operations pch_phub_fops = {
> > > + .owner = THIS_MODULE,
> > > + .read = pch_phub_read,
> > > + .write = pch_phub_write,
> > > + .unlocked_ioctl = pch_phub_ioctl,
> > > +};
> >
> > If would be good to add a line of
> > .llseek = default_llseek,
> > here. I have a patch to change the default llseek method to one
> > that disallows seeking, so if you add this line, there is one
> > less driver for me to patch.
> >
> > Arnd
> >
>
>
>


