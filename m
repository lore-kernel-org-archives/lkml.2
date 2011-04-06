Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755550Ab1DFRw1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 13:52:27 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42195 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753216Ab1DFRw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 13:52:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-url:user-agent;
        b=tYE4PimrhZjAMjQt7eHTT6mkfdYwQmY7S/A4SfumAIxRkD6mE4///ghXD78euK8VMr
         Kylsp47R/YbCV2o/3v/V6DAgNB5K1hdtFCr+hwLj/ci8vLSoS/zpRoC1mTc4m43jnBkQ
         lRhqNwsu7Ie6R1gM28iMY/3LESBaBzUqUjLRs=
Date: Wed, 6 Apr 2011 14:52:17 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Tim Blechmann <tim@klingt.org>
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [2.6.39-rc2] perf top fails to mmap
Message-ID: <20110406175217.GC4987@ghostprotocols.net>
References: <inhgjs$54a$1@dough.gmane.org>
 <4D9C84D5.6090303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D9C84D5.6090303@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Wed, Apr 06, 2011 at 09:20:53AM -0600, David Ahern escreveu:
> 
> 
> On 04/06/11 04:51, Tim Blechmann wrote:
> > hi all,
> > 
> > when trying to profile a process with `perf top -p $PID', perf exits with:
> > Failed to mmap with 22 (Invalid argument)
> 
> Works fine for me with latest kernel tree (this morning). Short lived
> process?
> 
> David
> 
> > 
> > this happens when running perf as the same process as the process and when 
> > running perf as root.

yep, works for me as well:

[acme@emilia ~]$ cat vsyscall.c 
#include <time.h>

int main(void)
{
        struct timespec t;
        //int i;
        //for(i = 0; i < 10000000; i++)
        while (1) {
                clock_gettime(CLOCK_MONOTONIC, &t);
		usleep(10);
	}
        return 0;
}
[acme@emilia ~]$ cc -lrt vsyscall.c -o vsyscall
[acme@emilia ~]$ ./vsyscall &
[acme@emilia linux]$ perf top -p `pidof vsyscall` -F 10000
PerfTop:  230 irqs/sec  kernel:88.3%  exact:  0.0% [10000Hz cycles],  (target_pid: 2728)
----------------------------------------------------------------------------------------

             samples  pcnt function             DSO
             _______ _____ ____________________ ____________________

               21.00 44.7% __nanosleep_nocancel /lib64/libc-2.12.so 
               13.00 27.7% usleep               /lib64/libc-2.12.so 
                6.00 12.8% __GI_clock_gettime   /lib64/librt-2.12.so
                6.00 12.8% main                 /home/acme/vsyscall
^C
[acme@emilia linux]$ su -
Password: 
[root@emilia ~]# perf top -p `pidof vsyscall` -F 10000 --hide_kernel_symbols
PerfTop:     428 irqs/sec  kernel:90.2%  exact:  0.0% [10000Hz cycles],  (target_pid: 2728)
-------------------------------------------------------------------------------------------

             samples  pcnt function             DSO
             _______ _____ ____________________ ____________________

               15.00 29.4% __nanosleep_nocancel /lib64/libc-2.12.so 
               14.00 27.5% usleep               /lib64/libc-2.12.so 
                9.00 17.6% __GI_clock_gettime   /lib64/librt-2.12.so
                8.00 15.7% main                 /home/acme/vsyscall 
^C
[root@emilia ~]#

- Arnaldo
