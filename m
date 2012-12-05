Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752672Ab2LEML3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 07:11:29 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:45662 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab2LEML2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 07:11:28 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v5 5/8] fat: restructure export_operations
References: <1353504277-5947-1-git-send-email-linkinjeon@gmail.com>
	<87hao35uqz.fsf@devron.myhome.or.jp>
	<CAKYAXd_X8Jkq=PdV+dVPTO_EAPHoZ37MynpjvkrPTDahWyUOTA@mail.gmail.com>
	<87obia17zr.fsf@devron.myhome.or.jp>
	<CAKYAXd-8ay4m6vsH1ztmomOrnXN+ThDi3w+jASyyUGOO12v6YA@mail.gmail.com>
	<871uf4yizs.fsf@devron.myhome.or.jp>
	<CAKYAXd_T2yGRXd3bk5HXXuVhx_ikO1xzinOy0d8TobokyiCRsA@mail.gmail.com>
Date: Wed, 05 Dec 2012 21:11:22 +0900
In-Reply-To: <CAKYAXd_T2yGRXd3bk5HXXuVhx_ikO1xzinOy0d8TobokyiCRsA@mail.gmail.com>
	(Namjae Jeon's message of "Wed, 5 Dec 2012 20:45:40 +0900")
Message-ID: <87pq2owvf9.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> I can understand what is doing. I'm asking why there is difference.
>>
>> 1) generic_fh_to_dentry() allows (*_PARENT && fh_len == 2).
>> 2) fat_fh_to_dentry_nostale() doesn't allows (*_PARENT && fh_len == 3).
>>
>> Why does logic has difference?
>
> When we consider the generic routine of encode_fh() and the structure ‘fid’
>
> struct fid {
>       struct {
>             u32 ino;
>             u32 gen;
>             u32 parent_ino;
>             u32 parent_gen;
>       } i32;
> };
>
> fh_len= 2(without parent)
> fh_len=4(with parent)
>
> Condition checking in export_encode_fh()
> {
>
>    if (parent && (len < 4)) {
>                 *max_len = 4;
>                 return FILEID_INVALID;
>         } else if (len < 2) {
>                 *max_len = 2;
>                 return FILEID_INVALID;
>         }
>         ...
>                 len = 2;
>         ...
>                 if (parent) {
> ..
>                                 len = 4;
>                                 type = FILEID_INO32_GEN_PARENT;
>                 }
> …
> }
>
> The logic does take care of altering the length for the ‘2’ cases
> with/without parent.
> So, while encoding -> the care has been taken for length checking but
> while decoding(generic_fh_to_dentry) the length check is not put in
> place.
> I think it should be done in the generic routine also.
>
> It should be:
> if ((fh_len != 2 && fh_len != 4) ||
>                 (fh_type != FILEID_INO32_GEN && fh_type !=
> FILEID_INO32_GEN_PARENT))
>     return NULL;
>
> Please share your opinion.

I know encode_fh(). But NFS is network protocol, and network can input
any data, and I guess the userland interface (open_by_handle()?) can be
any too.

And generic_fh_to_dentry()'s input verify choose to check the minimum
length only. But your logic choose the exact length.

I think the both is sane and correct. But I wonder why did you changed it.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
