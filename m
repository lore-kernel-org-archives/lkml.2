Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755891Ab1LGMak (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Dec 2011 07:30:40 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:48514 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755827Ab1LGMai (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Dec 2011 07:30:38 -0500
Message-ID: <4EDF5C61.4050204@linux.vnet.ibm.com>
Date: Wed, 07 Dec 2011 18:00:25 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Namhyung Kim <namhyung@gmail.com>
CC: linux-kernel@vger.kernel.org, gregkh@suse.de, dhowells@redhat.com,
        eparis@redhat.com, rjw@sisk.pl, kay.sievers@vrfy.org,
        jmorris@namei.org, tj@kernel.org, bp@amd64.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/2] PM / Usermodehelper: Introduce reference counting
 to solve usermodehelper_disabled race
References: <20111205212456.27496.35812.stgit@srivatsabhat.in.ibm.com> <20111205212524.27496.58775.stgit@srivatsabhat.in.ibm.com> <4EDD68E3.6050100@gmail.com>
In-Reply-To: <4EDD68E3.6050100@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
x-cbid: 11120712-8256-0000-0000-00000069A36A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/06/2011 06:29 AM, Namhyung Kim wrote:

> Hello,
> 
> 2011-12-06 오전 6:26, Srivatsa S. Bhat 쓴 글:
>> This patch adds the necessary synchronization framework to fix the race
>> condition with the 'usermodehelper_disabled' flag, by implementing a
>> refcounting solution. Specifically, it introduces the pair
>> get_usermodehelper()
>> and put_usermodehelper(), which can be used by the readers (those who
>> want to
>> read the value of the usermodehelper_disabled flag, such as
>> _request_firmware()
>> in this case). The writers (those who enable/disable usermodehelpers by
>> setting/resetting that flag) can use the pair umh_control_begin() and
>> umh_control_done().
>>
>> The reason for using a refcounting solution and not just a plain
>> mutex, is
>> that we don't want to unnecessarily serialize all users of
>> request_firmware(),
>> which act as readers. But note that we cannot use reader-writer locks
>> here
>> because the readers sleep (waiting for the firmware load from
>> user-space),
>> and sleeping with spinlocks held is not allowed. So refcounting
>> implemented
>> using mutex locks underneath, seems to be the best fit here.
>>
>> Signed-off-by: Srivatsa S. Bhat<srivatsa.bhat@linux.vnet.ibm.com>
>> ---
>>
>> The refcounting solution implemented here is adapted from the one used in
>> the CPU hotplug infrastructure (kernel/cpu.c). If this patchset sounds
>> reasonable, I plan to make the refcounting generic (in a later patch) and
>> expose it via include/linux/refcount.h or something similar, and then
>> use it
>> at these 2 places instead of duplicating code.
>>
> 
> IMHO it seems that the write path of the cpu_hotplug is protected by
> another mutex (cpu_add_remove_lock) to guarantee that the only one
> writer is active at a time. But I'm not sure this is the case for the
> umhelper too.


For the umhelper, I had not added anything explicit for this serialization
because, all the users of usermodehelper_disable/enable are callers
from hibernate/suspend code (which all take the 'pm_mutex' lock before
doing anything) or from reboot/shutdown code.

> 
> If more than 2 tasks call umh_control_begin() at the same time (is it
> possible though?), it will lost tasks except for the winner and
> active_writer AFAICS. Am I missing something?
> 


See my thoughts above about the callers of umh_control_begin(). 

Anyways, I'll use rwsemaphores as Tejun suggested, since that would be
the most logical choice here, and it also makes the code much simpler.

Thanks a lot for your review!

[Btw I was wondering why your mail didn't land in my inbox. Now I see,
I am neither in your "To" or "Cc" list! :-)]

Thanks,
Srivatsa S. Bhat

