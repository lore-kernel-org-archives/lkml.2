Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754565Ab2HaQtO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 12:49:14 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:13838 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab2HaQtN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 12:49:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6820"; a="229425086"
Message-ID: <5040EAF7.9010003@codeaurora.org>
Date: Fri, 31 Aug 2012 09:48:55 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Matthieu CASTET <castet.matthieu@free.fr>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        gregkh@linuxfoundation.org, arnd@arndb.de, alan@lxorguk.ukuu.org.uk,
        Matthieu Castet <matthieu.castet@parrot.com>
Subject: Re: [PATCH v2] hvc_dcc : add support to armv4 and armv5 core
References: <1346413645-4593-1-git-send-email-castet.matthieu@free.fr>
In-Reply-To: <1346413645-4593-1-git-send-email-castet.matthieu@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/31/2012 4:47 AM, Matthieu CASTET wrote:
> Signed-off-by: Matthieu Castet <matthieu.castet@parrot.com>

Please consider adding some sort of commit text. Does this add some new
feature I may want on some downstream distro kernel?

> @@ -51,7 +51,7 @@ static inline char __dcc_getchar(void)
>  	return __c;
>  }
>  
> -static inline void __dcc_putchar(char c)
> +static inline void __dcc_putchar_v6(char c)
>  {
>  	asm volatile("mcr p14, 0, %0, c0, c5, 0	@ write a char"
>  		: /* no output register */
> @@ -59,6 +59,69 @@ static inline void __dcc_putchar(char c)
>  	isb();
>  }
>  
> +static int hvc_dcc_put_chars_v6(uint32_t vt, const char *buf, int count)
> +{
> +	int i;
> +
> +	for (i = 0; i < count; i++) {
> +		while (__dcc_getstatus_v6() & DCC_STATUS_TX_V6)
> +			cpu_relax();
> +
> +		__dcc_putchar_v6(buf[i]);
> +	}
> +
> +	return count;
> +}

It's unfortunate that the main logic is duplicated. I wonder if we could
push the runtime decision slightly lower into the accessor functions
instead and make some new functions dcc_tx_busy() and dcc_rx_busy() or
something. Then these loops stay the same.

> +
> +static int hvc_dcc_get_chars_v6(uint32_t vt, char *buf, int count)
> +{
> +	int i;
> +
> +	for (i = 0; i < count; ++i)
> +		if (__dcc_getstatus_v6() & DCC_STATUS_RX_V6)
> +			buf[i] = __dcc_getchar_v6();
> +		else
> +			break;
> +
> +	return i;
> +}
> +
> +static const struct hv_ops hvc_dcc_get_put_ops_v6 = {
> +	.get_chars = hvc_dcc_get_chars_v6,
> +	.put_chars = hvc_dcc_put_chars_v6,
> +};
> +
> +#define DCC_STATUS_RX		(1 << 0)
> +#define DCC_STATUS_TX		(1 << 1)
> +
> +/* primitive JTAG1 protocol utilities */

This comment doesn't tell me much. Remove it?

> +static inline u32 __dcc_getstatus(void)
> +{
> +	u32 ret;
> +
> +	asm __volatile__ ("mrc p14, 0, %0, c0, c0	@ read comms ctrl reg"
> +		: "=r" (ret));

Can you use volatile instead of __volatile__ so that the file is consistent?

> +
> +	return ret;
> +}
> +
> +static inline char __dcc_getchar(void)
> +{
> +	char c;
> +
> +	asm __volatile__ ("mrc p14, 0, %0, c1, c0	@ read comms data reg"
> +		: "=r" (c));
> +

Do you see any multiple character inputs? I think you may need an isb
here similar to the v6/7 code and in the putchar as well.

> +	return c;
> +}
> +
> +static inline void __dcc_putchar(unsigned char c)
> +{
> +	asm __volatile__ ("mcr p14, 0, %0, c1, c0	@ write a char"
> +		: /* no output register */
> +		: "r" (c));
> +}
> +
>  static int hvc_dcc_put_chars(uint32_t vt, const char *buf, int count)
>  {
>  	int i;
>

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

