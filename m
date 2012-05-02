Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754001Ab2EBLc2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 07:32:28 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:50718 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752658Ab2EBLc1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 07:32:27 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: Killing the tty lock
Date: Wed, 2 May 2012 11:32:16 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <20120501173739.4fe61fb5@pyramind.ukuu.org.uk>
In-Reply-To: <20120501173739.4fe61fb5@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205021132.16662.arnd@arndb.de>
X-Provags-ID: V02:K0:Yw605RWNgOlLNWaaM/LhTJUI6A3Np+nqQEc3KwL3jtl
 utY0Yxix1Oi8pu9RnBDLsMUwLvSl3fUWFZbr2WZSsYVFWQnguE
 j5eDiSYZwV/dLZchz+cU9kJqq1t7g+ir80ghBmlwNsr+k6iuLF
 wKxCYQX0yVUZ1h6d9yESP3amBQgU2WSEosPrvYKPoPBUaBo8bf
 KCwI6hID22D0uGiu8qKCyLis2RByDQhXaeTu4ZlXWI9O7I5xkS
 k4hu6Ls9V6qzVi6nz1gj5/uAZ2QGay3yB+BgX/gcaTNZJ+AuPx
 LghF856a+mgAj8/zbxcHehDiWkKYg4+WyOQHVVNxumHv4EoCzI
 WDXc1Rde0sB2RLmJZWLU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 01 May 2012, Alan Cox wrote:
> This is a first stab at it by making the lock per tty and using tty_mutex
> to cover the lookup for now. We ought to move to the lookup handing back
> ttys with a ref but thats a further step.
> 
> It seems to mostly work but not quite reliably, so coul do with some more
> eyes and review for ideas.

Hi Alan,

I had tried the same some time ago but couldn't get it working because
some of the prerequisites were not there. I'll comment on the differences
between your patch and mine. In my version, I completely removed the
tty_mutex.c file and just open-coded mutex_lock() functions, but you
version with the extra checks also has its benefits. I found two differences
where I think your version is wrong, but I could be missing something.

> @@ -62,9 +63,7 @@ static void pty_close(struct tty_struct *tty, struct file *filp)
>  		        mutex_unlock(&devpts_mutex);
>  		}
>  #endif
> -		tty_unlock();
>  		tty_vhangup(tty->link);
> -		tty_lock();
>  	}
>  }

I had missed that we don't need to unlock here once the lock is per-tty,
this looks better than my version.

> @@ -654,15 +654,17 @@ static int ptmx_open(struct inode *inode, struct file *filp)
>  	if (retval)
>  		goto err_release;
>  
> -	tty_unlock();
> +	tty_unlock(tty);
>  	return 0;
>  err_release:
> -	tty_unlock();
> +	tty_unlock(tty);
>  	tty_release(inode, filp);
>  	return retval;
>  out:
> +        mutex_lock(&devpts_mutex);
>  	devpts_kill_index(inode, index);
> -	tty_unlock();
> +        mutex_unlock(&devpts_mutex);
> +	tty_unlock(tty);
>  err_file:
>  	tty_free_file(filp);
>  	return retval;

This one looks wrong: when you get to the "out" label, tty is not valid.

> @@ -1403,6 +1403,7 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx)
>  	}
>  	initialize_tty_struct(tty, driver, idx);
>  
> +	tty_lock(tty);
>  	retval = tty_driver_install_tty(driver, tty);
>  	if (retval < 0)
>  		goto err_deinit_tty;
> @@ -1418,6 +1419,7 @@ struct tty_struct *tty_init_dev(struct tty_driver *driver, int idx)
>  	return tty;
>  
>  err_deinit_tty:
> +	tty_unlock(tty);
>  	deinitialize_tty_struct(tty);
>  	free_tty_struct(tty);
>  err_module_put:
> @@ -1426,6 +1428,7 @@ err_module_put:
>  
>  	/* call the tty release_tty routine to clean out this slot */
>  err_release_tty:
> +	tty_unlock(tty);
>  	printk_ratelimited(KERN_INFO "tty_init_dev: ldisc open failed, "
>  				 "clearing slot %d\n", idx);
>  	release_tty(tty, idx);

So tty_init_dev returns a locked tty on success? If so, a comment about this
might be helpful. The part I don't understand is how ptmx_open takes the
lock right after calling tty_init_dev without anyone releasing it inbetween.
Or does it get released in tty_driver_install_tty or tty_ldisc_setup?

> @@ -1675,7 +1679,7 @@ int tty_release(struct inode *inode, struct file *filp)
>  		   opens on /dev/tty */
>  
>  		mutex_lock(&tty_mutex);
> -		tty_lock();
> +		tty_lock_pair(tty, o_tty);
>  		tty_closing = tty->count <= 1;
>  		o_tty_closing = o_tty &&
>  			(o_tty->count <= (pty_master ? 1 : 0));

Very clever.

>  static int tty_open(struct inode *inode, struct file *filp)
> @@ -1916,8 +1923,7 @@ retry_open:
>  	retval = 0;
>  
>  	mutex_lock(&tty_mutex);
> -	tty_lock();
> -
> +	/* This is protected by the tty_mutex */
>  	tty = tty_open_current_tty(device, filp);
>  	if (IS_ERR(tty)) {
>  		retval = PTR_ERR(tty);
> @@ -1938,17 +1944,19 @@ retry_open:
>  	}
>  
>  	if (tty) {
> +		tty_lock(tty);
>  		retval = tty_reopen(tty);
> -		if (retval)
> +		if (retval < 0) {
> +			tty_unlock(tty);
>  			tty = ERR_PTR(retval);
> -	} else
> +		}
> +	} else	/* Returns with the tty_lock held for now */
>  		tty = tty_init_dev(driver, index);
>  
>  	mutex_unlock(&tty_mutex);
>  	if (driver)
>  		tty_driver_kref_put(driver);
>  	if (IS_ERR(tty)) {
> -		tty_unlock();
>  		retval = PTR_ERR(tty);
>  		goto err_file;
>  	}

Ah, so this is why tty_init_dev takes the lock. In my version, I take
the lock after tty_init_dev in the else path, but I guess the result
is pretty much the same.

	Arnd
