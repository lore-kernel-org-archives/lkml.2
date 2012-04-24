Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756154Ab2DXB0F (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 21:26:05 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:48986 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754716Ab2DXB0D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 21:26:03 -0400
X-Sasl-enc: 0z0VanQuZ8HMmBH6UtPmxGBtv/S17wqVawtU/kKGgiLL8Q5aIbxMDJCS8g 1335230761
Message-ID: <1335230757.2260.15.camel@perseus.themaw.net>
Subject: Re: Breaking userspace? Re: 3.0.24 broke aufofs on mixed 32/64bit
 environment
From: Ian Kent <raven@themaw.net>
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: "stable@kernel.org" <stable@kernel.org>, autofs@vger.kernel.org,
        Linux-kernel <linux-kernel@vger.kernel.org>
Date: Tue, 24 Apr 2012 09:25:57 +0800
In-Reply-To: <4F959A5A.8070907@msgid.tls.msk.ru>
References: <4F94222C.6080608@msgid.tls.msk.ru>
	 <1335172741.2226.10.camel@perseus.themaw.net>
	 <4F958352.7050106@msgid.tls.msk.ru> <4F95897B.2040103@msgid.tls.msk.ru>
	 <4F959A5A.8070907@msgid.tls.msk.ru>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 22:07 +0400, Michael Tokarev wrote:
> On 23.04.2012 20:55, Michael Tokarev wrote:
> > On 23.04.2012 20:29, Michael Tokarev wrote:
> >> On 23.04.2012 13:19, Ian Kent wrote:
> >>> On Sun, 2012-04-22 at 19:22 +0400, Michael Tokarev wrote:
> >>>> This is JFYI for now, I only diagnozed the issue but had
> >>>> no time to see what's going on.
> >>>>
> >>>> The short story is that with 3.0.24 and later kernels,
> >>>> 32bit autofs stopped working on 64bit kernels, while
> >>>> it worked before just fine.
> >>>>
> >>>> The userspace is of version 5.0.4.  Platform is x86.
> >>>>
> >>>> The sympthoms of the issue is that automount daemon,
> >>>> on every access to a (not yet mounted) autofs mount
> >>>> point, stalls forever, with the process trying to
> >>>> access it stalling forever too -- this is why the
> >>>> system didn't reboot, -- it stayed on an attempt to
> >>>> access one of automount subdirs, somewhere in the
> >>>> middle.
> >>
> >> This is what happens with 3.0.24+:
> >>
> >> [pid 15207] read(4, "\5\0\0\0\3\0\0\0\2\0\0\0\35\0\0\0@\17\246\3\0\0\0\0\350\3\0\0\350\3\0\0"..., 304) = 300
> >> [pid 15207] read(4,  <unfinished ...> -- forever.
> >>
> >> It wants to read 304 bytes, but kernel only supplies 300
> >> bytes.
> >>
> >> $ file /usr/sbin/automount
> >> /usr/sbin/automount: ELF 32-bit LSB shared object, Intel 80386, version 1 (SYSV), dynamically linked (uses shared libs), for GNU/Linux 2.6.18, stripped
> >> $ uname -a
> >> Linux gandalf 3.0.0-amd64 #3.0.27 SMP Tue Apr 3 16:23:45 MSK 2012 x86_64 GNU/Linux
> >>
> >> This is a32744d4abae24572eff7269bc17895c41bd0085
> >> "autofs: work around unhappy compat problem on x86-64",
> >> included in 3.0.24:
> >>
> >> +static noinline size_t autofs_v5_packet_size(struct autofs_sb_info *sbi)
> >> +{
> >> +       size_t pktsz = sizeof(struct autofs_v5_packet);
> >> +#if defined(CONFIG_X86_64) && defined(CONFIG_COMPAT)
> >> +       if (sbi->compat_daemon > 0)
> >> +               pktsz -= 4;
> >> +#endif
> >> +       return pktsz;
> >> +}
> >> +
> >>
> >> "End result: the "packed" size of the structure is 300 bytes: 4-byte, but
> >> not 8-byte aligned.
> >>
> >> As a result, despite all the fields being in the same place on all
> >> architectures, sizeof() will round up that size to 304 bytes on
> >> architectures that have 8-byte alignment for u64."
> >>
> >> So I'm not sure how it worked before this change (from the
> >> description of the patch it looks like it should not work).
> >> But it definitely worked for me, and this patch broke it
> >> for me.
> > 
> > It worked because the userspace apparently does the "rigtht"
> > think already compensating for the kernel bitness mismatch.
> > This is a bit funky too, but it should work:
> > 
> > static size_t get_kpkt_len(void)
> > {
> >         size_t pkt_len = sizeof(struct autofs_v5_packet);
> >         struct utsname un;
> > 
> >         uname(&un);
> > 
> >         if (pkt_len % 8) {
> >                 if (strcmp(un.machine, "alpha") == 0 ||
> >                     strcmp(un.machine, "ia64") == 0 ||
> >                     strcmp(un.machine, "x86_64") == 0 ||
> >                     strcmp(un.machine, "ppc64") == 0)
> >                         pkt_len += 4;
> > 
> >         }
> > 
> >         return pkt_len;
> > }
> > 
> > So it looks like the kernel/user interface had an error,
> > userspace adopted to the kernel by doing something, so
> > it started working.  And next kernel adopted to the un-
> > patched userspace, thus breaking patched userspace.
> > 
> > That's quite messy... :(  And I'm not sure what to do
> > about this, -- the only solution - in my opinion anyway -
> > is to revert this kernel patch and maybe switch to a
> > new protocol version.
> 
> Okay, even if messy, there are quite easy pure userspace
> solutions to all this.
> 
> But first of all, I want to question this change in the
> first place, hence CC'ing to LKML too.

Back porting the 3.3 change to current stable kernels was not a good
idea IMO and I probably should have NAKed the one that I actually saw,
which was devoid of version btw.

The change came about because there was a complaint about me not wanting
to fix this in the kernel, but wanting to continue using the user space
workaround. But it was insisted that it be fixed in the kernel, and so
it was done.

Consequently people will encounter this gotcha sooner or later and will
need to apply a patch to resolve it. The back port to stable kernels
just means it's sooner rather than later.

I have already told you that I will need to provide a (updated, since
there is already a commit in git that covers 3.3) patch for autofs. I
haven't done that yet because I've been a little ill.

A quick web search finds the post that I made to the autofs list
explaining this.
http://comments.gmane.org/gmane.linux.file-systems/61832

> 
> Kernel has been shipping with this brokeness for quite
> some time, namely, since introduction of autofs4, dated
> Mon Mar 27 01:14:55 2006 -0800 (commit 5c0a32fc2cd0).
> 
> This is 6 whole years by now.
> 
> Main userspace user of this interface adopted long ago
> too, and has been in wide use for years as well.
> 
> This kernel change, even if right in theory, actually
> breaks all existing userspace which was working fine
> for years.
> 
> It looks like this is very much against main linux
> principle of not breaking stuff even if the change is
> "obviously right".
> 
> So it pretty much looks like this very fix has to be
> reverted in mainline and in all stable kernels.  At least
> that's what I'd do if you ask me.
> 
> 
> Now, back to "pure userspace" solution.
> 
> The kernel sends data to userspace, and the unit of
> exchange is pretty small - this structure of either
> 300 or 304 bytes.  Can the read from userspace EVER
> be partial, so that a fullread() function is necessary?
> I'm not sure, but to me it looks like this fullread()
> loop isn't needed in the first place, and just single
> read() (maybe repeating it in case of EINTR) should
> do the job already.  This way, we either handle the
> data we've read, if we think the amount we read
> is sufficient, and the packet looks sane, or just
> error out.  The filename is at the end of the struct,
> so actually there's no need to send whole struct from
> kernel, it is sufficient for the kernel to write up
> to the trailing zero, and userspace _may_ be able to
> understand (and no, this is not what userspace expects
> currently, so changing kernel to do so will break things --
> I'm just saying what can be done in _userspace_).
> 
> Now, we know that this sizeof(v5_packet) is designed
> wrongly.  But it is actually trivial for the userspace
> to expect EITHER 300 bytes OR 304 bytes from the kernel --
> again, all in one go.  For it to work, extend the struct
> with a padding at the end so it will be real 304 bytes,
> and request reading of these 304 bytes, but handle the
> read of 300 bytes too as successful.
> 
> This way, it will work for BOTH "bad" and "good" kernel.
> 
> Ofcourse it all breaks again if, in case of several
> requests going from the kernel, kernel will batch them
> into single larger read, so we'll lose packet boundary.
> If that's the case, my "solution" does not work obviously.
> 
> Still, the userspace may adapt again, by doing a probe,
> forcing the kernel to send us a request before making
> the mountpoint visible in the final location, checking
> the size of the data kernel sends, and setting that
> pkt_len variable to this value.  Ugly, but it will let
> the application to work in either case.
> 
> But again, to me the current situation with outright
> BREAKING of existing userspace is much uglier since
> it affects many users instead of a single userspace
> component...
> 
> Thanks,
> 
> /mjt
> 
> >> Should 3.3 work?  As far as I can see, it includes the
> >> same change (which has been backported!), so it may have
> >> the same _issue_...
> 


