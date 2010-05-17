Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755344Ab0EQNTg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 09:19:36 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:57818 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261Ab0EQNTf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 09:19:35 -0400
MIME-Version: 1.0
In-Reply-To: <1273799074.9999.653.camel@macbook.infradead.org>
References: <1273074054-11849-1-git-send-email-kirill@shutemov.name>
	 <1273799074.9999.653.camel@macbook.infradead.org>
Date: Mon, 17 May 2010 16:19:34 +0300
Message-ID: <AANLkTikvUvzQMjoM26PowGWVqAopdSSjKvE-NzSB2xMJ@mail.gmail.com>
Subject: Re: [PATCH v4] mtd: Do not corrupt backing device of device node 
	inode
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Jan Kara <jack@suse.cz>, Alexander Viro <viro@zeniv.linux.org.uk>,
       David Howells <dhowells@redhat.com>,
       Alexander Shishkin <virtuoso@slind.org>,
       Artem Bityutskiy <dedekind1@gmail.com>, linux-mtd@lists.infradead.org,
       linux-fsdevel@vger.kernel.org, stable@kernel.org,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 14, 2010 at 4:04 AM, David Woodhouse <dwmw2@infradead.org> wrote:
> On Wed, 2010-05-05 at 18:40 +0300, Kirill A. Shutemov wrote:
>> We cannot modify file->f_mapping->backing_dev_info, because it will corrupt
>> backing device of device node inode, since file->f_mapping is equal to
>> inode->i_mapping (see __dentry_open() in fs/open.c).
>>
>> Let's introduce separate inode for MTD device with appropriate backing
>> device.
>
> I hate the fact that we have to do this -- is it really the only option?
>
> Is it _just_ for the backing_device_info? Can't that be done
> differently?

Yes, it's ugly, but I don't see options.

>> @@ -85,11 +88,27 @@ static int mtd_open(struct inode *inode, struct file *file)
>>               goto out;
>>       }
>>
>> -     if (mtd->backing_dev_info)
>> -             file->f_mapping->backing_dev_info = mtd->backing_dev_info;
>> +     if (!mtd->inode) {
>> +             mtd->inode = new_inode(mtd_inode_mnt->mnt_sb);
>
> I believe that would be a race condition, if it wasn't for the BKL.

Ok, I'll fix it.

> And what happens when you close the chardevice and call iput() on the
> inode so it's destroyed, and then you re-open the device? You never set
> mtd->inode = NULL, so won't it now try to igrab a stale pointer?

inode destroys only on del_mtd_device() so it's safe to re-open chardevice.

> You won't have seen this in your testing unless you made it prune the
> icache between the close and open calls.
>
> --
> David Woodhouse                            Open Source Technology Centre
> David.Woodhouse@intel.com                              Intel Corporation
>
>
