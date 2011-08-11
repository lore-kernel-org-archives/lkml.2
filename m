Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752280Ab1HKICK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 04:02:10 -0400
Received: from nm13.bullet.mail.sp2.yahoo.com ([98.139.91.83]:38176 "HELO
	nm13.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751085Ab1HKICG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 04:02:06 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 177887.10958.bm@omp1038.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=iIuTUzeoX48SqypBAAPMI9vIlzx4KaaLXUXbEfdFg63WVSiRsb0un+WHhE7iNkaAy/F8Ae6FyInBf8Xkw8YPfe+K+CdpNJ+MJ3RweZjFYakpXjvoPknPoKa4/Pkhl35FPvlbl8S48J4HkdDUQhRmu7bNQeuaqr3rzsIU4nXwm0Y=;
X-YMail-OSG: INpV.hMVM1l5yvNlu3sVzvncHFnbDZyIYRVBKV8SgBVfx9.
 c2S88ruoQkzPFndpcZ_Wi6J5hbrhOsTWiFDyrQJc_q0wmYpMm0prHUC9_2dE
 fnhlogb2qcwFGSc0RsvAzUWLcLjMu8A9lHNLwJ6vavxhgHmbaADgiOx6Yrta
 XxM1qKlz_0exC9KRug10uNWE8uLJFNJ5Om9a95Gwx7yKgZib9SaSr9MsKiz9
 vW3FLOjefTh_9muQyrOFvwzJZTZl1X2DHv27IkpSYPetGJZ46lxd8oAOFwnX
 BahnFtlzApsxpYLoVTgbfpdHUNHZYO5BCZz.11Ceeu17l7YQqZ42yAK9a1_3
 Fg6Ltj2IbXeGRbMDmp_zOzwtwxhrscf5AKWhN0FTq7hRUXLEgdOTSVf7_JP3
 IAuWSxTgo31duc387OwuSWTgpklMzJek90J684jfhO8Z432HoJCDLuQM0Wft
 4ahkX
X-Mailer: YahooMailWebService/0.8.113.313619
References: <1312872786.70934.YahooMailNeo@web111712.mail.gq1.yahoo.com> <1db776d865939be598cdb80054cf5d93.squirrel@xenotime.net> <1312874259.89770.YahooMailNeo@web111704.mail.gq1.yahoo.com> <alpine.DEB.2.00.1108090900170.30199@chino.kir.corp.google.com> <1312964098.7449.YahooMailNeo@web111712.mail.gq1.yahoo.com> <alpine.DEB.2.00.1108102106410.14230@chino.kir.corp.google.com> <1313046422.18195.YahooMailNeo@web111711.mail.gq1.yahoo.com> <alpine.DEB.2.00.1108110010220.23622@chino.kir.corp.google.com>
Message-ID: <1313049724.11241.YahooMailNeo@web111704.mail.gq1.yahoo.com>
Date: Thu, 11 Aug 2011 01:02:04 -0700 (PDT)
From: Mahmood Naderan <nt_mahmood@yahoo.com>
Reply-To: Mahmood Naderan <nt_mahmood@yahoo.com>
Subject: Re: running of out memory => kernel crash
To: David Rientjes <rientjes@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        "\"\"\"linux-kernel@vger.kernel.org\"\"\"" 
	<linux-kernel@vger.kernel.org>,
        "\"\"linux-mm@kvack.org\"\"" <linux-mm@kvack.org>
In-Reply-To: <alpine.DEB.2.00.1108110010220.23622@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>Despite it's name, kswapd is still active, it's trying to reclaim memory 
>to prevent having to kill a process as the last resort.
 
I understand what you said, but I did two scenarios:
1- I wrote a simple C++ program that "new" a lot of pointers.
   for ( int i = 0; i < n; i++ ) {
     for ( int j = 0; j < n; j++ ) {
       for ( int k = 0; k < n; k++ ) {
         for ( int l = 0; l < n; l++ ) {
           double *ptr1 = new double[n*i];
           double *ptr2 = new double[n*j];
     }}}}

When I run the program, it ill eat the memory and when it reaches the
maximum ram, it get killed and I saw  message on terminal:

mahmood@vpc:~$ ./leak
Killed

for this scenario, there is no kswapd process running. As it eats the memory
suddenly it get killed.

2- There is 300MB ram. I opened an application saw that
free space reduced to 100MB, then another application reduced the free
space to 30MB. Another application reduced to 4MB. Now the "kswapd"
is running with a lot of disk activity and tries to keep free space at 4MB.
In this scenario, No application is killed.

The question is why in one scenario, the application is killed and in one
scenario, kswapd is running.

I think in the first scenario, the oom_score is calculated more rapidly 
than the second, so immediately is get killed. So kswapd has no chance 
to run because application is killed sooner. In the second scenario, 
kswapd has time to run first. So it will try to free some spaces. However 
since the disk activity is very high, the response time is very high
so the oom_score is calculated lately than first scenario.

Is my understandings correct?


>If /proc/sys/vm/panic_on_oom is not set, as previously mentioned, then 
>we'll need the kernel log to diagnose this further.
I checked that and it is 0. I am trying to reproduce the problem to get some logs


// Naderan *Mahmood;


----- Original Message -----
From: David Rientjes <rientjes@google.com>
To: Mahmood Naderan <nt_mahmood@yahoo.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>; """linux-kernel@vger.kernel.org""" <linux-kernel@vger.kernel.org>; ""linux-mm@kvack.org"" <linux-mm@kvack.org>
Sent: Thursday, August 11, 2011 11:43 AM
Subject: Re: running of out memory => kernel crash

On Thu, 11 Aug 2011, Mahmood Naderan wrote:

> >The default behavior is to kill all eligible and unkillable threads until 
> >there are none left to sacrifice (i.e. all kthreads and OOM_DISABLE).
>  
> In a simple test with virtualbox, I reduced the amount of ram to 300MB. 
> Then I ran "swapoff -a" and opened some applications. I noticed that the free
> spaces is kept around 2-3MB and "kswapd" is running. Also I saw that disk
> activity was very high. 
> That mean although "swap" partition is turned off, "kswapd" was trying to do
> something. I wonder how that behavior can be explained?
> 

Despite it's name, kswapd is still active, it's trying to reclaim memory 
to prevent having to kill a process as the last resort.

If /proc/sys/vm/panic_on_oom is not set, as previously mentioned, then 
we'll need the kernel log to diagnose this further.
