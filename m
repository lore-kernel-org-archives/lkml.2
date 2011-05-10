Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab1EJTi0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 15:38:26 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:39718 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab1EJTiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 15:38:25 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: linux-next: build failure after merge of the final tree (driver-core tree related)
Date: Tue, 10 May 2011 21:38:45 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc5+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Anton Guda <atu@dmeti.dp.ua>
References: <20110509145854.9e6d8806.sfr@canb.auug.org.au> <201105100019.52936.rjw@sisk.pl> <1304983104.1351.17.camel@zag>
In-Reply-To: <1304983104.1351.17.camel@zag>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201105102138.45867.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 10, 2011, Kay Sievers wrote:
> On Tue, 2011-05-10 at 00:19 +0200, Rafael J. Wysocki wrote:
> > On Monday, May 09, 2011, Kay Sievers wrote:
> > > On Mon, May 9, 2011 at 06:58, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > > > After merging the final tree, today's linux-next build (powerpc allnoconfig)
> > > > failed like this:
> > > >
> > > > kernel/sys.c: In function 'kernel_restart_prepare':
> > > > kernel/sys.c:317: error: implicit declaration of function 'usermodehelper_disable'
> > > 
> > > Rafael, seems usermodehelper_disable() depends on CONFIG_PM_SLEEP.
> > > 
> > > Any reason for that conditional? Remove it now?
> > 
> > Aw, we have two conflicting changes.  Could you prepare a patch on top of:
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-next
> > 
> > removing that #ifdef?  That needs to be done in kmod.h too.
> 
> Like this?

Yes, thanks.

I applied it to suspend-2.6/linux-next.

Rafael

 
> From: Kay Sievers <kay.sievers@vrfy.org>
> Subject: kmod: always provide usermodehelper_disable()
> 
> We need to prevent kernel-forked processes during system poweroff.
> Such processes try to access the filesystem whose disks we are
> trying to shutdown at the same time. This causes delays and exceptions
> in the storage drivers.
> 
> A follow-up patch will add these calls and need usermodehelper_disable()
> also on systems without suspend support.
> 
> Signed-off-by: Kay Sievers <kay.sievers@vrfy.org>
> ---
> 
> diff --git a/include/linux/kmod.h b/include/linux/kmod.h
> index 7f3dbcb..3102318 100644
> --- a/include/linux/kmod.h
> +++ b/include/linux/kmod.h
> @@ -111,12 +111,8 @@ call_usermodehelper(char *path, char **argv, char **envp, enum umh_wait wait)
>  
>  extern void usermodehelper_init(void);
>  
> -#ifdef CONFIG_PM_SLEEP
>  extern int usermodehelper_disable(void);
>  extern void usermodehelper_enable(void);
>  extern bool usermodehelper_is_disabled(void);
> -#else
> -static inline bool usermodehelper_is_disabled(void) { return false; }
> -#endif
>  
>  #endif /* __LINUX_KMOD_H__ */
> diff --git a/kernel/kmod.c b/kernel/kmod.c
> index 9ab513b..5ae0ff3 100644
> --- a/kernel/kmod.c
> +++ b/kernel/kmod.c
> @@ -245,7 +245,6 @@ static void __call_usermodehelper(struct work_struct *work)
>  	}
>  }
>  
> -#ifdef CONFIG_PM_SLEEP
>  /*
>   * If set, call_usermodehelper_exec() will exit immediately returning -EBUSY
>   * (used for preventing user land processes from being created after the user
> @@ -321,12 +320,6 @@ static void helper_unlock(void)
>  	if (atomic_dec_and_test(&running_helpers))
>  		wake_up(&running_helpers_waitq);
>  }
> -#else /* CONFIG_PM_SLEEP */
> -#define usermodehelper_disabled	0
> -
> -static inline void helper_lock(void) {}
> -static inline void helper_unlock(void) {}
> -#endif /* CONFIG_PM_SLEEP */
>  
>  /**
>   * call_usermodehelper_setup - prepare to call a usermode helper
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
> 

