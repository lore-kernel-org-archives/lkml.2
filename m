Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932275Ab0IXOO3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 10:14:29 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33686 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168Ab0IXOO1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 10:14:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=AZr9KNlECj4da68a/T1wyibaPoLJ1F1Slftux7n9jIMe+H4CbS2vZ62UeqS/j9vc/X
         cOS3FXz+TdnRunerHosVQcy74qp6uYnSXI398tU4bg3VIb3f8G5kHU+j7D93xSZifeQX
         hwn3mTwWSuH9riPNU47leovxf6QfGLGkEkWmw=
MIME-Version: 1.0
In-Reply-To: <201009241512.39311.arnd@arndb.de>
References: <20100921224610.GO13162@lucy>
	<20100923221253.GA4960@lucy>
	<20100923225346.GB4960@lucy>
	<201009241512.39311.arnd@arndb.de>
Date: Fri, 24 Sep 2010 07:14:27 -0700
X-Google-Sender-Auth: 6SGniv_Y2xzX_T1eC83jCWE5dpc
Message-ID: <AANLkTimMWAk22gSn2cXA25VNJ1o3OX-mazJfFFd_+MH2@mail.gmail.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver -v4
From: Vernon Mauery <vernux@us.ibm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 24, 2010 at 6:12 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Friday 24 September 2010, Vernon Mauery wrote:
>> +enum rtl_addr_type {
>> +     RTL_ADDR_TYPE_IO = 1,
>> +     RTL_ADDR_TYPE_MMIO,
>> +} __attribute__((packed));
>> +
>> +enum rtl_cmd_type {
>> +     RTL_CMD_NOP = 0,
>> +     RTL_CMD_ENTER_PRTM,
>> +     RTL_CMD_EXIT_PRTM,
>> +} __attribute__((packed));
>
> You didn't reply to Randy's comment about the packed attribute.
> I think it's rather confusing here.

Sorry.  I missed that comment.  The packed attribute on an enum forces
it into the smallest int type it can be.  enums are normally the size
of an int, but this enum in the RTL table must fit in an 8-bit int.

>> +/* The RTL table as presented by the EBDA: */
>> +struct ibm_rtl_table {
>> +     char signature[5];
>> +     u8 version;
>> +     u8 rt_status;
>> +     enum rtl_cmd_type command;
>> +     u8 command_status;
>> +     enum rtl_addr_type cmd_address_type;
>> +     u8 cmd_granularity;
>> +     u8 cmd_offset;
>> +     u16 reserve1;
>> +     u8 cmd_port_address[4]; /* platform dependent address */
>> +     u8 cmd_port_value[4];   /* platform dependent value */
>> +};
>
> I would recommend marking the member in this structure as packed instead,
> not the enum.

It does not have the same effect.  Without the packed attribute on the
enums, they end up to be the wrong size and then we would be reading
from the wrong location in memory.

>> +#define RTL_SIGNATURE (('L'<<24)|('T'<<16)|('R'<<8)|'_')
>> +
>> +#define ERROR(A, B...) printk(KERN_ERR "ibm-rtl: " A, ##B )
>> +#define WARNING(A, B...) printk(KERN_WARNING "ibm-rtl: " A, ##B )
>> +#define DEBUG(A, B...) do { \
>> +     if (debug) \
>> +             printk(KERN_INFO "ibm-rtl: " A, ##B ); \
>> +} while (0)
>
> We already have wrappers for these, no need to define your own.
> Please just use dev_{err,warn,dbg} or pr_{err,warning,debug}.

Ack.

>> +static DEFINE_MUTEX(rtl_lock);
>> +static struct ibm_rtl_table __iomem *rtl_table = NULL;
>> +static void __iomem *ebda_map;
>> +static void __iomem *rtl_cmd_iomem_addr = NULL;
>> +static u32 rtl_cmd_port_addr;
>> +static enum rtl_addr_type rtl_cmd_type;
>> +static u8 rtl_cmd_width;
>
> This is somewhat inconsistent, some of these are implicitly initialized,
> others have an explicit "= NULL". I would recommend leaving out the
> initialization, which is the historic way to do this in the kernel.

The variables that have an explicit initialization are the variables
that I read before I write.  It just looks funny to me to read a
variable that hasn't been initialized.  But I can axe the
initializations for the sake of consistency.

> Some people find it cleaner to define a structure containing all the
> driver specific data. Since there can be only one of these devices
> in your case, it's probably not important.
>
>> +                     if (rtl_cmd_type == RTL_ADDR_TYPE_MMIO)
>> +                             iowrite8((u8)cmd_port_val, rtl_cmd_iomem_addr);
>> +                     else
>> +                             outb((u8)cmd_port_val, rtl_cmd_port_addr);
>
> ioread/iowrite already has the capability to use both mmio and pio
> addresses. You can use ioport_map() to create an __iomem token that
> corresponds to your rtl_cmd_port_addr and get rid of the rtl_cmd_type
> variable.

Thank you for that tip.  I will look into it and roll out another version.

--Vernon

>        Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
