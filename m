Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756636Ab2ENOyc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 10:54:32 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:39522 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755667Ab2ENOyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 10:54:22 -0400
Date: Mon, 14 May 2012 11:54:16 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: David Ahern <dsahern@gmail.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf-record: Create events initially disabled -- again
Message-ID: <20120514145416.GB4254@infradead.org>
References: <1336968088-11531-1-git-send-email-dsahern@gmail.com>
 <87sjf31a8c.fsf@sejong.aot.lge.com>
 <4FB1041C.1050903@gmail.com>
 <4FB114CE.10904@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB114CE.10904@gmail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, May 14, 2012 at 08:21:02AM -0600, David Ahern escreveu:
> On 5/14/12 7:09 AM, David Ahern wrote:
> >>A problem I see is that it'll break group handling again:
> >>
> >>$ ./perf stat -g sleep 1
> >>
> >>Performance counter stats for 'sleep 1':
> >>
> >><not counted> task-clock
> >><not counted> context-switches
> >><not counted> CPU-migrations
> >><not counted> page-faults
> >><not counted> cycles
> >><not counted> stalled-cycles-frontend
> >><not counted> stalled-cycles-backend
> >><not counted> instructions
> >><not counted> branches
> >><not counted> branch-misses
> >>
> >>1.000868932 seconds time elapsed
> >>
> >>So I suggest changing perf_target__none() check to a proper one
> >>(perf_target__no_cpu? - the name might be changed soon) for your
> >>purpose.
> >
> >Something else is wrong then. I tested that command (saw your patch in
> >the history) and it worked for me. Also, this code path does not affect
> >perf-stat -- it touches perf-record and perf-test only.
> 
> I think it is something else. I am running latest git tree
> (3.4.0-rc7). perf from Linus' tree and acme/core both show:
> 
> perf stat -g  -- find /usr >/dev/null
> 
>  Performance counter stats for 'find /usr':
> 
>      <not counted> task-clock
>      <not counted> context-switches
>      <not counted> CPU-migrations
>      <not counted> page-faults
>      <not counted> cycles
>      <not counted> stalled-cycles-frontend
>      <not counted> stalled-cycles-backend
>      <not counted> instructions
>      <not counted> branches
>      <not counted> branch-misses
> 
>        0.111976940 seconds time elapsed
> 
> (Using find to make sure some work is done as opposed to sleep;
> openssl speed also shows the above.)

[acme@sandy ~]$ perf stat -g  -- find /usr >/dev/null
find: `/usr/lib64/audit': Permission denied
^Cfind: Interrupt

 Performance counter stats for 'find /usr':

     <not counted> task-clock              
     <not counted> context-switches        
     <not counted> CPU-migrations          
     <not counted> page-faults             
     <not counted> cycles                  
     <not counted> stalled-cycles-frontend 
     <not counted> stalled-cycles-backend  
     <not counted> instructions            
     <not counted> branches                
     <not counted> branch-misses           

       1.282060271 seconds time elapsed


[acme@sandy ~]$ uname -r
3.4.0-rc4-uprobes+

But:

[acme@felicio linux]$ uname -r
3.4.0-rc3+
[acme@felicio linux]$ perf stat -g  -- find /usr >/dev/null
^Cfind: Interrupt

 Performance counter stats for 'find /usr':

        126.499751 task-clock                #    0.122 CPUs utilized          
     <not counted> context-switches        
     <not counted> CPU-migrations          
     <not counted> page-faults             
       366,694,182 cycles                    #    2.899 GHz                    
       151,332,137 stalled-cycles-frontend   #   41.27% frontend cycles idle   
       103,373,418 stalled-cycles-backend    #   28.19% backend  cycles idle   
       408,309,250 instructions              #    1.11  insns per cycle        
                                             #    0.37  stalled cycles
                                             #    per insn
        77,453,802 branches                  #  612.284 M/sec                  
         1,703,728 branch-misses             #    2.20% of all branches        

       1.032917277 seconds time elapsed


[acme@felicio linux]$

Bisecting...

- Arnaldo
