Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751984Ab2BQNGT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 08:06:19 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48540 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464Ab2BQNGS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 08:06:18 -0500
MIME-Version: 1.0
In-Reply-To: <20120216151425.GB19158@phenom.ffwll.local>
References: <1329393696-4802-1-git-send-email-daniel.vetter@ffwll.ch>
	<1329393696-4802-2-git-send-email-daniel.vetter@ffwll.ch>
	<CAJd=RBBr4EkCwAaS3xZZrm0QE71Z0soyZXTuwXyBn6ohp3pU2Q@mail.gmail.com>
	<20120216151425.GB19158@phenom.ffwll.local>
Date: Fri, 17 Feb 2012 21:06:17 +0800
Message-ID: <CAJd=RBDFUZi3_tk2ZRpjF=5a9884zJGv4Ti_kM0pjXnRmw0jKA@mail.gmail.com>
Subject: Re: [PATCH] mm: extend prefault helpers to fault in more than PAGE_SIZE
From: Hillf Danton <dhillf@gmail.com>
To: Hillf Danton <dhillf@gmail.com>, Andrew Morton <akpm@linux-foundation.org>,
        Intel Graphics Development <intel-gfx@lists.freedesktop.org>,
        DRI Development <dri-devel@lists.freedesktop.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q1HD6UGj032126

On Thu, Feb 16, 2012 at 11:14 PM, Daniel Vetter <daniel@ffwll.ch> wrote:
> On Thu, Feb 16, 2012 at 09:32:08PM +0800, Hillf Danton wrote:
>> On Thu, Feb 16, 2012 at 8:01 PM, Daniel Vetter <daniel.vetter@ffwll.ch> wrote:
>> > @@ -416,17 +417,20 @@ static inline int fault_in_pages_writeable(char __user *uaddr, int size)
>> > Â  Â  Â  Â  * Writing zeroes into userspace here is OK, because we know that if
>> > Â  Â  Â  Â  * the zero gets there, we'll be overwriting it.
>> > Â  Â  Â  Â  */
>> > - Â  Â  Â  ret = __put_user(0, uaddr);
>> > + Â  Â  Â  while (uaddr <= end) {
>> > + Â  Â  Â  Â  Â  Â  Â  ret = __put_user(0, uaddr);
>> > + Â  Â  Â  Â  Â  Â  Â  if (ret != 0)
>> > + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  return ret;
>> > + Â  Â  Â  Â  Â  Â  Â  uaddr += PAGE_SIZE;
>> > + Â  Â  Â  }
>>
>> What if
>> Â  Â  Â  Â  Â  Â  Â uaddr & ~PAGE_MASK == PAGE_SIZE -3 &&
>> Â  Â  Â  Â  Â  Â  Â  Â  end & ~PAGE_MASK == 2
>
> I don't quite follow - can you elaborate upon which issue you're seeing?

I concerned that __put_user(0, end) is missed, but it was added below.

And looks good to me.
Hillf

> Â  Â  Â  Â if (ret == 0) {
> - Â  Â  Â  Â  Â  Â  Â  char __user *end = uaddr + size - 1;
> -
> Â  Â  Â  Â  Â  Â  Â  Â /*
> Â  Â  Â  Â  Â  Â  Â  Â  * If the page was already mapped, this will get a cache miss
> Â  Â  Â  Â  Â  Â  Â  Â  * for sure, so try to avoid doing it.
> Â  Â  Â  Â  Â  Â  Â  Â  */
> - Â  Â  Â  Â  Â  Â  Â  if (((unsigned long)uaddr & PAGE_MASK) !=
> + Â  Â  Â  Â  Â  Â  Â  if (((unsigned long)uaddr & PAGE_MASK) ==
> Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â ((unsigned long)end & PAGE_MASK))
> - Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  ret = __put_user(0, end);
> + Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  Â  ret = __put_user(0, end);
> Â  Â  Â  Â }
> Â  Â  Â  Â return ret;
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
