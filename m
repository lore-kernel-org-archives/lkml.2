Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755902Ab0JNSUB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 14:20:01 -0400
Received: from smtp-out.google.com ([74.125.121.35]:6983 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755862Ab0JNSUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 14:20:00 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=pOdt0G6yYXhgg6xhAQz/KIKgXQ9VV/iBRXpcFiOKwIODv1+VHk9m5khXFQ2vYnpG+W
         q7XUbr6WDZyXAfgvfsdQ==
MIME-Version: 1.0
In-Reply-To: <4CB72BF3.4030601@digium.com>
References: <1286237003-12406-1-git-send-email-venki@google.com>
	<4CB72BF3.4030601@digium.com>
Date: Thu, 14 Oct 2010 11:19:56 -0700
Message-ID: <AANLkTimSZDTjA-fsMzYb_5ogEYNkZArgWMJ5Q7LPbUb-@mail.gmail.com>
Subject: Re: Proper kernel irq time accounting -v4
From: Venkatesh Pallipadi <venki@google.com>
To: Shaun Ruffell <sruffell@digium.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 14, 2010 at 9:12 AM, Shaun Ruffell <sruffell@digium.com> wrote:
> On 10/04/2010 07:03 PM, Venkatesh Pallipadi wrote:
>> Solution to (1) involves adding extra timing on irq entry/exit to
>> get the fine granularity info and then exporting it to user.
>> The following patchset addresses this problem in a way similar to [2][3].
>> Keeps most of the code that does the timing generic
>> (CONFIG_IRQ_TIME_ACCOUNTING), based off of sched_clock(). And adds support for
>> this in x86. This time is not yet exported to userspace yet. Patch for that
>> coming soon.
>>
>
> Would you be willing to share your thoughts on how you plan to export
> this information to userspace?
>
> I applied this set to one of my machines in hopes of seeing more
> accurate hi time before I noticed that in the quoted paragraph you said
> this is still forthcoming.
>

Yes. I tried couple of variations on how to export this to user in my
earlier versions of this patchset and each of them had its own
problems. Right now I have patch that I am testing, which retrofits
/proc/stat to be based on this new fine granularity info. So, existing
tools like top, mpstat will show up this information.

This is how things would look like from top (with a CPU intensive loop
and a network intensive nc running on the system)


With vanilla kernel:
Cpu0  :  0.0% us,  0.3% sy,  0.0% ni, 99.3% id,  0.0% wa,  0.0% hi,  0.3% si
Cpu1  : 100.0% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu2  :  1.3% us, 27.2% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi, 71.4% si
Cpu3  :  1.6% us,  1.3% sy,  0.0% ni, 96.7% id,  0.0% wa,  0.0% hi,  0.3% si

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 7555 root      20   0  1760  528  436 R  100  0.0   0:15.79 nc
 7563 root      20   0  3632  268  204 R  100  0.0   0:13.13 loop


With this patchset:
Cpu0  :  0.0% us,  0.0% sy,  0.0% ni, 100.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu1  : 100.0% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi,  0.0% si
Cpu2  :  2.0% us, 30.6% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.0% hi, 67.4% si
Cpu3  :  0.7% us,  0.7% sy,  0.3% ni, 98.3% id,  0.0% wa,  0.0% hi,  0.0% si

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
 6289 root      20   0  3632  268  204 R  100  0.0   2:18.67 loop
 5737 root      20   0  1760  528  436 R   33  0.0   0:26.72 nc


With this patchset + exporting it through /proc/stat that I am testing:
Cpu0  :  1.3% us,  1.0% sy,  0.3% ni, 97.0% id,  0.0% wa,  0.0% hi,  0.3% si
Cpu1  : 99.3% us,  0.0% sy,  0.0% ni,  0.0% id,  0.0% wa,  0.7% hi,  0.0% si
Cpu2  :  1.3% us, 31.5% sy,  0.0% ni,  0.0% id,  0.0% wa,  8.3% hi, 58.9% si
Cpu3  :  1.0% us,  2.0% sy,  0.3% ni, 95.0% id,  0.0% wa,  0.7% hi,  1.0% si

  PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND
20929 root      20   0  3632  268  204 R   99  0.0   3:48.25 loop
20796 root      20   0  1760  528  436 R   33  0.0   2:38.65 nc


So, with this patchset you should see task CPU% showing only the exec
runtime of the task and not si time. With the upcoming change the CPU
times would get fixed as well. I am planning to send out the
"exporting through /proc/stat patchset" as incremental change once
this patchset gets into tip/next....

Thanks,
Venki
