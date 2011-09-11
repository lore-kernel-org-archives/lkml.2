Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760275Ab1IKQDs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 12:03:48 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:40676 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754935Ab1IKQDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 12:03:46 -0400
Message-ID: <4E6CDA70.5080205@gmail.com>
Date: Sun, 11 Sep 2011 17:57:36 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; it; rv:1.9.2.22) Gecko/20110907 SUSE/3.1.14 Thunderbird/3.1.14
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH, RFC] xip: use i_mutex for xip_file_fault
References: <4E6B82DB.50803@gmail.com> <20110910155639.GY2203@ZenIV.linux.org.uk> <4E6C705F.8010101@gmail.com> <20110911111504.GA2203@ZenIV.linux.org.uk> <20110911112552.GB2203@ZenIV.linux.org.uk>
In-Reply-To: <20110911112552.GB2203@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Il 11/09/2011 13:25, Al Viro ha scritto:
> On Sun, Sep 11, 2011 at 12:15:04PM +0100, Al Viro wrote:
>
>> write() grabs ->i_mutex on the file it's going to write to.  It uses
>> copy_from_user() while holding ->i_mutex; that can end up calling ->fault().
>> If your data comes from the same file mmapped in your address space, you
>> have xip_write_fault() called while you are in xip_file_write() and *already*
>> are holding ->i_mutex on the same inode.  With your patch it will, AFAICS,
>> cheerfully deadlock.
>
> Oh, wait...  You are only doing that to write side of pagefault?  That's
> better, but not much:
>
> thread 1: mmap the file, modify mapping
> thread 2: write() to file
>
> The former will do xip_write_fault() while holding ->mmap_sem.
> The latter will do copy_from_user() from xip_file_write(), getting
> pagefaults while holding ->i_mutex.
>
> Note that we are grabbing ->mmap_sem and ->i_mutex in opposite orders.
> I.e. that will deadlock on you - all you need is threads sharing the
> address space.
>

Ok, thank you very much for the on-line debug :) So i_mutex is not a 
good lock to use in this situation. It was a common sync point, but it 
has some collateral effect on the write path that we must avoid. At this 
point, what can be a good strategy? Any opinion is welcome.

Marco
