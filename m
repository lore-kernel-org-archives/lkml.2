Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161158Ab2GLObP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 10:31:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45673 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933848Ab2GLObM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 10:31:12 -0400
Message-ID: <1342103450.28010.10.camel@twins>
Subject: Re: [PATCH 14/16] sched: make __update_entity_runnable_avg() fast
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: Benjamin Segall <bsegall@google.com>, linux-kernel@vger.kernel.org,
        Venki Pallipadi <venki@google.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>,
        Mike Galbraith <efault@gmx.de>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
Date: Thu, 12 Jul 2012 16:30:50 +0200
In-Reply-To: <CAPM31R+RYvLLN0mK8VBOe7QTxCxEEuLEZ1OokeLAB=D0cxqJxQ@mail.gmail.com>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
	 <20120628022415.30496.53532.stgit@kitami.mtv.corp.google.com>
	 <1341416463.19870.6.camel@laptop> <1341422408.19870.12.camel@laptop>
	 <xm26fw90zo16.fsf@sword-of-the-dawn.mtv.corp.google.com>
	 <1341917490.3462.119.camel@twins>
	 <CAPM31R+RYvLLN0mK8VBOe7QTxCxEEuLEZ1OokeLAB=D0cxqJxQ@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-07-11 at 17:15 -0700, Paul Turner wrote:
> convergence
> 345> 47765

Ah, 345 is much saner indeed!

> And for posterity, a simple generator so that I don't lose it again:
> #include <math.h>
> #include <stdio.h>
> 
> #define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
> #define N 32
> #define WMULT_SHIFT 32
> 
> const long WMULT_CONST = ((1UL << N) - 1);
> const double y = .97857206208770013451;

I used pow(0.5, 1.0/N), no point in loosing precision and mis-typing a
digit or somesuch nonsense ;-)

> 
> long approx_decay(int c) {
>         return (c * 4008) >> 12;
> }
> 
> long mult_inv_array[N];
> void calc_mult_inv() {
>         int i;
>         double yn = 0;
> 
>         printf("inverses\n");
>         for (i = 0; i < N; i++) {
>                 yn = (double)WMULT_CONST * pow(y, i);
>                 mult_inv_array[i] = yn;
>                 printf("%d: %8lx\n", i, mult_inv_array[i]);
>         }
> 
>         printf("\n");
> }
> 
> long mult_inv(long c, int n) {
>         return SRR(c * runnable_avg_yN_inv[n], WMULT_SHIFT);

This works much better when you do:

  s/runnable_avg_yN_inv/mult_inv_array/

> }
> 
> void calc_yn_sum(int n)
> {
>         int i;
>         double sum = 0, sum_fl = 0, diff = 0;
>         long approx = 0, approx_fm = 0, approx_fm2 = 0;
> 
>         printf("sum y^n\n");
>         printf("   %8s  %8s  %8s  %8s %8s\n", "exact", "floor", "shift",
>                "fastmul1", "fastmul2");
>         for (i = 1; i < n; i++) {
>                 sum = (y * sum + y * 1024);
>                 sum_fl = floor(y * sum_fl+ y * 1024);
>                 approx = approx_decay(approx) + approx_decay(1024);
>                 approx_fm = mult_inv(approx_fm, 1) + mult_inv(1024, 1);
>                 approx_fm2 += mult_inv(1024, i);
> 
>                 /*diff = sum;*/
>                 printf("%2d: %8.0f  %8.0f  %8ld  %8ld  %8ld\n", i, sum,
>                                 sum_fl - diff,
>                                 approx - (long)diff,
>                                 approx_fm - (long)diff,
>                                 approx_fm2 - (long)diff);
> 
>         }
>         printf("\n");
> }
> 
> void calc_conv(long n) {
>         long old_n;
>         int i = -1;
> 
>         printf("convergence\n");
>         do {
>                 old_n = n;
>                 n = mult_inv(n, 1) + 1024;
>                 i++;
>         } while (n != old_n);
>         printf("%d> %ld\n", i - 1, n);
>         printf("\n");
> }
> 
> void main() {
>         calc_mult_inv();
>         calc_conv(1024);
>         calc_yn_sum(N);
> }
> 
> 
