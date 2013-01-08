Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755650Ab3AHKag (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:30:36 -0500
Received: from mail-oa0-f52.google.com ([209.85.219.52]:52016 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755379Ab3AHKaf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:30:35 -0500
MIME-Version: 1.0
In-Reply-To: <20130107090210.GA20716@elgon.mountain>
References: <20130107090210.GA20716@elgon.mountain>
Date: Tue, 8 Jan 2013 19:30:34 +0900
Message-ID: <CANKRQnh+USJwA=-+MYotvWQif7ZWQwPyUWnrbGQg5dFpvfh5Dg@mail.gmail.com>
Subject: Re: add Packet hub driver for Topcliff Platform controller hub
From: Tomoya MORINAGA <tomoya.rohm@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

On Mon, Jan 7, 2013 at 6:02 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> The patch cf4ece53460c: "add Packet hub driver for Topcliff Platform
> controller hub" from Sep 1, 2010, leads to the following warning:
> drivers/misc/pch_phub.c:596 pch_phub_bin_write()
>          error: buffer overflow 'buf' 4096 <= 15359
>
> Sorry my question is about an old patch.  Smatch complains because we
> only pass a PAGE_SIZE buffer to sysfs files so the test for
> "if (count > PCH_PHUB_OROM_SIZE) {" makes it think we are overflowing.
> In fact, count is never more than 4096 so there is no overflow, but I
> also think that it means only the first 4096 bytes of the firmware gets
> updated.
>
> drivers/misc/pch_phub.c
>    560  static ssize_t pch_phub_bin_write(struct file *filp, struct kobject *kobj,
>    561                                    struct bin_attribute *attr,
>    562                                    char *buf, loff_t off, size_t count)
>    563  {
>    564          int err;
>    565          unsigned int addr_offset;
>    566          int ret;
>    567          ssize_t rom_size;
>    568          struct pch_phub_reg *chip =
>    569                  dev_get_drvdata(container_of(kobj, struct device, kobj));
>    570
>    571          ret = mutex_lock_interruptible(&pch_phub_mutex);
>    572          if (ret)
>    573                  return -ERESTARTSYS;
>    574
>    575          if (off > PCH_PHUB_OROM_SIZE) {
>    576                  addr_offset = 0;
>    577                  goto return_ok;
>    578          }
>    579          if (count > PCH_PHUB_OROM_SIZE) {
>                             ^^^^^^^^^^^^^^^^^^
> This is 15359.
>
>    580                  addr_offset = 0;
>    581                  goto return_ok;
>    582          }
>    583
>    584          chip->pch_phub_extrom_base_address = pci_map_rom(chip->pdev, &rom_size);
>    585          if (!chip->pch_phub_extrom_base_address) {
>    586                  err = -ENOMEM;
>    587                  goto exrom_map_err;
>    588          }
>    589
>    590          for (addr_offset = 0; addr_offset < count; addr_offset++) {
>    591                  if (PCH_PHUB_OROM_SIZE < off + addr_offset)
>    592                          goto return_ok;
>    593
>    594                  ret = pch_phub_write_serial_rom(chip,
>    595                              chip->pch_opt_rom_start_address + addr_offset + off,
>    596                              buf[addr_offset]);
>                                     ^^^^^^^^^^^^^^^^
> Smatch complains because "buf" is only 4096 bytes.
>

I can understand your saying.

You mean just delete the following condition ?

579          if (count > PCH_PHUB_OROM_SIZE) {

Thanks.

-- 
ROHM Co., Ltd.
tomoya
