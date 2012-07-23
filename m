Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2GWIMr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jul 2012 04:12:47 -0400
Received: from osrc3.amd.com ([217.9.48.20]:52567 "EHLO mail.x86-64.org"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab2GWIMo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jul 2012 04:12:44 -0400
Date: Mon, 23 Jul 2012 10:12:38 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ming Lei <tom.leiming@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-usb <linux-usb@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Oliver Neukum <oneukum@suse.de>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [RFC] firmware load: defer request_firmware during early boot
 and resume
Message-ID: <20120723081238.GA16357@aftab.osrc.amd.com>
References: <CACVXFVNWOcrR9tYhU1wVUSJ_DJ8x+SCk993Sn9dYDe2kzJBDuQ@mail.gmail.com>
 <CA+55aFwZRvtpE2e3zNqvtobpPROqw_bOwNt+=DBzmScV0_rq=w@mail.gmail.com>
 <CACVXFVPupumYqeBwTwgK3C04VQBxOjkFMbaKQ-Gsz3teCWqQ=w@mail.gmail.com>
 <CA+55aFwte5bc-4FC758pBN3FbrtKQfwm_Mv_banekhL=kSF8kg@mail.gmail.com>
 <20120722125843.GC18939@liondog.tnic>
 <CA+55aFyOgWtyd=STeDrR687qKqu6TQ_q-aUTKcr_aQJNYrOhCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyOgWtyd=STeDrR687qKqu6TQ_q-aUTKcr_aQJNYrOhCg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 22, 2012 at 12:46:13PM -0700, Linus Torvalds wrote:
> On Sun, Jul 22, 2012 at 5:58 AM, Borislav Petkov <bp@alien8.de> wrote:
> >
> > Question: is there any other reason
> >
> >   [besides maybe embedded people who care about each single Kb of memory
> >    on the system]
> >
> > why we don't make this cache/uncache firmware thing *implicit*? That is,
> > load it once at driver open time and keep it in memory during the whole
> > driver's lifetime. And this all taken care of by the driver core, btw.
> 
> So some firmware is a *lot* more than "a few kB". We're talking
> hundreds of kB, sometimes more.

Ok.

> And to make matters worse, we keep it in memory with vmalloc(), which
> is a limited resource on 32-bit systems. So it can actually be worse
> than just the memory use itself.

Ok, a follow-up: why do we use vmalloc space for firmware, actually?
Because it can be a lot more than a few KB as you say above and a normal
kmalloc allocation could fail in such a case?

Becase I recently converted the AMD microcode driver to use a normal
get_zeroed_page page and got rid of all the vmalloc allocations it did
and it is still working :).

What I'm saying is, we probably could take care of the vmalloc issue by
allocating firmware memory early enough so that we can always succeed.
Oh, I see one problem here - the driver could be loaded very late in
the system lifetime and we could be having fragmented physical memory
so that kmalloc does actually fail. In such cases, we can fallback to
vmalloc I guess.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
