Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933577Ab2GLAPi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 20:15:38 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:47631 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933563Ab2GLAPg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 20:15:36 -0400
MIME-Version: 1.0
In-Reply-To: <1341917490.3462.119.camel@twins>
References: <20120628022413.30496.32798.stgit@kitami.mtv.corp.google.com>
 <20120628022415.30496.53532.stgit@kitami.mtv.corp.google.com>
 <1341416463.19870.6.camel@laptop> <1341422408.19870.12.camel@laptop>
 <xm26fw90zo16.fsf@sword-of-the-dawn.mtv.corp.google.com> <1341917490.3462.119.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Wed, 11 Jul 2012 17:15:04 -0700
Message-ID: <CAPM31R+RYvLLN0mK8VBOe7QTxCxEEuLEZ1OokeLAB=D0cxqJxQ@mail.gmail.com>
Subject: Re: [PATCH 14/16] sched: make __update_entity_runnable_avg() fast
To: Peter Zijlstra <peterz@infradead.org>
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
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I've been trying to dig up the little proglets that originally
computed this stuff, since some specific adjustments were made but for
the life of me[*] I cannot find it, so I am stuck trying to reverse
engineer it like you :-).
[*] Including some over-night greps on all my source trees.

The short answer is I can explain some of the differences, but not
all; I suspect that perhaps I generated things using a wonky table.
Will update the tables with the tweaked numbers below for next
posting.

Updated values:

inverses for fixed point multiplication by y^k
0: ffffffff
1: fa83b2da
2: f5257d14
3: efe4b99a
4: eac0c6e6
5: e5b906e6
6: e0ccdeeb
7: dbfbb796
8: d744fcc9
9: d2a81d91
10: ce248c14
11: c9b9bd85
12: c5672a10
13: c12c4cc9
14: bd08a39e
15: b8fbaf46
16: b504f333
17: b123f581
18: ad583ee9
19: a9a15ab4
20: a5fed6a9
21: a2704302
22: 9ef5325f
23: 9b8d39b9
24: 9837f050
25: 94f4efa8
26: 91c3d373
27: 8ea4398a
28: 8b95c1e3
29: 88980e80
30: 85aac367
31: 82cd8698
[ Delta versus previous is purely double vs float, no surprises on this one ]

convergence
345> 47765
[ This is accounting for the fact that we're not getting to use a
perfect value of y, but it is the value we will converge to with max
individual updates and our fastmult y^1 approximation ]

sum y^n
[ Where:
exact_n = exact_{n-1} * exact_y + 1024.0
floor_n = FLOOR( floor_{n-1} * exact_y * 1024.0 )
shift_n = approximating exact_n using shift/div for mult
fastmul1 = approximating exact_n using inverse mult of y^1 recursively
fastmul2 = \sum 1024*y^n using  inverse mult of y^k

Error terms for the approximations:
sum y^n
      exact     floor     shift  fastmul1 fastmul2
 1:     1002        -0         0         0         0
 2:     1983        -1         0         1         1
 3:     2942        -1        -1         1         1
 4:     3881        -1        -2         1         1
 5:     4800        -2        -3         1         1
 6:     5699        -2        -4         1         1
 7:     6579        -3        -5         1         1
 8:     7440        -3        -6         1         1
 9:     8283        -4        -6         2         2
10:     9108        -5        -7         1         2
11:     9914        -5        -8         1         2
12:    10704        -6        -9         1         2
13:    11477        -7        -9         2         3
14:    12233        -7       -10         2         3
15:    12973        -7       -11         2         3
16:    13697        -7       -12         2         3
17:    14405        -7       -13         1         3
18:    15099        -8       -14         1         3
19:    15777        -8       -16         0         3
20:    16441        -8       -17         0         3
21:    17091        -9       -18         0         3
22:    17727        -9       -18         1         4
23:    18349        -9       -20         0         3
24:    18958        -9       -20         1         4
25:    19554        -9       -21         1         4
26:    20137        -9       -22         1         4
27:    20707        -9       -24         1         4
28:    21266       -10       -25         1         4
29:    21812       -10       -27         0         3
30:    22347       -11       -28         1         4
31:    22870       -11       -30         0         3

The concern here is that we don't want approximations that
over-estimate to make possible exceeding our converged max load sum
above, which was accumulated using only single y^n steps.

For this reason I prefer the most conservative floor approximation
which never over-estimates, with errors <0.1%.  I think this is what I
chose previously (the first terms all align), but I can't explain the
divergence for higher n.

(Exact values)
      exact     floor     shift  fastmul1 fastmul2
 1:     1002      1002      1002      1002      1002
 2:     1983      1982      1982      1983      1983
 3:     2942      2941      2941      2943      2943
 4:     3881      3880      3879      3882      3882
 5:     4800      4798      4797      4801      4801
 6:     5699      5697      5695      5700      5700
 7:     6579      6576      6574      6580      6580
 8:     7440      7437      7434      7441      7441
 9:     8283      8279      8276      8284      8284
10:     9108      9103      9100      9108      9109
11:     9914      9909      9906      9915      9916
12:    10704     10698     10695     10705     10706
13:    11477     11470     11467     11478     11479
14:    12233     12226     12222     12234     12235
15:    12973     12966     12961     12974     12975
16:    13697     13690     13684     13698     13699
17:    14405     14398     14392     14406     14408
18:    15099     15091     15084     15099     15101
19:    15777     15769     15761     15777     15780
20:    16441     16433     16424     16441     16444
21:    17091     17082     17073     17091     17094
22:    17727     17718     17708     17727     17730
23:    18349     18340     18329     18349     18352
24:    18958     18949     18937     18958     18961
25:    19554     19545     19532     19554     19557
26:    20137     20128     20114     20137     20140
27:    20707     20698     20683     20708     20711
28:    21266     21256     21240     21266     21269
29:    21812     21802     21785     21812     21815
30:    22347     22336     22318     22347     22350
31:    22870     22859     22840     22870     22873

And for posterity, a simple generator so that I don't lose it again:
#include <math.h>
#include <stdio.h>

#define SRR(x, y) (((x) + (1UL << ((y) - 1))) >> (y))
#define N 32
#define WMULT_SHIFT 32

const long WMULT_CONST = ((1UL << N) - 1);
const double y = .97857206208770013451;

long approx_decay(int c) {
	return (c * 4008) >> 12;
}

long mult_inv_array[N];
void calc_mult_inv() {
	int i;
	double yn = 0;

	printf("inverses\n");
	for (i = 0; i < N; i++) {
		yn = (double)WMULT_CONST * pow(y, i);
		mult_inv_array[i] = yn;
		printf("%d: %8lx\n", i, mult_inv_array[i]);
	}

	printf("\n");
}

long mult_inv(long c, int n) {
	return SRR(c * runnable_avg_yN_inv[n], WMULT_SHIFT);
}

void calc_yn_sum(int n)
{
	int i;
	double sum = 0, sum_fl = 0, diff = 0;
	long approx = 0, approx_fm = 0, approx_fm2 = 0;

	printf("sum y^n\n");
	printf("   %8s  %8s  %8s  %8s %8s\n", "exact", "floor", "shift",
	       "fastmul1", "fastmul2");
	for (i = 1; i < n; i++) {
		sum = (y * sum + y * 1024);
		sum_fl = floor(y * sum_fl+ y * 1024);
		approx = approx_decay(approx) + approx_decay(1024);
		approx_fm = mult_inv(approx_fm, 1) + mult_inv(1024, 1);
		approx_fm2 += mult_inv(1024, i);

		/*diff = sum;*/
		printf("%2d: %8.0f  %8.0f  %8ld  %8ld  %8ld\n", i, sum,
				sum_fl - diff,
				approx - (long)diff,
				approx_fm - (long)diff,
				approx_fm2 - (long)diff);

	}
	printf("\n");
}

void calc_conv(long n) {
	long old_n;
	int i = -1;

	printf("convergence\n");
	do {
		old_n = n;
		n = mult_inv(n, 1) + 1024;
		i++;
	} while (n != old_n);
	printf("%d> %ld\n", i - 1, n);
	printf("\n");
}

void main() {
	calc_mult_inv();
	calc_conv(1024);
	calc_yn_sum(N);
}
