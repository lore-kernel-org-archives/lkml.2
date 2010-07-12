Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755637Ab0GLC04 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 22:26:56 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17370 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755203Ab0GLC0y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 22:26:54 -0400
Message-ID: <4C3A7D24.1050008@oracle.com>
Date: Sun, 11 Jul 2010 19:25:40 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
Organization: Oracle Linux Engineering
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091209 Fedora/3.0-3.fc11 Thunderbird/3.0
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Samium Gromoff <_deepfire@feelingofgreen.ru>, Greg KH <greg@kroah.com>
Subject: Re: [PATCH -mmotm] 8250_early: fix printk format warnings
References: <201007011948.o61JmnT2022795@imap1.linux-foundation.org> <20100702182437.977c8ef8.randy.dunlap@oracle.com> <20100709144148.3D25.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100709144148.3D25.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090203.4C3A7D60.01F2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/08/10 22:47, KOSAKI Motohiro wrote:
>> From: Randy Dunlap <randy.dunlap@oracle.com>
>>
>> Fix printk format warnings in serial-mmio32-support-for-8250_earlyc.patch:
>>
>> drivers/serial/8250_early.c:207: warning: format '%p' expects type 'void *', but argument 3 has type 'long long unsigned int'
>> drivers/serial/8250_early.c:210: warning: format '%p' expects type 'void *', but argument 2 has type 'long long unsigned int'
>>
>> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
>> Cc: Samium Gromoff <_deepfire@feelingofgreen.ru>
>> Cc: Greg KH <greg@kroah.com>
>> ---
>>  drivers/serial/8250_early.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>
>> --- mmotm-2010-0701-1219.orig/drivers/serial/8250_early.c
>> +++ mmotm-2010-0701-1219/drivers/serial/8250_early.c
>> @@ -202,12 +202,12 @@ static int __init parse_options(struct e
>>  	}
>>  
>>  	if (mmio || mmio32)
>> -		printk(KERN_INFO "Early serial console at MMIO%s 0x%p (options '%s')\n",
>> +		printk(KERN_INFO "Early serial console at MMIO%s 0x%llu (options '%s')\n",
>>  		       mmio32 ? "32" : "", (unsigned long long) port->mapbase,
>>  		       device->options);
>>  	else
>>  		printk(KERN_INFO "Early serial console at I/O port 0x%pr (options '%s')\n",
>> -		       (unsigned long long) port->iobase, device->options);
>> +		       (void *) port->iobase, device->options);

so why was this one using "%pr" at all?

> 
> seems still odd.
> 
> %pr don't mean bare pointer. it want resource. another %pr use case is here.

%p<X> still wants some pointer, not an (unsigned long long).
Yes, %pr should be giving a struct resource * instead of a void *.


> 
> drivers/pnp/resoruce.c
> ======================================================================
> struct pnp_resource *pnp_add_dma_resource(struct pnp_dev *dev, int dma,
>                                           int flags)
> {
>         struct pnp_resource *pnp_res;
>         struct resource *res;
> (snip)
>         pnp_dbg(&dev->dev, "  add %pr\n", res);
> ======================================================================
> 
> and port->iobase is merely unsingned long.
> I guess following change or something like are necessary.
> 
> -               printk(KERN_INFO "Early serial console at I/O port 0x%pr (options '%s')\n",
> -                      (unsigned long long) port->iobase, device->options);
> +               printk(KERN_INFO "Early serial console at I/O port %lu (options '%s')\n",
> +                      port->iobase, device->options);

Yes, that works too.  Thanks.

-- 
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
