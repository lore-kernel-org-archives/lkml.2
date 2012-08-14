Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab2HNSEY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 14:04:24 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52501 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab2HNSEW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 14:04:22 -0400
MIME-Version: 1.0
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D4137FBD89@USINDEM103.corp.hds.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D4137FBD89@USINDEM103.corp.hds.com>
From: Mike Waychison <mikew@google.com>
Date: Tue, 14 Aug 2012 11:04:00 -0700
Message-ID: <CAGTjWtC2C_Q4mDHYD4p63YCkEAcYTgXcBYHemdTByrgBzNLT1A@mail.gmail.com>
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

On Tue, Aug 14, 2012 at 9:05 AM, Seiji Aguchi <seiji.aguchi@hds.com> wrote:
> Hi,
>
> I'm sending an email to discuss how to remove create_sysfs_entry() from a write callback.
>
> [Problem]
>
> Current efi_pstore creates sysfs entries ,which enable users to access to NVRAM, in a write callback.
> If a kernel panic happens in interrupt contexts, pstore may fail because it could sleep due to dynamic
> memory allocations during creating sysfs entries.
>
> To resolve the problem above, my goal here is removing create_sysfs_entry() from a write callback.
>
> [Ideas]
>
>  (1) Introduce a workqueue updating sysfs entries
>
>      To remove create_sysfs_entry() from a write callback,
>      It seems to be possible if efi_pstore updates its sysfs files
>      by scanning existing entries in NVRAM with a GetNextVariable()
>      in a workqueue.
>
>
>      I created a prototype patch based on an idea above but can't avoid a race
>      between SetVariable() in a write callback and GetNextVariable() in a workqueue.
>      It is not guaranteed by EFI specification.
>
>      EFI 2.3.1 specification, page 217.
>      <snip>
>      Calls to SetVariable() between calls to
>      GetNextVariableName() may produce unpredictable results.
>      <snip>

Can we not serialize this with &efivars->lock if it is updated to
disable interrupts?  A loop in the workqueue that locks, iterates
through ->get_next_variable, and compares against searches in
efivars->list should work, no?

>
>
>  (2) Don't support sysfs entries in efi_pstore.
>
>      Another idea is _not_ updating sysfs entries at all in efi_pstore.
>      This can avoid a race SetVariable() and GetNextVariable().
>
>      write callback
>        - simply write a new entry with SetVariable().
>          - This fits a discussion about holding multiple logs in a thread below.
>            http://marc.info/?l=linux-kernel&m=134316268011854&w=2
>
>      erase callback
>        - simply erase an existing entry with SetVariable().
>
>      read callback
>        - Scaning existing entries with GetNextVariable().
>          We can avoid a race between GetNextVariable() in a read callback
>          and SetVariable() in a write/erase callback by protecting them with efi_lock.
>
>  IMO, idea (2) is reasonable because we already have an interface, /dev/pstore, which users can access
>  to NVRAM and we don't need to support multiple user interfaces.
>
> Any comments are welcome.
>
> Seiji
