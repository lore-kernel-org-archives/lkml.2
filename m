Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751735Ab2LALGq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Dec 2012 06:06:46 -0500
Received: from mxout2.iskon.hr ([213.191.128.81]:57135 "EHLO mxout2.iskon.hr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751339Ab2LALGo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Dec 2012 06:06:44 -0500
X-Remote-IP: 213.191.128.133
Date: Sat, 01 Dec 2012 12:06:41 +0100
From: Zlatko Calusic <zlatko.calusic@iskon.hr>
Organization: Iskon Internet d.d.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121031 Icedove/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org
References: <50A78AA9.5040904@iskon.hr> <20121130225200.GB6021@htj.dyndns.org> <20121130225545.GC6021@htj.dyndns.org>
In-Reply-To: <20121130225545.GC6021@htj.dyndns.org>
Message-ID: <50B9E4C1.2050002@iskon.hr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: Re: High context switch rate, ksoftirqd's chewing cpu
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45/RELEASE,
	 bases: 20121201 #8574610, check: 20121201 clean
X-SpamTest-Envelope-From: zlatko.calusic@iskon.hr
X-SpamTest-Group-ID: 00000000
X-SpamTest-Info: Profiles 39739 [Dec 01 2012]
X-SpamTest-Method: none
X-SpamTest-Rate: 0
X-SpamTest-SPF: none
X-SpamTest-Status: Not detected
X-SpamTest-Status-Extended: not_detected
X-SpamTest-Version: SMTP-Filter Version 3.0.0 [0284], KAS30/Release
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30.11.2012 23:55, Tejun Heo wrote:
> Hello, again.
> 
> Can you please try this patch?  Thanks!
> 
> diff --git a/kernel/workqueue.c b/kernel/workqueue.c
> index 042d221..26368ef 100644
> --- a/kernel/workqueue.c
> +++ b/kernel/workqueue.c
> @@ -1477,7 +1477,10 @@ bool mod_delayed_work_on(int cpu, struct workqueue_struct *wq,
>   	} while (unlikely(ret == -EAGAIN));
>   
>   	if (likely(ret >= 0)) {
> -		__queue_delayed_work(cpu, wq, dwork, delay);
> +		if (!delay)
> +			__queue_work(cpu, wq, &dwork->work);
> +		else
> +			__queue_delayed_work(cpu, wq, dwork, delay);
>   		local_irq_restore(flags);
>   	}
>   
> 

I have good news. The patch fixes the regression!

To doublecheck and provide you additional data, I updated to the latest Linus
kernel (commit 7c17e48), recompiled (WITHOUT the patch), rebooted and this is
what vmstat 1 looks like:

procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 1  0      0 2957924  43676 655840    0    0   868   460 1446 38112  1  1 75 23
 0  0      0 2957436  43684 655672    0    0     8  1290  941 30743  1  2 96  1
 0  0      0 2957416  43708 656120    0    0   300   501  755 23642  1  2 89  9
 1  0      0 2957648  43740 656592    0    0   632   162  946 19837  1  3 81 17
 0  0      0 2950104  43740 664660    0    0  8192     0  550  326  1  1 91  8
 0  0      0 2950600  43772 664092    0    0   148   289  691 39594  0  1 90  9
 0  0      0 2939580  43924 674612    0    0  5568   115 2424 38662  5  4 77 15
 0  1      0 2944888  43932 669580    0    0    56   869 1095 20062  6  1 89  4
 0  0      0 2945812  43936 670524    0    0   824    92  824 49790  0  2 93  5
 1  0      0 2945724  44084 670656    0    0   348    91  650 26455  1  1 89 10
 0  2      0 2945356  44380 670848    0    0   536   161  718 18824  1  2 76 22
 0  0      0 2944432  44400 671216    0    0   156   534  684 16232  2  1 81 17
 0  0      0 2943660  44412 671544    0    0   292   120  562 49618  1  3 87 10
 0  0      0 2943740  44412 671520    0    0     0     9  393 7247  0  0 100  0
 0  0      0 2943608  44420 671812    0    0   276    42  507 36329  1  1 96  3
 0  0      0 2943704  44420 671996    0    0   176     0  405  269  0  0 100  0
 0  0      0 2943548  44428 671964    0    0     0   238  534 14823  0  1 99  0
 0  0      0 2943136  44444 672156    0    0   212   692  698 29321  1  2 86 11

Then I applied the patch and this is how vmstat 1 looks now (WITH the patch):

 procs -----------memory---------- ---swap-- -----io---- -system-- ----cpu----
 r  b   swpd   free   buff  cache   si   so    bi    bo   in   cs us sy id wa
 1  0      0 2736628  35160 897708    0    0     8   293 1172 2493 17  3 79  1
 0  0      0 2737336  35172 897944    0    0   156    43  883  971  3  0 95  3
 0  0      0 2736500  35212 898252    0    0   292  5564 1267 2168 14  2 79  5
 0  0      0 2736056  35356 898864    0    0   596    51 1029 1344  2  3 90  6
 0  0      0 2735732  35504 899284    0    0   516    82 1225 1495  2  2 85 11
 0  1      0 2734052  35508 900324    0    0   512    91 1149 1225  2  2 93  4
 0  0      0 2733980  35508 899820    0    0     0    17  918 1164  2  1 96  1
 0  2      0 2733988  35812 899940    0    0   656  1764 1097 1549  3  2 79 17
 0  0      0 2733792  35820 900348    0    0    40    76 1303 1299  2  3 83 13
 0  0      0 2733888  35820 900344    0    0     0    17  914 1085  2  1 97  0
 0  0      0 2733316  35952 900364    0    0   144   235 1062 1316  1  2 95  3
 0  0      0 2733012  36092 900412    0    0   176    11 1112 1469  3  1 92  4
 0  0      0 2732732  36236 900444    0    0   160   709  932 1022  2  1 93  5
 1  0      0 2732128  36384 900400    0    0   156  8987 1491 2519 12  3 82  3
 0  0      0 2732128  36384 900416    0    0     0    34  927 1376  5  2 93  0
 0  0      0 2732044  36540 900788    0    0   444    82  963 1278  3  1 87  8
 1  0      0 2732020  36680 900796    0    0   168     2  883 1041  1  2 94  2
 0  0      0 2731228  36700 901456    0    0   324   196  882 1125  2  0 94  4

Observe the difference in the cs column!

I hope this gets in before 3.7.0. Good work Tejun!

Best regards,

-- 
Zlatko
