Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133Ab0IXNMw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 09:12:52 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:55692 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab0IXNMu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 09:12:50 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Vernon Mauery <vernux@us.ibm.com>
Subject: Re: [RFC][Patch] IBM Real-Time "SMI Free" mode driver -v4
Date: Fri, 24 Sep 2010 15:12:39 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>
References: <20100921224610.GO13162@lucy> <20100923221253.GA4960@lucy> <20100923225346.GB4960@lucy>
In-Reply-To: <20100923225346.GB4960@lucy>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009241512.39311.arnd@arndb.de>
X-Provags-ID: V02:K0:vsMTu9Pzl6VbrvMTI3RFxUsDnlKcD/CdamUyci8Ofr/
 zuoT3n1cNsH9oGMWUTLrfyT0gYxFxZZj/ObRWngHs4UQajoq/Q
 I/DcFjeQMFNSps9jRXfvFRTJerHzPaZFvWTTxO03cH0rWMGEB4
 bcsoJlbtu5gJQekoAgiq8AEj0Zey8DtxikuO4gVlfNZB9mPvSu
 Wl8qvGHBi2pppmFRLgs2g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 September 2010, Vernon Mauery wrote:
> +enum rtl_addr_type {
> +	RTL_ADDR_TYPE_IO = 1,
> +	RTL_ADDR_TYPE_MMIO,
> +} __attribute__((packed));
> +
> +enum rtl_cmd_type {
> +	RTL_CMD_NOP = 0,
> +	RTL_CMD_ENTER_PRTM,
> +	RTL_CMD_EXIT_PRTM,
> +} __attribute__((packed));

You didn't reply to Randy's comment about the packed attribute.
I think it's rather confusing here.

> +/* The RTL table as presented by the EBDA: */
> +struct ibm_rtl_table {
> +	char signature[5];
> +	u8 version;
> +	u8 rt_status;
> +	enum rtl_cmd_type command;
> +	u8 command_status;
> +	enum rtl_addr_type cmd_address_type;
> +	u8 cmd_granularity;
> +	u8 cmd_offset;
> +	u16 reserve1;
> +	u8 cmd_port_address[4]; /* platform dependent address */
> +	u8 cmd_port_value[4];   /* platform dependent value */
> +};

I would recommend marking the member in this structure as packed instead,
not the enum.

> +#define RTL_SIGNATURE (('L'<<24)|('T'<<16)|('R'<<8)|'_')
> +
> +#define ERROR(A, B...) printk(KERN_ERR "ibm-rtl: " A, ##B )
> +#define WARNING(A, B...) printk(KERN_WARNING "ibm-rtl: " A, ##B )
> +#define DEBUG(A, B...) do { \
> +	if (debug) \
> +		printk(KERN_INFO "ibm-rtl: " A, ##B ); \
> +} while (0)

We already have wrappers for these, no need to define your own.
Please just use dev_{err,warn,dbg} or pr_{err,warning,debug}.

> +static DEFINE_MUTEX(rtl_lock);
> +static struct ibm_rtl_table __iomem *rtl_table = NULL;
> +static void __iomem *ebda_map;
> +static void __iomem *rtl_cmd_iomem_addr = NULL;
> +static u32 rtl_cmd_port_addr;
> +static enum rtl_addr_type rtl_cmd_type;
> +static u8 rtl_cmd_width;

This is somewhat inconsistent, some of these are implicitly initialized,
others have an explicit "= NULL". I would recommend leaving out the
initialization, which is the historic way to do this in the kernel.

Some people find it cleaner to define a structure containing all the
driver specific data. Since there can be only one of these devices
in your case, it's probably not important.

> +			if (rtl_cmd_type == RTL_ADDR_TYPE_MMIO)
> +				iowrite8((u8)cmd_port_val, rtl_cmd_iomem_addr);
> +			else
> +				outb((u8)cmd_port_val, rtl_cmd_port_addr);

ioread/iowrite already has the capability to use both mmio and pio
addresses. You can use ioport_map() to create an __iomem token that
corresponds to your rtl_cmd_port_addr and get rid of the rtl_cmd_type
variable.

	Arnd
