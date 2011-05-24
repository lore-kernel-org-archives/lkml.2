Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752841Ab1EXFXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 01:23:46 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:59823 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752093Ab1EXFVv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 01:21:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=jK3S7Yu76tS1KfluYdd7OtHjKj1MJdkBOehpe53C543cN1D3MJiPP702HPQr4zKtUF
         zB0KnlE5wLBGhh7e08EfHLciO+Bt8/Z6RVQTb2GBMyePpk3YYvtWgwclT0heMPB/XySr
         IAQEubycSK4KtkGqjvxlADTo+jea7sj1KCLVU=
MIME-Version: 1.0
In-Reply-To: <87wrhgk8lp.fsf@devron.myhome.or.jp>
References: <20110328103431.GA22323@july>
	<201103301620.50263.arnd@arndb.de>
	<AANLkTi=QVe0UK3Q_xKG17_aHH7g4Y=miWu7UT7ogisyP@mail.gmail.com>
	<201103301706.36214.arnd@arndb.de>
	<BANLkTi=DizSrow6hW6QGZcP=ios7BDshUQ@mail.gmail.com>
	<87wrhgk8lp.fsf@devron.myhome.or.jp>
Date: Tue, 24 May 2011 14:21:50 +0900
X-Google-Sender-Auth: c99RP6HfeXAILX1LTT8T2QTiCxE
Message-ID: <BANLkTi=7C3Lv2WkPoZzBCh2S87cVFcbp3Q@mail.gmail.com>
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

On Tue, May 24, 2011 at 1:47 PM, OGAWA Hirofumi
<hirofumi@mail.parknet.co.jp> wrote:
> Kyungmin Park <kmpark@infradead.org> writes:
>
>> Hi again,
>
> Hi
>
>> Do you still object to merge this feature for .40? As I said the
>> batched discard design is out-of-scope of this patch.
>> It's implemented at other batched discard, ext4, xfs and so on.
>>
>> I hope fat is also support the batched discard.
>>
>> Any opinions?
>
> I'm also thinking implementing this is good though. Sorry, I'm not going
> to apply this for now, and would like to wait to be used by real
> userland (I hope guys notice the problem, or userland tackles it somehow
> sadly).
>
> I think, to expose the wrong behavior like this would be worse.
>
> E.g. one of problems, userland might do like this (trim chunk from 0 to
> number of block)
>
> for chunk in number_of_blocks
>        do_trim chunk
> done

It's handled at trim implementation. It just trim the fat aware block.
Not trim the blocks which fat doesn't know.
As fat don't use the block 0, 1, it adjust the start block at kernel.

+       if (start < FAT_START_ENT)
+               start = FAT_START_ENT;

and don't exceed the max cluster size.

+       len = (len > sbi->max_cluster) ? sbi->max_cluster : len;

+       for (count = start; count <= len; count++) {

>
> But this is actually wrong, this interface doesn't map blocks to 0-max,
> so userland have to know real maximum-block-number somehow for each FS
> (and maybe have to know real minimum-block-number).
>
> So, how to fix this? The solutions would be userland workaround, or fix
> kernel. If it was userland, userland have to know FS internal sadly. If
> it was kernel, we would have backward compatible nightmare, or ignore
> compatible :(.

I think basic concept of batched discard is trim at once instead of
deleted entries at filesystem (original one).
So it can set the specific start address or any start (usually 0) with
maximum length.

>
> I really think we have to rethink this and have agreement about common
> interface. Or there was real userland app, I think FAT can implement to
> work that app.

IMO, we should use the same user space application. user program
doesn't know the which filesystem are underlying.
So sample user space program used at ext4, xfs should be used. and I tested it.

Thank you,
Kyungmin Park
