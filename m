Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab1FILiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:38:16 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58739 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753970Ab1FILiM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:38:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4DF0B097.7010805@jp.fujitsu.com>
Date: Thu, 09 Jun 2011 20:37:59 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; ja; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: vnagarnaik@google.com
CC: kosaki.motohiro@jp.fujitsu.com, rostedt@goodmis.org, mingo@redhat.com,
        fweisbec@gmail.com, mrubin@google.com, dhsharp@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] trace: Set __GFP_NORETRY flag for ring buffer allocating
 process
References: <1307490088-8612-1-git-send-email-vnagarnaik@google.com> <1307491302-9236-1-git-send-email-vnagarnaik@google.com>
In-Reply-To: <1307491302-9236-1-git-send-email-vnagarnaik@google.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2011/06/08 9:01), Vaibhav Nagarnaik wrote:
> The tracing ring buffer is allocated from kernel memory. While
> allocating a large chunk of memory, OOM might happen which destabilizes
> the system. Thus random processes might get killed during the
> allocation.
> 
> This patch adds __GFP_NORETRY flag to the ring buffer allocation calls
> to make it fail more gracefully if the system will not be able to
> complete the allocation request.
> 
> Signed-off-by: Vaibhav Nagarnaik <vnagarnaik@google.com>
> ---
> Changelog:
> v2-v1: Added comment to explaing use of __GFP_NORETRY
> 
>  kernel/trace/ring_buffer.c |   25 ++++++++++++++++++++-----
>  1 files changed, 20 insertions(+), 5 deletions(-)

Unfortunately, __GFP_NORETRY is racy and don't work as expected.
If free memory is not enough, the thread may start to reclaim and
another thread can steal the reclaimed memory. And thread0 don't retry.

Then, thread0's alloc page may fail even though system have enough reclaimable
memory.

        thread0                                        thread1
        ---------------------------------------------------------------
        alloc_pages()
           get_page_from_freelist() -> fail
           try_to_free_pages()
                                                    alloc_pages()
                                                       get_page_from_freelist() -> success
           get_page_from_freelist() -> fail again

I think this is mm issue, and afaik, Minchan and some developers are
working on fixing it. but _now_ your patch doesn't work.

Thanks.



