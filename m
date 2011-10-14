Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756280Ab1JNKIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 06:08:30 -0400
Received: from smtp-out.google.com ([216.239.44.51]:5414 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754098Ab1JNKI1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 06:08:27 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=OGp6PR4Y1dbtG4+9ox0Zof2mk4CzYZqvyPO5m6mqv4YkwPh7P6jUk+gsx8zzCfi74
	rRnC0tqEnzu37Grti+uKg==
Date: Fri, 14 Oct 2011 03:08:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Oberman, Laurence (HAS GSE)" <Laurence.Oberman@hp.com>
cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Seger, Mark" <mark.seger@hp.com>,
        "Cabaniols, Sebastien" <Sebastien.Cabaniols@hp.com>
Subject: Re: Regression in reading /proc/stat in the newer kernels with large
 SMP and NUMA configurations
In-Reply-To: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
Message-ID: <alpine.DEB.2.00.1110140249310.21487@chino.kir.corp.google.com>
References: <8DC664164FA4D1449479E7B36CDCFB1F221E724322@GVW0676EXC.americas.hpqcorp.net>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Oberman, Laurence (HAS GSE) wrote:

> On the 2.6.16.x series sles or 2.6.18.x RHEL kernels each read takes 84 
> us.
> 
> dl785sles:~/wrk # cat 2.6.16.60-0.87.1-smp.log Opened, read and closed 8640 times and read total of 13996800 bytes
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
>  99.41    0.725717          84      8641           read
>   0.38    0.002768           0      8642           open
>   0.21    0.001539           0      8642           close
>   0.00    0.000000           0         1           write
>   0.00    0.000000           0         3           fstat
>   0.00    0.000000           0         8           mmap
>   0.00    0.000000           0         2           mprotect
>   0.00    0.000000           0         1           munmap
>   0.00    0.000000           0         1           brk
>   0.00    0.000000           0         1         1 access
>   0.00    0.000000           0         1           madvise
>   0.00    0.000000           0         1           execve
>   0.00    0.000000           0         1           arch_prctl
> ------ ----------- ----------- --------- --------- ----------------
> 100.00    0.730024                 25945         1 total    
> 
> On the 2.6.38.4 kernel each read takes > 6ms
> 
> dl785sles:~/wrk # cat 2.6.38.4-smp.log
> Opened, read and closed 8640 times and read total of 86235840 bytes
> % time     seconds  usecs/call     calls    errors syscall
> ------ ----------- ----------- --------- --------- ----------------
> 100.00   59.021650        6830      8641           read
>   0.00    0.000520           0      8642           open
>   0.00    0.000425           0      8642           close
>   0.00    0.000000           0         1           write
>   0.00    0.000000           0         3           fstat
>   0.00    0.000000           0         9           mmap
>   0.00    0.000000           0         2           mprotect
>   0.00    0.000000           0         1           munmap
>   0.00    0.000000           0         1           brk
>   0.00    0.000000           0         1         1 access
>   0.00    0.000000           0         1           madvise
>   0.00    0.000000           0         1           execve
>   0.00    0.000000           0         1           arch_prctl
> ------ ----------- ----------- --------- --------- ----------------
> 100.00   59.022595                 25946         1 total        
> 

The overhead is probably in kstat_irqs_cpu() which is called for each 
possible irq for each of the 32 possible cpus, and /proc/stat actually 
does the sum twice.  You would see the same type of overhead with 
/proc/interrupts if it wasn't masked by the locking that it requires to 
safely read irq_desc.  "dmesg | grep nr_irqs" will show how many percpu 
variables are being read for every cpu twice.
