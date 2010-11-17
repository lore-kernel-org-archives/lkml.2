Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751480Ab0KQXrH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 18:47:07 -0500
Received: from smtp-out.google.com ([216.239.44.51]:21868 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750722Ab0KQXrF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 18:47:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=yk+m6vs97KZPQXPEwmiEulzzTDL4pdO5pk6Fzu1t366BzGHtBhek18S9N3rSmTi6BF
         BXDOXxVfeeSuR1TbpN3w==
Date: Wed, 17 Nov 2010 15:46:51 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Ondrej Zary <linux@rainbow-software.org>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Balbir Singh <balbir@in.ibm.com>
Subject: Re: 2.6.35.5: hibernation broken... AGAIN
In-Reply-To: <201011172218.42053.linux@rainbow-software.org>
Message-ID: <alpine.LSU.2.00.1011171531310.15942@sister.anvils>
References: <201011171139.33398.linux@rainbow-software.org> <20101117130422.d9de48d8.akpm@linux-foundation.org> <201011172212.01433.rjw@sisk.pl> <201011172218.42053.linux@rainbow-software.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Nov 2010, Ondrej Zary wrote:
> On Wednesday 17 November 2010 22:12:01 Rafael J. Wysocki wrote:
> > On Wednesday, November 17, 2010, Andrew Morton wrote:
> > > On Wed, 17 Nov 2010 21:53:52 +0100
> > > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > > > On Wednesday, November 17, 2010, Ondrej Zary wrote:
> > > > > Hello,
> > > > > the nasty memory-corrupting hibernation bug
> > > > > https://bugzilla.kernel.org/show_bug.cgi?id=15753 is back since
> > > > > 2.6.35.5. 2.6.35.4 works fine, 2.6.35.5 crashes after two days.

That's distressing, for both and all of us: I'm sorry.

> > > > >
> > > > > It seems to be caused by b77c254d8d66e5e9aa81239fedba9f3d568097d9.
> >
> > > commit b77c254d8d66e5e9aa81239fedba9f3d568097d9
> > > Author: Hugh Dickins <hughd@google.com>
> > > Date:   Thu Sep 9 16:38:09 2010 -0700
> > >
> > >     swap: prevent reuse during hibernation

Embarrassing: I suspect that I've been confused, not for the first
time, by the fork-like nature of hibernation and its images.
I wonder if this patch below fixes it, Ondrej?

(And is it kernel swsusp or user swsusp that you're using?  May not
matter at all, but will help us to think more clearly about it,
if the corruption remains after this patch.)

Rafael, do you agree that this patch was actually required even for
your original commit 452aa6999e6703ffbddd7f6ea124d3968915f3e3
mm/pm: force GFP_NOIO during suspend/hibernation and resume?

Or am I still just as confused?  Or if not, are there more forking
places which require a similar patch?

Not signing it off yet,
Hugh

---

 kernel/power/hibernate.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- 2.6.37-rc2/kernel/power/hibernate.c	2010-11-01 13:01:31.000000000 -0700
+++ linux/kernel/power/hibernate.c	2010-11-17 15:23:36.000000000 -0800
@@ -348,16 +348,19 @@ int hibernation_snapshot(int platform_mo
 		goto Recover_platform;
 
 	error = create_image(platform_mode);
-	/* Control returns here after successful restore */
+	/* Control returns here after successful restore,
+	 * and also after creating the image in memory (or failing to do so).
+	 */
 
  Resume_devices:
 	/* We may need to release the preallocated image pages here. */
-	if (error || !in_suspend)
+	if (error || !in_suspend) {
 		swsusp_free();
+		set_gfp_allowed_mask(saved_mask);
+	}
 
 	dpm_resume_end(in_suspend ?
 		(error ? PMSG_RECOVER : PMSG_THAW) : PMSG_RESTORE);
-	set_gfp_allowed_mask(saved_mask);
 	resume_console();
  Close:
 	platform_end(platform_mode);
