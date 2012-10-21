Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab2JUXyZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Oct 2012 19:54:25 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:53259 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753497Ab2JUXyX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Oct 2012 19:54:23 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] fat: editions to support fat_fallocate()
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
	<87lif958lb.fsf@devron.myhome.or.jp>
	<CAKYAXd9CQoYBHb0S4bpU0-6QMwMvfC7m=RhDCYPzKwXfvu7VKw@mail.gmail.com>
	<87txtu206u.fsf@devron.myhome.or.jp>
	<CAKYAXd_R=FRv8+0uATLSG+JLSm7Vkb4g+_qRkqpaDf8vM4Fpdg@mail.gmail.com>
Date: Mon, 22 Oct 2012 08:54:19 +0900
In-Reply-To: <CAKYAXd_R=FRv8+0uATLSG+JLSm7Vkb4g+_qRkqpaDf8vM4Fpdg@mail.gmail.com>
	(Namjae Jeon's message of "Wed, 17 Oct 2012 19:57:53 +0900")
Message-ID: <878vazl6tw.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> The expectation of fallocate() is just for space reservation? If it was
>> just for space reservation, I'm not sure, why TV applications can't
>> reserve in userland without any kernel help (I wonder who interrupts TV
>> application). I feel a bit, it may be more lightweight than fallocate(),
>> and more reliable than out of spec fallocate().
>>
>> I'm still not sure why apps really want fallocate() on FAT.
> Yes, it is for user space reservation.
>
>>From the application perspective it is needed to realize in advance
> how much space is needed for that file write – so the requirement is
> precisely that the space reserved is entirely for me and no other I/O
> operation in that time should consume the space.
>
> Of course, as you said, space can be pre-allocated from user space by
> doing expanding truncate.
> Main drawbacks for reserving through USER space:
> 1) If we need to allocate 1GB space -> seek (1GB) and write -> it will
> ZEROUT the 1GB area (which is very time consuming) just for reserving
> space.
> 2) The Application must always be aware of the SEEK OFFSET - otherwise
> the APPEND WRITE will never occur and file is closed/opened (Append
> mode) again for writing – it will instead start writing from the end
> of file which is past the reserved space. So, this will also result in
> losing space in such case – if application is not keeping track of
> OFFSET
> 3) If suppose from user space we are doing expanding truncate of 1GB
> and suppose it fails after 256MB of allocation - in that case it did
> allocation of 256MB blocks - did ZEROUT for all these blocks and then
> returned failure - which is not optimal for just allocation of space.
>
> While if we make use of FALLOCATE
> 1)	It allows reserving the space in advance without any delay.
> 2)	Since, the space is reserved in advance. So, if suppose space is
> reserved for 1hour TV recording than any other application in the
> background cannot cause recording to fail in case of “no free space”
> left as it already pre-allocated space. Only other Applications will
> close.
> 3)	It allows for APPEND write to continue smoothly without actually
> keeping track of the file state, offset.
> 4)	Initially when the disk is not fragmented. It allows the
> possibility to get contiguous blocks and thus reducing fragmentation
> for that file.

OK.

Should TV recorder make sure it is reserving space with fallocate() for
each open() (or first open() after mount())? What fsck is going to do?
Or how to know fallocated space or corrupted space?

Does this break the linux fat driver doesn't know about this
fallocate()?  If so, it sounds like to be easy to break existent
drivers.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
