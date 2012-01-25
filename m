Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab2AYSop (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jan 2012 13:44:45 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:53202 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab2AYSon (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jan 2012 13:44:43 -0500
Message-ID: <4F204D90.7010105@linux.vnet.ibm.com>
Date: Thu, 26 Jan 2012 00:14:32 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Jiri Slaby <jirislaby@gmail.com>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Jiri Slaby <jslaby@suse.cz>, LKML <linux-kernel@vger.kernel.org>,
        Baohua.Song@csr.com, Tejun Heo <tj@kernel.org>,
        "pavel@ucw.cz" <pavel@ucw.cz>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: [linux-pm] PM: cannot hibernate -- BUG at	kernel/workqueue.c:3659
References: <4F1EC8D5.5040102@suse.cz> <201201250002.37916.rjw@sisk.pl> <4F1F4717.2090704@gmail.com> <201201250110.44360.rjw@sisk.pl> <4F20204F.6040606@linux.vnet.ibm.com> <4F202721.6050900@linux.vnet.ibm.com>
In-Reply-To: <4F202721.6050900@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12012518-9574-0000-0000-0000011B2FB4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 

> Commit 2aede851 (PM / Hibernate: Freeze kernel threads after preallocating
> memory) split up the freezing phase and moved the freezing of kernel threads
> to hibernation_snapshot() function.
> (This is a pretty old commit btw, I think it came in sometime around 3.2).
> 
> And there is a BUG_ON() in freeze_workqueues_begin() which complains if
> this function is called when the kernel threads are already frozen.
> 
> Now, coming to the userspace utility:
> 
>> In suspend.c inside the suspend-utils userspace package, I see a loop such
>> as:
>>
>>         error = freeze(snapshot_fd);
>> 	...
>>         attempts = 2;
>>         do {
>>                 if (set_image_size(snapshot_fd, image_size)) {
>>                         error = errno;
>>                         break;
>>                 }
>>                 if (atomic_snapshot(snapshot_fd, &in_suspend)) {
>                         ^^^ 
>         This ends up in the call to hibernation_snapshot().
> 
>>                         error = errno;
>>                         break;
>>                 }
>>                 if (!in_suspend) {
>>                         /* first unblank the console, see console_codes(4) */
>>                         printf("\e[13]");
>>                         printf("%s: returned to userspace\n", my_name);
>>                         free_snapshot(snapshot_fd);
>>                         break;
>>                 }
>>
>>                 error = write_image(snapshot_fd, resume_fd, -1);
>>                 if (error) {
> 
>         Since swap space is limited, we come here.
> 
>>                         free_swap_pages(snapshot_fd);
>>                         free_snapshot(snapshot_fd);

				^^^
	This function makes the ioctl call SNAPSHOT_FREE.

>>                         image_size = 0;
>>                         error = -error;
>>                         if (error != ENOSPC)
>>                                 break;
> 
> 
> 
> 
>         And because of the above 'if' condition, we don't break here.
>         IOW, we will run the loop a second time.
> 
>>                 } else {
>>                         splash.progress(100);
>> #ifdef CONFIG_BOTH
>>                         if (s2ram_kms || s2ram) {
>>                                 /* If we die (and allow system to continue)
>>                                  * between now and reset_signature(), very bad
>>                                  * things will happen. */
>>                                 error = suspend_to_ram(snapshot_fd);
>>                                 if (error)
>>                                         goto Shutdown;
>>                                 reset_signature(resume_fd);
>>                                 free_swap_pages(snapshot_fd);
>>                                 free_snapshot(snapshot_fd);
>>                                 if (!s2ram_kms)
>>                                         s2ram_resume();
>>                                 goto Unfreeze;
>>                         }
>> Shutdown:
>> #endif
>>                         close(resume_fd);
>>                         suspend_shutdown(snapshot_fd);
>>                 }
>>         } while (--attempts);
>>
>> ...
>> Unfreeze:
>>         unfreeze(snapshot_fd);
>>
>>
> 
> 
> So, since the loop is run a second time if not enough space was available,
> we end up calling hibernation_snapshot(), IOW freeze_workqueues_begin() a
> second time - and this is what makes the BUG_ON() to fire!
> 


SNAPSHOT_CREATE_IMAGE has a check for data->ready such as:

        if (data->mode != O_RDONLY || !data->frozen  || data->ready) {
                error = -EPERM;
                break;
        }

data->ready would be set to 1 only under SNAPSHOT_CREATE_IMAGE. However,
SNAPSHOT_FREE (invoked at the place shown above) will reset the value to 0.
This makes it possible for hibernation_snapshot() and hence
freeze_workqueues_begin() to be called a second time, which is unfortunate.

And actually, the patch I posted in my previous mail is not really the right
long-term fix, though it might fix the particular issue that Jiri is facing..

Because, allowing hibernation_snapshot() to get called a second time while
kernel threads are still frozen brings us to the same situation that commit
2aede851 (PM / Hibernate: Freeze kernel threads after preallocating memory)
tried to prevent! IOW, a call to hibernate_preallocate_memory() would be
done inside hibernation_snapshot(), when kernel threads are frozen.. which
is known to break XFS, to give one example as mentioned in the changelog
of the above commit.

So, the right way to fix this IMHO, would be to split up thaw_processes()
just like freezing phase:

/* freezes or thaws user space processes */
freeze_processes() - thaw_processes()

/* freezes or thaws kernel threads */
freeze_kernel_threads() - thaw_kernel_threads()

We have to insert this thaw_kernel_threads() at appropriate places in such a
way as to not require another ioctl if possible... Then things would be
more symmetric (and hence more easy to understand) and we can avoid getting
into strange situations as discussed here.

But before we venture into that, it would be good to know if the patch posted
in the previous mail fixes the particular problem reported in this thread,
atleast just to see if there are other problems lurking that we aren't aware
of yet..

Regards,
Srivatsa S. Bhat

