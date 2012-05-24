Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932388Ab2EXBQk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 21:16:40 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:48638 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071Ab2EXBQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 21:16:38 -0400
Message-ID: <4FBD8BD9.8070708@ce.jp.nec.com>
Date: Thu, 24 May 2012 10:16:09 +0900
From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Kent Overstreet <koverstreet@google.com>
CC: device-mapper development <dm-devel@redhat.com>,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, axboe@kernel.dk, yehuda@hq.newdream.net,
        mpatocka@redhat.com, vgoyal@redhat.com, bharrosh@panasas.com,
        tj@kernel.org, sage@newdream.net, agk@redhat.com,
        drbd-dev@lists.linbit.com
Subject: Re: [dm-devel] [PATCH v2 02/14] dm: kill dm_rq_bio_destructor
References: <1337817771-25038-1-git-send-email-koverstreet@google.com> <1337817771-25038-3-git-send-email-koverstreet@google.com> <4FBD7E80.4020005@ce.jp.nec.com> <20120524003915.GA27443@google.com>
In-Reply-To: <20120524003915.GA27443@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/24/12 09:39, Kent Overstreet wrote:
> On Thu, May 24, 2012 at 09:19:12AM +0900, Jun'ichi Nomura wrote:
>> The destructor may also be called from blk_rq_unprep_clone(),
>> which just puts bio.
>> So this patch will introduce a memory leak.
> 
> Well, keeping around bi_destructor solely for that reason would be
> pretty lousy. Can you come up with a better solution?

I don't have good one but here are some ideas:
  a) Do bio_endio() rather than bio_put() in blk_rq_unprep_clone()
     and let bi_end_io reap additional data.
     It looks ugly.
  b) Separate the constructor from blk_rq_prep_clone().
     dm has to do rq_for_each_bio loop again for constructor.
     Possible performance impact.
  c) Open code blk_rq_prep/unprep_clone() in dm.
     It exposes unnecessary block-internals to dm.
  d) Pass destructor function to blk_rq_prep/unprep_clone()
     for them to callback.

Umm, is "d)" better?
-- 
Jun'ichi Nomura, NEC Corporation
