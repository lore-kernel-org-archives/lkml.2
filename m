Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934571Ab1JaP7v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 11:59:51 -0400
Received: from mailout08.t-online.de ([194.25.134.20]:33861 "EHLO
	mailout08.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934538Ab1JaP7u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 11:59:50 -0400
Message-ID: <4EAEC5EB.9030004@t-online.de>
Date: Mon, 31 Oct 2011 16:59:39 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.2.23) Gecko/20110920 SUSE/3.1.15 Thunderbird/3.1.15
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, reiserfs-devel@vger.kernel.org,
        Greg KH <gregkh@suse.de>, Al Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [BUG] kernel 3.1.0 possible circular locking dependency detected
References: <4EAE5DE3.2020205@t-online.de> <CA+55aFzuWD1xRhQNLfe0ey_-1vACwY=ofD5PXSzL_5UeDRbk8g@mail.gmail.com>
In-Reply-To: <CA+55aFzuWD1xRhQNLfe0ey_-1vACwY=ofD5PXSzL_5UeDRbk8g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-ID: S3MzD4ZrohN8iFR-QLMTJLFBa0dDS5Qf+uKC8uu6Gc3NkjxZs3OToqkdzEadu5ZQ70
X-TOI-MSGID: b0c7f1ba-5e4f-4d70-b49f-aa5c921b58e0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 31.10.2011 16:08, schrieb Linus Torvalds:
> [ Added a few more people to the cc ]
>
> On Mon, Oct 31, 2011 at 1:35 AM, Knut Petersen
> <Knut_Petersen@t-online.de>  wrote:
>> After a " rm -r /verybigdir" (about 12G on a 25G reiserfs 3.6partition)
>> I found the following report about a circular locking dependency in
>> kernel 3.1.0
> Heh. There is even a comment about the ordering violation:
>
> /* We use I_MUTEX_CHILD here to silence lockdep. It's safe because xattr
>   * mutation ops aren't called during rename or splace, which are the
>   * only other users of I_MUTEX_CHILD. It violates the ordering, but that's
>   * better than allocating another subclass just for this code. */
>
> and apparently the comment is wrong: we *do* end up looking up xattrs
> during splice, due to the security_inode_need_killpriv() thing.
>
> So I think this needs a suid (or sgid) file that has xattrs and is removed.

Well, after rm -r  /some_small_dir_with_suid_and_sgid_files
there was no warning in dmesg.

I restored a copy of /verybigdir and searched for sgid/suid files with
find /test -type f -perm +6000 -exec ls -l {} \;

Result: not a singe suid/sgid file in /verybigdir

But  rm -r /verybigdir triggered the warning again ...

knut

> That said, I suspect this is a false positive, because the actual
> unlink can never happen while somebody is splicing to/from the same
> file at the same time (because then the iput wouldn't be the last one
> for the inode, and the file removal would be delayed until the file
> has been closed for the last time).
>
> But the hacky use of "I_MUTEX_CHILD" is basically not the proper way
> to silence the lockdep splat.
>
> Anybody?
>
>                    Linus
>

