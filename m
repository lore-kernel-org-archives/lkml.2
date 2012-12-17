Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2LQTCp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 14:02:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:49881 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654Ab2LQTCo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 14:02:44 -0500
Message-ID: <50CF6CB6.5030703@redhat.com>
Date: Mon, 17 Dec 2012 14:04:22 -0500
From: Brian Foster <bfoster@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: "Maxim V. Patlasov" <mpatlasov@parallels.com>
CC: miklos@szeredi.hu, dev@parallels.com, xemul@parallels.com,
        fuse-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
        devel@openvz.org
Subject: Re: [PATCH 5/6] fuse: truncate file if async dio failed
References: <20121214151424.27155.45971.stgit@maximpc.sw.ru> <20121214152113.27155.58793.stgit@maximpc.sw.ru> <50CB8931.2000305@redhat.com> <50CF288E.8060002@parallels.com>
In-Reply-To: <50CF288E.8060002@parallels.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/2012 09:13 AM, Maxim V. Patlasov wrote:
> Hi,
> 
> 12/15/2012 12:16 AM, Brian Foster пишет:
>> On 12/14/2012 10:21 AM, Maxim V. Patlasov wrote:
...
>>> +
>> fuse_do_truncate() looks fairly close to fuse_do_setattr(). Is there any
>> reason we couldn't make fuse_do_setattr() non-static, change the dentry
>> parameter to an inode and use that?
> 
> fuse_do_setattr() performs extra checks that fuse_do_truncate() needn't.
> Some of them are harmless, some not: fuse_allow_task() may return 0 if
> task credentials changed. E.g. super-user successfully opened a file,
> then setuid(other_user_uid), then write(2) to the file. write(2) doesn't
> check uid, but fuse_do_truncate() - via fuse_allow_task() - does.
> 

Conversely, what about the extra error handling bits in
fuse_do_setattr() that do not appear in fuse_do_truncate() (i.e., the
inode mode check, the change attributes call, updating the inode size,
etc.)? It seems like we would want some of that code here.

fuse_setattr() is the only caller of fuse_do_setattr(), so why not embed
some of the initial checks (such as fuse_allow_task()) there? I suppose
we could pull out some of the error handling checks there as well if
they are considered harmful to this post-write error truncate situation.

FWIW, I just tested a quick change that pulls up the fuse_allow_task()
check (via instrumenting a write error) and it seems to work as
expected. I can forward a patch if interested...

Brian

> This non-POSIX behaviour (ftruncate(2) returning -1 with errno==EACCES)
> was introduced long time ago:
> 
>> commit e57ac68378a287d6336d187b26971f35f7ee7251
>> Author: Miklos Szeredi <mszeredi@suse.cz>
>> Date:   Thu Oct 18 03:06:58 2007 -0700
>>
>>     fuse: fix allowing operations
>>
>>     The following operation didn't check if sending the request was
>> allowed:
>>
>>       setattr
>>       listxattr
>>       statfs
>>
>>     Some other operations don't explicitly do the check, but VFS calls
>>     ->permission() which checks this.
>>
>>     Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
>>     Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>>     Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> 
> and I'm not sure whether it was done intentionally or not. Maybe Miklos
> could shed some light on it...
> 
> Thanks,
> Maxim

