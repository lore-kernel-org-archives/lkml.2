Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755512Ab0E2N1N (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 09:27:13 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:57565 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929Ab0E2N1I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 09:27:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :content-type:content-transfer-encoding;
        b=AaPLIqgAnsluwlAMuADcIxsRgPV2aaj3H7O23Zwvor2sWD9/WcFnohrNltvB5OFRCU
         sQ0P8YUWiFBLWQ0hDG146rtLXR/I5b8VoK4gPfbn94Sj7H+TCzRFLxQhd4WZmCE/CWYi
         i0ZvDjwY2X2wuyZRPkF/ApAY4LyrVpzR9dWr8=
MIME-Version: 1.0
In-Reply-To: <20100529121019.GA25092@liondog.tnic>
References: <1275095926-18345-1-git-send-email-xiaosuo@gmail.com> 
	<20100529121019.GA25092@liondog.tnic>
From: Changli Gao <xiaosuo@gmail.com>
Date: Sat, 29 May 2010 21:26:47 +0800
Message-ID: <AANLkTimtX4HSql73IEAwOBqC2-R25713IgfihGR-fQm9@mail.gmail.com>
Subject: Re: [PATCH 1/2] fs: optimize mpage_readpage()
To: Borislav Petkov <bp@alien8.de>, Changli Gao <xiaosuo@gmail.com>,
       Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 29, 2010 at 8:10 PM, Borislav Petkov <bp@alien8.de> wrote:
> From: Changli Gao <xiaosuo@gmail.com>
> Date: Sat, May 29, 2010 at 09:18:46AM +0800
>
>> optimize mpage_readpage()
>>
>> we don't need to initialize bio, and pass it to do_mpage_readpage() as
>> parameter, as it is returned by do_mpage_readpage().
>>
>> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>> ----
>>  fs/mpage.c |    4 ++--
>>  1 file changed, 2 insertions(+), 2 deletions(-)
>> diff --git a/fs/mpage.c b/fs/mpage.c
>> index fd56ca2..94ff0d1 100644
>> --- a/fs/mpage.c
>> +++ b/fs/mpage.c
>> @@ -409,14 +409,14 @@ EXPORT_SYMBOL(mpage_readpages);
>>   */
>>  int mpage_readpage(struct page *page, get_block_t get_block)
>>  {
>> -     struct bio *bio = NULL;
>> +     struct bio *bio;
>>       sector_t last_block_in_bio = 0;
>>       struct buffer_head map_bh;
>>       unsigned long first_logical_block = 0;
>>
>>       map_bh.b_state = 0;
>>       map_bh.b_size = 0;
>> -     bio = do_mpage_readpage(bio, page, 1, &last_block_in_bio,
>> +     bio = do_mpage_readpage(NULL, page, 1, &last_block_in_bio,
>>                       &map_bh, &first_logical_block, get_block);
>>       if (bio)
>>               mpage_bio_submit(READ, bio);
>
> Nope, I don't think that's a good idea.
>
> On the one hand, this is a trick to shut up gcc:
>
> fs/mpage.c: In function ‘mpage_readpage’:
> fs/mpage.c:419: warning: ‘bio’ is used uninitialized in this function
>
> and, on the other hand, make sure bio is NULL and not some random stack
> value since bio is explicitly checked for NULL in do_mpage_readpage().
>

Did the compiler warning appear after applying my patch? It doesn't
happen when I testing it.  And I don't pass bio to
do_mpage_readpage(), but I pass NULL instead.

-- 
Regards，
Changli Gao(xiaosuo@gmail.com)
