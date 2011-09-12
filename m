Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755930Ab1ILNJW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 09:09:22 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:48486 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755711Ab1ILNJV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 09:09:21 -0400
MIME-Version: 1.0
In-Reply-To: <CA+X1aCQhUALGLrtjSzdHonQ1WdPgVMPa7kW2Yi0UFqBwD0Vv6w@mail.gmail.com>
References: <1313768318-7960-1-git-send-email-maxim.patlasov@gmail.com>
	<1313768318-7960-2-git-send-email-maxim.patlasov@gmail.com>
	<CANejiEWadFK9GdXSwKgzNoj1Da_4QTUidTp-6FGkBtZwhbKvfw@mail.gmail.com>
	<CA+X1aCRSADrUB+YVJ9j5u+VgGn=8fKw7A1eVVzPtODg+hK-B-w@mail.gmail.com>
	<CANejiEX=S8tyPDhAjm84+9xBNt08Q0mjWHjqh-kFqL4H1ME-RA@mail.gmail.com>
	<CA+X1aCSMb9CTpoHWv=UiMg-mHkB2ssmKRACtbDofWG=QSxXOdg@mail.gmail.com>
	<CANejiEV7UfEHEMwokKwE+Pwqn_HRUT0_9wHakhOYj8r0roGYuw@mail.gmail.com>
	<CA+X1aCR6Rptj_7bKf7O7TJ8a9z7AH0vXL90XAgY=+054WegsgQ@mail.gmail.com>
	<CANejiEUTjZbxesiKFzGE4a9rs-GQfq1ekzaDAv34pMGrEQAUcg@mail.gmail.com>
	<CA+X1aCQhUALGLrtjSzdHonQ1WdPgVMPa7kW2Yi0UFqBwD0Vv6w@mail.gmail.com>
Date: Mon, 12 Sep 2011 17:09:20 +0400
Message-ID: <CA+X1aCSPPoHjOyVpTgZ+NFySLiEK6hLM5boCVFaTTYBcQnYS1g@mail.gmail.com>
Subject: Re: [PATCH 1/1] CFQ: fix handling 'deep' cfqq
From: Maxim Patlasov <maxim.patlasov@gmail.com>
To: Shaohua Li <shli@kernel.org>
Cc: shaohua.li@intel.com, axboe@kernel.dk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shaohua,

>> So the key problem here is how to detect if a device is fast. Doing
>> the detection
>> in the dispatch stage always can't give us correct result. A fast device really
>> should be requests can be finished in short time. So I have something attached.
>> In my environment, a hard disk is detected slow and a ssd is detected fast, but
>> I haven't run any benchmark so far. How do you think about it?
>
> Thanks for the patch, I'll test it in several h/w configurations soon
> and let you know about results.

1. Single slow disk (ST3200826AS). Eight instances of aio-stress, cmd-line:

# aio-stress -a 4 -b 4 -c 1 -r 4 -O -o 0 -t 1 -d 1 -i 1 -s 16 f1_$I
f2_$I f3_$I f4_$I

Aggreagate throughput:

Pristine 3.1.0-rc5 (CFQ): 3.77 MB/s
Pristine 3.1.0-rc5 (noop): 2.63 MB/s
Pristine 3.1.0-rc5 (CFQ, slice_idle=0): 2.81 MB/s
3.1.0-rc5 + my patch (CFQ): 5.76 MB/s
3.1.0-rc5 + your patch (CFQ): 5.61 MB/s

2. Four modern disks (WD1003FBYX) assembled in RAID-0 (Adaptec
AAC-RAID (rev 09) 256Mb RAM). Eight instances of aio-stress with
think-time 1msec:

> --- aio-stress-orig.c	2011-08-16 17:00:04.000000000 -0400
> +++ aio-stress.c	2011-08-18 14:49:31.000000000 -0400
> @@ -884,6 +884,7 @@ static int run_active_list(struct thread
>      }
>      if (num_built) {
>  	ret = run_built(t, num_built, t->iocbs);
> +	usleep(1000);
>  	if (ret < 0) {
>  	    fprintf(stderr, "error %d on run_built\n", ret);
>  	    exit(1);

Cmd-line:

# aio-stress -a 4 -b 4 -c 1 -r 4 -O -o 0 -t 1 -d 1 -i 1 f1_$I f2_$I f3_$I f4_$I

Aggreagate throughput:

Pristine 3.1.0-rc5 (CFQ): 63.67 MB/s
Pristine 3.1.0-rc5 (noop): 100.8 MB/s
Pristine 3.1.0-rc5 (CFQ, slice_idle=0): 105.63 MB/s
3.1.0-rc5 + my patch (CFQ): 105.59 MB/s
3.1.0-rc5 + your patch (CFQ): 14.36 MB/s

So, to meet needs of striped raids, it's not enough to measure service
time of separate requests. We need somehow to measure whether given
hdd/raid is able to service many requests simultaneously in an
effective way.

Thanks,
Maxim
