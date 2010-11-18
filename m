Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756753Ab0KRKyQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 05:54:16 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:34696 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755798Ab0KRKyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 05:54:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:from:date:x-google-sender-auth:message-id
         :subject:to:cc:content-type;
        b=Ad0zPf+vLv+SunepLzYVjP1CF5UdF/BmPyhryMzkU9vpigrGY8KYIgQk7nG7T7WOvY
         WIQrcUTQ9OHVVL/9syKswXQmWdnGldE4OR142XWZKRiRVXUI+frSX5pyOWmM19jSmzub
         qZbCz8qiDNB81yO5hP27Loy/Hd43vWm+0lnIM=
MIME-Version: 1.0
From: Peng Tao <lkml.bergwolf@gmail.com>
Date: Thu, 18 Nov 2010 18:53:54 +0800
X-Google-Sender-Auth: xc5xge5-ezsp6Ezt1XIzzaAa6EE
Message-ID: <AANLkTimavN8px1k_Y65mFqsAsiLjgCh6vos22ZnZm+3Z@mail.gmail.com>
Subject: Question about nfs_page_async_flush assertion
To: linux-nfs@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all,

nfs_writepages calls into
write_cache_pages()->nfs_writepages_callback()->nfs_do_writepage()->nfs_page_async_flush(),
where it asserts BUG_ON(test_bit(PG_CLEAN, &req->wb_flags)).
My question is: how do we guarantee the request has PG_CLEAN flag set?

nfs_writepages calls:
 356         nfs_pageio_init_write(&pgio, inode, wb_priority(wbc));
 357         err = write_cache_pages(mapping, wbc,
nfs_writepages_callback, &pgio);
 358         nfs_pageio_complete(&pgio);

IIUC, the request will only be issued in nfs_pageio_complete() and
there nfs_write_rpcsetup() will call
nfs_writeback_release_full()->nfs_mark_request_commit() to set the
PG_CLEAN flag. If the request has not ever been issued before entering
nfs_writepages, the PG_CLEAN flag will not be set and the BUG_ON will
be triggered. Am I missing something?

-- 
Thanks,
-Bergwolf
