Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754430Ab2LRILv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 03:11:51 -0500
Received: from relay.parallels.com ([195.214.232.42]:39227 "EHLO
	relay.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754014Ab2LRILu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 03:11:50 -0500
Message-ID: <50D02550.3090903@parallels.com>
Date: Tue, 18 Dec 2012 12:12:00 +0400
From: "Maxim V. Patlasov" <mpatlasov@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Brian Foster <bfoster@redhat.com>
CC: <miklos@szeredi.hu>, <dev@parallels.com>, <xemul@parallels.com>,
        <fuse-devel@lists.sourceforge.net>, <linux-kernel@vger.kernel.org>,
        <devel@openvz.org>
Subject: Re: [PATCH 5/6] fuse: truncate file if async dio failed
References: <20121214151424.27155.45971.stgit@maximpc.sw.ru> <20121214152113.27155.58793.stgit@maximpc.sw.ru> <50CB8931.2000305@redhat.com> <50CF288E.8060002@parallels.com> <50CF6CB6.5030703@redhat.com>
In-Reply-To: <50CF6CB6.5030703@redhat.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [10.30.17.2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

12/17/2012 11:04 PM, Brian Foster пишет:
> On 12/17/2012 09:13 AM, Maxim V. Patlasov wrote:
>> Hi,
>>
>> 12/15/2012 12:16 AM, Brian Foster пишет:
>>> On 12/14/2012 10:21 AM, Maxim V. Patlasov wrote:
> ...
>>>> +
>>> fuse_do_truncate() looks fairly close to fuse_do_setattr(). Is there any
>>> reason we couldn't make fuse_do_setattr() non-static, change the dentry
>>> parameter to an inode and use that?
>> fuse_do_setattr() performs extra checks that fuse_do_truncate() needn't.
>> Some of them are harmless, some not: fuse_allow_task() may return 0 if
>> task credentials changed. E.g. super-user successfully opened a file,
>> then setuid(other_user_uid), then write(2) to the file. write(2) doesn't
>> check uid, but fuse_do_truncate() - via fuse_allow_task() - does.
>>
> Conversely, what about the extra error handling bits in
> fuse_do_setattr() that do not appear in fuse_do_truncate() (i.e., the
> inode mode check, the change attributes call, updating the inode size,
> etc.)? It seems like we would want some of that code here.

Yes, they won't harm.

>
> fuse_setattr() is the only caller of fuse_do_setattr(), so why not embed
> some of the initial checks (such as fuse_allow_task()) there? I suppose
> we could pull out some of the error handling checks there as well if
> they are considered harmful to this post-write error truncate situation.

Makes sense. I like it especially because it allows to avoid code 
duplication (handling FUSE_SETATTR fuse-request).

> FWIW, I just tested a quick change that pulls up the fuse_allow_task()
> check (via instrumenting a write error) and it seems to work as
> expected. I can forward a patch if interested...

I did exactly the same before sending previous email :) In my tests it 
works as expected too (modulo fuse_allow_task() that we can move up). 
I'll re-send corrected patch soon.

Thanks,
Maxim
