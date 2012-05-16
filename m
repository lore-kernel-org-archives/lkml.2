Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab2EPPsn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:48:43 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:48505 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab2EPPsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:48:40 -0400
Message-ID: <1337183225.3522.14.camel@falcor>
Subject: Re: [PATCH] vfs: fix IMA lockdep circular locking dependency
From: Mimi Zohar <zohar@linux.vnet.ibm.com>
To: Eric Paris <eparis@parisplace.org>
Cc: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@zeniv.linux.org.uk>, Mimi Zohar <zohar@us.ibm.com>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Wed, 16 May 2012 11:47:05 -0400
In-Reply-To: <CACLa4psYWecSy9sRuV2Nf9BPU0xspjJF-ZD63biqv6erUYKyGQ@mail.gmail.com>
References: <1336963631-3541-1-git-send-email-zohar@us.ibm.com>
	 <CA+55aFzrJNd5J7i3Rp7-ctc=bDn5GTWu=H1xyCgGZ-rzu74Gbw@mail.gmail.com>
	 <CA+55aFyPPZ0wayqPMCZtfP1w9nN-GnKJxYc9i_XM_Qk8d-zJzg@mail.gmail.com>
	 <CACLa4pujEBAS349Pr-EcBmzQgTHWthhCMV0Yqq0BG-F_gDjz4Q@mail.gmail.com>
	 <1337112446.20904.50.camel@falcor>
	 <CA+55aFxRRuWGD-4LYzO-T8eg22goKpej5AV36ALL8GaLP56oRA@mail.gmail.com>
	 <CA+55aFzOtY7tBw4YNH+QX+6L4opMsJ=sN4DfJURMv_yBTWqL1w@mail.gmail.com>
	 <20120516004251.GO22082@ZenIV.linux.org.uk>
	 <CA+55aFy0wJdq+-OAkUBsrkQogF5-N0P4DBQ+6-LXjBGscRQFNw@mail.gmail.com>
	 <CA+55aFy1qQkGXAr=0Zqk=qJeGTpfMOVC2=rdRWzQ1qsUZ5P0_g@mail.gmail.com>
	 <alpine.LRH.2.02.1205162135320.10697@tundra.namei.org>
	 <1337175731.2492.4.camel@localhost>	<1337176336.3522.5.camel@falcor>
	 <CACLa4psYWecSy9sRuV2Nf9BPU0xspjJF-ZD63biqv6erUYKyGQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051615-9360-0000-0000-00000665EAEB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-16 at 10:06 -0400, Eric Paris wrote:
> On Wed, May 16, 2012 at 9:52 AM, Mimi Zohar <zohar@linux.vnet.ibm.com> wrote:
> > On Wed, 2012-05-16 at 09:42 -0400, Eric Paris wrote:
> >> On Wed, 2012-05-16 at 21:37 +1000, James Morris wrote:
> >> > On Tue, 15 May 2012, Linus Torvalds wrote:
> >> >
> >> > > Hmm?
> >> >
> >> > diff --git a/security/capability.c b/security/capability.c
> >> > index 5bb21b1c448c..9a19c6a54e12 100644
> >> > --- a/security/capability.c
> >> > +++ b/security/capability.c
> >> > @@ -949,7 +949,6 @@ void __init security_fixup_ops(struct
> >> > security_operations *ops)
> >> >         set_to_cap_if_null(ops, file_alloc_security);
> >> >         set_to_cap_if_null(ops, file_free_security);
> >> >         set_to_cap_if_null(ops, file_ioctl);
> >> > -       set_to_cap_if_null(ops, file_mmap);
> >> >         set_to_cap_if_null(ops, file_mprotect);
> >> >         set_to_cap_if_null(ops, file_lock);
> >> >         set_to_cap_if_null(ops, file_fcntl);
> >> >
> >> >
> >> > Do we need to add addr_map to the fixup ops?
> >>
> >> No.  His patch works just fine without it.  If you look he uses:
> >>
> >> +     if (security_ops->mmap_file) {
> >>
> >> Which means since we didn't set an explicit .mmap_file, even with no
> >> other LSM loaded we would be fine.
> >>
> >> At the moment I'd rather stick with our usual notation of forcing
> >> capabilities to define every option even if all it does it return 0.  If
> >> Linus thinks it's a good idea to do
> >> if (security_ops->function)
> >>       security_ops->funtion(args);
> >> In the security server we should do that cleanup separately...
> >>
> >> -Eric
> >
> > James was pointing out that security_fixup_ops was not set for
> > mmap_addr, not mmap_file(), which should be initialized by
> > security_fixup_ops().
> 
> But it would be flat wrong to put it there.  True historically we did
> things differently, but this patch is right given Linus is doing it a
> different way.
> 
> Had Linus done what you two are suggesting:
> +int security_mmap_addr(unsigned long addr)
> +{
> +       if (security_ops->mmap_addr) {       <--- This would call cap_mmap_addr
> +               int ret = security_ops->mmap_addr(addr);
> +               if (ret)
> +                       return ret;
> +       }
> +       return cap_mmap_addr(addr);          <--- This would also call
> cap_mmap_addr
> +}
> 
> See the problem?
> 
> Like I said, we can do a full cleanup removing all of the useless
> capabilities functions and turning them into an inline branch instead
> of unconditional jump and return 0.  We could possibly even move all
> of the cap stacking into this layer instead of pushing it into the LSM
> layer.  But you shouldn't really do #2 without #1.  (Notice here Linus
> is doing both of those things, but only with this one hook)
> 
> -Eric

Sigh, I was actually thinking back to when LSM was not enabled, and the
default to enable caps was via the security_fixup_ops().  The default
today, without LSM enabled, is to call the cap functions directly from
the security stub functions, like how Linus included the call to
cap_mmap_addr():

static inline int security_mmap_addr(unsigned long addr)
{
        return cap_mmap_addr(addr);
}

Mimi

