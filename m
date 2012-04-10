Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758294Ab2DJAc1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:32:27 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39921 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab2DJAcZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:32:25 -0400
Date: Mon, 9 Apr 2012 17:32:22 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Colin Cross <ccross@google.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, werner <w.landgraf@ru.ru>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        linux-kernel@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        Rabin Vincent <rabin.vincent@stericsson.com>,
        Christian Bejram <christian.bejram@stericsson.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Subject: Re: v3.4-rc2 out-of-memory problems (was Re: 3.4-rc1
 sticks-and-crashs)
In-Reply-To: <CAMbhsRSV9Oy5n-GBjyhCtfCd=3_S9iif+qzEk0Oyy0EBC9AF6w@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1204091724590.21813@chino.kir.corp.google.com>
References: <CA+55aFwTFXtMLhXo7g9F7uyHc3W8SCw7z1gTm9jbWXM3Nqc_ZA@mail.gmail.com> <20120408195044.13ea6c8e.akpm@linux-foundation.org> <CA+55aFw7GsiZbNW84WVMUMT6C0Sw82jxaYxeaaB8qq=41Ep5Wg@mail.gmail.com> <alpine.DEB.2.00.1204090235350.14879@chino.kir.corp.google.com>
 <CA+55aFxUQJC+_aA0qnj0b-LoGfCjfFoG3HXgQ+7LND7y8dFDhw@mail.gmail.com> <alpine.DEB.2.00.1204091355280.10873@chino.kir.corp.google.com> <CAMbhsRRUNVn9_eL_obZxcZv7LqDW_8SeRApdKzDePbaW_Y4uvg@mail.gmail.com> <alpine.DEB.2.00.1204091636160.21813@chino.kir.corp.google.com>
 <CAMbhsRSV9Oy5n-GBjyhCtfCd=3_S9iif+qzEk0Oyy0EBC9AF6w@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Apr 2012, Colin Cross wrote:

> The point of the lowmem_deathpending patch was to avoid a stutter
> where the cpu would spend its time looping through the tasks due to
> repeated calls to lowmem_shrink instead of processing the kill signal
> to the selected thread.

What did you do to avoid this without CONFIG_PROFILING?

> With this patch, it will still loop through
> tasks until it finds the one that was previously killed and then
> abort.  It's possible that the improvements Anton made to the task
> loop reduce the performance impact enough that this whole mess could
> just be dropped (by reverting 1eda516, e5d7965, and 4755b72).
> 

I don't understand how calling shrink_slab() from direct reclaim or using 
drop_caches manually taking slightly longer because it has to iterate the 
tasklist to the point of the killed thread will significantly stall the 
thread from exiting.

Much more likely is the killed thread cannot exit because you've killed it 
in a lowmem situation without giving it access to memory reserves so that 
it may exit quickly as my patch does.  That has a higher liklihood of 
stalling the exit than doing for_each_process().
