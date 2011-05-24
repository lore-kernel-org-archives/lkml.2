Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753913Ab1EXHcU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 03:32:20 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:55870 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab1EXHcT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 03:32:19 -0400
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
Date: Tue, 24 May 2011 16:32:16 +0900
In-Reply-To: <BANLkTi=i5S1Pj6xOm1cY1XSUxx0jByq+JQ@mail.gmail.com> (Kyungmin
	Park's message of "Tue, 24 May 2011 15:55:34 +0900")
Message-ID: <87mxick0zj.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park <kmpark@infradead.org> writes:

>>> It's handled at trim implementation. It just trim the fat aware block.
>>> Not trim the blocks which fat doesn't know.
>>> As fat don't use the block 0, 1, it adjust the start block at kernel.
>>>
>>> +       if (start < FAT_START_ENT)
>>> +               start = FAT_START_ENT;
>>>
>>> and don't exceed the max cluster size.
>>>
>>> +       len = (len > sbi->max_cluster) ? sbi->max_cluster : len;
>>>
>>> +       for (count = start; count <= len; count++) {
>>
>> Yes. We _adjust_ from 0 to 2 here, so, the end of block also have to be
>> _adjusted_.
>>
>> From other point of view, if userland specified 0 - max-length
>> (i.e. number of blocks), what happens? It would trim block of 2 -
>> (max-length - 2), right?
>
> No, length is not changed. so max-length is used.

No, no. Userland will know max-length from statvfs, right? So, let's
assume it is 100 (->f_blocks) * 1024 (->f_bsize).

Now, userland know about max length, 102400, ok? Let's start to trim.

Assume, userland want to trim whole. So, userland will specify like

	trim(0, 102400).

What happen in kernel actually?

Current implement doesn't map blocks. So, in the case of FAT, it adjusts
from 0 to 2 * 1024.

So, it trims between 2048 and 102400. The problem is here. FS layout is
actually, 2048 and (102400 + 2048). I.e. actually userland has to do

	trim(2048, 102400 + 2048)

to specify whole. How to know 2048?

See what I'm saying?

FAT has liner block space, so the problem is small against mapping. But
other FSes has bigger problem.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
