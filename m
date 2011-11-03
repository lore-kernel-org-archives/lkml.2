Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934181Ab1KCSCd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 14:02:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32261 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932703Ab1KCSCb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 14:02:31 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: i@coly.li
Cc: Zhu Yanhai <zhu.yanhai@gmail.com>, linux-kernel@vger.kernel.org,
        bcrl@kvack.org, viro@zeniv.linux.org.uk, linux-aio@kvack.org,
        linux-fsdevel@vger.kernel.org, jaxboe@fusionio.com,
        Zhu Yanhai <gaoyang.zyh@taobao.com>
Subject: Re: [PATCH][RFC] A readahead complete notify approach to implement buffer aio
References: <1320138024-10837-1-git-send-email-gaoyang.zyh@taobao.com>
	<4EB2D8CF.2080108@coly.li>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 03 Nov 2011 14:01:55 -0400
In-Reply-To: <4EB2D8CF.2080108@coly.li> (Coly Li's message of "Fri, 04 Nov
	2011 02:09:19 +0800")
Message-ID: <x49y5vxytik.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Coly Li <i@coly.li> writes:

> On 2011年11月01日 17:00, Zhu Yanhai Wrote:
>> The current libaio/aio has to be Direct-IO, otherwise it falls back into sync IO.
>> However, the aio core has already been asychronous naturally. This patch adds a complete
>> notify mechanism to implement buffer aio, the main idea is to readahead()-like in
>> io_submit(), counts the non-uptodated pages assocaiated with each iocb, then put each ref
>> in the bio complete path just before unlock_page(), and hook them on to the aio ring buffer
>> finally when the ref drops to zero. In io_getevents(), we call vfs_read() as a safe net
>> since there is still little possibility that the pages had brought in were reclaimed
>> between io_submit() and io_getevents().
>> 
>> I have tested this patch for a while, for the small size random io request, its
>> performance is more or less the same with the traditional aio, for the big io request,
>> the overhead of one extra memory copy arises.
>> 
>> I think so far it has at least below obvious drawbacks,
>> 
>> * mpage_readpage() is a really narrow interface, I have no way to pass down
>> the new control struct baiocb, so I just put it into struct task_struct and
>> refer it by current() as a workaround.
>> 
>> * the do_baio_read() routine is heavily similar with do_generic_file_read(), but
>> the latter is really hard to modify. I think we may stuff these code down into the
>> readahead path to reduce code reduplication.
>> 
>> Hopefully the explanations are clear enough and don't muddy the water any worse.
>> I figure the code does need some better comments, and any suggestion are welcome.
>> 
>> Signed-off-by: Zhu Yanhai <gaoyang.zyh@taobao.com>
>> 
>> ---
>>  fs/aio.c                    |  319 ++++++++++++++++++++++++++++++++++++++++++-
>>  fs/buffer.c                 |   26 ++++-
>>  fs/mpage.c                  |   28 ++++-
>>  include/linux/aio.h         |    9 ++
>>  include/linux/aio_abi.h     |    1 +
>>  include/linux/blk_types.h   |    2 +
>>  include/linux/buffer_head.h |    3 +
>>  include/linux/page-flags.h  |    2 +
>>  include/linux/sched.h       |    1 +
>>  9 files changed, 386 insertions(+), 5 deletions(-)
>> 
>
> Hmm, I don't see the usage from user space. Is it possible to post a demo code in user space, so people are able to
> understand how to use/test your patch.

He added a new IOCB_CMD_blah for buffered aio reads.  That is,
unfortunately, a really poor way to go about doing things.  Please take
a look at the work Jens did on implementing buffered aio.  It can be
found in his linux-block git tree.

Cheers,
Jeff
