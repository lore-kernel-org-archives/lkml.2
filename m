Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab1CYQaw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:30:52 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:42931 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754107Ab1CYQau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:30:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=f8gWYQACv556Gwpr9QW1YOzBLWyB5xcLFl0GOyaZNeDMweQ+aec1NjariQNebF3OM7
         RbFymiQF4WA+dVh5PTcWGK2TWlPwxutOvcNqaWx9k+KXusLP/2Fzr/l/d9Frq7Mp1hoj
         1zhiYFw+AkWR5M/EPPbVbui8a5iymL2JsQ2es=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110325144544.GF1409@htj.dyndns.org>
References: <20110325125643.91510e0e.sfr@canb.auug.org.au>
	<20110325144544.GF1409@htj.dyndns.org>
Date: Fri, 25 Mar 2011 17:30:49 +0100
Message-ID: <AANLkTik=H0coPODvznFOLb8Kyq05RoypE_duNZ0U8wsi@mail.gmail.com>
Subject: Re: linux-next: manual merge of the ext4 tree with Linus' tree
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Theodore Tso <tytso@mit.edu>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mingming Cao <cmm@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 3:45 PM, Tejun Heo <tj@kernel.org> wrote:
> Hello, Stephen, Ted.
>
> On Fri, Mar 25, 2011 at 12:56:43PM +1100, Stephen Rothwell wrote:
>> Today's linux-next merge of the ext4 tree got a conflict in
>> fs/ext4/super.c between commit fd89d5f2030a ("ext4: convert to
>> alloc_workqueue()") from Linus' tree and commit 198868f35de9 ("ext4: Use
>> single thread to perform DIO unwritten convertion") from the ext4 tree.
>>
>> I just used the ext4 tree version.
>
> Both are about the same conversion but the one using alloc_workqueue()
> is better because 1. create_singlethread_workqueue() is going away and
> 2. it doesn't require strict ordering among queued works.
>
> Ted, what do you think?
>
> Thanks.
>
> --
> tejun
>

As my linux-next system is unstable, I had a look into my own merge
(into linux-next GIT) before ext4 stuff went to mainline.
Just wanted to test a revert to "old" code in linux-next (see below).

- Sedat -

--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -596,7 +596,7 @@ __acquires(bitlock)

        vaf.fmt = fmt;
        vaf.va = &args;
-       printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: group %u",
+       printk(KERN_CRIT "EXT4-fs error (device %s): %s:%d: group %u, ",
               sb->s_id, function, line, grp);
        if (ino)
                printk(KERN_CONT "inode %lu: ", ino);
@@ -3518,12 +3518,7 @@ static int ext4_fill_super(struct super_block
*sb, void *data, int silent)
        percpu_counter_set(&sbi->s_dirtyblocks_counter, 0);

 no_journal:
-       /*
-        * The maximum number of concurrent works can be high and
-        * concurrency isn't really necessary.  Limit it to 1.
-        */
-       EXT4_SB(sb)->dio_unwritten_wq =
-               alloc_workqueue("ext4-dio-unwritten", WQ_MEM_RECLAIM, 1);
+       EXT4_SB(sb)->dio_unwritten_wq =
create_singlethread_workqueue("ext4-dio-unwritten");
        if (!EXT4_SB(sb)->dio_unwritten_wq) {
                printk(KERN_ERR "EXT4-fs: failed to create DIO workqueue\n");
                goto failed_mount_wq;
- EOT -
