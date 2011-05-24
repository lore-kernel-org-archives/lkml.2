Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752926Ab1EXGj2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 02:39:28 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:42774 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384Ab1EXGj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 02:39:26 -0400
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
Date: Tue, 24 May 2011 15:39:22 +0900
In-Reply-To: <BANLkTi=7C3Lv2WkPoZzBCh2S87cVFcbp3Q@mail.gmail.com> (Kyungmin
	Park's message of "Tue, 24 May 2011 14:21:50 +0900")
Message-ID: <87r57ok3fp.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park <kmpark@infradead.org> writes:

>>> Do you still object to merge this feature for .40? As I said the
>>> batched discard design is out-of-scope of this patch.
>>> It's implemented at other batched discard, ext4, xfs and so on.
>>>
>>> I hope fat is also support the batched discard.
>>>
>>> Any opinions?
>>
>> I'm also thinking implementing this is good though. Sorry, I'm not going
>> to apply this for now, and would like to wait to be used by real
>> userland (I hope guys notice the problem, or userland tackles it somehow
>> sadly).
>>
>> I think, to expose the wrong behavior like this would be worse.
>>
>> E.g. one of problems, userland might do like this (trim chunk from 0 to
>> number of block)
>>
>> for chunk in number_of_blocks
>>        do_trim chunk
>> done
>
> It's handled at trim implementation. It just trim the fat aware block.
> Not trim the blocks which fat doesn't know.
> As fat don't use the block 0, 1, it adjust the start block at kernel.
>
> +       if (start < FAT_START_ENT)
> +               start = FAT_START_ENT;
>
> and don't exceed the max cluster size.
>
> +       len = (len > sbi->max_cluster) ? sbi->max_cluster : len;
>
> +       for (count = start; count <= len; count++) {

Yes. We _adjust_ from 0 to 2 here, so, the end of block also have to be
_adjusted_.

>From other point of view, if userland specified 0 - max-length
(i.e. number of blocks), what happens? It would trim block of 2 -
(max-length - 2), right?

So, actually, userland specify 2 - (max-length + 2). And userland has to
know 2 is real start, not 0.

But how to know it? Yes, it's FS internal layout, AFAICS, other FSes also
expose internal like this.

>> But this is actually wrong, this interface doesn't map blocks to 0-max,
>> so userland have to know real maximum-block-number somehow for each FS
>> (and maybe have to know real minimum-block-number).
>>
>> So, how to fix this? The solutions would be userland workaround, or fix
>> kernel. If it was userland, userland have to know FS internal sadly. If
>> it was kernel, we would have backward compatible nightmare, or ignore
>> compatible :(.
>
> I think basic concept of batched discard is trim at once instead of
> deleted entries at filesystem (original one).
> So it can set the specific start address or any start (usually 0) with
> maximum length.

Yes, I think so too (i.e. 0 - max length). But the implement is not
working like it. It exposes FS internal layout.

>> I really think we have to rethink this and have agreement about common
>> interface. Or there was real userland app, I think FAT can implement to
>> work that app.
>
> IMO, we should use the same user space application. user program
> doesn't know the which filesystem are underlying.

Indeed.

> So sample user space program used at ext4, xfs should be used. and I
> tested it.

I bet it doesn't trim whole FS (due to expose FS layout) actually even
if user asked like above example.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
