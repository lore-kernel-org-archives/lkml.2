Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755749Ab1DBKAx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 06:00:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49944 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755483Ab1DBKAv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 06:00:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:x-message-flag
         :x-operating-system:x-editor:x-disclaimer:user-agent;
        b=C2i7wDgoK8n+veDWbAEZ4b+CVfPxCFjcNoBVWBpfRELKdzGW+u3sBWtRg2bsqSuUr+
         dn05H0u5+PPffsMCJbSyEP1/r+YclO4OtYxzo/iPTIwd3aq/a/t328FqT3tc2+jcjQtJ
         pG6dKem1diVEICLP3ajRsIoQcA2KDZtYKS5/Y=
Date: Sat, 2 Apr 2011 19:00:44 +0900
From: Mattia Dongili <malattia@linux.it>
To: Andrea Gelmini <andrea.gelmini@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, anssi.hannula@iki.fi,
        linux-acpi@vger.kernel.org, axel.lin@gmail.com, trenn@suse.de,
        len.brown@intel.com, error27@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: Regression 2.6.39-rc1 for sony-laptop
Message-ID: <20110402100043.GA5890@kamineko.org>
References: <AANLkTi=1xtjEZc2C1=W-v2oYbvvcGH9k_DGGXvJ8=swq@mail.gmail.com>
 <20110401172241.GA26851@srcf.ucam.org>
 <BANLkTikPjwowBge82viT+Ma5UnP0fA-pew@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikPjwowBge82viT+Ma5UnP0fA-pew@mail.gmail.com>
X-Message-Flag: Cranky? Try Free Software instead!
X-Operating-System: Linux 2.6.39-rc1+ x86_64
X-Editor: Vim http://www.vim.org/
X-Disclaimer: Buh!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 02, 2011 at 11:44:57AM +0200, Andrea Gelmini wrote:
> 2011/4/1 Matthew Garrett <mjg59@srcf.ucam.org>:
> > touch any Sony code. I'll take a look at the Sony patches, thanks for
> > the report!
> 
> Hi Matthew,
>    and thanks a lot for your quick answer.
>    Maybe I messed up with bisect trying to find the origin of two regression.
>    One was this. The other one is this one.
> 
>    Hibernation (to disk, of course) doesn't work no more.
>    Screen blanks and nothing happens. No HD activity, and so on. I also
>    waited some minutes.
> 
>    Well, bisect blame this commit:
> 
> commit 2a4f0c81adcd1f812a63bc9106be2fd26f437730
> Author: Mattia Dongili <malattia@linux.it>
> Date:   Sat Feb 19 11:52:30 2011 +0900
> 
>     sony-laptop: cache handles and report them via sysfs
> 
>     Avoid calling into acpi each time we need to lookup a method handle
>     and report the available handles to ease collection of information when
>     debugging issues. Also move initialization of the platform driver
>     earlier to allow adding files from other setup functions.
> 
>     Signed-off-by: Mattia Dongili <malattia@linux.it>
>     Signed-off-by: Matthew Garrett <mjg@redhat.com>
> 
>  drivers/platform/x86/sony-laptop.c |   97 ++++++++++++++++++++++++++++++------
>  1 files changed, 81 insertions(+), 16 deletions(-)
> 
>    Do you have any suggestion to better track down this issue?
>    It's not possibile to simply revert it.

As already reported the following patch should fix the issue:

commit 88d25cbfda526567dabf056a868d8ff5f22a962e
Author: Mattia Dongili <malattia@linux.it>
Date:   Fri Apr 1 10:01:41 2011 +0900

    sony-laptop: fix early NULL pointer dereference
    
    The SNC acpi driver could get early notifications before it fully
    initializes and that could lead to dereferencing the sony_nc_handles
    structure pointer that is still NULL at that stage.
    Make sure we return early from the handle lookup function in these
    cases.
    
    Signed-off-by: Mattia Dongili <malattia@linux.it>

diff --git a/drivers/platform/x86/sony-laptop.c b/drivers/platform/x86/sony-laptop.c
index b2ce172..7082c55 100644
--- a/drivers/platform/x86/sony-laptop.c
+++ b/drivers/platform/x86/sony-laptop.c
@@ -810,6 +810,11 @@ static int sony_nc_handles_cleanup(struct platform_device *pd)
 static int sony_find_snc_handle(int handle)
 {
 	int i;
+
+	/* not initialized yet, return early */
+	if (!handles)
+		return -1;
+
 	for (i = 0; i < 0x10; i++) {
 		if (handles->cap[i] == handle) {
 			dprintk("found handle 0x%.4x (offset: 0x%.2x)\n",
-- 
mattia
:wq!
