Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754027Ab2HDRZz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 13:25:55 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34917 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753690Ab2HDRZw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 13:25:52 -0400
Message-ID: <501D5B1C.2070600@acm.org>
Date: Sat, 04 Aug 2012 12:25:48 -0500
From: Corey Minyard <tcminyard@gmail.com>
Reply-To: minyard@acm.org
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-cris-kernel@axis.com, starvik@axis.com,
        jesper.nilsson@axis.com
CC: Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH] CRIS: Fix I/O macros
References: <1341865359-18482-1-git-send-email-minyard@acm.org>
In-Reply-To: <1341865359-18482-1-git-send-email-minyard@acm.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can we get something like this in?  It would fix a lot of build regressions.

-corey

On 07/09/2012 03:22 PM, minyard@acm.org wrote:
> From: Corey Minyard <cminyard@mvista.com>
>
> The inb/outb macros for CRIS are broken from a number of points of
> view, missing () around parameters and they have an unprotected if
> statement in them.  This was breaking the compile of IPMI on CRIS
> and thus I was being annoyed by build regressions, so I fixed them.
>
> Plus I don't think they would have worked at all, since the data
> values were missing "&" and the outsl had a "3" instead of a "4"
> for the size.  From what I can tell, this stuff is not used at all,
> so this can't be any more broken than it was before, anyway.
>
> Signed-off-by: Corey Minyard <cminyard@mvista.com>
> ---
>   arch/cris/include/asm/io.h |   39 +++++++++++++++++++++++++++++++++------
>   1 files changed, 33 insertions(+), 6 deletions(-)
>
> diff --git a/arch/cris/include/asm/io.h b/arch/cris/include/asm/io.h
> index 32567bc..ac12ae2 100644
> --- a/arch/cris/include/asm/io.h
> +++ b/arch/cris/include/asm/io.h
> @@ -133,12 +133,39 @@ static inline void writel(unsigned int b, volatile void __iomem *addr)
>   #define insb(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,1,count) : 0)
>   #define insw(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,2,count) : 0)
>   #define insl(port,addr,count) (cris_iops ? cris_iops->read_io(port,addr,4,count) : 0)
> -#define outb(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,1,1)
> -#define outw(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,2,1)
> -#define outl(data,port) if (cris_iops) cris_iops->write_io(port,(void*)(unsigned)data,4,1)
> -#define outsb(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,1,count)
> -#define outsw(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,2,count)
> -#define outsl(port,addr,count) if(cris_iops) cris_iops->write_io(port,(void*)addr,3,count)
> +static inline void outb(unsigned char data, unsigned int port)
> +{
> +	if (cris_iops)
> +		cris_iops->write_io(port, (void *) &data, 1, 1);
> +}
> +static inline void outw(unsigned short data, unsigned int port)
> +{
> +	if (cris_iops)
> +		cris_iops->write_io(port, (void *) &data, 2, 1);
> +}
> +static inline void outl(unsigned int data, unsigned int port)
> +{
> +	if (cris_iops)
> +		cris_iops->write_io(port, (void *) &data, 4, 1);
> +}
> +static inline void outsb(unsigned int port, const void *addr,
> +			 unsigned long count)
> +{
> +	if (cris_iops)
> +		cris_iops->write_io(port, (void *)addr, 1, count);
> +}
> +static inline void outsw(unsigned int port, const void *addr,
> +			 unsigned long count)
> +{
> +	if (cris_iops)
> +		cris_iops->write_io(port, (void *)addr, 2, count);
> +}
> +static inline void outsl(unsigned int port, const void *addr,
> +			 unsigned long count)
> +{
> +	if (cris_iops)
> +		cris_iops->write_io(port, (void *)addr, 4, count);
> +}
>   
>   /*
>    * Convert a physical pointer to a virtual kernel pointer for /dev/mem

