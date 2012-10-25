Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759949Ab2JYPjM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 11:39:12 -0400
Received: from relay.parallels.com ([195.214.232.42]:40993 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759746Ab2JYPjL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 11:39:11 -0400
Message-ID: <50895CF6.2060600@parallels.com>
Date: Thu, 25 Oct 2012 19:38:30 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 08/11] fuse: use req->page_descs[] for argpages cases
References: <20120919161559.29482.55120.stgit@maximpc.sw.ru> <20120919163300.29482.26231.stgit@maximpc.sw.ru> <87fw523avx.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <87fw523avx.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Miklos,

10/25/2012 06:05 PM, Miklos Szeredi пишет:
> Maxim Patlasov <mpatlasov@parallels.com> writes:
>
>> @@ -888,11 +888,11 @@ static int fuse_copy_pages(struct fuse_copy_state *cs, unsigned nbytes,
>>   {
>>   	unsigned i;
>>   	struct fuse_req *req = cs->req;
>> -	unsigned offset = req->page_descs[0].offset;
>> -	unsigned count = min(nbytes, (unsigned) PAGE_SIZE - offset);
>>   
>>   	for (i = 0; i < req->num_pages && (nbytes || zeroing); i++) {
>>   		int err;
>> +		unsigned offset = req->page_descs[i].offset;
>> +		unsigned count = min(nbytes, req->page_descs[i].length);
> Wouldn't it be cleaner if callers calculated the last page's .length
> value from the total number of bytes?  So this would just be
>
> 		unsigned count = req->page_descs[i].length;
>
> And at the end of the function we can assert that nbytes went to exactly
> zero with a WARN_ON().
>
> But this is a change that needs careful testing, so maybe we're better
> off having that as a separate incremental patch later...

It cannot be as simple as 'unsigned count = req->page_descs[i].length' 
because in case of short reads 'nbytes' (coming from userspace) can be 
unpredictably small. Modulo you share my opinion that a caller of 
fuse_copy_pages() shouldn't modify req->page_descs[i].length.

As for WARN_ON(), we could probably guarantee that 'nbytes' <= 
capacity(req->pages[]) in WRITEs, but in READs, 'nbytes' comes from 
userspace and I'm not sure it's OK to clutter logs due to misbehaved 
userspace fuse (if we get 'nbytes' unexpectedly large).

Thanks,
Maxim
