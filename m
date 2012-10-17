Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756480Ab2JQK55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 06:57:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:51091 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2JQK5z convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 06:57:55 -0400
MIME-Version: 1.0
In-Reply-To: <87txtu206u.fsf@devron.myhome.or.jp>
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
	<87lif958lb.fsf@devron.myhome.or.jp>
	<CAKYAXd9CQoYBHb0S4bpU0-6QMwMvfC7m=RhDCYPzKwXfvu7VKw@mail.gmail.com>
	<87txtu206u.fsf@devron.myhome.or.jp>
Date: Wed, 17 Oct 2012 19:57:53 +0900
Message-ID: <CAKYAXd_R=FRv8+0uATLSG+JLSm7Vkb4g+_qRkqpaDf8vM4Fpdg@mail.gmail.com>
Subject: Re: [PATCH v2] fat: editions to support fat_fallocate()
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/16, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>> What is real usage pattern of persistent across remounts on FAT?
>> Yes,  like a TORRENT FILE -> it reserves space in advance
>> even though the system can be rebooted/disk unmounted and remount
>> but the space still remains there - as long as the torrent exists
>> Or if Torrent case does not matches currently
>> Then, Consider a case for a TV series to be recorded
>> Since – we want all the parts to be recorded on the same file (i.e.,
>> APPEND write) – and in such cases there are chances of TV shutdown,
>> device unmount-mount again. So, we need to have the space to be remain
>> available in such cases.
>
> The expectation of fallocate() is just for space reservation? If it was
> just for space reservation, I'm not sure, why TV applications can't
> reserve in userland without any kernel help (I wonder who interrupts TV
> application). I feel a bit, it may be more lightweight than fallocate(),
> and more reliable than out of spec fallocate().
>
> I'm still not sure why apps really want fallocate() on FAT.
Yes, it is for user space reservation.

>From the application perspective it is needed to realize in advance
how much space is needed for that file write – so the requirement is
precisely that the space reserved is entirely for me and no other I/O
operation in that time should consume the space.

Of course, as you said, space can be pre-allocated from user space by
doing expanding truncate.
Main drawbacks for reserving through USER space:
1) If we need to allocate 1GB space -> seek (1GB) and write -> it will
ZEROUT the 1GB area (which is very time consuming) just for reserving
space.
2) The Application must always be aware of the SEEK OFFSET - otherwise
the APPEND WRITE will never occur and file is closed/opened (Append
mode) again for writing – it will instead start writing from the end
of file which is past the reserved space. So, this will also result in
losing space in such case – if application is not keeping track of
OFFSET
3) If suppose from user space we are doing expanding truncate of 1GB
and suppose it fails after 256MB of allocation - in that case it did
allocation of 256MB blocks - did ZEROUT for all these blocks and then
returned failure - which is not optimal for just allocation of space.

While if we make use of FALLOCATE
1)	It allows reserving the space in advance without any delay.
2)	Since, the space is reserved in advance. So, if suppose space is
reserved for 1hour TV recording than any other application in the
background cannot cause recording to fail in case of “no free space”
left as it already pre-allocated space. Only other Applications will
close.
3)	It allows for APPEND write to continue smoothly without actually
keeping track of the file state, offset.
4)	Initially when the disk is not fragmented. It allows the
possibility to get contiguous blocks and thus reducing fragmentation
for that file.

Thanks.
>
>>> If once device was unmounted, we can't know the state of FS anymore,
>>> there are
>>> many implementations of FAT. And preallocation is not in the spec.
>> I agree, As you said before, we can make fat fallocate feature as
>> configurable – so this is entirely in the hands of USER.
>>>
>>> I worry to break something. And I guess the freeing preallocation on
>>> last close may fix the issue for usage.
>> Okay, we can avoid most of your concerns except suddenly unplugging usb
>> device.
>> But fallocate behavior will be different with other filesystem.
>>
>> How about to make fat fallocate with configuration to be used by users
>> is having needs?
>
> Hmm... I'm not still convinced to add makes really apps happy. Maybe,
> I'm sill not understanding your usage. I think the out of spec feature
> wouldn't be added if it was just a "better than nothing".
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
