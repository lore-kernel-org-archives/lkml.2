Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab2GYS4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 14:56:47 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:56926 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751090Ab2GYS4p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 14:56:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC PATCH 00/13] firmware loader: introduce cache/uncache firmware
Date: Wed, 25 Jul 2012 21:02:31 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Ming Lei <ming.lei@canonical.com>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        "linux-usb" <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com> <CACVXFVOiXRiqRsE46_xmOzK_dExNvkBaJVwjiZ9adhwqRRwY+g@mail.gmail.com> <CA+55aFxF_nSEZGp8h4oXhusJgQ+dvjNL2eMurJMaJFQMPCbu9g@mail.gmail.com>
In-Reply-To: <CA+55aFxF_nSEZGp8h4oXhusJgQ+dvjNL2eMurJMaJFQMPCbu9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201207252102.31830.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, July 25, 2012, Linus Torvalds wrote:
> On Wed, Jul 25, 2012 at 5:35 AM, Ming Lei <ming.lei@canonical.com> wrote:
> >
> > The below patch should fix the problem above.
> 
> Actually, I think we could make this even simpler.
> 
> There's nothing wrong with saying "user mode is enabled" *just* before
> we unthaw things, if we also simply guarantee that there is no
> sleeping lock or similar that we might get caught on (causing a
> deadlock or other untimely waking) before we've actually thawed
> everything.
> 
> So *if* the only problem wrt the USB hub code comes from this area,
> then I think the solution might be as simple as just moving the
> "usermodehelper_enable()" up a few lines, with a comment. Something
> like the *untested* and whitespace-damaged thing below..
> 
> Rafael?

Yes, we can do this I think.

> Who has one of those isight things and has seen the warning to test?

That I can't answer, sorry.

Rafael


> ---
> diff --git a/kernel/power/process.c b/kernel/power/process.c
> index 19db29f67558..5bf50e488196 100644
> --- a/kernel/power/process.c
> +++ b/kernel/power/process.c
> @@ -181,6 +181,12 @@ void thaw_processes(void)
>         pm_freezing = false;
>         pm_nosig_freezing = false;
> 
> +       /*
> +        * User mode helper are available again (or will be,
> +        * modulo scheduling)
> +        */
> +       usermodehelper_enable();
> +
>         oom_killer_enable();
> 
>         printk("Restarting tasks ... ");
> @@ -193,8 +199,6 @@ void thaw_processes(void)
>         } while_each_thread(g, p);
>         read_unlock(&tasklist_lock);
> 
> -       usermodehelper_enable();
> -
>         schedule();
>         printk("done.\n");
>  }
> 
> 

