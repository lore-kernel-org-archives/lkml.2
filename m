Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939Ab0HWO75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 10:59:57 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57382 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753680Ab0HWO7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 10:59:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=erzK60kjwjwE2Zt62fi2QgSWqbd2ew7INrA+JNYxvUNM12/N0wUuq6/qf6XoJ4e8Oq
         AFFKgKSPi6Pk2YPkGA5pMPIZoklrh/Ikla7GTYRK8Bgno19fYbsYSG52uDFkv+iKaJU2
         a4JYFBUPZ0jxsRNn0rfPPwUHYHKYj8V3RPTrI=
Subject: Re: [PATCH 0/4] initramfs: remove sparse warnings
From: Namhyung Kim <namhyung@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
In-Reply-To: <201008222233.01739.arnd@arndb.de>
References: <1282189064-3904-1-git-send-email-namhyung@gmail.com>
	 <20100820120001.GR31363@ZenIV.linux.org.uk>
	 <1282318601.1626.9.camel@leonhard>  <201008222233.01739.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 23 Aug 2010 23:59:43 +0900
Message-ID: <1282575583.1659.4.camel@leonhard>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010-08-22 (일), 22:33 +0200, Arnd Bergmann:
> On Friday 20 August 2010 17:36:41 Namhyung Kim wrote:
> > 
> > 2010-08-20 (금), 13:00 +0100, Al Viro:
> > > No.  This code should NOT use the VFS guts, TYVM.  The whole fscking point
> > > is that this puppy is a sequence of plain vanilla syscalls, ideally run
> > > simply in userland thread.  We used to have a magical mystery shite in there
> > > and it had been a huge PITA.
> > 
> > So is it worth to work on removing the warnings like this patchset does?
> > Or else, how can I improve the code even a bit? Can you please give me a
> > direction?
> 
> It would be useful to add annotations in those places where they are
> obviously just missing but don't require adding __force.
> Even better would be patches that fix actual bugs found by sparse.
> 
> Simply throwing in extra __force arguments will just make people
> nervous, because it is often a sign of papering over a bug instead
> of fixing it, and warnings in the core kernel are there exactly
> because there is no easy correct fix for them.
> 
> Try producing patches that clean up the code and result in using
> fewer annotations and especially few __force where possible.
> Also, in places where you need __force, make sure that a person
> reading that code understands why it's needed and that the use is
> correct (or at least permissable).
> 
> One possible solution in this particular case would be to add
> helper functions like 
> 
> /* wrapper for sys_newlstat for use in the init code */
> static inline int kern_newlstat(const char * filename, struct stat * statbuf)
> {
> 	mm_segment_t fs = get_fs();
> 	int ret;
> 
> 	set_fs(KERNEL_DS);
> 	ret = sys_newlstat((const char __user __force*)filename,
> 			   (struct stat __user __force *)statbuf);
> 	set_fs(fs);
> 
> 	return ret;
> }
> 
> Such a function makes it clear that it can only accept a kernel pointer,
> and it documents how the conversion to a __user pointer happens (by
> calling set_fs).
> Then again, it adds some bloat, and it may encourage people to do the
> same thing in device drivers, which could be argued against such helpers.
> 
> In general, my recommendation would be to leave code alone if you can't
> come up with a patch that clearly improves it. There is enough
> bad code in the kernel that can use some help along the lines of
> your other patches, so you may want to focus on that.
> 
> 	Arnd

Thank you Arnd for the precious comments and advices. This really helps
me.

-- 
Regards,
Namhyung Kim


