Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756220Ab0G3KBz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 06:01:55 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45989 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752726Ab0G3KBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 06:01:51 -0400
Message-ID: <4C52A307.7080002@canonical.com>
Date: Fri, 30 Jul 2010 03:01:43 -0700
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Nick Piggin <npiggin@suse.de>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>, xiaosuo@gmail.com,
        laijs@cn.fujitsu.com
Subject: Re: [PATCH 01/13] AppArmor: misc. base functions and defines
References: <1280440089-3203-1-git-send-email-john.johansen@canonical.com>	<1280440089-3203-2-git-send-email-john.johansen@canonical.com> <AANLkTikk3tNM-fsXuS_SeAWgaYYCFrFAToRXOBkPxwy9@mail.gmail.com>
In-Reply-To: <AANLkTikk3tNM-fsXuS_SeAWgaYYCFrFAToRXOBkPxwy9@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/30/2010 02:20 AM, Pekka Enberg wrote:
> On Fri, Jul 30, 2010 at 12:47 AM, John Johansen
> <john.johansen@canonical.com> wrote:
>> +/**
>> + * kvmalloc - do allocation preferring kmalloc but falling back to vmalloc
>> + * @size: size of allocation
>> + *
>> + * Return: allocated buffer or NULL if failed
>> + *
>> + * It is possible that policy being loaded from the user is larger than
>> + * what can be allocated by kmalloc, in those cases fall back to vmalloc.
>> + */
>> +void *kvmalloc(size_t size)
>> +{
>> +       void *buffer = NULL;
>> +
>> +       if (size == 0)
>> +               return NULL;
>> +
>> +       /* do not attempt kmalloc if we need more than 16 pages at once */
>> +       if (size <= (16*PAGE_SIZE))
>> +               buffer = kmalloc(size, GFP_NOIO | __GFP_NOWARN);
> 
> 16 pages is a lot of memory for 64 K pages. What's the purpose of
yes it is, and I don't expect it will every allocate that much, though it
will occassionally with large policies do allocations larger than 16*4K.
The figure here is some what arbitrary, and I would certainly be willing
to shrink it.  Basically it is there to put a clamp on allocating precious
physically contiguous memory.

> GFP_NOIO here? vmalloc() will do GFP_KERNEL allocations anyway.
> 
yep, and it used to be GFP_KERNEL too, looking back GFP_NOIO happend when
poking at a bug where apparmor was trigger a IO when it was allocating its
memory.  Turned out the bug wasn't apparmor related just being triggered
while apparmor was loading policy, but the GFP_NOIO flag stuck here.
I am more than willing to flip it back.

>> +       if (!buffer) {
>> +               /* see kvfree for why size must be at least work_struct size
>> +                * when allocated via vmalloc
>> +                */
>> +               if (size < sizeof(struct work_struct))
>> +                       size = sizeof(struct work_struct);
>> +               buffer = vmalloc(size);
>> +       }
>> +       return buffer;
>> +}
> 
> Please don't hide this into apparmor internals. People have invented
> this function in the past so maybe it's time to put it in mm/util.c?
>
sure, I would be more than willing to replace this with a generic
system fn.  The last attempt I saw at adding generic routines of this
nature was here
http://www.spinics.net/lists/linux-fsdevel/msg31407.html

>> +
>> +/**
>> + * do_vfree - workqueue routine for freeing vmalloced memory
>> + * @work: data to be freed
>> + *
>> + * The work_struct is overlaid to the data being freed, as at the point
>> + * the work is scheduled the data is no longer valid, be its freeing
>> + * needs to be delayed until safe.
>> + */
>> +static void do_vfree(struct work_struct *work)
>> +{
>> +       vfree(work);
>> +}
>> +
>> +/**
>> + * kvfree - free an allocation do by kvmalloc
>> + * @buffer: buffer to free (MAYBE_NULL)
>> + *
>> + * Free a buffer allocated by kvmalloc
>> + */
>> +void kvfree(void *buffer)
>> +{
>> +       if (is_vmalloc_addr(buffer)) {
>> +               /* Data is no longer valid so just use the allocated space
>> +                * as the work_struct
>> +                */
>> +               struct work_struct *work = (struct work_struct *) buffer;
>> +               INIT_WORK(work, do_vfree);
>> +               schedule_work(work);
> 
> I don't understand this part here. Is it needed for interrupt contexts
> or does vfree() sleep somewhere? If it's for the former, I think we
> can just add a comment saying that kvmalloc/kvfree is not safe from
> interrupt context and remove the schedule_work() parts here.
> 
vfree can sleep, and skipping the schedule_work parts won't work for
apparmor as many of these allocations are being freed via rcu callbacks
as most of our object life cycles are dependent on cred refcounting.
