Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757477Ab2IGHHa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Sep 2012 03:07:30 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48174 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753182Ab2IGHH2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Sep 2012 03:07:28 -0400
MIME-Version: 1.0
In-Reply-To: <CAKYAXd_mxq26bhRYd-YM9OBjYMO12TD4wHxm6PqHBLjgGFHaZg@mail.gmail.com>
References: <1346774264-8031-1-git-send-email-linkinjeon@gmail.com>
	<20120904161747.GJ23464@ZenIV.linux.org.uk>
	<CAKYAXd_wTxqbC-UxYimCkZtvSddx=f3FG0hoiEY_doMjoxkKog@mail.gmail.com>
	<87harc34d9.fsf@devron.myhome.or.jp>
	<CAKYAXd-8aztDe1QiFT=NSQX8J+h_FM+cAWwo+Q+fUQHpNGTctw@mail.gmail.com>
	<87y5knz6l5.fsf@devron.myhome.or.jp>
	<CAKYAXd_mxq26bhRYd-YM9OBjYMO12TD4wHxm6PqHBLjgGFHaZg@mail.gmail.com>
Date: Fri, 7 Sep 2012 16:01:43 +0900
Message-ID: <CAKYAXd-QtSYy4SQErVTXrxcv=YhFzhOm3PKpj=HoZKmpAG7vGQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Al Viro <viro@zeniv.linux.org.uk>, akpm@linux-foundation.org,
        bfields@fieldses.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi. OGAWA.

I checked read-only option for export on FAT.
I think that there are 3 approaches as mentioned below.

1. As per the current scenario – user already has the option of
setting ‘ro’ in /etc/exports – so that can also be used to make it
read-only.
	
2. Forcefully set to “read-only” while executing FAT export operation.
-> As you know, we can set read-only(ro) export in /etc/exports.
If we set read-only export regardless of /etc/exports, This is "HACK"
and it will work regardless of user setting.

3. When FAT is mounted with -onfs option,-> Make it ‘ro’ at the mount
time itself.
-> It is simple to implement, but VFAT of NFS Server will be set to
read-only as well as NFS client.

4. As already suggested – only problem left now is of ‘RENAME’ all
other points can be taken care in the current solution. So, how about
putting RENAME as a limitation? or we can return EBUSY about rename
case to avoid collision.

Let me know which approach you prefer. Especially through more
insights on ‘rename’ part as all through the discussion this has been
the bottleneck part left now. And sincerely fruitful discussion on
this ‘rename’ might result in stable FAT over NFS.

Please let me know your opinion.

Thanks.
2012/9/6, Namjae Jeon <linkinjeon@gmail.com>:
> 2012/9/6 OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
>> Namjae Jeon <linkinjeon@gmail.com> writes:
>>
>>>>> In this long discusstion about the FAT acceptance over NFS, our belief
>>>>> is still that the objective should be to reduce errors as much as
>>>>> possible and then if there are certain scenarios - at least that could
>>>>> be highlighted as a limitation in Documentation instead of completely
>>>>> discarding the usage of FAT over NFS.  So how about puttting rename
>>>>> scenario as a limitation ? In ideal scenario how many times this is
>>>>> going to happen ?
>>>>
>>>> My understanding of your patches is to introduce the silent corruption
>>>> bug by getting wrong location via ino on some cases, instead of
>>>> ESTALE. And make surprise to userland by change ino.
>>>>
>>>> Why is it safe to change ino? If you are saying to remove the changing
>>>> ino on rename, how handle the case of collision?
>>> Yes, agreed this would lead to collision. So, If we are choosing
>>> 'i_pos' as inode
>>> number, We need to have a mechanism to avoid this 'i_pos' being reused.
>>>
>>> We can have one thing over here. As a part of avoidance for such
>>> scenarios -
>>> We can return EBUSY for this rename operation. i.e., If the inode is
>>> being
>>> referenced then in such cases it makes sense to return EBUSY over NFS
>>> and
>>>  forcus on the large part of the solution which is making FAT stable.
>>>
>>> Let me know your opinion.
>>
>> It sounds like sane to provide the limited but stable behavior, with the
>> option. But at first, I'd like to see the read-only export but clean
>> solution, and make it stable. (I'm not thinking about the implementation
>> detail. It may be the stable ino solution, or may not be.)
> Hi. OGAWA.
> I Agree. Once, I will check whether it is possible to implement
> read-only export or not.
> And If I face some problem or have some concern, I will discuss about
> it with you.
>
>>
>> After that, we can make it writable incrementally.
> Okay.
> Thanks a lot.
>> --
>> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
