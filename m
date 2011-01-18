Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753346Ab1ARBM6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 20:12:58 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:39601 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753127Ab1ARBM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 20:12:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Q6lFh+mDLGDcuEjsXA9ZqvB+h9lTBuwZ8RtfAoetz/GnnKGvgOCggOv/V9WJf2t1N8
         WILuCTmc5phhA8p80Gk5U+TyNeaUh6BonnNnWQN4diIKJYdD6o+bDhK0mqDXmbFVfUns
         waKnAhBM49vMe7temGqn6GEf+aehLzEiICa/Q=
MIME-Version: 1.0
In-Reply-To: <20110115173211.GC27123@htj.dyndns.org>
References: <20110113025646.GB27381@tux1.beaverton.ibm.com>
	<AANLkTi=hF8hwgtx+N-dBNRjoffX7nQmaehkE3PsFpSDq@mail.gmail.com>
	<20110113074603.GC27381@tux1.beaverton.ibm.com>
	<AANLkTi=pkM1-91cKULt=5L=cPpTUcR5qqFrbj7Bjtk36@mail.gmail.com>
	<20110115173211.GC27123@htj.dyndns.org>
Date: Tue, 18 Jan 2011 09:12:55 +0800
X-Google-Sender-Auth: 3JYXLPaTErkcYOKu0qseGAFcOMY
Message-ID: <AANLkTi=MiY+GMXRwfOMhEzGQC3=F89FOKAJ4y1hvyDG0@mail.gmail.com>
Subject: Re: [PATCH v7.1] block: Coordinate flush requests
From: Shaohua Li <shli@kernel.org>
To: Tejun Heo <tj@kernel.org>
Cc: djwong@us.ibm.com, Jens Axboe <axboe@kernel.dk>,
        "Theodore Ts'o" <tytso@mit.edu>, Neil Brown <neilb@suse.de>,
        Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.cz>,
        Mike Snitzer <snitzer@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Keith Mannthey <kmannth@us.ibm.com>, Mingming Cao <cmm@us.ibm.com>,
        linux-ext4@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Josef Bacik <josef@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/16 Tejun Heo <tj@kernel.org>:
> Hello,
>
> On Fri, Jan 14, 2011 at 09:00:22AM +0800, Shaohua Li wrote:
>> it appears we can easily implement this in blk_do_flush, I had
>> something at my hand too, passed test but no data yet.
>
>> Task1: ...FS.....C
>> Task2: ....F......S...C
>> Task3: ......F.........S..C
>> F means a flush is queued, S means a flush is dispatched, C means the flush
>> is completed. In above, when Task2's flush is completed, we actually can
>> make Task3 flush complete, as Task2's flush is dispatched after Task3's flush
>> is queued. With the same reason, we can't merge Task2 and Task3's flush with
>> Task1's.
>
> I think this is the correct direction but we can take it further.  The
> only thing block layer has to guarantee is (ignoring FUA support),
>
> * If the flush request is empty, at least one flush is executed upon
>  its completion.
>
> * If the flush request is not empty, the payload is written only after
>  a preceding flush and follwed by another flush if requested.
>
> So, if we can combine N flushes with or without data,
>
>  PREFLUSH -> N flush data payloads -> POSTFLUSH
This makes sense. would it possible N flush data payloads delay the
first request?

> The following is something I hacked past few hours.  I just made it
> compile so it's definitely horridly broken.  Please don't try to even
> test it, but it should still give an idea about the direction.  I'll
> try to finish this early next week.
I'm looking forward to seeing it.

Thanks,
Shaohua
