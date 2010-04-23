Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757404Ab0DWU6w (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 16:58:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:39541 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757273Ab0DWU6q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 16:58:46 -0400
Date: Fri, 23 Apr 2010 13:56:25 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Arve =?ISO-8859-1?Q?Hj=F8nnev=E5g?= <arve@android.com>
Cc: linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>,
       =?ISO-8859-1?Q?M=E1rton_N=E9meth?= <nm127@freemail.hu>,
       Sven Neumann <s.neumann@raumfeld.com>,
       Tero Saarni <tero.saarni@gmail.com>,
       Henrik Rydberg <rydberg@euromail.se>, Matthew Garrett <mjg@redhat.com>,
       Jiri Kosina <jkosina@suse.cz>, linux-input@vger.kernel.org
Subject: Re: [PATCH 8/9] Input: Block suspend while event queue is not
 empty.
Message-Id: <20100423135625.1e12d005.randy.dunlap@oracle.com>
In-Reply-To: <1271984938-13920-9-git-send-email-arve@android.com>
References: <1271984938-13920-1-git-send-email-arve@android.com>
	<1271984938-13920-2-git-send-email-arve@android.com>
	<1271984938-13920-3-git-send-email-arve@android.com>
	<1271984938-13920-4-git-send-email-arve@android.com>
	<1271984938-13920-5-git-send-email-arve@android.com>
	<1271984938-13920-6-git-send-email-arve@android.com>
	<1271984938-13920-7-git-send-email-arve@android.com>
	<1271984938-13920-8-git-send-email-arve@android.com>
	<1271984938-13920-9-git-send-email-arve@android.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090202.4BD209E1.01EE:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Apr 2010 18:08:57 -0700 Arve Hjønnevåg wrote:

> Add an ioctl, EVIOCSSUSPENDBLOCK, to enable a suspend_blocker that will block
> suspend while the event queue is not empty. This allows userspace code to
> process input events while the device appears to be asleep.


All new ioctls need to be added to Documentation/ioctl/ioctl-number.txt, please.

> Signed-off-by: Arve Hjønnevåg <arve@android.com>
> ---
>  drivers/input/evdev.c |   22 ++++++++++++++++++++++
>  include/linux/input.h |    3 +++
>  2 files changed, 25 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/input/evdev.c b/drivers/input/evdev.c
> index 2ee6c7a..66e0d16 100644
> --- a/drivers/input/evdev.c
> +++ b/drivers/input/evdev.c
> @@ -585,6 +594,19 @@ static long evdev_do_ioctl(struct file *file, unsigned int cmd,
>  		else
>  			return evdev_ungrab(evdev, client);
>  
> +	case EVIOCGSUSPENDBLOCK:
> +		return put_user(client->use_suspend_blocker, ip);
> +
> +	case EVIOCSSUSPENDBLOCK:
> +		spin_lock_irq(&client->buffer_lock);
> +		if (!client->use_suspend_blocker && p)
> +			suspend_blocker_init(&client->suspend_blocker, "evdev");
> +		else if (client->use_suspend_blocker && !p)
> +			suspend_blocker_destroy(&client->suspend_blocker);
> +		client->use_suspend_blocker = !!p;
> +		spin_unlock_irq(&client->buffer_lock);
> +		return 0;
> +
>  	default:
>  
>  		if (_IOC_TYPE(cmd) != 'E')
> diff --git a/include/linux/input.h b/include/linux/input.h
> index 7ed2251..b2d93b4 100644
> --- a/include/linux/input.h
> +++ b/include/linux/input.h
> @@ -82,6 +82,9 @@ struct input_absinfo {
>  
>  #define EVIOCGRAB		_IOW('E', 0x90, int)			/* Grab/Release device */
>  
> +#define EVIOCGSUSPENDBLOCK	_IOR('E', 0x91, int)			/* get suspend block enable */
> +#define EVIOCSSUSPENDBLOCK	_IOW('E', 0x91, int)			/* set suspend block enable */
> +
>  /*
>   * Event types
>   */
> -- 


thanks,
---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
