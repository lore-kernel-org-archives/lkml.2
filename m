Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755941Ab0JHI3Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 04:29:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35072 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752722Ab0JHI3X (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 04:29:23 -0400
Message-ID: <4CAED656.2080300@redhat.com>
Date: Fri, 08 Oct 2010 10:29:10 +0200
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Matthew Wilcox <matthew@wil.cx>, Pavel Emelyanov <xemul@parallels.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xiyou.wangcong@gmail.com
Subject: Re: [PATCH v2] procfs: fix numbering in /proc/locks
References: <4CA484BA.7090809@redhat.com>	<4CAB1693.2080301@redhat.com> <20101007162702.7db08f5b.akpm@linux-foundation.org>
In-Reply-To: <20101007162702.7db08f5b.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/08/2010 01:27 AM, Andrew Morton wrote:
> On Tue, 05 Oct 2010 14:14:11 +0200
> Jerome Marchand <jmarchan@redhat.com> wrote:
> 
>> On 09/30/2010 02:38 PM, Jerome Marchand wrote:
>>>
>>> The lock number in /proc/locks (first field) is implemented by a counter
>>> (private field of struct seq_file) which is incremented at each call of
>>> locks_show() and reset to 1 in locks_start() whatever the offset is. It
>>> should be reset according to the actual position in the list.
>>>
>>> Moreover, locks_show() can be called twice to print a single line thus
>>> skipping a number. The counter should be incremented in locks_next().
>>>
>>> Signed-off-by: Jerome Marchand <jmarchan@redhat.com>
>>> ---
>>>  locks.c |    4 ++--
>>>  1 file changed, 2 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/fs/locks.c b/fs/locks.c
>>> index ab24d49..49d7343 100644
>>> --- a/fs/locks.c
>>> +++ b/fs/locks.c
>>> @@ -2166,19 +2166,19 @@ static int locks_show(struct seq_file *f, void *v)
>>>  	list_for_each_entry(bfl, &fl->fl_block, fl_block)
>>>  		lock_get_status(f, bfl, (long)f->private, " ->");
>>>  
>>> -	f->private++;
>>>  	return 0;
>>>  }
>>>  
>>>  static void *locks_start(struct seq_file *f, loff_t *pos)
>>>  {
>>>  	lock_kernel();
>>> -	f->private = (void *)1;
>>> +	f->private = (void *) (*pos + 1);
>>
>> That cast trigger a warning on some arch:
>> "warning: cast to pointer from integer of different size"
>>
>> There is no real risk here. At worst /proc/locks will show wrong number
>> if there is more than 2^32 locks, but should I mute the warning it with
>> something like:
>>         f->private = (void *) (size_t) (*pos + 1);
>> ?
> 
> Putting a loff_t into a void* is a pretty alarming thing to do.  If
> we're really going to do that then use a (long) cast and put a very
> good comment at the code site explaining why the bug doesn't matter, so
> people aren't misled.
> 
> But really, why sweat it?  kmalloc the eight bytes, make ->private
> point at that and we never have to think about it again.  Bonus points
> for doing this without any typecasts ;)
> 

That's definitely cleaner. I'll do that.

Thanks,
Jerome
