Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755641Ab1EXJpG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 05:45:06 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:47272 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751832Ab1EXJpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 05:45:04 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Kyungmin Park <kmpark@infradead.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Lukas Czerner <lczerner@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH v6] fat: Batched discard support for fat
References: <20110328103431.GA22323@july> <201103301620.50263.arnd@arndb.de>
	<AANLkTi=QVe0UK3Q_xKG17_aHH7g4Y=miWu7UT7ogisyP@mail.gmail.com>
	<201103301706.36214.arnd@arndb.de>
	<BANLkTi=DizSrow6hW6QGZcP=ios7BDshUQ@mail.gmail.com>
	<87wrhgk8lp.fsf@devron.myhome.or.jp>
	<BANLkTi=7C3Lv2WkPoZzBCh2S87cVFcbp3Q@mail.gmail.com>
	<87r57ok3fp.fsf@devron.myhome.or.jp>
	<BANLkTi=i5S1Pj6xOm1cY1XSUxx0jByq+JQ@mail.gmail.com>
	<87mxick0zj.fsf@devron.myhome.or.jp>
	<BANLkTiktjZ3ezpN0HuviWGzjoWUKqtXjZA@mail.gmail.com>
Date: Tue, 24 May 2011 18:44:59 +0900
In-Reply-To: <BANLkTiktjZ3ezpN0HuviWGzjoWUKqtXjZA@mail.gmail.com> (Kyungmin
	Park's message of "Tue, 24 May 2011 17:54:35 +0900")
Message-ID: <87ei3ojuuc.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park <kmpark@infradead.org> writes:

>>> No, length is not changed. so max-length is used.
>>
>> No, no. Userland will know max-length from statvfs, right? So, let's
>> assume it is 100 (->f_blocks) * 1024 (->f_bsize).
>>
>> Now, userland know about max length, 102400, ok? Let's start to trim.
>>
>> Assume, userland want to trim whole. So, userland will specify like
>>
>>        trim(0, 102400).
>>
>> What happen in kernel actually?
>>
>> Current implement doesn't map blocks. So, in the case of FAT, it adjusts
>> from 0 to 2 * 1024.
>>
>> So, it trims between 2048 and 102400. The problem is here. FS layout is
>> actually, 2048 and (102400 + 2048). I.e. actually userland has to do
>>
>>        trim(2048, 102400 + 2048)
>
> Umm maybe first implementation does as like this, but Lukas mentioned
> it's wrong. So I modified it for batched discard concept.

I don't know what Lukas thought/said though, I hope he notices the
problem if real app started to use. Or I'd like to know how to work
without the knowledge of FS internal.

> You want the loop like this
>
> for (count = start; count <= (start + len); count++)

I'm not sure this loop is what doing from the above example. Like I said
in previous thread, I'd like to see liner mapping from 0 like simply
regular file in _all_FSes_. If I read ext* correctly, it was hell of raw
FS layout.

I.e. FAT has from "2 - (2 + number_of_blocks)" layout, in FAT case, I
think it should map to "0 to number_of_block", and expose as liner from 0.

But, it should be for all FSes, otherwise there is no benefit for
userland. If there is exception, userland would has to know FS internal
after all.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
