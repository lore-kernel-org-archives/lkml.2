Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757501Ab0DWVIY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:08:24 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33350 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384Ab0DWVIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:08:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=MWwTyztZigOCaRHbG3ZgrZ17IGbQTw1pMnm+ZnwL5QKjxCt3hI4LhUoRAxl3GGKG/C
         v1caSbDkGiJstViMXNGGOg9XFG7ERGJmGL669R4xMNZgAXWQxtTHNCxwS6pi6toVPBHU
         DoCqjHtZpoqt2GWTxn1H+G5ACSVcnpv9FVYYQ=
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH 8/9] Input: Block suspend while event queue is not empty.
Date: Fri, 23 Apr 2010 14:08:14 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc5; KDE/4.4.2; x86_64; ; )
Cc: Arve =?iso-8859-1?q?Hj=F8nnev=E5g?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       =?iso-8859-1?q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Sven Neumann <s.neumann@raumfeld.com>,
       Tero Saarni <tero.saarni@gmail.com>,
       Henrik Rydberg <rydberg@euromail.se>, Matthew Garrett <mjg@redhat.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
References: <1271984938-13920-1-git-send-email-arve@android.com> <1271984938-13920-9-git-send-email-arve@android.com> <20100423135625.1e12d005.randy.dunlap@oracle.com>
In-Reply-To: <20100423135625.1e12d005.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201004231408.15885.dmitry.torokhov@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 23 April 2010 01:56:25 pm Randy Dunlap wrote:
> On Thu, 22 Apr 2010 18:08:57 -0700 Arve Hjønnevåg wrote:
> > Add an ioctl, EVIOCSSUSPENDBLOCK, to enable a suspend_blocker that will
> > block suspend while the event queue is not empty. This allows userspace
> > code to process input events while the device appears to be asleep.
> 
> All new ioctls need to be added to Documentation/ioctl/ioctl-number.txt,
> please.

I do not see the reason for it to be in the kernel still. Have a process
that listens to all input devices (or subset of them), once events stop
coming initiate suspend.

> 
> > Signed-off-by: Arve Hjønnevåg <arve@android.com>
> > ---
> > 
> >  drivers/input/evdev.c |   22 ++++++++++++++++++++++
> >  include/linux/input.h |    3 +++
> >  2 files changed, 25 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> > index 2ee6c7a..66e0d16 100644
> > --- a/drivers/input/evdev.c
> > +++ b/drivers/input/evdev.c
> > @@ -585,6 +594,19 @@ static long evdev_do_ioctl(struct file *file,
> > unsigned int cmd,
> > 
> >  		else
> >  		
> >  			return evdev_ungrab(evdev, client);
> > 
> > +	case EVIOCGSUSPENDBLOCK:
> > +		return put_user(client->use_suspend_blocker, ip);
> > +
> > +	case EVIOCSSUSPENDBLOCK:
> > +		spin_lock_irq(&client->buffer_lock);
> > +		if (!client->use_suspend_blocker && p)
> > +			suspend_blocker_init(&client->suspend_blocker, "evdev");
> > +		else if (client->use_suspend_blocker && !p)
> > +			suspend_blocker_destroy(&client->suspend_blocker);
> > +		client->use_suspend_blocker = !!p;
> > +		spin_unlock_irq(&client->buffer_lock);
> > +		return 0;
> > +
> > 
> >  	default:
> >  		if (_IOC_TYPE(cmd) != 'E')
> > 
> > diff --git a/include/linux/input.h b/include/linux/input.h
> > index 7ed2251..b2d93b4 100644
> > --- a/include/linux/input.h
> > +++ b/include/linux/input.h
> > @@ -82,6 +82,9 @@ struct input_absinfo {
> > 
> >  #define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release 
device */
> > 
> > +#define EVIOCGSUSPENDBLOCK	_IOR('E', 0x91, int)			/* get 
suspend block
> > enable */ +#define EVIOCSSUSPENDBLOCK	_IOW('E', 0x91, int)			/* 
set
> > suspend block enable */ +
> > 
> >  /*
> >  
> >   * Event types
> >   */
> 
> thanks,
> ---
> ~Randy
> *** Remember to use Documentation/SubmitChecklist when testing your code
> *** --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Dmitry
