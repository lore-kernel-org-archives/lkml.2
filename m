Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761818Ab2FEKsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 06:48:37 -0400
Received: from smtp-01.mandic.com.br ([200.225.81.132]:38074 "EHLO
	smtp-01.mandic.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761786Ab2FEKsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 06:48:35 -0400
X-Greylist: delayed 399 seconds by postgrey-1.27 at vger.kernel.org; Tue, 05 Jun 2012 06:48:35 EDT
Message-ID: <4FCDE270.1020906@cesarb.net>
Date: Tue, 05 Jun 2012 07:41:52 -0300
From: Cesar Eduardo Barros <cesarb@cesarb.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org
Subject: frontswap: is frontswap_init called from swapoff safe?
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I was looking at the swapfile.c parts of the recently-merged frontswap, 
and noticed that frontswap_init can be called from swapoff when 
try_to_unuse fails.

This looks odd to me. Whether it is safe or not depends on what 
frontswap_ops.init does, but the comment for __frontswap_init ("Called 
when a swap device is swapon'd") and the function name itself seem to 
imply it should be called only for swapon, not when relinking the 
swap_info after a failed swapoff.

In particular, if frontswap_ops.init assumes the swap map is empty, it 
would break, since as far as I know when try_to_unuse fails there are 
still pages in the swap.

(By the way, the comment above enable_swap_info at sys_swapoff needs to 
be updated to also explain why reading p->frontswap_map outside the lock 
is safe at that point, like it does for p->prio and p->swap_map.)

-- 
Cesar Eduardo Barros
cesarb@cesarb.net
cesar.barros@gmail.com
