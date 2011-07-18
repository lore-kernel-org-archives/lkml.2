Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756556Ab1GRLlY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 07:41:24 -0400
Received: from www262.sakura.ne.jp ([202.181.97.72]:64092 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751128Ab1GRLlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 07:41:23 -0400
X-Nat-Received: from [202.181.97.72]:60505 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1310989278.7746
To: andriy.shevchenko@linux.intel.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: can: remove custom hex_to_bin()
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1310977597-9666-1-git-send-email-andriy.shevchenko@linux.intel.com>
In-Reply-To: <1310977597-9666-1-git-send-email-andriy.shevchenko@linux.intel.com>
Message-Id: <201107182041.EHB78622.VOFSHFMOOFtLJQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 18 Jul 2011 20:41:14 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE, bases: 17072011 #5619247, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Shevchenko wrote:
>  	for (i = 0, dlc_pos++; i < cf.can_dlc; i++) {
> -
> -		tmp = asc2nibble(sl->rbuff[dlc_pos++]);
> -		if (tmp > 0x0F)
> +		tmp = hex_to_bin(sl->rbuff[dlc_pos++]);
> +		if (tmp < 0)
>  			return;
>  		cf.data[i] = (tmp << 4);
> -		tmp = asc2nibble(sl->rbuff[dlc_pos++]);
> -		if (tmp > 0x0F)
> +		tmp = hex_to_bin(sl->rbuff[dlc_pos++]);
> +		if (tmp < 0)
>  			return;
>  		cf.data[i] |= tmp;
>  	}

What about changing

  void hex2bin(u8 *dst, const char *src, size_t count)

to

  bool hex2bin(u8 *dst, const char *src, size_t count)

in order to do error checks like

bool hex2bin_with_validation(u8 *dst, const char *src, size_t count)
{
	while (count--) {
		int c = hex_to_bin(*src++);
		int d;
		if (c < 0)
			return false;
		d = hex_to_bin(*src++)
		if (d < 0)
			return false;
		*dst++ = (c << 4) | d;
	}
	return true;
}

and use hex2bin() rather than hex_to_bin()?
