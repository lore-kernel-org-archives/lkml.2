Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756731Ab2GCPdx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 11:33:53 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:48708 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753616Ab2GCPdw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:33:52 -0400
Message-ID: <1341329631.2164.15.camel@joe2Laptop>
Subject: Re: [RFC][PATCHv2 2/3] lib: printf: append support of '%*p[Mm][FR]'
From: Joe Perches <joe@perches.com>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, proski@gnu.org,
        Andrei Emeltchenko <andrei.emeltchenko@intel.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Date: Tue, 03 Jul 2012 08:33:51 -0700
In-Reply-To: <1341310000-4082-2-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1341264199.10162.2.camel@joe2Laptop>
	 <1341310000-4082-1-git-send-email-andriy.shevchenko@linux.intel.com>
	 <1341310000-4082-2-git-send-email-andriy.shevchenko@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-03 at 13:06 +0300, Andy Shevchenko wrote:
> There are many places in the kernel where the drivers print small buffers as a
> hex string. This patch adds a support of the variable width buffer to print it
> as a hex string with a delimiter. The idea came from Pavel Roskin here:
> http://www.digipedia.pl/usenet/thread/18835/17449/
> 
> Sample output of
> 	pr_info("buf[%d:%d] %*pM\n", from, len, len, &buf[from]);
> could be look like this:
> 	[ 0.726130] buf[51:8] e8:16:b6:ef:e3:74:45:6e
> 	[ 0.750736] buf[59:15] 31:81:b8:3f:35:49:06:ae:df:32:06:05:4a:af:55
> 	[ 0.757602] buf[17:5] ac:16:d5:2c:ef

Hi Andy.

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -655,12 +655,13 @@ char *resource_string(char *buf, char *end, struct resource *res,
[]
> +char *hex_string(char *buf, char *end, u8 *addr, struct printf_spec spec,
> +		 const char *fmt)
[]
> @@ -678,18 +679,31 @@ char *mac_address_string(char *buf, char *end, u8 *addr,
[]
> +	while (i < len) {

Oh good, a while loop, thanks.

[]

> @@ -947,6 +961,9 @@ int kptr_restrict __read_mostly;
>   * - 'MF' For a 6-byte MAC FDDI address, it prints the address
>   *       with a dash-separated hex notation
>   * - '[mM]R For a 6-byte MAC address, Reverse order (Bluetooth)
> + *       Optional usage is %*p[Mn][FR] with variable length to print. It
> + *       supports up to 64 bytes of the input. Consider to use print_hex_dump()
> + *       for the larger input.

It might be more sensible to use new, distinct
"%*pH" and "%*ph" functions and not touch the
mac address function at all.  Will anyone ever
really want to emit the buffer in reverse?
I don't think so.

Perhaps when using a hex_string_buffer func the
separator should be a space/no-space with %*pHh.

You could extend the max to 128 or larger now.


