Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934272Ab1KCR7V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 13:59:21 -0400
Received: from oproxy1-pub.bluehost.com ([66.147.249.253]:58369 "HELO
	oproxy1-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S934234Ab1KCR7T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 13:59:19 -0400
Message-ID: <4EB2D8CF.2080108@coly.li>
Date: Fri, 04 Nov 2011 02:09:19 +0800
From: Coly Li <i@coly.li>
Reply-To: i@coly.li
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; zh-CN; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Zhu Yanhai <zhu.yanhai@gmail.com>
CC: linux-kernel@vger.kernel.org, bcrl@kvack.org, viro@zeniv.linux.org.uk,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org,
        jaxboe@fusionio.com, Zhu Yanhai <gaoyang.zyh@taobao.com>
Subject: Re: [PATCH][RFC] A readahead complete notify approach to implement
 buffer aio
References: <1320138024-10837-1-git-send-email-gaoyang.zyh@taobao.com>
In-Reply-To: <1320138024-10837-1-git-send-email-gaoyang.zyh@taobao.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Identified-User: {1390:box585.bluehost.com:colyli:coly.li} {sentby:smtp auth 123.120.157.244 authed with i@coly.li}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年11月01日 17:00, Zhu Yanhai Wrote:
> The current libaio/aio has to be Direct-IO, otherwise it falls back into sync IO.
> However, the aio core has already been asychronous naturally. This patch adds a complete
> notify mechanism to implement buffer aio, the main idea is to readahead()-like in
> io_submit(), counts the non-uptodated pages assocaiated with each iocb, then put each ref
> in the bio complete path just before unlock_page(), and hook them on to the aio ring buffer
> finally when the ref drops to zero. In io_getevents(), we call vfs_read() as a safe net
> since there is still little possibility that the pages had brought in were reclaimed
> between io_submit() and io_getevents().
> 
> I have tested this patch for a while, for the small size random io request, its
> performance is more or less the same with the traditional aio, for the big io request,
> the overhead of one extra memory copy arises.
> 
> I think so far it has at least below obvious drawbacks,
> 
> * mpage_readpage() is a really narrow interface, I have no way to pass down
> the new control struct baiocb, so I just put it into struct task_struct and
> refer it by current() as a workaround.
> 
> * the do_baio_read() routine is heavily similar with do_generic_file_read(), but
> the latter is really hard to modify. I think we may stuff these code down into the
> readahead path to reduce code reduplication.
> 
> Hopefully the explanations are clear enough and don't muddy the water any worse.
> I figure the code does need some better comments, and any suggestion are welcome.
> 
> Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
> 
> ---
>  fs/aio.c                    |  319 ++++++++++++++++++++++++++++++++++++++++++-
>  fs/buffer.c                 |   26 ++++-
>  fs/mpage.c                  |   28 ++++-
>  include/linux/aio.h         |    9 ++
>  include/linux/aio_abi.h     |    1 +
>  include/linux/blk_types.h   |    2 +
>  include/linux/buffer_head.h |    3 +
>  include/linux/page-flags.h  |    2 +
>  include/linux/sched.h       |    1 +
>  9 files changed, 386 insertions(+), 5 deletions(-)
> 

Hmm, I don't see the usage from user space. Is it possible to post a demo code in user space, so people are able to
understand how to use/test your patch.

BTW, if there is any performance number, it should be interesting, too.

Thanks.

-- 
Coly Li
