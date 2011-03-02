Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768Ab1CBP0E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 10:26:04 -0500
Received: from mailout-de.gmx.net ([213.165.64.22]:58281 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751988Ab1CBP0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 10:26:03 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18WdXMOB/0WFXX/tRotUpEXUflcn7TqoDOwllWjyu
	W7ZN6B0oaQ5o/f
Subject: Re: [PATCH] sched: next buddy hint on sleep and preempt path
From: Mike Galbraith <efault@gmx.de>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Rik van Riel <riel@redhat.com>
In-Reply-To: <1299061903.1310.1.camel@laptop>
References: <1299022433-17233-1-git-send-email-venki@google.com>
	 <1299061903.1310.1.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 02 Mar 2011 16:25:58 +0100
Message-ID: <1299079558.9020.18.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.1.2 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-03-02 at 11:31 +0100, Peter Zijlstra wrote:
> On Tue, 2011-03-01 at 15:33 -0800, Venkatesh Pallipadi wrote:
> > When a task in a taskgroup sleeps, pick_next_task starts all the way back at
> > the root and picks the task/taskgroup with the min vruntime across all
> > runnable tasks. But, when there are many frequently sleeping tasks
> > across different taskgroups, it makes better sense to stay with same taskgroup
> > for its slice period (or until all tasks in the taskgroup sleeps) instead of
> > switching cross taskgroup on each sleep after a short runtime.
> > This helps specifically where taskgroups corresponds to a process with
> > multiple threads. The change reduces the number of CR3 switches in this case.
> 
> I wasn't expecting this approach to this problem, and was dreading a
> pick_next_task() rewrite, but aside from all the mentioned problems it
> does look quite nice :-)
> 
> It doesn't avoid iterating the whole hierarchy every schedule, but like
> you say, it should avoid the expensive cr3 switches.

FWIW, some numbers from banging tbench and mysql+oltp together to see
what happens.

unpatched tip

mysql+oltp solo

clients              1          2          4          8         16         32         64        128        256
              11078.14   20600.50   36517.18   36097.94   34989.94   33628.60   31682.38   26809.03   20311.53
              10987.48   20636.78   36983.98   36556.50   35035.15   33626.54   31740.77   27124.11   20448.92
              10977.32   20640.12   36362.76   36315.82   34794.60   33675.73   31817.49   26927.34   20386.41
         avg  11014.31   20625.80   36621.30   36323.42   34939.89   33643.62   31746.88   26953.49   20382.28

tbench 16 solo 1076.32 MB/sec

mysql+oltp + tbench 16
clients              1          2          4          8         16         32         64        128        256
               9147.08   16458.56   17613.71   20514.14   18233.71   18115.45   17205.45   14346.86    9073.38
               9700.07   16409.88   19206.53   19311.40   18644.14   17926.43   17030.01   13646.80    9137.17
               9324.63   16705.00   18909.88   19535.12   18718.56   17794.90   16957.54   13591.91    8858.30
         avg   9390.59   16524.48   18576.70   19786.88   18532.13   17945.59   17064.33   13861.85    9022.95

tbench 16 + mysql+oltp  590.49 MB/sec

patched tip

mysql+oltp solo

clients              1          2          4          8         16         32         64        128        256
              11040.91   20535.52   32602.98   36062.36   34890.45   33663.40   31923.10   27007.86   20285.95
              11076.79   20708.12   35328.35   36502.54   35251.00   33568.11   31633.70   26846.61   20336.28
              11071.31   20697.78   37281.81   36451.19   35285.16   33502.64   31353.73   26733.23   20151.40
         avg  11063.00   20647.14   35071.04   36338.69   35142.20   33578.05   31636.84   26862.56   20257.87
                 1.004      1.001       .957      1.000      1.005       .998       .996       .996       .993

tbench 16 solo 1080.23 MB/sec
                 1.003

mysql+oltp + tbench 16
clients              1          2          4          8         16         32         64        128        256
               9649.64   17510.35   18231.25   19089.73   19363.54   18528.36   17190.88   14393.28    8747.72
              10010.87   17308.15   19926.13   20421.10   19757.92   18901.87   18127.18   14701.35    9157.01
               9759.10   16897.08   19305.13   19289.35   20086.89   18777.02   17144.39   14690.63    9160.61
         avg   9806.53   17238.52   19154.17   19600.06   19736.11   18735.75   17487.48   14595.08    9021.78
                 1.044      1.043      1.031       .990      1.064      1.044      1.024      1.052       .999

tbench 16 + mysql+oltp  593.36 MB/sec
                        1.004

Note: Variance at peak (4) is cgroups oddity with mysql+oltp.  Unpatched
solo run happened to hit 3 consecutive good runs.  Variance is the norm
right at peak for some odd reason.  

	-Mike

