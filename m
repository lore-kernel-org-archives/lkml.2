Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830Ab2CZBDN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Mar 2012 21:03:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58850 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752555Ab2CZBDI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Mar 2012 21:03:08 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.7.4
Message-ID: <4F6FBFEA.3070204@jp.fujitsu.com>
Date: Mon, 26 Mar 2012 10:01:30 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows NT 6.0; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Ulrich Drepper <drepper@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: seq_put_decimal_* optimization
References: <CAOPLpQcu3DTLHYnfbX0_k1M4=Yw2LSFEB6K4nEGavve1mWDsSg@mail.gmail.com>
In-Reply-To: <CAOPLpQcu3DTLHYnfbX0_k1M4=Yw2LSFEB6K4nEGavve1mWDsSg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2012/03/24 21:52), Ulrich Drepper wrote:

> If we want to squeeze out the last drop of slack from the /proc text
> generation, shouldn't we then avoid code like
> 
> +       seq_put_decimal_ull(m, ' ', 0);
> 
> which is worse than what was there before? I realize that the code
> actually becomes more readable like this.  So how about automatically
> optimizing the code by adding something like the following to
> seq_file.h:
> 
> #define seq_put_decimal_ull(m, delimiter, num) \
>   (__builtin_constant_p(num) && \
>    __builtin_constant_p(delimiter) && (delimiter) == ' ' \
>    ? seq_write(m, " " #num, sizeof(" " #num) - 1) \
>    : seq_put_decimal_ull(m, delimiter, num))
> 
> Completely untested and it is a minimal change.  It could be written
> using an inline function and probably made more general that way
> (e.g., handle more delimiters).  But this code should handle the case
> that exist today and lead to a (very small) improvement without any
> real costs to maintenance.
> 

Could you wait a while ?

I'm now considering to add a binary interface /proc/stat.bin and
I would like to use seq_put_decimal_ull() as..
==
int seq_put_decimal_ull(struct seq_file *m, int delimiter, unsigned long long num)
{
	if (m->binstream_format)
		return seq_binstream_attend(num, sizeof(num));
	.....
}
==
Then, we can maintain /proc/stat and /proc/stat.bin in one function
fs/proc/stat.c::show_stat().
Maybe good for applications like top and sa..

Thanks,
-Kame
















