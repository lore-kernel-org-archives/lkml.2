Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab2HDTN0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 15:13:26 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:45714 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753979Ab2HDTNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 15:13:25 -0400
MIME-Version: 1.0
In-Reply-To: <501D5B1C.2070600@acm.org>
References: <1341865359-18482-1-git-send-email-minyard@acm.org>
	<501D5B1C.2070600@acm.org>
Date: Sat, 4 Aug 2012 21:13:23 +0200
X-Google-Sender-Auth: Y0YwtGk6BzjDrKKZO8x53Tph0fQ
Message-ID: <CAMuHMdXubOmUynZhUzgYJCMZ5zV-Uat1EkVgED_rJZqYABUo4g@mail.gmail.com>
Subject: Re: [PATCH] CRIS: Fix I/O macros
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: minyard@acm.org
Cc: linux-kernel@vger.kernel.org, linux-cris-kernel@axis.com, starvik@axis.com,
        jesper.nilsson@axis.com, Corey Minyard <cminyard@mvista.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Corey,

On Sat, Aug 4, 2012 at 7:25 PM, Corey Minyard <tcminyard@gmail.com> wrote:
> Can we get something like this in?  It would fix a lot of build regressions.

Yes, would be nice.

I also noticed these issues, causing obscure errors like:

drivers/block/paride/bpck.c: In function 'bpck_read_regr':
drivers/block/paride/bpck.c:56:140: error: invalid operands to binary
& (have 'void *' and 'int')
drivers/block/paride/bpck.c:62:140: error: invalid operands to binary
& (have 'void *' and 'int')

and

drivers/char/ipmi/ipmi_si_intf.c: In function 'port_outw':
drivers/char/ipmi/ipmi_si_intf.c:1373:153: error: invalid operands to
binary << (have 'void *' and 'int')
drivers/char/ipmi/ipmi_si_intf.c: In function 'port_outl':
drivers/char/ipmi/ipmi_si_intf.c:1388:151: error: invalid operands to
binary << (have 'void *' and 'int')

I wanted to fix them, but due to my vacation that hasn't happen yet.
Fortunately, as I hadn't noticed your patch before ;-)

And FWIW, indeed no one ever sets a non-zero cris_iops.

Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>

> On 07/09/2012 03:22 PM, minyard@acm.org wrote:
>>
>> From: Corey Minyard <cminyard@mvista.com>
>>
>> The inb/outb macros for CRIS are broken from a number of points of
>> view, missing () around parameters and they have an unprotected if
>> statement in them.  This was breaking the compile of IPMI on CRIS
>> and thus I was being annoyed by build regressions, so I fixed them.
>>
>> Plus I don't think they would have worked at all, since the data
>> values were missing "&" and the outsl had a "3" instead of a "4"
>> for the size.  From what I can tell, this stuff is not used at all,
>> so this can't be any more broken than it was before, anyway.
>>
>> Signed-off-by: Corey Minyard <cminyard@mvista.com>
>> ---
>>   arch/cris/include/asm/io.h |   39
>> +++++++++++++++++++++++++++++++++------
>>   1 files changed, 33 insertions(+), 6 deletions(-)
>>
>> diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
>> index 32567bc..ac12ae2 100644
>> --- a/arch/cris/include/asm/io.h
>> +++ b/arch/cris/include/asm/io.h
>> @@ -133,12 +133,39 @@ static inline void writel(unsigned int b, volatile
>> void __iomem *addr)
>>   #define insb(port,addr,count) (cris_iops ?
>> cris_iops->read_io(port,addr,1,count) : 0)
>>   #define insw(port,addr,count) (cris_iops ?
>> cris_iops->read_io(port,addr,2,count) : 0)
>>   #define insl(port,addr,count) (cris_iops ?
>> cris_iops->read_io(port,addr,4,count) : 0)
>> -#define outb(data,port) if (cris_iops)
>> cris_iops->write_io(port,(void*)(unsigned)data,1,1)
>> -#define outw(data,port) if (cris_iops)
>> cris_iops->write_io(port,(void*)(unsigned)data,2,1)
>> -#define outl(data,port) if (cris_iops)
>> cris_iops->write_io(port,(void*)(unsigned)data,4,1)
>> -#define outsb(port,addr,count) if(cris_iops)
>> cris_iops->write_io(port,(void*)addr,1,count)
>> -#define outsw(port,addr,count) if(cris_iops)
>> cris_iops->write_io(port,(void*)addr,2,count)
>> -#define outsl(port,addr,count) if(cris_iops)
>> cris_iops->write_io(port,(void*)addr,3,count)
>> +static inline void outb(unsigned char data, unsigned int port)
>> +{
>> +       if (cris_iops)
>> +               cris_iops->write_io(port, (void *) &data, 1, 1);
>> +}
>> +static inline void outw(unsigned short data, unsigned int port)
>> +{
>> +       if (cris_iops)
>> +               cris_iops->write_io(port, (void *) &data, 2, 1);
>> +}
>> +static inline void outl(unsigned int data, unsigned int port)
>> +{
>> +       if (cris_iops)
>> +               cris_iops->write_io(port, (void *) &data, 4, 1);
>> +}
>> +static inline void outsb(unsigned int port, const void *addr,
>> +                        unsigned long count)
>> +{
>> +       if (cris_iops)
>> +               cris_iops->write_io(port, (void *)addr, 1, count);
>> +}
>> +static inline void outsw(unsigned int port, const void *addr,
>> +                        unsigned long count)
>> +{
>> +       if (cris_iops)
>> +               cris_iops->write_io(port, (void *)addr, 2, count);
>> +}
>> +static inline void outsl(unsigned int port, const void *addr,
>> +                        unsigned long count)
>> +{
>> +       if (cris_iops)
>> +               cris_iops->write_io(port, (void *)addr, 4, count);
>> +}
>>     /*
>>    * Convert a physical pointer to a virtual kernel pointer for /dev/mem

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
