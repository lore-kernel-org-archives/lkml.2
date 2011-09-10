Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932349Ab1IJLSm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 07:18:42 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:38897 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759212Ab1IJLSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 07:18:41 -0400
MIME-Version: 1.0
In-Reply-To: <CADDb1s2hN0Pi336_gn_+HxJ+i4kd6Ce5XBOjEKoPzdovxVBt5g@mail.gmail.com>
References: <CADDb1s1pLQMMipe-zoHM6u4C_ZmUm_r4rsYxfft9mFQ56+Wgaw@mail.gmail.com>
	<CADDb1s2hN0Pi336_gn_+HxJ+i4kd6Ce5XBOjEKoPzdovxVBt5g@mail.gmail.com>
Date: Sat, 10 Sep 2011 20:18:39 +0900
Message-ID: <CAKYAXd_Q44ifO8+47-Kvie9xij+1h8U5y36Byh7u6tU_6+vh2w@mail.gmail.com>
Subject: Re: Issue with lazy umount and closing file descriptor in between
From: NamJae Jeon <linkinjeon@gmail.com>
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/9/8 Amit Sahrawat <amit.sahrawat83@gmail.com>:
> I know that lazy umount was designed keeping in mind that the
> mountpoint is not accesible to all future I/O but for the ongoing I/O
> it will continute to work. It is only after the I/O is finished that
> the umount will actually occur. But this can be tricky at times
> considering there are situations where the operation will continue to
> be executed than what is expected duration, and you cannot unplug the
> device during that period because there are chances of filesystem
> corruption on doing so.
> Is there anything which could be done in this context? because simply
> reading the fd-table and closing fd's will not serve the purpose and
> there is every chance of a OOPs occuring due to this closing.
> Signalling from this point to the all the process's with open fd's on
> that mountpoint to close fd i.e., handling needs to be done from the
> user space applications...? Does this make sense
>
> Please through some insight into this. I am not looking for exact
> solution it is just mere opinion's on this that can add to this.
>
> Thanks & Regards,
> Amit Sahrawat
>
> On Tue, Sep 6, 2011 at 10:56 PM, Amit Sahrawat
> <amit.sahrawat83@gmail.com> wrote:
>> We have observed below issues in busybox umount:
>> 1. force umount (umount -f): it does not work as expected.
>> 2. lazy umount(umount -l): it detaches the mount point but waits for
>> current mount point users(processes) to finish.
>> Corruption happens when we powerdown, while lazy umount is waiting for
>> a process to finish.
>> (e.g. #dd if=/dev/zero of=/mnt/test.txt ).
>> What could be the ideal way so as to avoid file system corruption in
>> above scenario?
>> Is it fine to close all open file descriptors on umount system call
>> before attempting umount? But this results in OOPS in certain
>> situations like:
>> 1. User app issue a write/read request
>> 2. Write reaches in kernel space but sleeps for some time e.g. it is
>> not available in dentry cache.
>> 3. In the meanwhile, we issue umount. This will close open file
>> descriptor, free file/dentry object and then umount.
>> 4. Now write wakes up and finds NULL file/dentry object and triggers oops.
>> Please offer some advice on this issue.
>> Thanks & Regards,
>> Amit Sahrawat
>>
>

Before close opend file, plz try to flush write request using
sys_fsync or etc.. and you should do mutex_lock about opened inode at
the same time. because next write request should be blocked by user
app.
