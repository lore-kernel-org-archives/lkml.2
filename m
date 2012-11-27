Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756247Ab2K0T5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 14:57:47 -0500
Received: from mailout39.mail01.mtsvc.net ([216.70.64.83]:48073 "EHLO
	n12.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752039Ab2K0T5p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 14:57:45 -0500
Message-ID: <1354046255.2444.10.camel@thor>
Subject: Re: [PATCH 21/21] TTY: move tty buffers to tty_port
From: Peter Hurley <peter@hurleysoftware.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Jiri Slaby <jirislaby@gmail.com>,
        gregkh@linuxfoundation.org, alan@linux.intel.com,
        linux-kernel@vger.kernel.org, Dave Jones <davej@redhat.com>
Date: Tue, 27 Nov 2012 14:57:35 -0500
In-Reply-To: <5095BC6E.2010505@gmail.com>
References: <1350592007-9216-1-git-send-email-jslaby@suse.cz>
	 <1350592007-9216-22-git-send-email-jslaby@suse.cz>
	 <50897E98.5080502@gmail.com> <50911F67.3040303@suse.cz>
	 <CA+1xoqfZ5DHVi44Y_a5EmXYeN6Eh=COSP4CiA6tM-aqJE1vBoQ@mail.gmail.com>
	 <5091448D.3@suse.cz>
	 <CA+1xoqdRBCQYBQdK-=KJohtua_wD_fp4akk6_jS0x3x82fRp5g@mail.gmail.com>
	 <5093EC1B.2050800@suse.cz>
	 <CA+1xoqdRV5LORTDM9iiTRQwCdGK9XqcW54zyh03M-c-mVU2YLQ@mail.gmail.com>
	 <5093F262.6000301@suse.cz> <50947B7B.8080601@gmail.com>
	 <50953E8D.9000504@suse.cz> <5095A384.5080205@gmail.com>
	 <5095BC6E.2010505@gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.2.4-0build1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Authenticated-User: 125194 peter@hurleysoftware.com
X-MT-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
X-MT-INTERNAL-ID: 8fa290c2a27252aacf65dbc4a42f3ce3735fb2a4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-11-03 at 20:53 -0400, Sasha Levin wrote:
> On 11/03/2012 07:06 PM, Sasha Levin wrote:
> > On 11/03/2012 11:55 AM, Jiri Slaby wrote:
> >> On 11/03/2012 03:03 AM, Sasha Levin wrote:
> >>> On 11/02/2012 12:18 PM, Jiri Slaby wrote:
> >>>> On 11/02/2012 05:07 PM, Sasha Levin wrote:
> >>>>> On Fri, Nov 2, 2012 at 11:51 AM, Jiri Slaby <jslaby@suse.cz> wrote:
> >>>>>> On 10/31/2012 04:59 PM, Sasha Levin wrote:
> >>>>>>> So you probably want a lot more than 100k syscalls, why limit it at
> >>>>>>> all actually?
> >>>>>>
> >>>>>> I unset the limit but I still can't reproduce...
> >>>>>>
> >>>>>>> I've attached my .config for the guest kernel as reference.
> >>>>>>
> >>>>>> Even using this config does not help to reproduce that.
> >>>>>>
> >>>>>> Do you use some special trinity params?
> >>>>>
> >>>>> Not really:
> >>>>>
> >>>>>     ./trinity -m --quiet --dangerous -l off
> >>>>
> >>>> Oh, you run that as root??
> >>>>
> >>>>> Can I add something to my kernel to provide more info when it happens?
> >>>>
> >>>> Maybe the attached patch can tell us more...
> >>>>
> >>>
> >>> Nope, I see the warnings mentioned before, without the new 'HUH' warnings.
> >>
> >> Actually it does. It is exactly as you wrote some time earlier. The work
> >> is scheduled after is was cancelled and should not trigger anymore. Or,
> >> it is scheduled before it is supposed to do. Could you try the attached
> >> patch and report what happens with that patch?
> >>
> >> PS I can't reproduce by whatever I tried.
> >>
> >> thanks,
> >>
> > 
> > Interesting...
> > 
> > [  388.783955] tty is bad=0 ops=          (null)Pid: 6480, comm: kworker/1:2 Tainted: G        W
> > 3.7.0-rc3-next-20121102-sasha-00002-gbb570e0-dirty #111
> 
> So after fuzzing for a while I'm also seeing these:
> 
> [  603.533932] tty is bad=-2 ops=          (null)Pid: 37, comm: kworker/4:0 Tainted: G        W    3.7.0-rc3-next-20121102-sasha-000
> 02-gbb570e0-dirty #112

Hi Sasha,

Assuming this access-after-free is still reproducible for you, would you
be willing to try the patch below? I tried to reproduce this and
couldn't (with multiple cores and with just single core).

It would distinguish between case A (that the buf work is not being
cancelled) and case B (that the buf work is being scheduled after the
port has already been freed). It should BUG in case B, which would also
expose the call chain. It won't help at all in case A though :\

Regards,
Peter Hurley

-- >% --
Subject: [PATCH -next] tty: debug: Narrow possible causes of access-after-free


Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/pty.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/tty/pty.c b/drivers/tty/pty.c
index be6a373..893fe69 100644
--- a/drivers/tty/pty.c
+++ b/drivers/tty/pty.c
@@ -409,6 +409,7 @@ static void pty_cleanup(struct tty_struct *tty)
 {
 	tty->port->itty = NULL;
 	tty_port_put(tty->port);
+	tty->port = NULL;
 }
 
 /* Traditional BSD devices */
-- 
1.8.0



