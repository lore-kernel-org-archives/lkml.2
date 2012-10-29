Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932705Ab2J2SQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 14:16:24 -0400
Received: from smtp1.smmp-rueil.gmessaging.net ([81.80.3.134]:48475 "EHLO
	smtp1.smmp-rueil.gmessaging.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932181Ab2J2SQW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 14:16:22 -0400
Message-ID: <29600_1351534580_508EC7F3_29600_2345_1_508EC7F1.9030102@sagemcom.com>
Date: Mon, 29 Oct 2012 19:16:17 +0100
From: Guillaume Juan <guillaume.juan@sagemcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n_gsm: prevent crash due to dereferencing NULL gsm->tty
References: <26026_1351239109_508A45C4_26026_63_1_508A45C1.3010407@sagemcom.com> <20121029162947.6270b4da@pyramind.ukuu.org.uk>
In-Reply-To: <20121029162947.6270b4da@pyramind.ukuu.org.uk>
X-MIMETrack: Itemize by SMTP Server on CHELS01SC/SERV/SAGEMCOM(Release 7.0.4|March 23, 2009) at
 10/29/2012 07:16:18 PM,
	Serialize by Router on CHELS01SC/SERV/SAGEMCOM(Release 7.0.4|March 23, 2009) at
 10/29/2012 07:16:19 PM,
	Serialize complete at 10/29/2012 07:16:19 PM
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 29/10/2012 17:29, Alan Cox a écrit :

> 
> More important is fixing the bug completely. I agree there is a bug I
> don't think your fix is sufficient however.
>

It may not fix all cases but I think it improves things both from a
practical and theoretical point of view.
In particular the part in gsmtty_hangup: the crash was systematic if the
user space released the virtual ttys fds only after the N_GSM line
discipline was removed (with ioctl).
I explained all the crashes I had, and did not reproduced crashes after
my patch. Note that I don't have use-cases where the DCE itself opens
some DLCIs, which certainly can cause a lot more trouble.


> 
> You no longer set dlci->dead before doing the dlci release

Yes I do, see line 2036:
+	if (dlci)
+		dlci->dead = 1;
I do it only for DLCI#0 but this is the same as what the previous code
was doing (I don't understand why but I thought that was another topic).
I was not sure that this dlci->dead was really efficient, but I decided
to keep it because addressing the relevance of dlci->dead was not the
purpose of my patch.

> Also moving the gsm_dlci_release seems to have no value at all because
> there is no locking in the code concerned so viewed from any other thread
> you've changed nothing but timings. Yes its probably way harder to hit.
> 

I don't really see your point, or I think you may be speaking of a
different matter. Once gsm_dlci_release has done its job, the T2 timer
should no longer be rearmed by anything the user-space could do, because
the tty will be hung up (tty_vhangup is synchronous isn't it ?). At
least tty_port_close_start would not call tty_port_lower_dtr_rts
anymore. So then the comment /* Now we are sure T2 has stopped */ after
del_timer_sync will be true.
Do you see any other paths that may lead to relaunch the T2 timer
afterwards? Don't you agree that gsmtty_release should be done before
del_timer_sync?

> I can see two ways of tackling it both of which basically come down to
> the same thing. In gsmld_detach_gsm after the gsm_cleanup_mux we need to
> 
> - be sure the thing cannot re-open

If you talk about reopening from the other side, I agree with you that
dlci->dead does not seem to protect enough. However I can read in the
description of gsmld_close that "the function will not be called while
other ldisc methods are in progress". If this is true, the concurrence
of gsmld_receive_buf should not be possible ?

> - wait until all the DLCIs are dead

I am not sure what you mean by this:
- gsm_cleanup_mux already waits for the answer to CLD command and to the
closure of DLCI#0. As I reported previously, it will never see the
answers coming because of the line-discipline life-cycle design, but
this is yet another topic.
- or maybe you mean wait until we are sure there are no longer
references to the virtual ttys. This seems to me impossible to achieve
because the user-space closes them at its own pace.

> then do the tty_kref_put and gsm->tty = NULL
> 
> Thoughts ?
> 
> Alan


Guillaume

#
" Ce courriel et les documents qui lui sont joints peuvent contenir des
informations confidentielles ou ayant un caractère privé. S'ils ne vous sont
pas destinés, nous vous signalons qu'il est strictement interdit de les
divulguer, de les reproduire ou d'en utiliser de quelque manière que ce
soit le contenu. Si ce message vous a été transmis par erreur, merci d'en
informer l'expéditeur et de supprimer immédiatement de votre système
informatique ce courriel ainsi que tous les documents qui y sont attachés."


                               ******

" This e-mail and any attached documents may contain confidential or
proprietary information. If you are not the intended recipient, you are
notified that any dissemination, copying of this e-mail and any attachments
thereto or use of their contents by any means whatsoever is strictly
prohibited. If you have received this e-mail in error, please advise the
sender immediately and delete this e-mail and all attached documents
from your computer system."
#

