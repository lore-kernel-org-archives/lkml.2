Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757496Ab0GDLIo (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jul 2010 07:08:44 -0400
Received: from pfepb.post.tele.dk ([195.41.46.236]:51652 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757449Ab0GDLIh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jul 2010 07:08:37 -0400
Date: Sun, 4 Jul 2010 13:08:35 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
       alsa-devel@alsa-project.org
Subject: Re: [PATCH 2/6] sound/oss: convert to unlocked_ioctl
Message-ID: <20100704110835.GA31920@merkur.ravnborg.org>
References: <1278195310-25590-1-git-send-email-arnd@arndb.de> <1278195310-25590-3-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278195310-25590-3-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> diff --git a/sound/oss/au1550_ac97.c b/sound/oss/au1550_ac97.c
> index c1070e3..3547450 100644
> --- a/sound/oss/au1550_ac97.c
> +++ b/sound/oss/au1550_ac97.c
> @@ -824,22 +824,26 @@ mixdev_ioctl(struct ac97_codec *codec, unsigned int cmd,
>  	return codec->mixer_ioctl(codec, cmd, arg);
>  }
>  
> -static int
> -au1550_ioctl_mixdev(struct inode *inode, struct file *file,
> -			       unsigned int cmd, unsigned long arg)
> +static long
> +au1550_ioctl_mixdev(struct file *file, unsigned int cmd, unsigned long arg)
>  {
>  	struct au1550_state *s = (struct au1550_state *)file->private_data;
>  	struct ac97_codec *codec = s->codec;
> +	int ret;
> +
> +	lock_kernel();
> +	ret = mixdev_ioctl(codec, cmd, arg);
> +	unlock_kernel();
>  
> -	return mixdev_ioctl(codec, cmd, arg);
> +	return ret;
>  }

General comment...
In several places you declare a local variable of type "int",
but the function return a long.

I know that mixdev_ioctl() return an int so nothing is lost but
it just looks wrong.

> diff --git a/sound/oss/dmasound/dmasound_core.c b/sound/oss/dmasound/dmasound_core.c
> index 3f3c3f7..b5464fb 100644
> --- a/sound/oss/dmasound/dmasound_core.c
> +++ b/sound/oss/dmasound/dmasound_core.c
> @@ -337,8 +337,8 @@ static int mixer_release(struct inode *inode, struct file *file)
>  	unlock_kernel();
>  	return 0;
>  }
> -static int mixer_ioctl(struct inode *inode, struct file *file, u_int cmd,
> -		       u_long arg)
> +
> +static long mixer_ioctl(struct file *file, u_int cmd, u_long arg)
>  {
>  	if (_SIOC_DIR(cmd) & _SIOC_WRITE)
>  	    mixer.modify_counter++;
> @@ -362,11 +362,22 @@ static int mixer_ioctl(struct inode *inode, struct file *file, u_int cmd,
>  	return -EINVAL;
>  }
>  
> +static long mixer_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
> +{
> +	int ret;
> +
> +	lock_kernel();
> +	ret = mixer_ioctl(file, cmd, arg);
> +	unlock_kernel();
> +
> +	return ret;
> +}

Here it looks like a potential but.
mixer_ioctl() return a long which is stored in an int and then we return a long.


> -static int sq_ioctl(struct inode *inode, struct file *file, u_int cmd,
> -		    u_long arg)
> +static long sq_ioctl(struct file *file, u_int cmd, u_long arg)
>  {
>  	int val, result;
>  	u_long fmt;
> @@ -1114,18 +1124,29 @@ static int sq_ioctl(struct inode *inode, struct file *file, u_int cmd,
>  		return IOCTL_OUT(arg,val);
>  
>  	default:
> -		return mixer_ioctl(inode, file, cmd, arg);
> +		return mixer_ioctl(file, cmd, arg);
>  	}
>  	return -EINVAL;
>  }
>  
> +static long sq_unlocked_ioctl(struct file *file, u_int cmd, u_long arg)
> +{
> +	int ret;
> +
> +	lock_kernel();
> +	ret = sq_ioctl(file, cmd, arg);
> +	unlock_kernel();
> +
> +	return ret;
> +}
ditto: long -> int -> long


	Sam
