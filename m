Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab2FFDOb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 23:14:31 -0400
Received: from mail-wi0-f170.google.com ([209.85.212.170]:41350 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751420Ab2FFDO3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 23:14:29 -0400
MIME-Version: 1.0
In-Reply-To: <20120606025729.GA1197@redhat.com>
References: <20120528114124.GA6813@localhost> <CA+55aFxHt8q8+jQDuoaK=hObX+73iSBTa4bBWodCX3s-y4Q1GQ@mail.gmail.com>
 <20120529155759.GA11326@localhost> <CA+55aFykFaBhzzEyRYWRS9Qoy_q_R65Cuth7=XvfOZEMqjn6=w@mail.gmail.com>
 <20120530032129.GA7479@localhost> <20120605172302.GB28556@redhat.com>
 <20120605174157.GC28556@redhat.com> <20120605184853.GD28556@redhat.com>
 <20120605201045.GE28556@redhat.com> <20120606025729.GA1197@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Jun 2012 20:14:08 -0700
X-Google-Sender-Auth: vdEC82U2Gdx-tk25yQ02qZyVnzA
Message-ID: <CA+55aFyxucvhYhbk0yyNa1WSeYXgHHAyWRHPNWDwODQhyAWGww@mail.gmail.com>
Subject: Re: write-behind on streaming writes
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        linux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 5, 2012 at 7:57 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>
> I had expected a bigger difference as sync_file_range() is just driving
> max queue depth of 32 (total 16MB IO in flight), while flushers are
> driving queue depths up to 140 or so. So in this paritcular test, driving
> much deeper queue depths is not really helping much. (I have seen higher
> throughputs with higher queue depths in the past. Now sure why don't we
> see it here).

How did interactivity feel?

Because quite frankly, if the throughput difference is 12.5 vs 12
seconds, I suspect the interactivity thing is what dominates.

And from my memory of the interactivity different was absolutely
*huge*. Even back when I used rotational media, I basically couldn't
even notice the background write with the sync_file_range() approach.
While the regular writeback without the writebehind had absolutely
*huge* pauses if you used something like firefox that uses fsync()
etc. And starting new applications that weren't cached was noticeably
worse too - and then with sync_file_range it wasn't even all that
noticeable.

NOTE! For the real "firefox + fsync" test, I suspect you'd need to do
the writeback on the same filesystem (and obviously disk) as your home
directory is. If the big write is to another filesystem and another
disk, I think you won't see the same issues.

Admittedly, I have not really touched anything with a rotational disk
for the last few years, nor do I ever want to see those rotating
pieces of high-tech rust ever again. And maybe your SAN has so good
latency even under load that it doesn't really matter. I remember it
mattering a lot back when..

Of course, back when I did that testing and had rotational media, we
didn't have the per-bdi writeback logic with the smart speed-dependent
depths etc, so it may be that we're just so much better at writeback
these days that it's not nearly as noticeable any more.

                        Linus
