Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363Ab0FOGZl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jun 2010 02:25:41 -0400
Received: from sm-d311v.smileserver.ne.jp ([203.211.202.206]:8080 "EHLO
	sm-d311v.smileserver.ne.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752655Ab0FOGZj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jun 2010 02:25:39 -0400
Message-ID: <000401cb0c53$91a9e300$66f8800a@maildom.okisemi.com>
From: "Masayuki Ohtake" <masa-korg@dsn.okisemi.com>
To: "Arnd Bergmann" <arnd@arndb.de>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "LKML" <linux-kernel@vger.kernel.org>,
       "Andrew" <andrew.chih.howe.khor@intel.com>,
       "Intel OTC" <joel.clark@intel.com>, "Wang, Qi" <qi.wang@intel.com>,
       "Wang, Yong Y" <yong.y.wang@intel.com>
References: <4C0CE88C.9050708@dsn.okisemi.com> <4C161BE7.4080805@dsn.okisemi.com> <201006141450.53572.arnd@arndb.de>
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver
Date: Tue, 15 Jun 2010 15:25:30 +0900
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

>> +#to set CAN clock to 50Mhz
>> +ifdef CONFIG_PCH_CAN_PCLK_50MHZ
>> +EXTRA_CFLAGS +=-DPCH_CAN_PCLK_50MHZ
>> +endif

>This should not be necessary. Just use CONFIG_PCH_CAN_PCLK_50MHZ directly
>in the code instead of the extra PCH_CAN_PCLK_50MHZ macro.

I have a question. I show the above reason.
In case CAN is integrated as MODULE, macro name is CONFIG_PCH_CAN_PCLK_50MHZ_MODULE.
On the other hand, integrated as built-in, CONFIG_PCH_CAN_PCLK_50MHZ.
To prevent PHUB source code from integrated as MODULE or BUILT-IN,
we re-define macro name in Makefile.

If use CONFIG_PCH_CAN_PCLK_50MHZ directly in the source code,
in case buit-in, behavior is not correct.
But in case module, behavior is not correct.

Please give us your opinion

Thanks,
Ohtake.
----- Original Message ----- 
From: "Arnd Bergmann" <arnd@arndb.de>
To: "Masayuki Ohtak" <masa-korg@dsn.okisemi.com>
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>; "LKML" <linux-kernel@vger.kernel.org>; "Andrew"
<andrew.chih.howe.khor@intel.com>; "Intel OTC" <joel.clark@intel.com>; "Wang, Qi" <qi.wang@intel.com>; "Wang, Yong Y"
<yong.y.wang@intel.com>
Sent: Monday, June 14, 2010 9:50 PM
Subject: Re: [PATCH] Topcliff PHUB: Generate PacketHub driver


> On Monday 14 June 2010, Masayuki Ohtak wrote:
> > Hi we have modified for your comments.
> > Please Confirm below.
>
> Looks much better. A few more comments about the new code:
>
> > +#to set CAN clock to 50Mhz
> > +ifdef CONFIG_PCH_CAN_PCLK_50MHZ
> > +EXTRA_CFLAGS +=-DPCH_CAN_PCLK_50MHZ
> > +endif
>
> This should not be necessary. Just use CONFIG_PCH_CAN_PCLK_50MHZ directly
> in the code instead of the extra PCH_CAN_PCLK_50MHZ macro.
> > +
> > +DEFINE_MUTEX(pch_phub_ioctl_mutex);
>
> This should probable be 'static DEFINE_MUTEX', since the symbol does not
> need to be visible in the entire kernel.
>
>
> > +/*--------------------------------------------
> > + internal function prototypes
> > +--------------------------------------------*/
> > +static __s32 __devinit pch_phub_probe(struct pci_dev *pdev, const
> > +        struct pci_device_id *id);
> > +static void __devexit pch_phub_remove(struct pci_dev *pdev);
> > +static __s32 pch_phub_suspend(struct pci_dev *pdev, pm_message_t state);
> > +static __s32 pch_phub_resume(struct pci_dev *pdev);
> > +static __s32 pch_phub_open(struct inode *inode, struct file *file);
> > +static __s32 pch_phub_release(struct inode *inode, struct file *file);
> > +static long pch_phub_ioctl(struct file *file, unsigned int cmd,
> > + unsigned long arg);
> > +static ssize_t pch_phub_read(struct file *, char __user *, size_t, loff_t *);
> > +static ssize_t pch_phub_write(struct file *, const char __user *,
> > + size_t, loff_t *);
>
> My general recommendation would be to reorder all the function
> definitions so that you don't need any of these forward declarations.
> That is the order used in most parts of the kernel (so you start reading
> at the bottom), and it makes it easier to understand the structure of
> the code IMHO.
>
> > +/** pch_phub_open - Implements the Initializing and opening of the Packet Hub
> > + module.
> > + *  @inode: Contains the reference of the inode structure
> > + *  @file: Contains the reference of the file structure
> > + */
> > +static __s32 pch_phub_open(struct inode *inode, struct file *file)
> > +{
> > + __s32 ret;
> > +
> > + spin_lock(&pch_phub_lock);
> > + if (pch_phub_reg.pch_phub_opencount) {
> > + ret = -EBUSY;
> > + } else {
> > + pch_phub_reg.pch_phub_opencount++;
> > + ret = 0;
> > + }
> > + spin_unlock(&pch_phub_lock);
> > +
> > + return ret;
> > +}
>
> As far as I can tell, there is no longer a reason to prevent multiple
> openers. Besides, even if there is only a single user, you might still
> have concurrency problems, so the lock does not help and you could remove
> the open function entirely.
>
> > +/** pch_phub_read - Implements the read functionality of the Packet Hub module.
> > + *  @file: Contains the reference of the file structure
> > + *  @buf: Usermode buffer pointer
> > + *  @size: Usermode buffer size
> > + *  @pos: Contains the reference of the file structure
> > + */
> > +
> > +static ssize_t pch_phub_read(struct file *file, char __user *buf, size_t size,
> > + loff_t *pos)
> > +{
> > + __u32 rom_signature = 0;
> > + __u8 rom_length;
> > + __s32 ret_value;
> > + __u32 tmp;
> > + __u8 data;
> > + __u32 addr_offset = 0;
> > +
> > + /*Get Rom signature*/
> > + pch_phub_read_serial_rom(0x80, (__u8 *)&rom_signature);
> > + pch_phub_read_serial_rom(0x81, (__u8 *)&tmp);
> > + rom_signature |= (tmp & 0xff) << 8;
> > + if (rom_signature == 0xAA55) {
> > + pch_phub_read_serial_rom(0x82, &rom_length);
> > + if (size > (rom_length * 512)+1)
> > + return -ENOMEM;
> > +
> > + for (addr_offset = 0;
> > + addr_offset <= ((__u32)rom_length * 512);
> > + addr_offset++) {
> > + pch_phub_read_serial_rom(0x80 + addr_offset, &data);
> > + ret_value = copy_to_user((void *)&buf[addr_offset],
> > + (void *)&data, 1);
> > + if (ret_value)
> > + return -EFAULT;
> > + }
> > + } else {
> > + return -ENOEXEC;
> > + }
> > +
> > + return rom_length * 512 + 1;
> > +}
>
> This function has multiple problems:
>
> - If the size argument is less than rom_length*512, you access past the
>   user-provided buffer.
> - When the user does an llseek or pread, the *pos argument is not zero,
>   so you should return data from the middle, but you still return data
>   from the beginning.
> - You don't update the *pos argument with the new position, so you cannot
>   continue the read where the first call left.
> - Instead of returning -ENOMEM, you should just the data you have (or
>   0 for end-of-file).
> - ENOEXEC does not seem appropriate either: The user can just check
>   these buffer for the signature here, so you just as well return
>   whatever you find in the ROM.
>
> > +
> > +/** pch_phub_write - Implements the write functionality of the Packet Hub
> > + *  module.
> > + *  @file: Contains the reference of the file structure
> > + *  @buf: Usermode buffer pointer
> > + *  @size: Usermode buffer size
> > + *  @pos: Contains the reference of the file structure
> > + */
> > +static ssize_t pch_phub_write(struct file *file, const char __user *buf,
> > + size_t size, loff_t *pos)
> > +{
> > + static __u8 data[PCH_PHUB_OROM_SIZE];
> > + __s32 ret_value;
> > + __u32 addr_offset = 0;
> > +
> > + if (size > PCH_PHUB_OROM_SIZE)
> > + size = PCH_PHUB_OROM_SIZE;
> > +
> > + ret_value = copy_from_user(data, buf, size);
> > + if (ret_value)
> > + return -EFAULT;
> > +
> > + for (addr_offset = 0; addr_offset < size; addr_offset++) {
> > + ret_value = pch_phub_write_serial_rom(0x80 + addr_offset,
> > + data[addr_offset]);
> > + }
> > +
> > + return size;
> > +}
>
> This has the same problems, plus a buffer overflow: You must never have an
> array of multiple kilobytes on the stack (data[PCH_PHUB_OROM_SIZE]), because
> the stack itself is only a few kilobytes in the kernel. Better use a loop
> with copy_from_user like the read function does.
>
> > +/** pch_phub_release - Implements the release functionality of the Packet Hub
> > + *  module.
> > + *  @inode: Contains the reference of the inode structure
> > + *  @file: Contains the reference of the file structure
> > + */
> > +static __s32 pch_phub_release(struct inode *inode, struct file *file)
> > +{
> > + spin_lock(&pch_phub_lock);
> > +
> > + if (pch_phub_reg.pch_phub_opencount > 0)
> > + pch_phub_reg.pch_phub_opencount--;
> > + spin_unlock(&pch_phub_lock);
> > +
> > + return 0;
> > +}
>
> When you remove the open function, this one can go away as well.
>
> > +/** pch_phub_ioctl - Implements the various ioctl functionalities of the Packet
> > + *  Hub module.
> > + *  @inode: Contains the reference of the inode structure
> > + *  @file: Contains the reference of the file structure
> > + *  @cmd: Contains the command value
> > + *  @arg: Contains the command argument value
> > + */
> > +
> > +
> > +static long pch_phub_ioctl(struct file *file, unsigned int cmd,
> > + unsigned long arg)
> > +{
> > + __s32 ret_value = 0;
> > + struct pch_phub_reqt __user *p_pch_phub_reqt;
> > + __u32 data;
> > + __u32 mac_addr[2];
> > + __s32 ret;
> > + __u32 i;
> > + void __user *varg = (void __user *)arg;
> > +
> > + ret = mutex_trylock(&pch_phub_ioctl_mutex);
> > + if (ret == 0)
> > + goto return_ioctrl;/*Can't get mutex lock*/
>
> mutex_trylock is probably not what you want, it returns immediately
> when there is another function in the kernel.
> mutex_lock_interruptible seems more appropriate, it will block
> until the mutex is free or the process gets sent a signal,
> which you should handle by returning -ERESTARTSYS.
>
> In either case, you must not jump to return_ioctrl here, because
> that will try to release the mutex that you do not hold here,
> causing a hang the next time you enter the function.
>
> > + if (pch_phub_reg.pch_phub_suspended == true) {
> > + ret_value = -EPERM;
> > + goto return_ioctrl;
> > + }
> > +
> > + p_pch_phub_reqt = (struct pch_phub_reqt *)varg;
> > +
> > + if (ret_value)
> > + goto return_ioctrl;
>
> is always zero here.
>
> > + /* End of Access area check */
> > +
> > +
> > + switch (cmd) {
> > +
> > + case IOCTL_PHUB_READ_MAC_ADDR:
> > + mac_addr[0] = 0;
> > + mac_addr[1] = 0;
> > + for (i = 0; i < 4; i++) {
> > + pch_phub_read_gbe_mac_addr(i, (__u8 *)&data);
> > + mac_addr[0] |= data << i*8;
> > + }
> > + for (; i < 6; i++) {
> > + pch_phub_read_gbe_mac_addr(i, (__u8 *)&data);
> > + mac_addr[1] |= data << (i-4)*8;
> > + }
> > +
> > + ret_value = copy_to_user((void *)&p_pch_phub_reqt->data,
> > + (void *)mac_addr, sizeof(mac_addr));
>
> p_pch_phub_reqt->data has multiple problems:
>
> - You have the typecast to (void *), which is wrong and unneeded.
> - The data structure has no point at all any more when you use only one
>   field.
>
> Just make this
>
> u8 mac_addr[6];
> for (i = 0; i < 4; i++)
> pch_phub_read_gbe_mac_addr(i, &mac_addr[i]);
> ret_value = copy_to_user(varg, mac_addr, sizeof(mac_addr));
>
> > +#define PHUB_IOCTL_MAGIC (0xf7)
> > +
> > +/*Outlines the read register function signature.  */
> > +#define IOCTL_PHUB_READ_REG (_IOW(PHUB_IOCTL_MAGIC, 1, __u32))
> > +
> > +/*Outlines the write register function signature. */
> > +#define IOCTL_PHUB_WRITE_REG (_IOW(PHUB_IOCTL_MAGIC, 2, __u32))
> > +
> > +/*Outlines the read, modify and write register function signature. */
> > +#define IOCTL_PHUB_READ_MODIFY_WRITE_REG (_IOW(PHUB_IOCTL_MAGIC, 3,\
> > + __u32))
> > +
> > +/*Outlines the read option rom function signature. */
> > +#define IOCTL_PHUB_READ_OROM (_IOW(PHUB_IOCTL_MAGIC, 4, __u32))
> > +
> > +/*Outlines the write option rom function signature. */
> > +#define IOCTL_PHUB_WRITE_OROM (_IOW(PHUB_IOCTL_MAGIC, 5, __u32))
>
> These should all get removed now.
>
> > +/*Outlines the read mac address function signature. */
> > +#define IOCTL_PHUB_READ_MAC_ADDR (_IOW(PHUB_IOCTL_MAGIC, 6, __u32))
> > +
> > +/*brief Outlines the write mac address function signature. */
> > +#define IOCTL_PHUB_WRITE_MAC_ADDR (_IOW(PHUB_IOCTL_MAGIC, 7, __u32))
>
> IOCTL_PHUB_READ_MAC_ADDR needs _IOR instead of _IOW, and the type
> is still wrong here. Your code currently has struct pch_phub_reqt
> instead of __u32, and if you change the ioctl function as I explained
> above, it should become
>
> #define IOCTL_PHUB_READ_MAC_ADDR (_IOR(PHUB_IOCTL_MAGIC, 6, __u8[6]))
> #define IOCTL_PHUB_WRITE_MAC_ADDR (_IOW(PHUB_IOCTL_MAGIC, 7, __u8[6]))
>
> Arnd
>


