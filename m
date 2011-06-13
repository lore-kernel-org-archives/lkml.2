Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755073Ab1FMWMa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 18:12:30 -0400
Received: from mail.perches.com ([173.55.12.10]:2868 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755053Ab1FMWM3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 18:12:29 -0400
Subject: Re: [PATCH 2/3] usbip: dump the port status difference
From: Joe Perches <joe@perches.com>
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Matt Mooney <mfm@muteddisk.com>,
        Max Vozeler <max@hinterhof.net>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        usbip-devel@lists.sourceforge.net, devel@driverdev.osuosl.org,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <4DF68159.1090206@freemail.hu>
References: <4DF68159.1090206@freemail.hu>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 13 Jun 2011 15:12:26 -0700
Message-ID: <1308003146.26699.43.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-06-13 at 23:30 +0200, Németh Márton wrote:
> From: Márton Németh <nm127@freemail.hu>
> 
> Change the dump function to
> really show the differences in the status bit changes
> +static void dump_port_status_diff(u32 prev_status, u32 new_status)
>  {
>  	int i = 0;

> -	pr_debug("status %08x:", status);
> +	pr_debug("status %08x -> %08x:", prev_status, new_status);
>  	for (i = 0; i < 32; i++) {
> -		if (status & (1 << i))
> -			pr_debug(" %s", bit_desc[i]);
> +		if (!(prev_status & (1 << i)) &&
> +		      new_status & (1 << i)) {
> +			pr_debug(" +%s", bit_desc[i]);
> +		} else if (prev_status & (1 << i) &&
> +			   !(new_status & (1 << i))) {
> +			pr_debug(" -%s", bit_desc[i]);
> +		} else if (prev_status & (1 << i) &&
> +			   new_status & (1 << i)) {
> +			pr_debug("  %s", bit_desc[i]);
> +		}
>  	}
>  	pr_debug("\n");

trivia:

I think the output isn't quite what you might expect.
It could be interleaved by pr_cont from a different
thread. 

I think this might be a bit more readable as below and
this doesn't use implicit newlines by successive pr_<level>.

static void dump_port_status_diff(u32 old_status, u32 new_status)
{
	int i = 0;
	u32 bit = 1;

	char change;
	pr_debug("status old->new %08x -> %08x\n", old_status, new_status);
	while (bit) {
		u32 old = old_status & bit;
		u32 new = new_status & bit;
		char change;

		if (!old && new)
			change = '+';
		else if (old && !new)
			change = '-';
		else
			change = ' ';
		if (old || new)
			pr_debug(" %c%s\n", change, bit_desc[i]);
		bit <<= 1;
		i++;
  	}
}

I don't know if this is in any sort of fast-path or if
gcc will completely optimize this completely away if
pr_debug isn't declared, but maybe surround the function
implementation with

static void dump_port_status_diff(u32 prev_status, u32 new_status)
{
#ifdef DEBUG
	...
#endif
}


