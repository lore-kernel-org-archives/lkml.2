Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756762Ab2LGT2H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 14:28:07 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:46593 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab2LGT2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 14:28:05 -0500
MIME-Version: 1.0
Date: Fri, 7 Dec 2012 20:28:03 +0100
Message-ID: <CAHTX3d+VNDVQjnTnAB=Ywxo7odvNmCPu=wGZ03-xWLecSMsS9A@mail.gmail.com>
Subject: Using IO functions across ARM, PPC and Microblaze architectures
From: Michal Simek <monstr@monstr.eu>
To: linux-arch@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I would like to get some advices what correct coding style is.

I have one problem with some drivers (uartlite for example)
which are shared across three architectures arm, powerpc and microblaze.

Because I need to use IO functions which will behave
on arm as little endian and on powerpc as big endian
and on microblaze depends on endian setting.
I haven't found any IO function which I could use by 3 architectures
without using preprocessor macros or runtime detection

Please correct me if there is any standard IO function which I could use
for this case.

I was looking at.
readl - make no sense on PowerPC because I need big endian and it is
little there
ioread - is little endian on PPC(ioreadXXbe is big endain)
ioreadXXbe - is always big endian
in_be/in_le - is the same option as ioread/writebe

Using __raw_readl function should be also problematic on ARM
because doesn't prevent reordering or partial accesses.


It means that I should use helper function.

1. Using helper function + preprocessor macros
(using static inline function also possible)

#ifdef __LITTLE_ENDIAN
# define driver_read ioread32
#else
# define driver_read ioread32be
#endif

fce() {
      u32 val = driver_read(..);
}

2. Using function pointers
a) initialization based on preprocesor macros

fce() {
      u32 val;

#ifdef __LITTLE_ENDIAN
      dev_data->read_fn = ioread32
#else
      dev_data->read_fn = ioread32be
#endif

      val = dev_data->read_fn(..);
}

b) Runtime initialization - here is the question if there is
any standard function which I could use.

fce() {
	int num = 1;
	/* run time endian detection */	
	if (*(char *)&num == 1) {
		dev_data->read_fn = ioread32
	else
		dev_data->read_fn = ioread32be

	val = dev_data->read_fn(..);
}

Can you recommend me the best way I should use?

Thanks,
Michal

-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
