Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755635Ab2JJQrd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 12:47:33 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:57279 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753941Ab2JJQra (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 12:47:30 -0400
MIME-Version: 1.0
In-Reply-To: <20121006081742.48d5e5e8@infradead.org>
References: <1346945041-26676-10-git-send-email-peter.senna@gmail.com>
	<20121006081742.48d5e5e8@infradead.org>
Date: Wed, 10 Oct 2012 18:47:28 +0200
Message-ID: <CA+MoWDp6nMccVQxm93ht-4vxYN4HTACW+H-Xa9onaykwQFwyWw@mail.gmail.com>
Subject: Re: [PATCH 4/14] drivers/media/v4l2-core/videobuf2-core.c: fix error
 return code
From: Peter Senna Tschudin <peter.senna@gmail.com>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: kernel-janitors@vger.kernel.org, Julia.Lawall@lip6.fr,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 6, 2012 at 1:17 PM, Mauro Carvalho Chehab
<mchehab@infradead.org> wrote:
> Em Thu,  6 Sep 2012 17:23:57 +0200
> Peter Senna Tschudin <peter.senna@gmail.com> escreveu:
>
>> From: Peter Senna Tschudin <peter.senna@gmail.com>
>>
>> Convert a nonnegative error return code to a negative one, as returned
>> elsewhere in the function.
>>
>> A simplified version of the semantic match that finds this problem is as
>> follows: (http://coccinelle.lip6.fr/)
>>
>> // <smpl>
>> (
>> if@p1 (\(ret < 0\|ret != 0\))
>>  { ... return ret; }
>> |
>> ret@p1 = 0
>> )
>> ... when != ret = e1
>>     when != &ret
>> *if(...)
>> {
>>   ... when != ret = e2
>>       when forall
>>  return ret;
>> }
>>
>> // </smpl>
>>
>> Signed-off-by: Peter Senna Tschudin <peter.senna@gmail.com>
>>
>> ---
>>  drivers/media/v4l2-core/videobuf2-core.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/media/v4l2-core/videobuf2-core.c b/drivers/media/v4l2-core/videobuf2-core.c
>> index 4da3df6..f6bc240 100644
>> --- a/drivers/media/v4l2-core/videobuf2-core.c
>> +++ b/drivers/media/v4l2-core/videobuf2-core.c
>> @@ -1876,8 +1876,10 @@ static int __vb2_init_fileio(struct vb2_queue *q, int read)
>>        */
>>       for (i = 0; i < q->num_buffers; i++) {
>>               fileio->bufs[i].vaddr = vb2_plane_vaddr(q->bufs[i], 0);
>> -             if (fileio->bufs[i].vaddr == NULL)
>> +             if (fileio->bufs[i].vaddr == NULL) {
>> +                     ret = -EFAULT;
>>                       goto err_reqbufs;
>> +             }
>
> Had you test this patch? I suspect it breaks the driver, as there are failures under
> streaming handling that are acceptable, as it may indicate that userspace was not
> able to handle all queued frames in time. On such cases, what the Kernel does is to
> just discard the frame. Userspace is able to detect it, by looking inside the timestamp
> added on each frame.

No, I have not tested it. This was the only place the function was
returning non negative value for error path, so looked as a bug to me.
May I add a comment about returning non-negative value is intended
there?

>
>>               fileio->bufs[i].size = vb2_plane_size(q->bufs[i], 0);
>>       }
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
>
> Cheers,
> Mauro



-- 
Peter
