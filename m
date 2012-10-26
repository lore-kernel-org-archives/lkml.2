Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965407Ab2JZQed (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 12:34:33 -0400
Received: from smtp1.smmp-rueil.gmessaging.net ([81.80.3.134]:50189 "EHLO
	smtp1.smmp-rueil.gmessaging.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965301Ab2JZQe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 12:34:28 -0400
Message-ID: <3252_1351269266_508ABB91_3252_975_1_508ABB8F.5040906@sagemcom.com>
Date: Fri, 26 Oct 2012 18:34:23 +0200
From: Guillaume Juan <guillaume.juan@sagemcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-serial@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] n_gsm: prevent crash due to dereferencing NULL gsm->tty
References: <26026_1351239109_508A45C4_26026_63_1_508A45C1.3010407@sagemcom.com> <20121026152052.GA15840@kroah.com>
In-Reply-To: <20121026152052.GA15840@kroah.com>
X-MIMETrack: Itemize by SMTP Server on CHELS01SC/SERV/SAGEMCOM(Release 7.0.4|March 23, 2009) at
 10/26/2012 06:34:23 PM,
	Serialize by Router on CHELS01SC/SERV/SAGEMCOM(Release 7.0.4|March 23, 2009) at
 10/26/2012 06:34:26 PM,
	Serialize complete at 10/26/2012 06:34:26 PM
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 26/10/2012 17:20, Greg Kroah-Hartman a écrit :

> On Fri, Oct 26, 2012 at 10:11:45AM +0200, Guillaume Juan wrote:
>> From: Guillaume Juan <guillaume.juan@sagemcom.com>
>>
>> If gsm->tty happens to be NULL in gsmld_output, avoid crashing the kernel (the crash is replaced by a warning dump).
> 
> How can ->tty be NULL here?
> 

I had some crashes and identified 2 causes: this is what I tried to explain in the 2nd part of the changelog ("Prevent at earlier level such situation: [...]"). Basically it is because the T1 and T2 timers may be rearmed while gsm_cleanup_mux executes (T1 is rearmed by gsmtty_hangup called by gsm_cleanup_mux itself via gsm_dlci_release, whereas T2 may be rearmed by a concurrent call to gsmtty_close).

My patch is intended to remove theses causes, but I thought safer to avoid the crash in gsmld_output if ever there are other causes remaining. Do you mean I should let the crash happen for these unproven cases?

>> Prevent at earlier level such situation:
>> - gsmtty_hangup does no longer call gsm_dlci_begin_close when called synchronously from gsm_cleanup_mux, because this would arm a timer that will asynchronously lead to use gms->tty, potentially after it is nullified.
>> - in gsm_cleanup_mux, release DLCIs (other than DLCI#0 which is the control one) before closing mux. Else, it can happen that the T2 timer is rearmed by another thread scheduled between del_timer_sync and gsm_dlci release
>> (for example by the following call-stack: fput => tty_release => tty_port_close_start => tty_port_lower_dtr_rts => gsm_dtr_rts => gsmtty_modem_update)
> 
> Please wrap your changelog comments at 72 columns.
>

Sorry, I didn't know this rule (it is the 1st time I post a patch and the 1st time I use git). I will when I re-send.


>>
>> Signed-off-by: Guillaume Juan <guillaume.juan@sagemcom.com>
>> ---
>>  drivers/tty/n_gsm.c |   35 ++++++++++++++++++++++++++---------
>>  1 files changed, 26 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/tty/n_gsm.c b/drivers/tty/n_gsm.c
>> index 1e8e8ce..fe3c6ad 100644
>> --- a/drivers/tty/n_gsm.c
>> +++ b/drivers/tty/n_gsm.c
>> @@ -1510,8 +1510,8 @@ static void gsm_dlci_begin_open(struct gsm_dlci *dlci)
>>  }
>>  
>>  /**
>> - *	gsm_dlci_begin_close	-	start channel open procedure
>> - *	@dlci: DLCI to open
>> + *	gsm_dlci_begin_close	-	start channel close procedure
>> + *	@dlci: DLCI to close
>>   *
>>   *	Commence closing a DLCI from the Linux side. We issue DISC messages
>>   *	to the modem which should then reply with a UA, at which point we
>> @@ -2031,6 +2031,13 @@ void gsm_cleanup_mux(struct gsm_mux *gsm)
>>  	spin_unlock(&gsm_mux_lock);
>>  	WARN_ON(i == MAX_MUX);
>>  
>> +	/* Free up any link layer users */
>> +	if (dlci)
>> +		dlci->dead = 1;
>> +	for (i = 1; i < NUM_DLCI; i++)
>> +		if (gsm->dlci[i])
>> +			gsm_dlci_release(gsm->dlci[i]);
>> +
>>  	/* In theory disconnecting DLCI 0 is sufficient but for some
>>  	   modems this is apparently not the case. */
>>  	if (dlci) {
>> @@ -2041,15 +2048,11 @@ void gsm_cleanup_mux(struct gsm_mux *gsm)
>>  	del_timer_sync(&gsm->t2_timer);
>>  	/* Now we are sure T2 has stopped */
>>  	if (dlci) {
>> -		dlci->dead = 1;
>>  		gsm_dlci_begin_close(dlci);
>>  		wait_event_interruptible(gsm->event,
>>  					dlci->state == DLCI_CLOSED);
>> +		gsm_dlci_release(dlci);
>>  	}
>> -	/* Free up any link layer users */
>> -	for (i = 0; i < NUM_DLCI; i++)
>> -		if (gsm->dlci[i])
>> -			gsm_dlci_release(gsm->dlci[i]);
>>  	/* Now wipe the queues */
>>  	list_for_each_entry_safe(txq, ntxq, &gsm->tx_list, list)
>>  		kfree(txq);
>> @@ -2192,6 +2195,10 @@ EXPORT_SYMBOL_GPL(gsm_alloc_mux);
>>  
>>  static int gsmld_output(struct gsm_mux *gsm, u8 *data, int len)
>>  {
>> +	if (gsm->tty == NULL) {
>> +		WARN(1, "NULL gsm->tty pointer in gsmld_output\n");
>> +		return -EINVAL;
>> +	}
>>  	if (tty_write_room(gsm->tty) < len) {
>>  		set_bit(TTY_DO_WRITE_WAKEUP, &gsm->tty->flags);
>>  		return -ENOSPC;
>> @@ -2323,7 +2330,7 @@ static void gsmld_flush_buffer(struct tty_struct *tty)
>>   *	@tty: device
>>   *
>>   *	Called from the terminal layer when this line discipline is
>> - *	being shut down, either because of a close or becsuse of a
>> + *	being shut down, either because of a close or because of a
>>   *	discipline change. The function will not be called while other
>>   *	ldisc methods are in progress.
>>   */
>> @@ -2954,6 +2961,15 @@ static void gsmtty_close(struct tty_struct *tty, struct file *filp)
>>  	gsm = dlci->gsm;
>>  	if (tty_port_close_start(&dlci->port, tty, filp) == 0)
>>  		goto out;
>> +	/* Should not happen because the DLCI ttys are hung up (which causes
>> +	   tty_port_close_start to return 0) by gsm_dlci_release before setting
>> +	   gsm->tty to NULL */
>> +	if (gsm->tty == NULL) {
>> +		WARN(1, "NULL gsm->tty pointer in gsmtty_close for %s\n",
>> +			tty->name);
>> +		goto out;
>> +	}
>> +
>>  	gsm_dlci_begin_close(dlci);
>>  	tty_port_close_end(&dlci->port, tty);
>>  	tty_port_tty_set(&dlci->port, NULL);
>> @@ -2967,7 +2983,8 @@ static void gsmtty_hangup(struct tty_struct *tty)
>>  {
>>  	struct gsm_dlci *dlci = tty->driver_data;
>>  	tty_port_hangup(&dlci->port);
>> -	gsm_dlci_begin_close(dlci);
>> +	if (!dlci->gsm->dead)
>> +		gsm_dlci_begin_close(dlci);
>>  }
>>  
>>  static int gsmtty_write(struct tty_struct *tty, const unsigned char *buf,
>> -- 
>> 1.7.0.4
>>
>>
>>
>> #
>> " Ce courriel et les documents qui lui sont joints peuvent contenir des
>> informations confidentielles ou ayant un caractère privé. S'ils ne vous sont
>> pas destinés, nous vous signalons qu'il est strictement interdit de les
>> divulguer, de les reproduire ou d'en utiliser de quelque manière que ce
>> soit le contenu. Si ce message vous a été transmis par erreur, merci d'en
>> informer l'expéditeur et de supprimer immédiatement de votre système
>> informatique ce courriel ainsi que tous les documents qui y sont attachés."
>>
>>
>>                                ******
>>
>> " This e-mail and any attached documents may contain confidential or
>> proprietary information. If you are not the intended recipient, you are
>> notified that any dissemination, copying of this e-mail and any attachments
>> thereto or use of their contents by any means whatsoever is strictly
>> prohibited. If you have received this e-mail in error, please advise the
>> sender immediately and delete this e-mail and all attached documents
>> from your computer system."
>> #
> 
> Because of that footer, I am not allowed to accept this patch at all.
> Please remove it and resend.
> 
> thanks,
> 
> greg k-h


Argh. I'm afraid I don't know how to remove it, since it seems added automatically by my company mail server. I probably will have to struggle with the admins. But since you ARE the "intended recipient" and the content is NOT "confidential or proprietary", does it really forbid you to use the patch?

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

