Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755340Ab2EZA2x (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 20:28:53 -0400
Received: from nm29.bullet.mail.ne1.yahoo.com ([98.138.90.92]:22117 "HELO
	nm29.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753303Ab2EZA2v convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 20:28:51 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 167206.34241.bm@omp1003.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=rrXHX3gtcr3ZrKoTqKjEhqhO6E6uVyhtPkU6Rdm9WbHWminTmzDco1cyns1oau5O2kZAezdEhZG79dkHgKPg7AVRAaOUUBpilzkdXWoW98nzYGCUQYFLAd9wOMU4Qn6X54JEx9fZ5XthWVEe99Vy6sUig07zo8Plv5tgBxF7zek=;
X-YMail-OSG: _FcouQ4VM1lGrmZ8bbS2f6uiKPVCVe5Un9iMKt_zAOe60dX
 jlcrjzLxsmoINLYExP_Bruy3XOlS7Z.D5DacTEZhZEFm7Th5.XhKBprjA.Fl
 xGAnsz0POMJqKfVCZP9vRY8vB4uNz6HBri1YlfKalVQlO9IObaahQ0wYaO.5
 lKmQwP1ftEeCk8awzMSpspUoE6_h2vZt_USn7Q.aq9Pl9BDP36LtXPt7akz5
 .TzszviEOXZBDqWethuEAeNipMhdFhiOMow5Up7TRJhyMX2y_WDUWCUsWq26
 Ebpc31hxRYoQgNgZj67hCRC11gobhCOauAaahKquU_5RytJU5FAOMwG6Rh0R
 IG0CP5UdxCwUIoggDsFquo2lmq4vNiEJCbWhqKhatZ2D3PriBEQZa4bkd.Q3
 hFU4LfRU6N.mSV_iSGYlMG4K6vu4-
X-Mailer: YahooMailWebService/0.8.118.349524
References: <1337406674.48432.YahooMailNeo@web121303.mail.ne1.yahoo.com> <alpine.LSU.2.00.1205191301430.10539@eggly.anvils>
Message-ID: <1337992130.90506.YahooMailNeo@web121305.mail.ne1.yahoo.com>
Date: Fri, 25 May 2012 17:28:50 -0700 (PDT)
From: Sam Portolla <samportolla@yahoo.com>
Reply-To: Sam Portolla <samportolla@yahoo.com>
Subject: Re: exit_mmap BUG_ON in 2.6.23 (and Add qdisc __NET_XMIT_STOLEN) 
To: Hugh Dickins <hughd@google.com>, "kaber@trash.net" <kaber@trash.net>,
        "jarkao2@gmail.com" <jarkao2@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "samPortolla@yahoo.com" <samPortolla@yahoo.com>
In-Reply-To: <alpine.LSU.2.00.1205191301430.10539@eggly.anvils>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



[pease cc samPortolla@yahoo.com on the replies; not a member of this mailer]

Hi Hugh,

Thank you!  It turns out our 2.6.23 kernel does not have this old patch, I am also adding Jarek, David and Patrick who were involved in the below fix for their insights:


commit 378a2f090f7a478704a372a4869b8a9ac206234e
Date:   Mon Aug 4 22:31:03 2008 -0700
net_sched: Add qdisc __NET_XMIT_STOLEN flag
In this failure case below, as well as some others, the ethernet driver printed a transmit timeout just before the crash.

It seems since we don't have the above patch, the kernel qdisc Tx packet path for fragmented packets can be messed up and corrupt the skb  it passes to drivers, which in the historic case that led to above fix, caused an skb NULL ptr de-ref in the driver itself (which we also saw once). 

Jarek, David or Patrick,

Could the lack of above patch cause the kernel to also falsely detect transmit timeouts on various drivers as it can not properly keep track of packets transmitted? Can you please elaborate so  a newbie like me can understand?

Is the above commit the sole one required for the kernel panic/skb NULL de-ref driver issue or is there more needed fixes later on that can be backported to an older kernel (2.6.23 GNU/Linux x86_64)?


Hugh, 

 I wonder if the lack of above patch in our code base could explain the exit_mmap() BUG_ON as well due to memory corruption causing MMU to not be able to locate the page(s) it had to free. NR_PTES keeps track of that? Could you explain that more?



Thank you ALL

----- Original Message -----
From: Hugh Dickins <hughd@google.com>
To: Sam Portolla <samportolla@yahoo.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>; "aarcange@redhat.com" <aarcange@redhat.com>
Sent: Saturday, May 19, 2012 1:45 PM
Subject: Re: exit_mmap BUG_ON in 2.6.23

On Fri, 18 May 2012, Sam Portolla wrote:
> [please cc samPortolla@yahoo.com on your replies, not subscribed to the linux-kernel mailer]
> 
> Hi, I have read the thread on same issue in 3.1:
> but this is happening on earlier GNU linux version 2.6.23 for x86_64,
> which does not have THP (I believe), nor it has huge_memory.c.
> Is there a fix one of you experts could supply?  Issue is not reproducible
> so far, but happened on a customer site. Some info below.
> 
> kernel BUG at .../bfc/linux/kernel-2.6.x/mm/mmap.c:2049!
> 
> Line 2049 is in exit_mmap():
> 
> BUG_ON(mm->nr_ptes > (FIRST_USER_ADDRESS+PMD_SIZE-1)>>PMD_SHIFT);
> 
>  RIP: 0010:[<ffffffff80277840>]  [<ffffffff80277840>] exit_mmap+0xf0/0x100 
> [snip]
>  Call Trace:
>  [<ffffffff8022ee14>] mmput+0x44/0xd0
>  [<ffffffff802340a1>] exit_mm+0x91/0x100
>  [<ffffffff802347ea>] do_exit+0x17a/0x960
>  [<ffffffff8023c4bc>] __dequeue_signal+0xec/0x1b0
>  [<ffffffff80235048>] do_group_exit+0x38/0x90
>  [<ffffffff8023e3c6>] get_signal_to_deliver+0x2d6/0x4b0
>  [<ffffffff8020b69a>] do_notify_resume+0xaa/0x760
>  [<ffffffff8020c818>] retint_signal+0x3d/0x85

I've checked back through old ChangeLogs, and (apart from a UserModeLinux
case) I don't see any fix for a BUG_ON(nr_ptes) issue in between 2.6.19
and the much later THP issue, which you're right to think cannot be yours.

But the 2.6.19 case, and one which a video driver writer had more recently,
were both caused by unrelated code zeroing beyond what it had allocated:
happening to zero part of a higher-level page table, making it impossible
for task exit to locate all the page tables (and pages) it had to free.

Though I can't be sure, these BUG_ON(nr_ptes) reports do seem perhaps
too infrequent to be caused by bad logic in mm itself: I suspect memory
corruption in your case too.

There's no clue here as to what the cause might be, I'm afraid.
Rebuilding your kernel with CONFIG_DEBUG_PAGEALLOC=y, and slab debugging
on, might shed more light: but that's probably not something you want to
get into on a customer site, for a problem only seen once or twice.

The best I can suggest is for you to change that BUG_ON to a WARN_ON,
so at least the kernel doesn't crash there, and you might gather more
information from each time it happens; but you'll probably leak pages,
and may very well crash soon for other reasons (e.g. when evicting an
inode cannot locate all the maps of its pages).

Hugh 
