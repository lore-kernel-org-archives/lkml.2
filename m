Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760123Ab1EOQNB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 12:13:01 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:34779 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760066Ab1EOQM4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 12:12:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=nGjBB6p4/CfaLNFt4mt7SedcwQjKDs7NLB7xZ9iJXmwjSoagXr4P/h7e16yCDdv95i
         j+m5HH6dYNlxwq/J/nJdUFfll9bW8320elM/Sh6ZQ4THQKVcj4OUfFEmdbtGWkcuLVPC
         u+r4A30wN7XgAKciKXfLGJErfFdLmeVzC+Bfc=
MIME-Version: 1.0
In-Reply-To: <20110515152747.GA25905@localhost>
References: <BANLkTi=XqROAp2MOgwQXEQjdkLMenh_OTQ@mail.gmail.com>
 <m2fwokj0oz.fsf@firstfloor.org> <BANLkTikhj1C7+HXP_4T-VnJzPefU2d7b3A@mail.gmail.com>
 <20110512054631.GI6008@one.firstfloor.org> <BANLkTi=fk3DUT9cYd2gAzC98c69F6HXX7g@mail.gmail.com>
 <BANLkTikofp5rHRdW5dXfqJXb8VCAqPQ_7A@mail.gmail.com> <20110514165346.GV6008@one.firstfloor.org>
 <BANLkTik6SS9NH7XVSRBoCR16_5veY0MKBw@mail.gmail.com> <20110514174333.GW6008@one.firstfloor.org>
 <BANLkTinst+Ryox9VZ-s7gdXKa574XXqt5w@mail.gmail.com> <20110515152747.GA25905@localhost>
From: Andrew Lutomirski <luto@mit.edu>
Date: Sun, 15 May 2011 12:12:36 -0400
X-Google-Sender-Auth: giIH2IzYhG8KgguFQENBHgMmvhM
Message-ID: <BANLkTim-AnEeL=z1sYm=iN7sMnG0+m0SHw@mail.gmail.com>
Subject: Re: Kernel falls apart under light memory pressure (i.e. linking vmlinux)
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Andi Kleen <andi@firstfloor.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 15, 2011 at 11:27 AM, Wu Fengguang <fengguang.wu@intel.com> wrote:
> On Sun, May 15, 2011 at 09:37:58AM +0800, Minchan Kim wrote:
>> On Sun, May 15, 2011 at 2:43 AM, Andi Kleen <andi@firstfloor.org> wrote:
>> > Copying back linux-mm.
>> >
>> >> Recently, we added following patch.
>> >> https://lkml.org/lkml/2011/4/26/129
>> >> If it's a culprit, the patch should solve the problem.
>> >
>> > It would be probably better to not do the allocations at all under
>> > memory pressure.  Even if the RA allocation doesn't go into reclaim
>>
>> Fair enough.
>> I think we can do it easily now.
>> If page_cache_alloc_readahead(ie, GFP_NORETRY) is fail, we can adjust
>> RA window size or turn off a while. The point is that we can use the
>> fail of __do_page_cache_readahead as sign of memory pressure.
>> Wu, What do you think?
>
> No, disabling readahead can hardly help.
>
> The sequential readahead memory consumption can be estimated by
>
>                2 * (number of concurrent read streams) * (readahead window size)
>
> And you can double that when there are two level of readaheads.
>
> Since there are hardly any concurrent read streams in Andy's case,
> the readahead memory consumption will be ignorable.
>
> Typically readahead thrashing will happen long before excessive
> GFP_NORETRY failures, so the reasonable solutions are to
>
> - shrink readahead window on readahead thrashing
>  (current readahead heuristic can somehow do this, and I have patches
>  to further improve it)
>
> - prevent abnormal GFP_NORETRY failures
>  (when there are many reclaimable pages)
>
>
> Andy's OOM memory dump (incorrect_oom_kill.txt.xz) shows that there are
>
> - 8MB   active+inactive file pages
> - 160MB active+inactive anon pages
> - 1GB   shmem pages
> - 1.4GB unevictable pages
>
> Hmm, why are there so many unevictable pages?  How come the shmem
> pages become unevictable when there are plenty of swap space?

That was probably because one of my testcases creates a 1.4GB file on
ramfs.  (I can provoke the problem without doing evil things like
that, but the test script is rather reliable at killing my system and
it works fine on my other machines.)

If you want, I can try to generate a trace that isn't polluted with
the evil ramfs file.

--Andy
