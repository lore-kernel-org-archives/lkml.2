Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760703Ab0JJBwj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 21:52:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:53254 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872Ab0JJBwi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 21:52:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=CI0m2V7T8U98WtAgOWhSRJllIMEZt0fQALoesnMqgPk38Ck5EkIbzYG2qnRfCLfhlL
         jOc4adYNTrZh36CorLVFb3djHvNI+EC61kqxtivL1zO1z20e9m5Hgi+nREi74fSzcFRK
         w3dbUz01yofKsn/UokjdWaye1NX5dtnxx7d+8=
MIME-Version: 1.0
In-Reply-To: <20101009092127.GB20975@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101007192245.GC26435@n2100.arm.linux.org.uk>
	<AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
	<20101008175308.GA10975@n2100.arm.linux.org.uk>
	<AANLkTi=ERZjVDS=Q7aw1zA23KF68irUP3vvKLZw5meBU@mail.gmail.com>
	<20101008230451.GB10975@n2100.arm.linux.org.uk>
	<20101008232539.GA28697@kroah.com>
	<20101008234448.GD10975@n2100.arm.linux.org.uk>
	<AANLkTinhwORqdWU43yr1AXJGZm2zPKGG+Q9twruNs2aH@mail.gmail.com>
	<20101009092127.GB20975@n2100.arm.linux.org.uk>
Date: Sun, 10 Oct 2010 04:52:36 +0300
Message-ID: <AANLkTimQJLmDZPHtVJLCv9ZQgx_Yjh9=MOwOxMSAz4QX@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Greg KH <greg@kroah.com>, linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 9, 2010 at 12:21 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> static unsigned long reserve_mem(struct meminfo *mi, unsigned long size)
> {
>        unsigned long addr = ~0;
>        int i;
>
>        for (i = mi->nr_banks - 1; i >= 0; i--)
>                if (mi->bank[i].size >= size) {
>                        mi->bank[i].size -= size;
>                        addr = mi->bank[i].start + mi->bank[i].size;
>                        break;
>                }
>
>        return addr;
> }
>
> static void __init my_fixup(struct machine_desc *desc, struct tag *tags,
>                            char **cmdline, struct meminfo *mi)
> {
>        omapfb_buffer_phys = reserve_mem(mi, 32*1048576);
>        if (omapfb_buffer_phys == ~0)
>                pr_warn("Unable to allocate omapfb buffer\n");
> }
>
> Then later:
>
>        omapfb_buffer = ioremap(omapfb_buffer_phys, 32*1048576);
>
> That's a damned simple and direct implementation of exactly what I
> described, and results in something which is much more architecturally
> correct than what's going on today.

I tried this, it doesn't work.

At the time 'fixup' is called, 'meminfo' is empty; the tags haven't
been parsed. So my solution is to move the memblock_add() after
'reserve', and pass 'meminfo' as an argument:

--- a/arch/arm/mm/init.c
+++ b/arch/arm/mm/init.c
@@ -272,8 +272,6 @@ void __init arm_memblock_init(struct meminfo *mi,
struct machine_desc *mdesc)
        int i;

        memblock_init();
-       for (i = 0; i < mi->nr_banks; i++)
-               memblock_add(mi->bank[i].start, mi->bank[i].size);

        /* Register the kernel text, kernel data and initrd with memblock. */
 #ifdef CONFIG_XIP_KERNEL
@@ -295,7 +293,10 @@ void __init arm_memblock_init(struct meminfo *mi,
struct machine_desc *mdesc)

        /* reserve any platform specific memblock areas */
        if (mdesc->reserve)
-               mdesc->reserve();
+               mdesc->reserve(mi);
+
+       for (i = 0; i < mi->nr_banks; i++)
+               memblock_add(mi->bank[i].start, mi->bank[i].size);

        memblock_analyze();
        memblock_dump_all();

-- 
Felipe Contreras
