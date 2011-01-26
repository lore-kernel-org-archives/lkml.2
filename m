Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752586Ab1AZCwy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 21:52:54 -0500
Received: from kroah.org ([198.145.64.141]:52900 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344Ab1AZCwx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 21:52:53 -0500
Date: Wed, 26 Jan 2011 10:46:08 +0800
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: torvalds@linux-foundation.org, San Mehat <san@google.com>,
        Aaron Durbin <adurbin@google.com>, Duncan Laurie <dlaurie@google.com>,
        linux-kernel@vger.kernel.org, Tim Hockin <thockin@google.com>
Subject: Re: [PATCH v1 3/6] driver: Google EFI SMI
Message-ID: <20110126024608.GB28283@kroah.com>
References: <20110125002433.12637.51091.stgit@mike.mtv.corp.google.com>
 <20110125002449.12637.35623.stgit@mike.mtv.corp.google.com>
 <20110125031752.GA9846@kroah.com>
 <AANLkTi=XhRX-=k8UmmQFshP6fgF_q2c-9gEHuH0mWu0a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTi=XhRX-=k8UmmQFshP6fgF_q2c-9gEHuH0mWu0a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 03:12:52PM -0800, Mike Waychison wrote:
> On Mon, Jan 24, 2011 at 7:17 PM, Greg KH <greg@kroah.com> wrote:
> > On Mon, Jan 24, 2011 at 04:24:49PM -0800, Mike Waychison wrote:
> >> +struct gsmi_ioctl {
> >> +     uint16_t        length;         /* total length including data */
> >> +     int             version;        /* structure version */
> >> +     int             command;        /* ioctl command */
> >
> > Ick.  Use proper data types if you are going to create a new ioctl.
> > Same goes for the structures above (hint, use __u32 and friends, not the
> > unit??_t crap.
> >
> > I'd strongly suggest NOT creating a new ioctl though, that' just going
> > to be a pain in the long run.
> 
> Ok.  I'll change these.  Even if the __u32 vs u32 vs uint32_t
> differentiation is non-sense :(

Well, it really isn't nonsense.  __u32 and u32 can be different, and who
really knows what uint32_t means in the end (hint the _t things are for
userspace, not kernelspace, remember the issues of running 64bit kernels
with 32bit userspace programs.)

Actually, that reminds me, what are you going to do about 32/64bit
issues?  This is one reason why ioctls really really suck.  Not to
mention the fact that you really are just adding special syscalls to the
system here, which is another reason people hate them.

So, let me ask, what specifically are you wanting to import/export
to/from the kernel here?  Have you thought about other kernel/user apis
instead of ioctls?  What is forcing you to use ioctls?

> >> +     union {
> >> +             struct gsmi_get_nvram_var       get_nvram_var;
> >> +             struct gsmi_get_next_var        get_next_var;
> >> +             struct gsmi_set_nvram_var       set_nvram_var;
> >> +             struct gsmi_set_event_log       set_event_log;
> >> +             struct gsmi_clear_event_log     clear_event_log;
> >> +     } gsmi_cmd;
> >> +} __packed;
> >> +
> >> +#define GSMI_BASE                    'G'
> >> +#define GSMI_IOCTL_VERSION           1
> >> +#define GSMI_IOCTL                   _IOWR(GSMI_BASE, GSMI_IOCTL_VERSION, \
> >> +                                         struct gsmi_ioctl)
> >> +
> >> +#endif /* _LINUX_GSMI_H */
> >> diff --git a/include/linux/miscdevice.h b/include/linux/miscdevice.h
> >> index 18fd130..34f5dfa 100644
> >> --- a/include/linux/miscdevice.h
> >> +++ b/include/linux/miscdevice.h
> >> @@ -40,6 +40,7 @@
> >>  #define BTRFS_MINOR          234
> >>  #define AUTOFS_MINOR         235
> >>  #define MAPPER_CTRL_MINOR    236
> >> +#define GOOGLE_SMI_MINOR     242
> >>  #define MISC_DYNAMIC_MINOR   255
> >
> > Why make this a static number and not just use a dynamic one?
> 
> Well, we use static device numbers, which is why it has historically
> been static as well.  Yes, that puts us squarely in the 1990s :)
> 
> I can change this guy too though.

Yes please, we don't need to reserve any more numbers, as the 1990s was
a long time ago :)

thanks,

greg k-h
