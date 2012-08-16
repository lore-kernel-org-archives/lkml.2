Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757042Ab2HPTAn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 15:00:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2760 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab2HPTAl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 15:00:41 -0400
Message-ID: <502D42E5.7090403@redhat.com>
Date: Thu, 16 Aug 2012 14:58:45 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, Hugh Dickins <hughd@google.com>
CC: linux-mm <linux-mm@kvack.org>
Subject: Re: Repeated fork() causes SLAB to grow without bound
References: <20120816024610.GA5350@evergreen.ssec.wisc.edu>
In-Reply-To: <20120816024610.GA5350@evergreen.ssec.wisc.edu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2012 10:46 PM, Daniel Forrest wrote:
> I'm hoping someone has seen this before...
>
> I've been trying to track down a performance problem with Linux 3.0.4.
> The symptom is system-mode load increasing over time while user-mode
> load remains constant while running a data ingest/processing program.
>
> Looking at /proc/meminfo I noticed SUnreclaim increasing steadily.
>
> Looking at /proc/slabinfo I noticed anon_vma and anon_vma_chain also
> increasing steadily.

Oh dear.

Basically, what happens is that at fork time, a new
"level" is created for the anon_vma hierarchy. This
works great for normal forking daemons, since the
parent process just keeps running, and forking off
children.

Look at anon_vma_fork() in mm/rmap.c for the details.

Having each child become the new parent, and the
previous parent exit, can result in an "infinite"
stack of anon_vmas.

Now, the parent anon_vma we cannot get rid of,
because that is where the anon_vma lock lives.

However, in your case you have many more anon_vma
levels than you have processes!

I wonder if it may be possible to fix your bug
by adding a refcount to the struct anon_vma,
one count for each VMA that is directly attached
to the anon_vma (ie. vma->anon_vma == anon_vma),
and one for each page that points to the anon_vma.

If the reference count on an anon_vma reaches 0,
we can skip that anon_vma in anon_vma_clone, and
the child process should not get that anon_vma.

A scheme like that may be enough to avoid the trouble
you are running into.

Does this sound realistic?

> I was able to generate a simple test program that will cause this:
>
> ---
>
> #include <unistd.h>
>
> int main(int argc, char *argv[])
> {
>     pid_t pid;
>
>     while (1) {
>        pid = fork();
>        if (pid == -1) {
> 	 /* error */
> 	 return 1;
>        }
>        if (pid) {
> 	 /* parent */
> 	 sleep(2);
> 	 break;
>        }
>        else {
> 	 /* child */
> 	 sleep(1);
>        }
>     }
>     return 0;
> }
>
> ---
>
> In the actual program (running as a daemon), a child is reading data
> while its parent is processing the previously read data.  At any time
> there are only a few processes in existence, with older processes
> exiting and new processes being fork()ed.  Killing the program frees
> the slab usage.
>
> I patched the kernel to 3.0.40, but the problem remains.  I also
> compiled with slab debugging and can see that the growth of anon_vma
> and anon_vma_chain is due to anon_vma_clone/anon_vma_fork.
>
> Is this a known issue?  Is it fixed in a later release?
>
> Thanks,
>


