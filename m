Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758127Ab2FZCKi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 22:10:38 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:58734 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757862Ab2FZCKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 22:10:36 -0400
MIME-Version: 1.0
In-Reply-To: <CABe66sV=coC3=-CU1uDrCfN7aucKg59emTZZS=kL41OwYyrNBw@mail.gmail.com>
References: <1339815965-1171-1-git-send-email-filbranden@gmail.com>
	<1339815965-1171-2-git-send-email-filbranden@gmail.com>
	<20120618200131.GA12351@fieldses.org>
	<CABe66sW0k4N_7vMduOZMRak-U4A+6E7i+fiGwKEVBazJ1npBeg@mail.gmail.com>
	<20120626002908.GA14279@fieldses.org>
	<CABe66sV=coC3=-CU1uDrCfN7aucKg59emTZZS=kL41OwYyrNBw@mail.gmail.com>
Date: Mon, 25 Jun 2012 22:10:35 -0400
Message-ID: <CABe66sXc6tD83D=w_=YeNBo-5A7Q_KPTCq1-Dfnk9JCNw0i5ug@mail.gmail.com>
Subject: Re: [PATCH 1/1] locks: prevent side-effects of locks_release_private
 before file_lock is initialized
From: Filipe Brandenburger <filbranden@gmail.com>
To: "J. Bruce Fields" <bfields@fieldses.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Matthew Wilcox <matthew@wil.cx>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bruce,

Just to let you know that I just tested the patch below on top of
3.5.0-rc4 and it works fine...

Do you like the idea of this second patch or do you prefer the
__locks_free_lock() one?

Do you agree with the name "fl_lease_inuse" for the field in file_lock
struct to track whether the lease was initialized/assigned?

May I go ahead and submit a PATCHv2 for this fix?

Cheers,
Filipe


On Mon, Jun 25, 2012 at 8:48 PM, Filipe Brandenburger
<filbranden@gmail.com> wrote:
> Hi Bruce,
>
> I was just reviewing this set of patches today... I think if the idea
> is not to call fl->fl_lmops->lm_release_private(fl) when the file_lock
> struct was not used, then I'd prefer to introduce an exported
> __locks_free_lock() function that would do it in order not to expose
> the kmem_cache implementation and allow other implementations to do
> it.
>
> But I was reading the code and thinking a little more about it and now
> I think the correct behavior should be to always call
> fl->fl_lmops->lm_release_private(fl) (if the pointers are not NULL)
> and have that function behave appropriately if the file_lock struct
> was not used.
>
> What made me think of that was a use of fl_ops (it's not directly
> fl_lmops, but still I think it would be nice to keep a similar
> interface) where nfs4_fl_lock_ops.fl_release_private =
> nfs4_fl_release_lock and nfs4_fl_release_lock calls
> nfs4_put_lock_state which frees some lists and decrements the usage
> counter... Not calling fl->fl_ops->fl_release_private(fl) in that
> particular case would be clearly wrong...
>
> So I was thinking of tracking whether the lease was assigned, probably
> setting the flag in vfs_setlease(), and then changing
> lease_release_private_callback() to check whether the flag was set and
> only resetting the F_SETOWN and F_SETSIG information if the flag was
> set...
>
> What do you think of that idea?
>
> I just got a quick diff which outlines what I'm thinking of, I haven't
> tested it yet, I'll try to build it and run it to see if it passes the
> testcase. But please let me know what you think of it.
>
> Cheers,
> Fil
>
> ------- >8 cut here -------
>
>
> diff --git a/fs/locks.c b/fs/locks.c
> index 814c51d..242ac84 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -429,7 +429,7 @@ static void lease_break_callback(struct file_lock *fl)
>
>  static void lease_release_private_callback(struct file_lock *fl)
>  {
> -       if (!fl->fl_file)
> +       if (!fl->fl_file || !fl->fl_lease_inuse)
>                return;
>
>        f_delown(fl->fl_file);
> @@ -1513,6 +1513,9 @@ int vfs_setlease(struct file *filp, long arg,
> struct file_lock **lease)
>        error = __vfs_setlease(filp, arg, lease);
>        unlock_flocks();
>
> +       if (!error)
> +               lease->fl_lease_inuse = 1;
> +
>        return error;
>  }
>  EXPORT_SYMBOL_GPL(vfs_setlease);
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 17fd887..2c577a9 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -1176,6 +1176,7 @@ struct file_lock {
>        struct list_head fl_block;      /* circular list of blocked processes */
>        fl_owner_t fl_owner;
>        unsigned int fl_flags;
> +       unsigned char fl_lease_inuse;
>        unsigned char fl_type;
>        unsigned int fl_pid;
>        struct pid *fl_nspid;
