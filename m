Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030591Ab2CQGOd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 02:14:33 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49930 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754703Ab2CQGOa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 02:14:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120317023740.GH12704@decadent.org.uk>
References: <20120316233829.GA14022@kroah.com>
	<20120316233811.484341257@linuxfoundation.org>
	<20120317023740.GH12704@decadent.org.uk>
Date: Sat, 17 Mar 2012 10:14:29 +0400
X-Google-Sender-Auth: _YkWLNpaw-EZxFBbRNnf1lX3-HI
Message-ID: <CAKywueTUH_Zrh7iD_zsyvtmLt9O2dbd_KNrzNWzFQm4z8ZtbcQ@mail.gmail.com>
Subject: Re: [ 10/41] CIFS: Do not kmalloc under the flocks spinlock
From: Pavel Shilovsky <piastry@etersoft.ru>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Jeff Layton <jlayton@redhat.com>, Steve French <sfrench@us.ibm.com>
Content-Type: text/plain; charset=KOI8-R
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

17 Õ¡“‘¡ 2012ö«. 6:37 –œÃÿ⁄œ◊¡‘≈Ãÿ Ben Hutchings <ben@decadent.org.uk> Œ¡–…”¡Ã:
> On Fri, Mar 16, 2012 at 04:38:20PM -0700, Greg KH wrote:
>> 3.2-stable review patch. öIf anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Pavel Shilovsky <piastry@etersoft.ru>
>>
>> commit d5751469f210d2149cc2159ffff66cbeef6da3f2 upstream.
>>
>> Reorganize the code to make the memory already allocated before
>> spinlock'ed loop.
>>
>> Reviewed-by: Jeff Layton <jlayton@redhat.com>
>> Signed-off-by: Pavel Shilovsky <piastry@etersoft.ru>
>> Signed-off-by: Steve French <sfrench@us.ibm.com>
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>
>> ---
>> öfs/cifs/file.c | ö 69 ++++++++++++++++++++++++++++++++++++++++++++++-----------
>> ö1 file changed, 56 insertions(+), 13 deletions(-)
>>
>> --- a/fs/cifs/file.c
>> +++ b/fs/cifs/file.c
> [....]
>> @@ -940,29 +950,55 @@ cifs_push_posix_locks(struct cifsFileInf
>> ö ö ö ö ö ö ö return rc;
>> ö ö ö }
>>
>> + ö ö lock_flocks();
>> + ö ö cifs_for_each_lock(cfile->dentry->d_inode, before) {
>> + ö ö ö ö ö ö if ((*before)->fl_flags & FL_POSIX)
>> + ö ö ö ö ö ö ö ö ö ö count++;
>> + ö ö }
>> + ö ö unlock_flocks();
>> +
>> ö ö ö INIT_LIST_HEAD(&locks_to_send);
>>
>> + ö ö /*
>> + ö ö ö* Allocating count locks is enough because no locks can be added to
>> + ö ö ö* the list while we are holding cinode->lock_mutex that protects
>> + ö ö ö* locking operations of this inode.
>> + ö ö ö*/
>> + ö ö for (; i < count; i++) {
>> + ö ö ö ö ö ö lck = kmalloc(sizeof(struct lock_to_push), GFP_KERNEL);
>> + ö ö ö ö ö ö if (!lck) {
>> + ö ö ö ö ö ö ö ö ö ö rc = -ENOMEM;
>> + ö ö ö ö ö ö ö ö ö ö goto err_out;
>> + ö ö ö ö ö ö }
>> + ö ö ö ö ö ö list_add_tail(&lck->llist, &locks_to_send);
>> + ö ö }
>> +
>> + ö ö i = 0;
>> + ö ö el = locks_to_send.next;
>> ö ö ö lock_flocks();
>> ö ö ö cifs_for_each_lock(cfile->dentry->d_inode, before) {
>> + ö ö ö ö ö ö if (el == &locks_to_send) {
>> + ö ö ö ö ö ö ö ö ö ö /* something is really wrong */
>> + ö ö ö ö ö ö ö ö ö ö cERROR(1, "Can't push all brlocks!");
>> + ö ö ö ö ö ö ö ö ö ö break;
>> + ö ö ö ö ö ö }
>> ö ö ö ö ö ö ö flock = *before;
>> + ö ö ö ö ö ö if ((flock->fl_flags & FL_POSIX) == 0)
>> + ö ö ö ö ö ö ö ö ö ö continue;
> [...]
>
> If I understand the logic correctly, el == &locks_to_send means we
> already used all the lock_to_push structures. ö(It should also be
> equivalent to testing i == count. öWhy is i incremented but not
> otherwise used in the loop?)
>
> But we test this before flock->fl_flags & FL_POSIX, which means we
> don't know whether this lock actually needs to be assigned one of
> those structures. öSo it appears that we might report a spurious error
> if the lock list ends with a mandatory lock. öIf so, this is
> relatively harmless but does need to be fixed.
>

You are right here, thanks for the catch! I will repost the patch asap.

-- 
Best regards,
Pavel Shilovsky.
