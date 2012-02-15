Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754576Ab2BOSz6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 13:55:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:49615 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753474Ab2BOSz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 13:55:57 -0500
Message-ID: <4F3BFFB3.1040907@gmail.com>
Date: Wed, 15 Feb 2012 11:55:47 -0700
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.1) Gecko/20120208 Thunderbird/10.0.1
MIME-Version: 1.0
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
CC: Luigi Semenzato <semenzato@chromium.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vasiliy Kulikov <segoon@openwall.com>,
        Stephen Wilson <wilsons@start.ca>, Oleg Nesterov <oleg@redhat.com>,
        Tejun Heo <tj@kernel.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Andi Kleen <ak@linux.intel.com>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>,
        Robert Richter <robert.richter@amd.com>, linux-kernel@vger.kernel.org,
        sonnyrao@chromium.org, olofj@chromium.org, eranian@google.com
Subject: Re: [PATCH] Perf: bug fix: distinguish between rename and exec
References: <1329195360-10699-1-git-send-email-semenzato@chromium.org>  <1329310113.2293.72.camel@twins> <4F3BE3F9.2010002@gmail.com> <1329327045.2293.156.camel@twins>
In-Reply-To: <1329327045.2293.156.camel@twins>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/12 10:30 AM, Peter Zijlstra wrote:
> On Wed, 2012-02-15 at 09:57 -0700, David Ahern wrote:
>>
>> I'm not Acme, but I do care. We use a lot of processes with named
>> threads that give users an idea about the function of a particular
>> thread.
>>
> But why would they care? If you're debugging its easy enough to see from
> the backtrace and if you're not, most tools like top/ps don't even show
> threads (by default).
>
> So who cares what threads are called.
>
> I realize I'm not going to convince anybody, but I genuinely don't see
> the point of naming threads.

Very subjective. How fast do you want your users/tech 
staff/developers/QA testers to make sense of what is going on? Which is 
more informative (process and thread names sanitized)

$ top -d5

top - 18:39:49 up 23:46,  1 user,  load average: 0.75, 0.37, 0.24
Cpu(s): 11.0%us, 19.0%sy,  0.0%ni, 47.8%id,  0.0%wa,  0.3%hi, 21.8%si, 
0.0%st

   PID USER   S %CPU %MEM    TIME+  COMMAND
  3830 root   S 62.4  1.1   1:16.68 myapp


Wow, myapp is sucking up CPU. I wonder what it's doing. 'H'.


With non-named threads:

top - 18:40:36 up 23:47,  1 user,  load average: 0.89, 0.47, 0.28
Cpu(s): 15.5%us, 22.4%sy,  0.0%ni, 45.7%id,  0.0%wa,  0.6%hi, 15.9%si, 
0.0%st

   PID USER  S %CPU %MEM    TIME+  COMMAND
  3891 root  S 44.8  1.1   0:12.39 myapp
  3879 root  R 14.6  1.1   0:26.07 myapp
  3893 root  S  8.7  1.1   0:08.62 myapp

Ok, so 3 threads are dominating the CPU. I guess I need to hook up gdb 
to find out which functional areas those threads are running. Or, for 
one product I worked on you have to know that the thread map is dumped 
to a file, get shell access, read it and mentally correlate lwps.

Or you can name the threads:

top - 18:40:36 up 23:47,  1 user,  load average: 0.89, 0.47, 0.28
Cpu(s): 15.5%us, 22.4%sy,  0.0%ni, 45.7%id,  0.0%wa,  0.6%hi, 15.9%si, 
0.0%st

   PID USER  S %CPU %MEM    TIME+  COMMAND
  3891 root  S 44.8  1.1   0:12.39 myapp:dispatch
  3879 root  R 14.6  1.1   0:26.07 myapp:my-mgr
  3893 root  S  8.7  1.1   0:08.62 myapp:worker

Sure process knowledge is needed but top gives a lot more information 
for named threads.

Even with perf having named threads makes the event dumps 100x more 
understandable because the comm name gives you a hint about what the 
task is does.

David
