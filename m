Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755171Ab1GEWaG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 18:30:06 -0400
Received: from smtp.ispras.ru ([83.149.198.202]:47319 "EHLO smtp.ispras.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752609Ab1GEWaF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 18:30:05 -0400
From: Alexey Khoroshilov <khoroshilov@ispras.ru>
To: Christoph Hellwig <hch@tuxera.com>
Cc: Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Anton Salikhmetov <alexo@tuxera.com>,
        Al Viro <viro@zeniv.linux.org.uk>, roman@ardistech.com,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: [PATCH v2 0/2] hfsplus: add error checking for hfs_find_init()
Date: Wed,  6 Jul 2011 02:29:58 +0400
Message-Id: <1309905000-28983-1-git-send-email-khoroshilov@ispras.ru>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <20110630114242.GA9597@infradead.org>
References: <20110630114242.GA9597@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> hfs_find_init() may fail with ENOMEM, but there are places, where
>> the returned value is not checked. The consequences can be very
>> unpleasant, e.g. kfree uninitialized pointer and
>> inappropriate mutex unlocking.
>> 
>> The patch adds checks for errors in hfs_find_init().
>> 
>> Found by Linux Driver Verification project (linuxtesting.org).
>
> What kind of testing did you do in detail?

Actually we work on two complementary approaches.

The first one is heavy-weight static analysis of drivers source code 
aimed to detect incorrect usage of kernel core APIs. It was a violation
of mutex usage rule detected by our tools that uncovers lack of error checking
of hfs_find_init() returned value. Yes, memory allocation failure is not 
an often event, but if it happens in inappropriate moment
(e.g. in hfs_find_init() in our case) consequencies can be very unplesant.
A benefit of static analysis approach is automatic evaluation of 
such seldom executed paths that can be hard to reproduce and that lead to 
hard to catch failures.

The second approach is implemented by KEDR toolset that aimed to facilitate 
runtime analysis of kernel modules. KEDR tools operate on the modules chosen 
by the user and can detect memory leaks, perform fault simulation according 
to user-defined scenarios and more. This approach often gives more sound results,
but it requires extra efforts to ensure good coverage and
it requires presence of actual hardware for device drivers verification.


>> -        hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
>> +        err = hfs_find_init(HFSPLUS_SB(sb)->cat_tree, &fd);
>> +        if (err)
>> +                goto err_init;
>>  
>>          hfsplus_cat_build_key(sb, fd.search_key, cnid, NULL);
>>          entry_size = hfsplus_fill_cat_thread(sb, &entry,
>> @@ -255,6 +257,7 @@ err1:
>>                  hfs_brec_remove(&fd);
>>  err2:
>>          hfs_find_exit(&fd);
>> +err_init:
>
> Please just return the error directly unless there's something to
> unwind, both here and in other places.

Done.

>> @@ -124,9 +124,10 @@ static void hfsplus_ext_write_extent_locked(struct inode *inode)
>>          if (HFSPLUS_I(inode)->extent_state & HFSPLUS_EXT_DIRTY) {
>>                  struct hfs_find_data fd;
>>  
>> -                hfs_find_init(HFSPLUS_SB(inode->i_sb)->ext_tree, &fd);
>> -                __hfsplus_ext_write_extent(inode, &fd);
>> -                hfs_find_exit(&fd);
>> +                if (!hfs_find_init(HFSPLUS_SB(inode->i_sb)->ext_tree, &fd)) {
>> +                        __hfsplus_ext_write_extent(inode, &fd);
>> +                        hfs_find_exit(&fd);
>> +                }
>>          }
>>  }
>
> This one need to be propagated back through the callers.

Done.

>> @@ -523,7 +528,11 @@ void hfsplus_file_truncate(struct inode *inode)
>>                  goto out;
>>  
>>          mutex_lock(&hip->extents_lock);
>> -        hfs_find_init(HFSPLUS_SB(sb)->ext_tree, &fd);
>> +        res = hfs_find_init(HFSPLUS_SB(sb)->ext_tree, &fd);
>> +        if (res) {
>> +                mutex_unlock(&hip->extents_lock);
>> +                return;
>> +        }
>
> At least add an XXX comment about the lack of error handling here.
> Once hfsplus gets converted to the new truncate sequence we'll be
> able to handle to return it.

Done.

