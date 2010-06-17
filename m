Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab0FQHBK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 03:01:10 -0400
Received: from mga14.intel.com ([143.182.124.37]:6039 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754148Ab0FQHBG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 03:01:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,430,1272870000"; 
   d="scan'208";a="289871913"
Subject: [patch] Over schedule issue fixing
From: "Alex,Shi" <alex.shi@intel.com>
To: linux-kernel@vger.kernel.org
Cc: yanmin.zhang@intel.com, tim.c.chen@intel.com
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Jun 2010 14:08:13 +0800
Message-ID: <1276754893.9452.5442.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

commit e709715915d69b6a929d77e7652c9c3fea61c317 introduced an imbalance
schedule issue. If we do not use CGROUP, function update_h_load won't
want to update h_load. When the system has a large number of tasks far
more than logical CPU number, the incorrect cfs_rq[cpu]->h_load value
will cause load_balance() to pull too many tasks to local CPU from the
busiest CPU. So the busiest CPU keeps being in a round robin. That will
hurt performance. 
The issue was found originally by a scientific calculation workload that
developed by Yanmin. with the commit, the workload performance drops
about 40% from this commit.  We can be reproduced by a short program as
following.

# gcc -o sl sched-loop.c -lpthread
# ./sl -n 100 -t 100 & 
# cat /proc/sched_debug &> sd1 
# grep -A 1 cpu# sd1
sd1:cpu#0, 2533.008 MHz
sd1-  .nr_running                    : 2
--
sd1:cpu#1, 2533.008 MHz
sd1-  .nr_running                    : 1
--
sd1:cpu#2, 2533.008 MHz
sd1-  .nr_running                    : 11
--
sd1:cpu#3, 2533.008 MHz
sd1-  .nr_running                    : 12
--
sd1:cpu#4, 2533.008 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#5, 2533.008 MHz
sd1-  .nr_running                    : 11
--
sd1:cpu#6, 2533.008 MHz
sd1-  .nr_running                    : 10
--
sd1:cpu#7, 2533.008 MHz
sd1-  .nr_running                    : 12
--
sd1:cpu#8, 2533.008 MHz
sd1-  .nr_running                    : 11
--
sd1:cpu#9, 2533.008 MHz
sd1-  .nr_running                    : 12
--
sd1:cpu#10, 2533.008 MHz
sd1-  .nr_running                    : 1
--
sd1:cpu#11, 2533.008 MHz
sd1-  .nr_running                    : 1
--
sd1:cpu#12, 2533.008 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#13, 2533.008 MHz
sd1-  .nr_running                    : 2
--
sd1:cpu#14, 2533.008 MHz
sd1-  .nr_running                    : 2
--
sd1:cpu#15, 2533.008 MHz
sd1-  .nr_running                    : 1

After apply the fixing patch, cfs_rq get balance. 

sd1:cpu#0, 2533.479 MHz
sd1-  .nr_running                    : 7
--
sd1:cpu#1, 2533.479 MHz
sd1-  .nr_running                    : 7
--
sd1:cpu#2, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#3, 2533.479 MHz
sd1-  .nr_running                    : 7
--
sd1:cpu#4, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#5, 2533.479 MHz
sd1-  .nr_running                    : 7
--
sd1:cpu#6, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#7, 2533.479 MHz
sd1-  .nr_running                    : 7
--
sd1:cpu#8, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#9, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#10, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#11, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#12, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#13, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#14, 2533.479 MHz
sd1-  .nr_running                    : 6
--
sd1:cpu#15, 2533.479 MHz
sd1-  .nr_running                    : 6

---
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <pthread.h>

volatile int * exiting;

void *idle_loop(){
        volatile int calc01 = 100;
        while(*exiting !=1)
                calc01++;
}
int main(int argc, char *argv[]){
        int                     i, t, c, er=0, num=8;
        static  char            optstr[] = "n:t:";
        pthread_t                       ptid[1024];

        while ((c = getopt(argc, argv, optstr)) != EOF)
                switch (c) {
                case 'n':
                        num = atoi(optarg);
                        break;
                case 't':
                        t = atoi(optarg);
                        break;
                case '?':
                        er = 1;
                        break;
                }

        if (er) {
                printf("usage: %s %s\n", argv[0], optstr);
                exit(1);
        }
        exiting = malloc(sizeof(int));

        *exiting = 0;
        for(i=0; i<num ; i++)
                pthread_create(&ptid[i], NULL, idle_loop, NULL);

        sleep(t);
        *exiting = 1;

        for (i=0; i<num; i++)
                pthread_join(ptid[i], NULL);
        exit(0);

}

Reviewed-by: Yanmin zhang <yanmin.zhang@intel.com>
Signed-off-by: Alex Shi <alex.shi@intel.com>

diff --git a/kernel/sched.c b/kernel/sched.c
index f8b8996..a18bf93 100644
--- a/kernel/sched.c
+++ b/kernel/sched.c
@@ -1660,9 +1660,6 @@ static void update_shares(struct sched_domain *sd)
 
 static void update_h_load(long cpu)
 {
-	if (root_task_group_empty())
-		return;
-
 	walk_tg_tree(tg_load_down, tg_nop, (void *)cpu);
 }
 


