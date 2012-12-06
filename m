Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932361Ab2LFHho (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 02:37:44 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60781 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932316Ab2LFHhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 02:37:42 -0500
MIME-Version: 1.0
In-Reply-To: <87pq2owvf9.fsf@devron.myhome.or.jp>
References: <1353504277-5947-1-git-send-email-linkinjeon@gmail.com>
	<87hao35uqz.fsf@devron.myhome.or.jp>
	<CAKYAXd_X8Jkq=PdV+dVPTO_EAPHoZ37MynpjvkrPTDahWyUOTA@mail.gmail.com>
	<87obia17zr.fsf@devron.myhome.or.jp>
	<CAKYAXd-8ay4m6vsH1ztmomOrnXN+ThDi3w+jASyyUGOO12v6YA@mail.gmail.com>
	<871uf4yizs.fsf@devron.myhome.or.jp>
	<CAKYAXd_T2yGRXd3bk5HXXuVhx_ikO1xzinOy0d8TobokyiCRsA@mail.gmail.com>
	<87pq2owvf9.fsf@devron.myhome.or.jp>
Date: Thu, 6 Dec 2012 16:37:41 +0900
Message-ID: <CAKYAXd-CAhBDNYRTF22Yh8iGDb1_6+0V-U2wJsSuAjU3Q4q-SQ@mail.gmail.com>
Subject: Re: [PATCH v5 5/8] fat: restructure export_operations
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/12/5, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>> I can understand what is doing. I'm asking why there is difference.
>>>
>>> 1) generic_fh_to_dentry() allows (*_PARENT && fh_len == 2).
>>> 2) fat_fh_to_dentry_nostale() doesn't allows (*_PARENT && fh_len == 3).
>>>
>>> Why does logic has difference?
>>
>> When we consider the generic routine of encode_fh() and the structure
>> ‘fid’
>>
>> struct fid {
>>       struct {
>>             u32 ino;
>>             u32 gen;
>>             u32 parent_ino;
>>             u32 parent_gen;
>>       } i32;
>> };
>>
>> fh_len= 2(without parent)
>> fh_len=4(with parent)
>>
>> Condition checking in export_encode_fh()
>> {
>>
>>    if (parent && (len < 4)) {
>>                 *max_len = 4;
>>                 return FILEID_INVALID;
>>         } else if (len < 2) {
>>                 *max_len = 2;
>>                 return FILEID_INVALID;
>>         }
>>         ...
>>                 len = 2;
>>         ...
>>                 if (parent) {
>> ..
>>                                 len = 4;
>>                                 type = FILEID_INO32_GEN_PARENT;
>>                 }
>> …
>> }
>>
>> The logic does take care of altering the length for the ‘2’ cases
>> with/without parent.
>> So, while encoding -> the care has been taken for length checking but
>> while decoding(generic_fh_to_dentry) the length check is not put in
>> place.
>> I think it should be done in the generic routine also.
>>
>> It should be:
>> if ((fh_len != 2 && fh_len != 4) ||
>>                 (fh_type != FILEID_INO32_GEN && fh_type !=
>> FILEID_INO32_GEN_PARENT))
>>     return NULL;
>>
>> Please share your opinion.
>
> I know encode_fh(). But NFS is network protocol, and network can input
> any data, and I guess the userland interface (open_by_handle()?) can be
> any too.
>
> And generic_fh_to_dentry()'s input verify choose to check the minimum
> length only. But your logic choose the exact length.
>
> I think the both is sane and correct. But I wonder why did you changed it.
There was no particular reason for us to put those conditions. It is
just we knew what fh lengths we have chosen for the 2 cases
WITH/WITHOUT parent.
i.e., we checked with encoded length.
Now, when I check the export functions of other filesystems(btrfs,
nilfs2, udf). They also adopt the same method of checking the exact
length and type.
If there is any particular reason, we will look into that and can also
updated on that.

Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
