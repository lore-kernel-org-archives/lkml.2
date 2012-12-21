Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752354Ab2LUPmo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 10:42:44 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49773 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432Ab2LUPmg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 10:42:36 -0500
Message-ID: <1356104532.4547.37.camel@marge.simpson.net>
Subject: Re: [RFC][PATCH RT 4/4 v2] sched/rt: Use IPI to trigger RT task
 push migration instead of pulling
From: Mike Galbraith <bitbucket@online.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Carsten Emde <C.Emde@osadl.org>,
        John Kacur <jkacur@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        Clark Williams <clark.williams@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Frank Rowand <frank.rowand@am.sony.com>
Date: Fri, 21 Dec 2012 16:42:12 +0100
In-Reply-To: <1355428396.17101.382.camel@gandalf.local.home>
References: <20121212192733.221810086@goodmis.org>
	 <20121212193920.803917953@goodmis.org>
	 <1355428396.17101.382.camel@gandalf.local.home>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:IHHj3/T1J3+Kh4U1qkFxXHdHAuvd5DEUDkwKTN/XQ9S
 KuWmU0qJEuCUDy/IidF4qIzVWJ3bnzZVXk9/hGe47oqEoajDhp
 hiVdGMGFY+1xHsOzfoTLnB8veBBNCoA9YI/cgVP6BmsNRyg4vc
 DDwi48tyWviS8TxsMs6raZhkmD7edLNOD+ato6zJZFrmepQetn
 iWNf0kDzyCT/zFg55HG2IyhTbGq6UJ0BRnStLsO2XvvPVXRg/G
 583bAVuwRfBehyHELossmG+hc2/0AlJ/nnG7Dox9Br+mj+fWYg
 ptM4ZDKF9WJlTmoHnqfWiPENsqS62QrYwgB4J0WgRgKtx2qe15
 nzSwUyQrjNzsPLYOhuDE+6OfsbZKxhZFgPQQJF0Ph/C8aZfl1O
 qszkikih8/XBA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-12-13 at 14:53 -0500, Steven Rostedt wrote: 
> I didn't get a chance to test the latest IPI patch series on the 40 core
> box, and only had my 4 way box to test on. But I was able to test it
> last night and found some issues.
> 
> The RT_PUSH_IPI doesn't get automatically set because just doing the
> sched_feat_enable() wasn't enough. Below is the corrected patch.
> 
> Also, for some reason patch 3 caused the box to hang. Perhaps it

Yeah, I got to experience that, grabbed the wrong patch4, so didn't see
this warning, and got to fix the feature too :)

> required the RT_PUSH_IPI set, because it worked with the original patch
> series. But that series only did the push ipi. I removed it on the 40
> core before noticing that the RT_PUSH_IPI wasn't being automatically
> enabled.
> 
> Here's an update of patch 4:
> 
> sched/rt: Use IPI to trigger RT task push migration instead of pulling
> 
> When debugging the latencies on a 40 core box, where we hit 300 to
> 500 microsecond latencies, I found there was a huge contention on the
> runqueue locks.

Makes a WEE bit of difference on my dainbramaged 64 core DL980, using a
SCHED_RR massive_intr 3 for 5 minutes as the bouncable load.  This box
has only sched domains MC and CPU.. thinks it's a rather large laptop.

NO_RT_PUSH_IPI

T: 0 (14147) P:99 I:100 C:3059998 Min:      0 Act:    4 Avg:    3 Max:     368
T: 1 (14148) P:99 I:100 C:3059922 Min:      0 Act:   37 Avg:    3 Max:     372
T: 2 (14149) P:99 I:100 C:3059847 Min:      0 Act:    7 Avg:    3 Max:     361
T: 3 (14150) P:99 I:100 C:3059772 Min:      0 Act:   40 Avg:    2 Max:     346
T: 4 (14151) P:99 I:100 C:3059698 Min:      0 Act:    5 Avg:    2 Max:     307
T: 5 (14152) P:99 I:100 C:3059622 Min:      0 Act:    5 Avg:    2 Max:     379
T: 6 (14153) P:99 I:100 C:3059548 Min:      0 Act:    4 Avg:    3 Max:     341
T: 7 (14154) P:99 I:100 C:3059473 Min:      0 Act:    5 Avg:    4 Max:     379
T: 8 (14155) P:99 I:100 C:3059398 Min:      0 Act:   30 Avg:    5 Max:     552
T: 9 (14156) P:99 I:100 C:3059323 Min:      0 Act:    4 Avg:    3 Max:     760
T:10 (14157) P:99 I:100 C:3059248 Min:      0 Act:    3 Avg:    2 Max:     360
T:11 (14158) P:99 I:100 C:3059172 Min:      0 Act:   21 Avg:    4 Max:     583
T:12 (14159) P:99 I:100 C:3059097 Min:      0 Act:    4 Avg:    2 Max:     467
T:13 (14160) P:99 I:100 C:3059021 Min:      0 Act:    3 Avg:    2 Max:     350
T:14 (14161) P:99 I:100 C:3058946 Min:      0 Act:    5 Avg:    4 Max:     353
T:15 (14162) P:99 I:100 C:3058871 Min:      0 Act:    6 Avg:    2 Max:     481
T:16 (14163) P:99 I:100 C:3058794 Min:      0 Act:    3 Avg:    4 Max:     749
T:17 (14164) P:99 I:100 C:3058716 Min:      0 Act:    3 Avg:    5 Max:     632
T:18 (14165) P:99 I:100 C:3058642 Min:      0 Act:    4 Avg:    3 Max:     492
T:19 (14166) P:99 I:100 C:3058564 Min:      0 Act:    3 Avg:    3 Max:     500
T:20 (14167) P:99 I:100 C:3058486 Min:      0 Act:    4 Avg:    6 Max:     567
T:21 (14168) P:99 I:100 C:3058408 Min:      0 Act:    5 Avg:    4 Max:     444
T:22 (14169) P:99 I:100 C:3058330 Min:      0 Act:    4 Avg:    3 Max:     417
T:23 (14170) P:99 I:100 C:3058253 Min:      0 Act:    3 Avg:    5 Max:     591
T:24 (14171) P:99 I:100 C:3058175 Min:      0 Act:    4 Avg:    4 Max:     737
T:25 (14172) P:99 I:100 C:3058098 Min:      0 Act:    4 Avg:    4 Max:     628
T:26 (14173) P:99 I:100 C:3058019 Min:      0 Act:    4 Avg:    5 Max:     599
T:27 (14174) P:99 I:100 C:3057939 Min:      0 Act:    3 Avg:    4 Max:     370
T:28 (14175) P:99 I:100 C:3057858 Min:      0 Act:    3 Avg:    4 Max:     384
T:29 (14176) P:99 I:100 C:3057777 Min:      0 Act:    3 Avg:    4 Max:     440
T:30 (14177) P:99 I:100 C:3057696 Min:      0 Act:    4 Avg:    3 Max:     492
T:31 (14178) P:99 I:100 C:3057616 Min:      0 Act:    2 Avg:    3 Max:     383
T:32 (14179) P:99 I:100 C:3057534 Min:      0 Act:    4 Avg:    5 Max:     484
T:33 (14180) P:99 I:100 C:3057454 Min:      0 Act:    4 Avg:    5 Max:     622
T:34 (14181) P:99 I:100 C:3057373 Min:      0 Act:    3 Avg:    3 Max:     388
T:35 (14182) P:99 I:100 C:3057291 Min:      0 Act:    4 Avg:    3 Max:     447
T:36 (14183) P:99 I:100 C:3057209 Min:      0 Act:    4 Avg:    4 Max:     519
T:37 (14184) P:99 I:100 C:3057126 Min:      0 Act:    3 Avg:    2 Max:     484
T:38 (14185) P:99 I:100 C:3057043 Min:      0 Act:    4 Avg:    5 Max:     408
T:39 (14186) P:99 I:100 C:3056960 Min:      0 Act:    3 Avg:    4 Max:     405
T:40 (14187) P:99 I:100 C:3056876 Min:      0 Act:    3 Avg:    6 Max:     681
T:41 (14188) P:99 I:100 C:3056793 Min:      0 Act:    3 Avg:    3 Max:    1082
T:42 (14189) P:99 I:100 C:3056709 Min:      0 Act:    4 Avg:    4 Max:     445
T:43 (14190) P:99 I:100 C:3056625 Min:      0 Act:    4 Avg:    6 Max:     427
T:44 (14191) P:99 I:100 C:3056541 Min:      0 Act:    4 Avg:    4 Max:     501
T:45 (14192) P:99 I:100 C:3056457 Min:      0 Act:    4 Avg:    4 Max:     412
T:46 (14193) P:99 I:100 C:3056373 Min:      0 Act:    4 Avg:    5 Max:     438
T:47 (14194) P:99 I:100 C:3056289 Min:      0 Act:    4 Avg:    4 Max:     437
T:48 (14195) P:99 I:100 C:3056204 Min:      0 Act:    5 Avg:    8 Max:     626
T:49 (14196) P:99 I:100 C:3056120 Min:      0 Act:    2 Avg:    2 Max:     643
T:50 (14197) P:99 I:100 C:3056034 Min:      0 Act:    5 Avg:    4 Max:     502
T:51 (14198) P:99 I:100 C:3055949 Min:      0 Act:    4 Avg:    3 Max:     427
T:52 (14199) P:99 I:100 C:3055863 Min:      0 Act:    3 Avg:    3 Max:     515
T:53 (14200) P:99 I:100 C:3055778 Min:      0 Act:    4 Avg:    4 Max:     397
T:54 (14201) P:99 I:100 C:3055693 Min:      0 Act:    3 Avg:    5 Max:     866
T:55 (14202) P:99 I:100 C:3055607 Min:      0 Act:    4 Avg:    4 Max:     536
T:56 (14203) P:99 I:100 C:3055521 Min:      0 Act:    3 Avg:    6 Max:     611
T:57 (14204) P:99 I:100 C:3055435 Min:      0 Act:    4 Avg:    4 Max:     487
T:58 (14205) P:99 I:100 C:3055348 Min:      0 Act:    2 Avg:    4 Max:     647
T:59 (14206) P:99 I:100 C:3055261 Min:      0 Act:    3 Avg:    3 Max:     520
T:60 (14207) P:99 I:100 C:3055175 Min:      0 Act:    4 Avg:    4 Max:     686
T:61 (14208) P:99 I:100 C:3055088 Min:      0 Act:    4 Avg:    5 Max:     531
T:62 (14209) P:99 I:100 C:3055001 Min:      0 Act:    4 Avg:    5 Max:     435
T:63 (14210) P:99 I:100 C:3054914 Min:      0 Act:    4 Avg:    4 Max:     525

RT_PUSH_IPI

T: 0 (14065) P:99 I:100 C:3089627 Min:      1 Act:    3 Avg:    2 Max:      10
T: 1 (14066) P:99 I:100 C:3089574 Min:      2 Act:    4 Avg:    2 Max:      10
T: 2 (14067) P:99 I:100 C:3089521 Min:      1 Act:    3 Avg:    3 Max:      10
T: 3 (14068) P:99 I:100 C:3089468 Min:      1 Act:    4 Avg:    3 Max:       8
T: 4 (14069) P:99 I:100 C:3089415 Min:      1 Act:    2 Avg:    2 Max:      12
T: 5 (14070) P:99 I:100 C:3089361 Min:      1 Act:    2 Avg:    2 Max:       7
T: 6 (14071) P:99 I:100 C:3089308 Min:      1 Act:    3 Avg:    2 Max:      12
T: 7 (14072) P:99 I:100 C:3089255 Min:      2 Act:    3 Avg:    3 Max:      29
T: 8 (14073) P:99 I:100 C:3089201 Min:      2 Act:    4 Avg:    3 Max:      11
T: 9 (14074) P:99 I:100 C:3089140 Min:      1 Act:    3 Avg:    4 Max:      43
T:10 (14075) P:99 I:100 C:3089093 Min:      2 Act:    3 Avg:    3 Max:      14
T:11 (14076) P:99 I:100 C:3089038 Min:      2 Act:    4 Avg:    3 Max:      11
T:12 (14077) P:99 I:100 C:3088982 Min:      2 Act:    3 Avg:    3 Max:       8
T:13 (14078) P:99 I:100 C:3088927 Min:      2 Act:    4 Avg:    3 Max:      13
T:14 (14079) P:99 I:100 C:3088871 Min:      1 Act:    3 Avg:    4 Max:      13
T:15 (14080) P:99 I:100 C:3088817 Min:      1 Act:    3 Avg:    4 Max:      13
T:16 (14081) P:99 I:100 C:3088762 Min:      1 Act:    3 Avg:    2 Max:       9
T:17 (14082) P:99 I:100 C:3088707 Min:      1 Act:    4 Avg:    2 Max:       8
T:18 (14083) P:99 I:100 C:3088652 Min:      2 Act:    3 Avg:    2 Max:      11
T:19 (14084) P:99 I:100 C:3088597 Min:      2 Act:    4 Avg:    3 Max:      14
T:20 (14085) P:99 I:100 C:3088542 Min:      1 Act:    4 Avg:    3 Max:       8
T:21 (14086) P:99 I:100 C:3088487 Min:      2 Act:    3 Avg:    3 Max:      19
T:22 (14087) P:99 I:100 C:3088432 Min:      2 Act:    3 Avg:    3 Max:      18
T:23 (14088) P:99 I:100 C:3088377 Min:      2 Act:    4 Avg:    3 Max:      12
T:24 (14089) P:99 I:100 C:3088321 Min:      2 Act:    3 Avg:    3 Max:      14
T:25 (14090) P:99 I:100 C:3088265 Min:      2 Act:    4 Avg:    4 Max:      14
T:26 (14091) P:99 I:100 C:3088208 Min:      2 Act:    4 Avg:    3 Max:      14
T:27 (14092) P:99 I:100 C:3088151 Min:      2 Act:    3 Avg:    3 Max:       9
T:28 (14093) P:99 I:100 C:3088094 Min:      2 Act:    3 Avg:    3 Max:      23
T:29 (14094) P:99 I:100 C:3088038 Min:      2 Act:    4 Avg:    3 Max:      10
T:30 (14095) P:99 I:100 C:3087980 Min:      2 Act:    3 Avg:    3 Max:      19
T:31 (14096) P:99 I:100 C:3087924 Min:      1 Act:    4 Avg:    3 Max:      10
T:32 (14097) P:99 I:100 C:3087866 Min:      1 Act:    3 Avg:    3 Max:      11
T:33 (14098) P:99 I:100 C:3087807 Min:      1 Act:    3 Avg:    3 Max:      14
T:34 (14099) P:99 I:100 C:3087749 Min:      1 Act:    2 Avg:    2 Max:      13
T:35 (14100) P:99 I:100 C:3087690 Min:      2 Act:    3 Avg:    3 Max:      12
T:36 (14101) P:99 I:100 C:3087631 Min:      2 Act:    3 Avg:    3 Max:      13
T:37 (14102) P:99 I:100 C:3087572 Min:      1 Act:    5 Avg:    4 Max:      22
T:38 (14103) P:99 I:100 C:3087512 Min:      2 Act:    3 Avg:    3 Max:      12
T:39 (14104) P:99 I:100 C:3087453 Min:      2 Act:    3 Avg:    3 Max:      11
T:40 (14105) P:99 I:100 C:3087392 Min:      2 Act:    4 Avg:   13 Max:      50
T:41 (14106) P:99 I:100 C:3087333 Min:      2 Act:    4 Avg:   10 Max:      42
T:42 (14107) P:99 I:100 C:3087272 Min:      1 Act:    2 Avg:    4 Max:      20
T:43 (14108) P:99 I:100 C:3087211 Min:      1 Act:    2 Avg:    5 Max:      23
T:44 (14109) P:99 I:100 C:3087149 Min:      1 Act:    3 Avg:    6 Max:      38
T:45 (14110) P:99 I:100 C:3087088 Min:      1 Act:    6 Avg:    4 Max:      37
T:46 (14111) P:99 I:100 C:3087027 Min:      2 Act:    4 Avg:    4 Max:      44
T:47 (14112) P:99 I:100 C:3086965 Min:      1 Act:    2 Avg:    2 Max:      12
T:48 (14113) P:99 I:100 C:3086903 Min:      2 Act:    3 Avg:    3 Max:      12
T:49 (14114) P:99 I:100 C:3086841 Min:      1 Act:    3 Avg:    4 Max:      14
T:50 (14115) P:99 I:100 C:3086778 Min:      1 Act:    3 Avg:    3 Max:      11
T:51 (14116) P:99 I:100 C:3086715 Min:      2 Act:    3 Avg:    3 Max:      12
T:52 (14117) P:99 I:100 C:3086652 Min:      2 Act:    3 Avg:    3 Max:      17
T:53 (14118) P:99 I:100 C:3086589 Min:      1 Act:    2 Avg:    3 Max:      14
T:54 (14119) P:99 I:100 C:3086525 Min:      2 Act:    3 Avg:    3 Max:      10
T:55 (14120) P:99 I:100 C:3086462 Min:      1 Act:    3 Avg:    3 Max:       9
T:56 (14121) P:99 I:100 C:3086398 Min:      2 Act:    4 Avg:    3 Max:      14
T:57 (14122) P:99 I:100 C:3086335 Min:      2 Act:    4 Avg:    3 Max:      25
T:58 (14123) P:99 I:100 C:3086270 Min:      2 Act:    4 Avg:    3 Max:      12
T:59 (14124) P:99 I:100 C:3086207 Min:      2 Act:    3 Avg:    3 Max:      12
T:60 (14125) P:99 I:100 C:3086143 Min:      2 Act:    4 Avg:    3 Max:      13
T:61 (14126) P:99 I:100 C:3086079 Min:      2 Act:    3 Avg:    3 Max:      11
T:62 (14127) P:99 I:100 C:3086014 Min:      2 Act:    4 Avg:    3 Max:      12
T:63 (14128) P:99 I:100 C:3085949 Min:      2 Act:    3 Avg:    3 Max:      11


