Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627Ab1BNXI3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 18:08:29 -0500
Received: from lo.gmane.org ([80.91.229.12]:42040 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753532Ab1BNXIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 18:08:23 -0500
X-Injected-Via-Gmane: http://gmane.org/
Mail-Followup-To: linux-kernel@vger.kernel.org
To: linux-kernel@vger.kernel.org
From: Nikolaus Rath <Nikolaus@rath.org>
Subject: Re: virt_to_page for userspace pointers
Date: Mon, 14 Feb 2011 17:46:30 -0500
Message-ID: <87tyg6utdl.fsf@inspiron.ap.columbia.edu>
References: <87k4hgn8qa.fsf@inspiron.ap.columbia.edu>
	<878vxuxkfr.fsf@inspiron.ap.columbia.edu>
	<4D4DC2D6.8030905@ens-lyon.org> <4D583E17.80606@rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: ebox.rath.org
Mail-Copies-To: never
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
Cancel-Lock: sha1:QdwD7fLZTOxD+rGLctBka0GJ9dE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nikolaus Rath <Nikolaus@rath.org> writes:
> On 02/05/2011 04:36 PM, Brice Goglin wrote:
>>> Is there an equivalent function to virt_to_page (and virt_to_phys) that
>>> works with userspace pointers? Or do I have to manually walk through the
>>> page tables? In the later case, are there any examples of this kind of
>>> search that I could use as a basis?
>>>   
>> 
>> You probably want get_user_pages() (or get_user_pages_fast()).
>
> Thanks for the pointer, that already helped a lot!
>
> I would, however, prefer a more primitive function that just gives me
> the struct page without locking it. And if the page is swapped out, I'd
> rather get a NULL pointer than having a page frame allocated.  Is there
> anything like that?

After studying the source for get_user_pages(), I believe the following
should do what I want:

    vma = find_extend_vma(current->mm, (unsigned long) data.vi_buf);
    if(vma == NULL) {
        err("find_extend_vma failed for VI.");
    }
    acq_dev->vi_pg = follow_page(vma, (unsigned long) data.vi_buf, 0);
    if(acq_dev->vi_pg == NULL) {
        err("follow_page failed for VI.");
    }

Unfortunately, I'm getting into trouble at link time when using these
functions:

  MODPOST 1 modules
WARNING: "follow_page" [/home/nikratio/control/acq196_hostdrv/acq200_hostdrv.ko] undefined!
WARNING: "find_extend_vma" [/home/nikratio/control/acq196_hostdrv/acq200_hostdrv.ko] undefined!

Can they only be used in the kernel itself, but not in kernel modules?

Thanks,

   -Nikolaus

-- 
 »Time flies like an arrow, fruit flies like a Banana.«

  PGP fingerprint: 5B93 61F8 4EA2 E279 ABF6  02CF A9AD B7F8 AE4E 425C

