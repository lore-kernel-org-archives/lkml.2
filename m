Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752538Ab1GIHe5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Jul 2011 03:34:57 -0400
Received: from smtp-out.google.com ([216.239.44.51]:16754 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783Ab1GIHe4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Jul 2011 03:34:56 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=qjE9m/a0TeesxaUb/PvF+zALpbEJyePqRgl2InxB197opLYem26vmtyf9kzd/zRWk
	L+1kIZBPzCYyTw1qpvSrA==
MIME-Version: 1.0
In-Reply-To: <1310121147.3282.706.camel@twins>
References: <20110707053036.173186930@google.com> <20110707112302.GB8227@elte.hu>
 <1310049528.3282.583.camel@twins> <CAPM31RKH8m1CpVWmRVLi8bMNSgdQU+Qzc2sTaWbx4r1b2fHF7w@mail.gmail.com>
 <1310121147.3282.706.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Sat, 9 Jul 2011 00:34:21 -0700
Message-ID: <CAPM31RLy4hvaRUi5iVeOyEapRtguR5rNUrn+3oGax_Mm3GxqTw@mail.gmail.com>
Subject: Re: [patch 00/17] CFS Bandwidth Control v7.1
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@openvz.org>, Hu Tao <hutao@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 8, 2011 at 3:32 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2011-07-08 at 00:39 -0700, Paul Turner wrote:
>>
>> >  Going beyond that
>> > would be using static_branch() to track if there is any bandwidth
>> > tracking required at all.
>> >
>>
>> I spent some time examining this option as well.  Our toolchain
>> apparently is stuck on gcc-4.4 which left me scratching my head at the
>> supposed jump label assembly being omitted until I realized
>> CC_HAS_ASM_GOTO was missing.  I will roll this up also and benchmark
>> tomorrow.
>
> Ah, does it actually make things worse if it uses the static_branch
> fallbacks? If so we should probably use some HAVE_JUMP_LABEL foo.
>

I started whittling at this today, the numbers so far on my hardware (i7
12-thread) are as follows.

Base performance with !CONFIG_CFS_BW:

Performance counter stats for './pipe-test-100k' (50 runs):

       893,486,206 instructions             #      1.063 IPC     ( +-   0.296% )
       840,904,951 cycles                     ( +-   0.359% )
       160,076,980 branches                   ( +-   0.305% )

        0.735022174  seconds time elapsed   ( +-   0.143% )



Original performance (v7.2):
                            cycles                  instructions
     branches
----------------------------------------------------------------------------------------------------
base                	    893,486,206 	    840,904,951 	    160,076,980
+unconstrained      	    929,244,021 (+4.00)	    883,923,194 (+5.12)	
  167,131,228 (+4.41)
+10000000000/1000:  	    934,424,430 (+4.58)	    875,605,677 (+4.13)	
  168,466,469 (+5.24)
+10000000000/10000: 	    940,048,385 (+5.21)	    883,922,489 (+5.12)	
  169,512,329 (+5.89)
+10000000000/100000:	    934,351,875 (+4.57)	    888,878,742 (+5.71)	
  168,457,809 (+5.24)
+10000000000/1000000:	    931,127,353 (+4.21)	    874,830,745 (+4.03)	
   167,861,492 (+4.86)

The first step was fixing the missing inlining on update_curr().  This was a
major improvement.

Fix inlining on update_curr:
                            cycles                  instructions
     branches
----------------------------------------------------------------------------------------------------
base                	    893,486,206 	    840,904,951 	    160,076,980
+unconstrained      	    909,771,488 (+1.82)	    850,091,039 (+1.09)	
  164,385,813 (+2.69)
+10000000000/1000:  	    915,384,142 (+2.45)	    859,591,791 (+2.22)	
  165,616,386 (+3.46)
+10000000000/10000: 	    922,657,403 (+3.26)	    865,701,436 (+2.95)	
  166,996,717 (+4.32)
+10000000000/100000:	    928,636,540 (+3.93)	    866,234,685 (+3.01)	
  168,111,517 (+5.02)
+10000000000/1000000:	    922,311,143 (+3.23)	    859,445,796 (+2.20)	
   166,922,517 (+4.28)

I also realized on the dequeue path we can shave a branch by reversing the
order of some of the conditionals.

In particular reordering (!runnable || !enabled) ---> (!enabled || !runnable).
The latter choice saves us a branch in the !enabled case when !runnable, and
has the same cost in the enabled case.

Speed up return_cfs_rq_runtime:
                            cycles                  instructions
     branches
----------------------------------------------------------------------------------------------------
base                	    893,486,206 	    840,904,951 	    160,076,980
+unconstrained      	    906,151,427 (+1.42)	    877,497,749 (+4.35)	
  163,738,499 (+2.29)
+10000000000/1000:  	    910,284,839 (+1.88)	    885,136,630 (+5.26)	
  164,804,085 (+2.95)
+10000000000/10000: 	    911,860,656 (+2.06)	    891,433,792 (+6.01)	
  165,098,115 (+3.14)
+10000000000/100000:	    913,062,037 (+2.19)	    890,918,139 (+5.95)	
  165,327,113 (+3.28)
+10000000000/1000000:	    920,966,554 (+3.08)	    899,250,040 (+6.94)	
   166,813,750 (+4.21)

Finally introducing jump labels when there are no constrained groups claws back
a good portion of the remaining time.

Add jump labels:
                            cycles                  instructions
     branches
----------------------------------------------------------------------------------------------------
base                	    893,486,206 	    840,904,951 	    160,076,980
+unconstrained      	    900,477,543 (+0.78)	    890,310,950 (+5.88)	
  161,037,844 (+0.60)
+10000000000/1000:  	    921,436,697 (+3.13)	    919,362,792 (+9.33)	
  168,491,279 (+5.26)
+10000000000/10000: 	    907,214,638 (+1.54)	    894,406,875 (+6.36)	
  165,743,207 (+3.54)
+10000000000/100000:	    918,094,542 (+2.75)	    910,211,234 (+8.24)	
  167,841,828 (+4.85)
+10000000000/1000000:	    910,698,725 (+1.93)	    885,385,460 (+5.29)	
   166,406,742 (+3.95)

There's some permutations on where we use jump labels that I have to finish
evaluating (including whether we want to skip the jump labels in the
!CC_HAS_ASM_GOTO case), as well as one or two other shavings that I am
looking at.  Will post v7.2 incorporating these speed ups as well as some build
fixes for the !CONFIG_CGROUP case on Monday/Tuesday.

Thanks,

- Paul
