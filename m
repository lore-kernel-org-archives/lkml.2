Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758034Ab0GDUwi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 16:52:38 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:64384 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757979Ab0GDUwg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 16:52:36 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 2/6] sound/oss: convert to unlocked_ioctl
Date: Sun, 4 Jul 2010 22:52:29 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.35-rc3+; KDE/4.4.90; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <1278195310-25590-3-git-send-email-arnd@arndb.de> <20100704110835.GA31920@merkur.ravnborg.org>
In-Reply-To: <20100704110835.GA31920@merkur.ravnborg.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007042252.29997.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1+CrIUPZbkiS03ye6usVOTlb465NwiL3jDpBgi
 2cpysEPP/1240EAumwvSx15AWsZSX9SpZFZODq9V+/asQeajYV
 YLHqttWRiGe3AuUkolj7Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 04 July 2010 13:08:35 Sam Ravnborg wrote:
>
> General comment...
> In several places you declare a local variable of type "int",
> but the function return a long.
> 
> I know that mixdev_ioctl() return an int so nothing is lost but
> it just looks wrong.

This is completely intentional and follows what we have done in
lots of other drivers that are already converted the same way.

The idea is that it was a bad choice to make the 'unlocked_ioctl'
operation return 'long' in the first place. I remember Al
ranting about this a few years ago. The ioctl syscall always
returns an 'int' to user space, the only reason we have a
'long' return code in the definition of sys_ioctl and most
other syscalls is to avoid problems for 32 bit emulation
on some architectures.
 
Maybe one day someone will rename all unlocked_ioctl calls
back to ioctl and change the return type back to int.

> > diff --git a/sound/oss/dmasound/dmasound_core.c b/sound/oss/dmasound/dmasound_core.c
> > index 3f3c3f7..b5464fb 100644
> > --- a/sound/oss/dmasound/dmasound_core.c
> > +++ b/sound/oss/dmasound/dmasound_core.c
> > @@ -337,8 +337,8 @@ static int mixer_release(struct inode *inode, struct file *file)
> >  	unlock_kernel();
> >  	return 0;
> >  }
> > -static int mixer_ioctl(struct inode *inode, struct file *file, u_int cmd,
> > -		       u_long arg)
> > +
> > +static long mixer_ioctl(struct file *file, u_int cmd, u_long arg)
> >  {
> >  	if (_SIOC_DIR(cmd) & _SIOC_WRITE)
> >  	    mixer.modify_counter++;
> > @@ -362,11 +362,22 @@ static int mixer_ioctl(struct inode *inode, struct file *file, u_int cmd,
> >  	return -EINVAL;
> >  }
> >  
> > +static long mixer_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
> > +{
> > +	int ret;
> > +
> > +	lock_kernel();
> > +	ret = mixer_ioctl(file, cmd, arg);
> > +	unlock_kernel();
> > +
> > +	return ret;
> > +}
> 
> Here it looks like a potential but.
> mixer_ioctl() return a long which is stored in an int and then we return a long.

Right. I should probably have left the return value of mixer_ioctl as an int
instead, to follow the scheme used in other drivers.

	Arnd
