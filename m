Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752302Ab1BBOMh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Feb 2011 09:12:37 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54044 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751700Ab1BBOMg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Feb 2011 09:12:36 -0500
MIME-Version: 1.0
In-Reply-To: <201102021037.14364.arnd@arndb.de>
References: <1296550966-4015-1-git-send-email-walle@corscience.de>
 <20110202043944.GG29148@angua.secretlab.ca> <201102021037.14364.arnd@arndb.de>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 2 Feb 2011 07:12:15 -0700
X-Google-Sender-Auth: 3DLfJ3o1QeTDUroN3jW_thIzPzo
Message-ID: <AANLkTimRsEB5DBX0NH80f_aoqWn8-5KzXnf-p8_fHnsx@mail.gmail.com>
Subject: Re: [PATCH] spi: spidev: Add 32 bit compat ioctl()
To: Arnd Bergmann <arnd@arndb.de>
Cc: Bernhard Walle <walle@corscience.de>, dbrownell@users.sourceforge.net,
        spi-devel-general@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 2, 2011 at 2:37 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Wednesday 02 February 2011, Grant Likely wrote:
>> On Tue, Feb 01, 2011 at 10:02:46AM +0100, Bernhard Walle wrote:
>> > Add the compat_ioctl for operations on /dev/spi* so that 32 bit
>> > userspace applications can access SPI. As far as I can see all data
>> > structure are already prepared for that, so no additional conversion has
>> > to be done.
>> >
>> > My use case is MIPS with N32 userspace ABI and toolchain, and that was
>> > also the platform where I tested it successfully (Cavium Octeon).
>> >
>> > Signed-off-by: Bernhard Walle <walle@corscience.de>
>>
>> Arnd, can you please give your opinion on this one?  I haven't fully
>> got my head around the subtleties of 32/64 bit file_operations.
>
> The patch is correct on everything except s390, which does not have SPI.
> The only thing that is missing for s390 is a pointer conversion of the ioctl
> argument, like:
>
> static long
> compat_spidev_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> {
>        return spidev_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
> }
>
> Some years ago, I proposed adding a common
>
> #ifdef CONFIG_COMPAT
> long generic_compat_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
> {
>        if (!file->unlocked_ioctl)
>                return -ENOTTY;
>        return filp->f_ops->unlocked_ioctl(filp, cmd, (unsigned long)compat_ptr(arg));
> }
> #else
> #define generic_compat_ioctl NULL
> #endif
>
> for this purpose, but it never made it in. Maybe I should try again.

I'd like to see that go in too.  If you can implement it for the
2.6.39, then I'd like to see this patch rebased on top of it.

g.
