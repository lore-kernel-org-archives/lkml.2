Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759566Ab2JYNkB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 09:40:01 -0400
Received: from relay.parallels.com ([195.214.232.42]:40708 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759520Ab2JYNj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 09:39:59 -0400
Message-ID: <50894109.8080901@parallels.com>
Date: Thu, 25 Oct 2012 17:39:21 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Miklos Szeredi <miklos@szeredi.hu>
CC: "fuse-devel@lists.sourceforge.net" <fuse-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@openvz.org" <devel@openvz.org>
Subject: Re: [PATCH 07/11] fuse: add per-page descriptor <offset, length>
 to fuse_req (v2)
References: <20120919163242.29482.83047.stgit@maximpc.sw.ru> <20121001111432.11376.46219.stgit@maximpc.sw.ru> <87k3ue3cse.fsf@tucsk.pomaz.szeredi.hu>
In-Reply-To: <87k3ue3cse.fsf@tucsk.pomaz.szeredi.hu>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

10/25/2012 05:24 PM, Miklos Szeredi пишет:
> Maxim Patlasov <mpatlasov@parallels.com> writes:
>
>> The ability to save page pointers along with lengths and offsets in fuse_req
>> will be useful to cover several iovec-s with a single fuse_req.
>>
>> Per-request page_offset is removed because anybody who need it can use
>> req->page_descs[0].offset instead.
>>
>> Changed in v2:
>>   - replaced structure page_desc with fuse_page_desc
>>
>> Signed-off-by: Maxim Patlasov <mpatlasov@parallels.com>
>> ---
>>   fs/fuse/dev.c    |   26 +++++++++++++++++++-------
>>   fs/fuse/file.c   |   10 +++++-----
>>   fs/fuse/fuse_i.h |   15 ++++++++++++---
>>   3 files changed, 36 insertions(+), 15 deletions(-)
>>
>> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
>> index b241a7d..72ad962 100644
>> --- a/fs/fuse/dev.c
>> +++ b/fs/fuse/dev.c
>> @@ -35,14 +35,17 @@ static struct fuse_conn *fuse_get_conn(struct file *file)
>>   }
>>   
>>   static void fuse_request_init(struct fuse_req *req, struct page **pages,
>> +			      struct fuse_page_desc *page_descs,
>>   			      unsigned npages)
>>   {
>>   	memset(req, 0, sizeof(*req));
>> +	memset(page_descs, 0, sizeof(*page_descs) * npages);
> Makes me wonder:  why aren't we zeroing out the page array too?

Good catch, thnx! This is a legacy since time when I attempted to use 
<page, length, offset> as fuse_page_desc. Now, when we have both 
page_descs[] and pages[], it's natural to zero both.

>
> @@ -82,6 +92,8 @@ void fuse_request_free(struct fuse_req *req)
>   {
>   	if (req->pages != req->inline_pages)
>   		kfree(req->pages);
> +	if (req->page_descs != req->inline_page_descs)
> +		kfree(req->page_descs);
> You allocate them together, you can free them together.  Just add a
> BUG_ON() if you feel paranoid.

OK.

Thanks,
Maxim
