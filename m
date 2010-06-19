Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab0FSRpQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 13:45:16 -0400
Received: from smtp-out.google.com ([74.125.121.35]:57112 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819Ab0FSRpL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 13:45:11 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:content-transfer-encoding:x-system-of-record;
	b=WyN65KUkw5CCG+AXvpgKV/jXJpiWXzTfFuZsLMbTnA8dPWLcURvFmjE9aBZqNHx3h
	Nm7bb72f1vgJ0SBTmkFtg==
MIME-Version: 1.0
In-Reply-To: <20100619104439.GA7659@lst.de>
References: <1276907415-504-1-git-send-email-mrubin@google.com> 
	<1276907415-504-2-git-send-email-mrubin@google.com> <20100619104439.GA7659@lst.de>
From: Michael Rubin <mrubin@google.com>
Date: Sat, 19 Jun 2010 10:44:46 -0700
Message-ID: <AANLkTimawKkDNpaVrfQtfxPah3QduodLK2njWLTMOhMl@mail.gmail.com>
Subject: Re: [PATCH 1/3] writeback: Creating /sys/kernel/mm/writeback/writeback
To: Christoph Hellwig <hch@lst.de>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-mm@kvack.org, jack@suse.cz, akpm@linux-foundation.org,
       david@fromorbit.com, axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for looking at this.

On Sat, Jun 19, 2010 at 3:44 AM, Christoph Hellwig <hch@lst.de> wrote:
> I'm fine with exposting this. but the interface is rather awkward.
> These kinds of multiple value per file interface require addition
> parsing and are a pain to extend.  Please do something like
>
> /proc/sys/vm/writeback/
>
>                        pages_dirtied
>                        pages_cleaned
>                        dirty_threshold
>                        background_threshold
>
> where you can just read the value from the file.

Cool. This is kind of funny. In the google tree I implemented this in
the same multi-file-one-value-in-file manner. The debate on one file
for all vs that style was heated. And I changed it before sending
upstream. I really don't care either way. So I will just change the
patch and move the values to that location

Do you mind explaining why something would go in /proc/ vs /sys? I
thought the idea was to not put things in /proc anymore.

>> diff --git a/fs/nilfs2/segment.c b/fs/nilfs2/segment.c
>> index c920164..84b0181 100644
>> --- a/fs/nilfs2/segment.c
>> +++ b/fs/nilfs2/segment.c
>> @@ -1598,8 +1598,10 @@ nilfs_copy_replace_page_buffers(struct page *page, struct list_head *out)
>>       } while (bh = bh->b_this_page, bh2 = bh2->b_this_page, bh != head);
>>       kunmap_atomic(kaddr, KM_USER0);
>>
>> -     if (!TestSetPageWriteback(clone_page))
>> +     if (!TestSetPageWriteback(clone_page)) {
>>               inc_zone_page_state(clone_page, NR_WRITEBACK);
>> +             inc_zone_page_state(clone_page, NR_PAGES_ENTERED_WRITEBACK);
>> +     }
>>       unlock_page(clone_page);
>
> I'm not very happy about having this opencoded in a filesystem.

I wasn't excited about this section either. What does opencoded mean?
Do you mean it should not be exposed to specific fs code?

mrubin
