Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab1IDAAV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 20:00:21 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:59243 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab1IDAAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 20:00:18 -0400
MIME-Version: 1.0
In-Reply-To: <1315092941.97677.YahooMailClassic@web29519.mail.ird.yahoo.com>
References: <CAG1a4rs+-K8GukJE-C8a7JCbw6usdY1FLxjXM7AWYEUpADXusQ@mail.gmail.com>
 <1315092941.97677.YahooMailClassic@web29519.mail.ird.yahoo.com>
From: Pavel Ivanov <paivanof@gmail.com>
Date: Sat, 3 Sep 2011 19:59:46 -0400
Message-ID: <CAG1a4rscDrbiCKxSPvbkG7SutQ5HCU2tX9FJEv81nFuVxLWekg@mail.gmail.com>
Subject: Re: Kernel 3.1.0-rc4 oops when connecting iPod
To: Hin-Tak Leung <hintak_leung@yahoo.co.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 3, 2011 at 7:35 PM, Hin-Tak Leung <hintak_leung@yahoo.co.uk> wrote:
>> "if(sbi->s_backup_vhdr)" as you suggested didn't help.
>> But I made
>> another change. I made fs/hfsplus/super.c to look like this
>> near the
>> line 529:
>>
>> out_free_vhdr:
>>     printk(KERN_ERR "hfs: sbi->s_vhdr =
>> %p, sbi->s_backup_vhdr = %p\n",
>> sbi->s_vhdr, sbi->s_backup_vhdr);
>>     kfree(sbi->s_vhdr);
>>     kfree(sbi->s_backup_vhdr);
>>
>> And here's what I see after connecting an iPod:
>>
>> [   92.549197] hfs: filesystem size too
>> large blksz_shift=14,
>> total_blocks=486494
>> [   92.635714] hfs: sbi->s_vhdr =
>> ffff88013703a690, sbi->s_backup_vhdr
>> = ffff88013703e268
>> [   92.730543]
>> =============================================================================
>> [   92.828425] BUG kmalloc-4096: Invalid
>> object pointer 0xffff88013703a690
>> ...
>> [   93.213890]
>> =============================================================================
>> [   93.311834] BUG kmalloc-4096: Invalid
>> object pointer 0xffff88013703e268
>> ...
>> [   93.868618] hfs: filesystem size too
>> large blksz_shift=14,
>> total_blocks=486494
>> [   93.955327] hfs: sbi->s_vhdr =
>> ffff8801343c37d8, sbi->s_backup_vhdr
>> = ffff8801343c5120
>> [   94.050133]
>> =============================================================================
>> [   94.148026] BUG kmalloc-4096: Invalid
>> object pointer 0xffff8801343c37d8
>> ...
>> [   94.533895]
>> =============================================================================
>> [   94.631746] BUG kmalloc-4096: Invalid
>> object pointer 0xffff8801343c5120
>>
>>
>> So these 2 pointers are exactly what causing the trouble.
>
> This is interesting... so it would appear that hfsplus_read_wrapper() isn't working correctly, but enough of correct information to pass checks. I just re-read your e-mail and your device has a logical block size of 4096 bytes, whereas most of the hfsplus code uses a block size of 512... you will need to look into hfsplus_submit_bio(), which is in the same file wrapper.c.

I've looked into the code myself a little and here's what I see.
hfsplus_read_wrapper() calls to hfsplus_submit_bio() twice to fill
sbi->s_vhdr and sbi->s_backup_vhdr. And according to parameters they
are filled with pointers into sbi->s_vhdr_buf and
sbi->s_backup_vhdr_buf respectively. It's done with the following code
at fs/hfsplus/wrapper.c:79:

	if (!(rw & WRITE) && data)
		*data = (u8 *)buf + offset;

So s_vhdr and s_backup_vhdr shouldn't be freed, s_vhdr_buf and
s_backup_vhdr_buf should be freed instead. And indeed changing in
hfsplus_fill_super()

	kfree(sbi->s_vhdr);
	kfree(sbi->s_backup_vhdr);

to

	kfree(sbi->s_vhdr_buf);
	kfree(sbi->s_backup_vhdr_buf);

fixes BUG reports from SLUB.

Now, the problem with "too large" error is trickier. According to this message

>> [   92.549197] hfs: filesystem size too large blksz_shift=14, total_blocks=486494

HFS thinks that my iPod has block size of 16 KiB. But
generic_check_addressable() decides that everything with blocks larger
than PAGE_CACHE_SHIFT (i.e. 4 KiB on my system) cannot be addressable
and thus filesystem cannot be mounted. I guess it wasn't supposed to
be that way. Is hfsplus_read_wrapper() wrong in determining block size
or all iPods where this was tested actually had block size 4 KiB or
less?

> It is going to be difficult to do anything without the actual device and 8GB is too large to be send around. Assuming it is mostly music/media and there isn't too much stuff which is too confident/private, can I ask you to send me say, the first few MB of the disk?

I'll send it in a separate email bypassing lists.


Pavel
