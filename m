Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933826Ab0HERJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 13:09:33 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:33589 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755750Ab0HERJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 13:09:28 -0400
Date: Thu, 5 Aug 2010 13:09:26 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: James Bottomley <James.Bottomley@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <AANLkTintTMXirWF+Y-CwK4dn8Mqk8=ba9_+yjX9P837V@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1008051306080.1944-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fake "address-of" expressions that evaluate to NULL generally confuse
readers and can provoke compiler warnings.  This patch (as1411)
removes one such fake expression, using an "#ifdef" in its place.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>

---

On Wed, 4 Aug 2010, Linus Torvalds wrote:

> On Tue, Aug 3, 2010 at 9:13 PM, James Bottomley <James.Bottomley@suse.de> wrote:
> >
> > Alan Stern (3):
> >      sd: add support for runtime PM
> >      implement runtime Power Management
> >      convert to the new PM framework
> 
> Guys, these kind of crazy games really aren't appropriate:
> 
>   +/* scsi_pm.c */
>   +#ifdef CONFIG_PM_OPS
>   +extern const struct dev_pm_ops scsi_bus_pm_ops;
>   +#else
>   +#define scsi_bus_pm_ops                (*NULL)
>   +#endif
> 
> that's just crazy. Yes, I see how it's then used (address-of operator
> turns it back into NULL), but the compiler warns about it
> ("drivers/scsi/scsi_sysfs.c:384: warning: dereferencing ‘void *’
> pointer") and I think the compiler is 100% correct about warning about
> it.
> 
> It's not just the (*NULL) games, btw. The above can cause confusion.
> It's ugly not just because it causes the compiler to warn, but because
> you use a very subtle and non-standard way of using #define's, so that
> when you look at the source code where this is used, it's not at all
> obvious what is going on. The code looks like
> 
>     .pm             = &scsi_bus_pm_ops,
> 
> and dammit, it would be rather understandable if some _human_ that
> reads that is also confused and thinks that the above means that the
> .pm pointer can never be NULL. The address-of would certainly throw
> me, and not necessarily at all make me grep for "could that possibly
> be some crazy way to say NULL".
> 
> And there is absolutely no reason to play games like that. It would
> have been entirely understandable if you just put the #ifdef in the C
> code itself, or if you used a #define that just said
> 
>   #ifdef CONFIG_PM_OPS
>   #define SCSI_BUS_PM_OPS &scsi_bus_pm_ops
>   #else
>   #define SCSI_BUS_PM_OPS NULL
>   #endif
> 
> and I think it would be less confusing, and it wouldn't upset the compiler.
> 
> Yes, yes, I realize that we do these kinds of things for function
> pointers all the time, so I do understand where the pattern comes
> from. At the same time, I rather think that function pointers are a
> bit different, and they don't have the whole address-of problem.
> 
> I guess I should be happy that you didn't use some linker tricks to
> make "&scsi_bus_pm_ops" turn into NULL at link time. That could be
> done too, and would have been even more subtly confusing.

In my opinion this is the simplest and easiest-to-understand approach.  
The two of you can fight over who merges it first.  :-)

Alan Stern



Index: usb-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_priv.h
+++ usb-2.6/drivers/scsi/scsi_priv.h
@@ -148,8 +148,6 @@ static inline void scsi_netlink_exit(voi
 /* scsi_pm.c */
 #ifdef CONFIG_PM_OPS
 extern const struct dev_pm_ops scsi_bus_pm_ops;
-#else /* CONFIG_PM_OPS */
-#define scsi_bus_pm_ops		(*NULL)
 #endif
 #ifdef CONFIG_PM_RUNTIME
 extern void scsi_autopm_get_target(struct scsi_target *);
Index: usb-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- usb-2.6.orig/drivers/scsi/scsi_sysfs.c
+++ usb-2.6/drivers/scsi/scsi_sysfs.c
@@ -382,7 +382,9 @@ struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
 	.uevent		= scsi_bus_uevent,
+#ifdef CONFIG_PM_OPS
 	.pm		= &scsi_bus_pm_ops,
+#endif
 };
 EXPORT_SYMBOL_GPL(scsi_bus_type);
 

