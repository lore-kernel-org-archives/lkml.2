Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755925Ab1C3NW0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:22:26 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52828 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754657Ab1C3NWY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:22:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kyungmin Park <kmpark@infradead.org>
Subject: Re: [PATCH v6] fat: Batched discard support for fat
Date: Wed, 30 Mar 2011 15:22:18 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
References: <20110328103431.GA22323@july>
In-Reply-To: <20110328103431.GA22323@july>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103301522.18836.arnd@arndb.de>
X-Provags-ID: V02:K0:GCeYKNe4a1EGLMUlXRdSoL/bweViWova3xO44Y+4/fG
 huvQVeOSXYDMCEQiCM3042lQT76fUFR50pAZQBTlfgs5ko+u/A
 qwy9+Vd5y/F/7rIWlZL0NIwMIk32iJDoIZyq4DV5m7JeHkpjzG
 +2DLpGnnOU4L72orJWkkdsccwFt5uXLhq1NFaxax55x/WbDqp8
 7SOhfiPVJemvpqvW2tsCA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 March 2011, Kyungmin Park wrote:
> So you will go through (blocks, bytes...) 0 -> 20
> 
>   OOOO==O===OO===OOOOO==O===O===OOOOOOO===
>   ^                   ^
>   0                   20
> 
> So, you will call discard on extents:
> 
> 0-3
> You'll skip 6 because is smaller than minlen
> 10-11
> 15-19
> 
> instead of 
> 
> 0-3
> 10-11
> 15-19
> 30-36

Sorry for joining the discussion late, but shouldn't you also pass
the alignment of the discards?

FAT is typically used on cheap media that have very limited support
for garbage-collection, such as eMMC or SD cards.

On most SDHC cards, you only ever want to issue discard on full erase
blocks (allocation units per spec), typically sized 4 MB.

If you just pass the minimum length, the file system could end up
erasing a 4 MB section that spans two half erase blocks, or it
could span a few clusters of the following erase block, both of
which is not desirable from a performance point of view.

On other media, you have the same problem inside an erase block:
These might be able to discard parts of an erase block efficiently,
but normally not less than a flash page (typically 8 to 32 KB).

Again, you don't want to discard partial pages in this case, and
that is much more important than discarding a large number of pages
because it would result in an immediate copy-on-write operation.

Further, when you erase some pages inside of an erase block, you
probably should not span multiple erase blocks but instead issue
separate requests for each set of pages in one erase block.

	Arnd

	Arnd
