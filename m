Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab3AJRip (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:38:45 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:37335 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753787Ab3AJRio (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:38:44 -0500
Date: Thu, 10 Jan 2013 23:06:03 +0530
From: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
To: Rafael Aquini <aquini@redhat.com>, Rik van Riel <riel@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, walken@google.com,
        eric.dumazet@gmail.com, lwoodman@redhat.com, jeremy@goop.org,
        Jan Beulich <JBeulich@novell.com>, knoel@redhat.com,
        chegu_vinod@hp.com, mingo@redhat.com
Subject: Re: [PATCH 0/5] x86,smp: make ticket spinlock proportional backoff
 w/ auto tuning
Message-ID: <20130110173603.GA31549@linux.vnet.ibm.com>
Reply-To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
References: <20130108172632.1126898a@annuminas.surriel.com>
 <50ED679B.9020306@linux.vnet.ibm.com>
 <20130110022722.GA1636@x61.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20130110022722.GA1636@x61.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13011017-7182-0000-0000-00000454EA06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Rafael Aquini <aquini@redhat.com> [2013-01-10 00:27:23]:

> On Wed, Jan 09, 2013 at 06:20:35PM +0530, Raghavendra K T wrote:
> > I ran kernbench on 32 core (mx3850) machine with 3.8-rc2 base.
> > x base_3.8rc2
> > + rik_backoff
> >     N           Min           Max        Median           Avg        Stddev
> > x   8       222.977        231.16       227.735       227.388     3.1512986
> > +   8        218.75       232.347      229.1035     228.25425     4.2730225
> > No difference proven at 95.0% confidence
> 
> I got similar results on smaller systems (1 socket, dual-cores and quad-cores)
> when running Rik's latest series, no big difference for good nor for worse,
> but I also think Rik's work is meant to address bigger systems with more cores
> contending for any given spinlock.

I was able to do the test on same 32 core machine with
4 guests (8GB RAM, 32 vcpu).
Here are the results

base = 3.8-rc2
patched =  base + Rik V3 backoff series [patch 1-4]

+-----------+-----------+-----------+------------+-----------+
                kernbench (sec lower is better) 
+-----------+-----------+-----------+------------+-----------+
    base        stdev        patched      stdev     %improve
+-----------+-----------+-----------+------------+-----------+
    44.3000     2.0404	    46.7928     1.7518	  -5.62709
    94.8262     5.1444	   102.4737     7.8406	  -8.06475
   156.0540    14.5797	   167.6888     9.7110	  -7.45562
   202.3225    15.8906	   213.1435    17.1778	  -5.34839
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
               sysbench (sec lower is better)
+-----------+-----------+-----------+------------+-----------+
    base        stdev        patched      stdev     %improve
+-----------+-----------+-----------+------------+-----------+
    16.8512     0.4164	    17.7301     0.3761	  -5.21565
    13.0411     0.4115	    12.9380     0.1554	   0.79058
    18.4573     0.2123	    18.4662     0.2005	  -0.04822
    24.2021     0.1713	    24.3690     0.3270	  -0.68961
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
               ebizzy (record/sec higher is better)
+-----------+-----------+-----------+------------+-----------+
    base        stdev        patched      stdev     %improve
+-----------+-----------+-----------+------------+-----------+
  2494.4000    27.5447	  2400.6000    83.4255	  -3.76042
  2636.6000   302.9658	  2757.5000   147.5137	   4.58545
  2236.8333   239.6531	  2131.6667   156.1534	  -4.70158
  1768.8750   142.5437	  1901.3750   295.2147	   7.49064
+-----------+-----------+-----------+------------+-----------+
+-----------+-----------+-----------+------------+-----------+
              dbench (throughput in MB/sec higher is better)
+-----------+-----------+-----------+------------+-----------+
    base        stdev        patched      stdev     %improve
+-----------+-----------+-----------+------------+-----------+
 10076.9180  2410.9655	  5870.7460  4297.4532	  xxxxxxx
  2152.5220    88.2853	  1517.8270    61.9742	 -29.48611
  1334.9608    34.3247	  1078.4275    38.2288	 -19.21654
   946.6355    32.0426	   753.0757    25.5302	 -20.44713
+-----------+-----------+-----------+------------+-----------+

Please note that I have put dbench_1x result as xxxx since I observed
very high variance in the result.

