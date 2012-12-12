Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab2LLAN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Dec 2012 19:13:27 -0500
Received: from ares07.inai.de ([5.9.24.206]:50489 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab2LLANX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Dec 2012 19:13:23 -0500
Date: Wed, 12 Dec 2012 01:13:22 +0100 (CET)
From: Jan Engelhardt <jengelh@inai.de>
To: Jan Kara <jack@suse.cz>
cc: linux-fsdevel@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: Read starvation by sync writes
In-Reply-To: <20121210221222.GA25700@quack.suse.cz>
Message-ID: <alpine.LNX.2.01.1212120110470.3666@nerf07.vanv.qr>
References: <20121210221222.GA25700@quack.suse.cz>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2012-12-10 23:12, Jan Kara wrote:
>
>  I was looking into IO starvation problems where streaming sync writes (in
>my case from kjournald but DIO would look the same) starve reads. This is
>because reads happen in small chunks and until a request completes we don't
>start reading further (reader reads lots of small files) while writers have
>plenty of big requests to submit. Both processes end up fighting for IO
>requests and writer writes nr_batching 512 KB requests while reader reads
>just one 4 KB request or so.[...]
>Simple reproducer is:
>
>echo 3 >/proc/sys/vm/drop_caches
>dd if=/dev/zero of=/tmp/f bs=1M count=10000 &
>sleep 30
>time cat /etc/* 2>&1 >/dev/null
>killall dd
>rm /tmp/f
>
>  The question is how can we fix this?

The ROW scheduler attempts to address it up by prioritizing reads,
and it works out for me.

 (Mail info.)
 Date: Tue, 11 Dec 2012 14:41:18
 From: Tanya Brokhman <tlinder@codeaurora.org>
 Subject: [PATCH v4 0/2] ROW scheduling Algorithm
