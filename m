Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755166Ab1EXIyi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 04:54:38 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:49436 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754798Ab1EXIyg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 04:54:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=NWtdwwyYXKfb0nbHf5HV8TAhR/yy+Q8yH9fzEn9bO1LxHVJ3B5WlNlvkr9mJg67vpW
         DWUym9M4iNWjHMV9y1mTn77Fwpnqhj6aBLcDMKV0nvPsa3Qb9rmUzXtJidnSmGDghtHJ
         630jF2egtAVc3JazhJcBXfwyK4ona1IHdrrs4=
MIME-Version: 1.0
In-Reply-To: <87mxick0zj.fsf@devron.myhome.or.jp>
References: <20110328103431.GA22323@july>
	<201103301620.50263.arnd@arndb.de>
	<AANLkTi=QVe0UK3Q_xKG17_aHH7g4Y=miWu7UT7ogisyP@mail.gmail.com>
	<201103301706.36214.arnd@arndb.de>
	<BANLkTi=DizSrow6hW6QGZcP=ios7BDshUQ@mail.gmail.com>
	<87wrhgk8lp.fsf@devron.myhome.or.jp>
	<BANLkTi=7C3Lv2WkPoZzBCh2S87cVFcbp3Q@mail.gmail.com>
	<87r57ok3fp.fsf@devron.myhome.or.jp>
	<BANLkTi=i5S1Pj6xOm1cY1XSUxx0jByq+JQ@mail.gmail.com>
	<87mxick0zj.fsf@devron.myhome.or.jp>
Date: Tue, 24 May 2011 17:54:35 +0900
X-Google-Sender-Auth: rr6LMnglK5nBa00ni6L4gq3n8hc
Message-ID: <BANLkTiktjZ3ezpN0HuviWGzjoWUKqtXjZA@mail.gmail.com>
Subject: Re: [PATCH v6] fat: Batched discard support for fat
From: Kyungmin Park <kmpark@infradead.org>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: Arnd Bergmann <arnd@arndb.de>, Lukas Czerner <lczerner@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 4:32 PM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
> Kyungmin Park <kmpark@infradead.org> writes:
>
>>>> It's handled at trim implementation. It just trim the fat aware block.
>>>> Not trim the blocks which fat doesn't know.
>>>> As fat don't use the block 0, 1, it adjust the start block at kernel.
>>>>
>>>> +       if (start < FAT_START_ENT)
>>>> +               start = FAT_START_ENT;
>>>>
>>>> and don't exceed the max cluster size.
>>>>
>>>> +       len = (len > sbi->max_cluster) ? sbi->max_cluster : len;
>>>>
>>>> +       for (count = start; count <= len; count++) {
>>>
>>> Yes. We _adjust_ from 0 to 2 here, so, the end of block also have to be
>>> _adjusted_.
>>>
>>> From other point of view, if userland specified 0 - max-length
>>> (i.e. number of blocks), what happens? It would trim block of 2 -
>>> (max-length - 2), right?
>>
>> No, length is not changed. so max-length is used.
>
> No, no. Userland will know max-length from statvfs, right? So, let's
> assume it is 100 (->f_blocks) * 1024 (->f_bsize).
>
> Now, userland know about max length, 102400, ok? Let's start to trim.
>
> Assume, userland want to trim whole. So, userland will specify like
>
>        trim(0, 102400).
>
> What happen in kernel actually?
>
> Current implement doesn't map blocks. So, in the case of FAT, it adjusts
> from 0 to 2 * 1024.
>
> So, it trims between 2048 and 102400. The problem is here. FS layout is
> actually, 2048 and (102400 + 2048). I.e. actually userland has to do
>
>        trim(2048, 102400 + 2048)

Umm maybe first implementation does as like this, but Lukas mentioned
it's wrong. So I modified it for batched discard concept.

You want the loop like this

for (count = start; count <= (start + len); count++)

>
> to specify whole. How to know 2048?
>
> See what I'm saying?
>
> FAT has liner block space, so the problem is small against mapping. But
> other FSes has bigger problem.
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
