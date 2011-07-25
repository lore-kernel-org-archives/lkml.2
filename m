Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751529Ab1GYMru (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 08:47:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57984 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751631Ab1GYMrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 08:47:43 -0400
Date: Mon, 25 Jul 2011 08:47:41 -0400
From: Don Zickus <dzickus@redhat.com>
To: Tony Luck <tony.luck@intel.com>
Cc: "Huang, Ying" <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] pstore: change mutex locking to spin_locks
Message-ID: <20110725124741.GB2866@redhat.com>
References: <1311195386-22743-1-git-send-email-dzickus@redhat.com>
 <4E277584.1060200@intel.com>
 <20110721122731.GV3765@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E9EC9DC6@orsmsx505.amr.corp.intel.com>
 <4E28C552.8060803@intel.com>
 <20110722121302.GB9732@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301E9FA0EE5@orsmsx505.amr.corp.intel.com>
 <CA+8MBb+E462CVOe+5FQb62Tdi5R6cBYgFZUW7sxWDDh2QTaxxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+8MBb+E462CVOe+5FQb62Tdi5R6cBYgFZUW7sxWDDh2QTaxxA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 22, 2011 at 04:21:14PM -0700, Tony Luck wrote:
> On Fri, Jul 22, 2011 at 3:39 PM, Luck, Tony <tony.luck@intel.com> wrote:
> > Yup - oops is the only one where the current kernel continues - all the
> > others (halt, reboot, kexec, panic) lead to the termination of the
> > current kernel - and thus no user processes that would be able to
> > see the shiny new entry in the pstore file system.
> 
> Doh - I went to look at what it would take to fix this - and found that
> I'd already implemented it:
> 
> 
>                 if (reason == KMSG_DUMP_OOPS && pstore_is_mounted())
>                         pstore_mkfile(PSTORE_TYPE_DMESG, psinfo->name, id,
>                                       psinfo->buf, hsize + l1_cpy + l2_cpy,
>                                       CURRENT_TIME, psinfo);

Right, but it still has to be created with locks surrounding it.  And the
question is what type of locks should we use.  Mutexes don't work when
called from the NMI case and spinlocks don't seem to work when called from
the OOPs (pstore_mkfile) case.

Cheers,
Don
