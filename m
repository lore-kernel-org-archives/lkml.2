Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262Ab2K1TPg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 14:15:36 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36876 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932195Ab2K1TPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 14:15:34 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
References: <CAAJw_ZtbhE5Jtd4PsWx8a23QdFTW7aMrKBmRf-bo5Wrean9Xhg@mail.gmail.com>
 <20121120180949.GG1408@quack.suse.cz> <CAAJw_ZsQdLO5qLdGPzmPf+N2D6CZw+S-4mvRGnxfARL71LuRaw@mail.gmail.com>
 <CAAJw_ZsAyB0z0TF1mqPz1Z+H+tg7W6LVzNLKf0BkuF3u8TTMuQ@mail.gmail.com>
 <CA+55aFyvT3R3kgwJzp9mY5eE1fwMnzXnmBpHSbqjd-eJRVDkJw@mail.gmail.com>
 <50AF7901.20401@kernel.dk> <CAAJw_ZvXGKcjfOAS_tRdXJ9SjpCKw1t7rNt+Q=ieCkVJwN2qcg@mail.gmail.com>
 <Pine.LNX.4.64.1211241555470.4300@file.rdu.redhat.com> <CAAJw_ZvUqRmCCQ5-2PdFPRyfdzZMuphGU=hgAjUOHGk=n9Mheg@mail.gmail.com>
 <CAAJw_ZuJXnAz1ukBwQa3xNbQaL1KUBSrbQMK2hn-7D6Ar1p3fQ@mail.gmail.com>
 <50B46E05.70906@kernel.dk> <CAAJw_ZsYuLCwCTc6U=ELO_PvyjnVKQdkPke2enfzm6zOeWAqjA@mail.gmail.com>
 <50B4B313.3030707@kernel.dk> <Pine.LNX.4.64.1211272252260.18338@file.rdu.redhat.com>
 <50B5CC5A.8060607@kernel.dk> <Pine.LNX.4.64.1211281222410.11599@file.rdu.redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 28 Nov 2012 11:15:12 -0800
X-Google-Sender-Auth: Ks1eyTRbCmHR884BbOBOck01y00
Message-ID: <CA+55aFx4zYnEsUyGJurBjB0XZ0AgmyKqW-+KWVDvma3w6csnHQ@mail.gmail.com>
Subject: Re: [PATCH] Introduce a method to catch mmap_region (was: Recent
 kernel "mount" slow)
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Chua <jeff.chua.linux@gmail.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, Jan Kara <jack@suse.cz>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, this is crap.

We don't introduce random hooks like this just because the block layer
has shit-for-brains and cannot be bothered to do things right.

The fact is, the whole locking in the block layer open routine is
total and utter crap. It doesn't lock the right thing, even with your
change *anyway* (or with the change Jens had). Absolutely nothing in
"mmap_region()" cares at all about the block-size anywhere - it's
generic, after all - so locking around it is f*cking pointless. There
is no way in hell that the caller of ->mmap can *ever* care about the
block size, since it never even looks at it.

Don't do random crap like this.

Why does the code think that mmap matters so much anyway? As you say,
the mmap itself does *nothing*. It has no impact for the block size.

                 Linus

On Wed, Nov 28, 2012 at 9:25 AM, Mikulas Patocka <mpatocka@redhat.com> wrote:
>
>
> On Wed, 28 Nov 2012, Jens Axboe wrote:
>
>> On 2012-11-28 04:57, Mikulas Patocka wrote:
>> >
>> > This patch is wrong because you must check if the device is mapped while
>> > holding bdev->bd_block_size_semaphore (because
>> > bdev->bd_block_size_semaphore prevents new mappings from being created)
>>
>> No it doesn't. If you read the patch, that was moved to i_mmap_mutex.
>
> Hmm, it was wrong before the patch and it is wrong after the patch too.
>
> The problem is that ->mmap method doesn't do the actual mapping, the
> caller of ->mmap (mmap_region) does it. So we must actually catch
> mmap_region and protect it with the lock, not ->mmap.
