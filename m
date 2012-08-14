Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757516Ab2HNUr7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 16:47:59 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:34951 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756336Ab2HNUr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 16:47:57 -0400
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D4137FC0DF@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4137FBD89@USINDEM103.corp.hds.com>
 <CAGTjWtC2C_Q4mDHYD4p63YCkEAcYTgXcBYHemdTByrgBzNLT1A@mail.gmail.com>
 <A5ED84D3BB3A384992CBB9C77DEDA4D4137FC07B@USINDEM103.corp.hds.com> <A5ED84D3BB3A384992CBB9C77DEDA4D4137FC0DF@USINDEM103.corp.hds.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 14 Aug 2012 13:47:35 -0700
Message-ID: <CAGTjWtCrE3v+q0nKtM-Nx5PKDQ6CVGjU=uF0Gp=W97u9bHAjgg@mail.gmail.com>
Subject: Re: efi_pstore: question about how to remove create_sysfs_entry()
 from a write callback.
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dzickus@redhat.com" <dzickus@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 12:29 PM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> Mike,
>
> Previous pseudo code was not correct.
> More precisely, it is as follows.
> But, we still need to alloc memory dynamically in the part of <Save information about new entry>
> because a workqueue can't know how many new entries in advance.
>
>  spin_lock_irqsave(&efivars_lock);
>
>  do {
>         get_next_variable();
>         if (found new entry)
>                 <Save information about new entry>

If the work item is changed to instead do a loop, storage for this may
be saved elsewhere, either the stack (though 1KiB is sorta pushing it)
or on the heap.

>
>  } while()
>
>  spin_lock_irqrestore(&efivars_lock);
>
>   efivars_create_sysfs_entries();

Something like this (pseudo) may work:

/* Loop until we have all entries in efivars. */
while (1) {
  variable_name = kzalloc(1024, GFP_KERNEL );
  spin_lock_irqsave(&efivars->lock);
  bool found = false;
  while (1) {
     ret = ops->get_next_variable(variable_name)
     if (ret == EFI_NOT_FOUND)
        break;
     if (!variable_is_already_present(variable, &efivars->list) {
       found = true;
       break;
     }
  }
  if (!found) {
    kfree(variable_name);
    break;
  }
  <Register in sysfs>
}


If we are calling into pstore_info ops though from interrupt context,
it seems we'll need to fix the immediate problem of updating the
locking throughout to be interrupt safe.


>
> Seiji
>
>> -----Original Message-----
>> From: linux-kernel-owner@vger.kernel.org [mailto:linux-kernel-owner@vger.kernel.org] On Behalf Of Seiji Aguchi
>> Sent: Tuesday, August 14, 2012 2:52 PM
>> To: Mike Waychison
>> Cc: linux-kernel@vger.kernel.org; Luck, Tony (tony.luck@intel.com); Matthew Garrett (mjg@redhat.com); dzickus@redhat.com; dle-
>> develop@lists.sourceforge.net; Satoru Moriya
>> Subject: RE: efi_pstore: question about how to remove create_sysfs_entry() from a write callback.
>>
>> > Can we not serialize this with &efivars->lock if it is updated to
>> > disable interrupts?  A loop in the workqueue that locks, iterates
>> > through
>> > ->get_next_variable, and compares against searches in
>> > efivars->list should work, no?
>>
>> If my understanding is correct, your pseudo code is as follows.
>>
>> spin_lock_irqsave(&efivars_lock);
>>
>> do {
>>       get_next_variable();
>>       if (found new entry)
>>               efivars_create_sysfs_entries();
>>
>> } while()
>>
>> spin_lock_irqrestore(&efivars_lock);
>>
>> But, memory is allocated dynamically with kzalloc() in efivars_create_sysfs_entries().
>> I don't want to allocate memory  while holding spin_lock.
>>
>> Please let me know if I'm missing something.
>>
>> Seiji
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in the body of a message to majordomo@vger.kernel.org More
>> majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
